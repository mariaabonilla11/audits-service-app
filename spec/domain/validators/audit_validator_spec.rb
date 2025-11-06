require 'rails_helper'
require_relative '../../../app/domain/validators/audit_validator'

RSpec.describe Domain::Validators::AuditValidator do
  context 'when required fields are missing' do
    it 'returns errors for missing entity and action' do
      audit = Domain::Entities::Audit.new(
        entity: nil,
        action: nil,
        entity_id: nil,
        metadata: {},
        timestamp: nil,
        service: nil
      )

      errors = described_class.validate(audit)
      expect(errors).to be_an(Array)
      expect(errors).not_to be_empty
      # Ajusta los mensajes según lo que devuelva tu validador:
      expected = [
        "Entity is required",
        "Action is required",
        "Entity ID is required",
        "Metadata is required",
        "Timestamp is required",
        "Service is required"
      ]

      expect(errors).to match_array(expected)
    end
  end

end