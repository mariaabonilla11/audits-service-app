require_dependency Rails.root.join('app/infrastructure/repositories/mongo_audit_repository').to_s
require_dependency Rails.root.join('app/domain/entities/audit').to_s
module UseCases
  module Audits
    class FindAudit
      def initialize(repository: Infrastructure::Repositories::MongoAuditRepository.new)
        @repository = repository
      end

      def execute(id) 
        result = @repository.find_by_id(id, service: 'invoices-service')
        unless result.is_a?(Domain::Entities::Audit)
          Rails.logger.error("FindAudit.execute expected Domain::Entities::Audit, got: #{result.class}")
          raise ArgumentError, "expected Domain::Entities::Audit"
        end
        return result
      end
    end
  end
end