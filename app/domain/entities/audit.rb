module Domain
  module Entities
    class Audit
      attr_accessor :id, :entity, :action, :entity_id, :metadata, :timestamp, :service

      def initialize(id: nil, entity: nil, action: nil, entity_id: nil, metadata: {}, timestamp: nil, service: nil)
        @id = id
        @entity = entity
        @action = action
        @entity_id = entity_id
        @metadata = metadata
        @timestamp = timestamp
        @service = service
      end
    end
  end
end
