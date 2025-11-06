require 'rails_helper'
require_relative '../../../app/domain/entities/audit'

RSpec.describe Domain::Entities::Audit, type: :model do
  describe 'validations' do
    context 'with valid attributes' do
      it 'creates a audit successfully' do
          audit = Domain::Entities::Audit.new(
              id: 1,
              entity: 'Client',
              action: 'POST',
              entity_id: '1',
              metadata: '{name: "Juan", email: "example@gmail.com"}',
              timestamp: '2035-09-09T14:34:15Z',
              service: 'clients-service'
          )
        expect(audit.entity).to eq('Client')
        expect(audit.action).to eq('POST')
        expect(audit.entity_id).to eq('1')
        expect(audit.metadata).to eq('{name: "Juan", email: "example@gmail.com"}')
        expect(audit.timestamp).to eq('2035-09-09T14:34:15Z')
        expect(audit.service).to eq('clients-service')
      end
    end
  end
end