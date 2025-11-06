module Domain
  module Validators
    class AuditValidator
      def self.validate(audit)
        errors = []
        errors << "Entity is required" if audit.entity.nil? || audit.entity.empty?
        errors << "Action is required" if audit.action.nil? || audit.action.empty?
        errors << "Entity ID is required" if audit.entity_id.nil? || audit.entity_id.empty?
        errors << "Metadata is required" if audit.metadata.nil? || audit.metadata.empty?
        errors << "Timestamp is required" if audit.timestamp.nil?
        errors << "Service is required" if audit.service.nil? || audit.service.empty?
        errors
      end

      def self.valid?(audit)
        validate(audit).empty?
      end
    end
  end
end