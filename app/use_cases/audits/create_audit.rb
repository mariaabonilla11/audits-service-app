require_dependency Rails.root.join('app/infrastructure/repositories/mongo_audit_repository').to_s
require_dependency Rails.root.join('app/domain/entities/audit').to_s
module UseCases
  module Audits
    class CreateAudit
      def initialize(repository: Infrastructure::Repositories::MongoAuditRepository.new)
        @repository = repository
      end

      # Accepts a Domain::Entities::Audit instance (built by the controller)
      def execute(audit)
        unless audit.is_a?(Domain::Entities::Audit)
          Rails.logger.error("CreateAudit.execute expected Domain::Entities::Audit, got: #{audit.class}")
          raise ArgumentError, "expected Domain::Entities::Audit"
        end

        result = @repository.create(audit)
        return result
      end
    end
  end
end