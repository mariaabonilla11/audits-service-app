require_dependency Rails.root.join('app/domain/repositories/audit_repository').to_s
require_dependency Rails.root.join('app/domain/entities/audit').to_s
module Infrastructure
  module Repositories
    class MongoAuditRepository < Domain::Repositories::AuditRepository
      def create(audit)
        result = ::Audit.create(
          entity: audit.entity,
          action: audit.action,
          entity_id: audit.entity_id,
          metadata: audit.metadata,
          timestamp: audit.timestamp,
          service: audit.service
        )
        return result if result.persisted?
        { errors: result.errors.full_messages }
      end

      # Find audit by entity_id (the ID of the audited resource, e.g. invoice ID)
      # Optionally filter by service name
      def find_by_id(entity_id, service: nil)
        query = { entity_id: entity_id }
        query[:service] = service if service.present?

        # Use where().first instead of find_by to avoid DocumentNotFound exception
        record = ::Audit.where(query).first
        return nil unless record

        # Use the to_domain method if available, otherwise build manually
        record.respond_to?(:to_domain) ? record.to_domain : build_domain_audit(record)
      end

      private

      def build_domain_audit(record)
        Domain::Entities::Audit.new(
          id: record.id.to_s,
          entity: record.entity,
          action: record.action,
          entity_id: record.entity_id.to_s,
          metadata: record.metadata,
          timestamp: record.timestamp,
          service: record.service
        )
      end
    end
  end
end