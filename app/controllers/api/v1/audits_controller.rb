
require_relative '../../../use_cases/audits/create_audit'
require_relative '../../../use_cases/audits/find_audit'
require_dependency Rails.root.join('app/infrastructure/repositories/mongo_audit_repository').to_s
require_dependency Rails.root.join('app/domain/entities/audit').to_s
require_dependency Rails.root.join('app/domain/validators/audit_validator').to_s

class Api::V1::AuditsController < ApplicationController
  def create
    # build domain entity from permitted params (convert to symbol keys)
    attrs = audit_params.to_h.symbolize_keys
    audit = Domain::Entities::Audit.new(**attrs)
    errors = Domain::Validators::AuditValidator.validate(audit)
    if errors.empty?
      result = ::UseCases::Audits::CreateAudit.new.execute(audit)
      if result.is_a?(Hash) && result[:errors]
        render json: { message: 'Errores de validación', errors: result[:errors] }, status: :unprocessable_entity
      else
        render json: { message: 'Auditoría creada exitosamente', audit: result }, status: :created
      end
    else
      render json: { message: 'Errores de validación', errors: errors }, status: :unprocessable_entity
    end
  end

  def show
    audit_id = params[:id]
    audit_repository = Infrastructure::Repositories::MongoAuditRepository.new
    result = ::UseCases::Audits::FindAudit.new(repository: audit_repository).execute(audit_id)  
    if result
      render json: { message: "Auditoría encontrada exitosamente", audit: result}, status: :ok
    else
      render json: { message: "Auditoría no encontrada" }, status: :not_found
    end
  end

  private

  def audit_params
    params.require(:audit).permit(:entity, :action, :entity_id, :metadata, :timestamp, :service)
  end
end


