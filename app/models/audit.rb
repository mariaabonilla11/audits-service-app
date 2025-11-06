# app/models/audit.rb
class Audit
  include ::Mongoid::Document
  include ::Mongoid::Timestamps::Short 

  # Campos pedidos
  field :_id, type: String, default: ->{ SecureRandom.uuid }
  field :entity,    type: String
  field :action,    type: String
  field :entity_id, type: String # o String si prefieres almacenar ids como strings
  field :metadata,  type: Hash, default: {}
  field :timestamp, type: Time
  field :service,   type: String

  
  # Indexes útiles para consultas
  index({ entity: 1, entity_id: 1 })
  index({ timestamp: -1 })
  index({ service: 1 })

  # Validaciones básicas
  validates :entity, :action, :entity_id, presence: true

  # Conversión hacia la entidad de dominio (tu clase Domain::Entities::Audit)
  def to_domain
    Domain::Entities::Audit.new(
      id: id.to_s,
      entity: entity,
      action: action,
      entity_id: entity_id.to_s,
      metadata: metadata || {},
      timestamp: timestamp,
      service: service
    )
  end

  # Crear modelo desde la entidad de dominio
  def self.from_domain(domain_audit)
    new(
      _id: (domain_audit.id if domain_audit.id.present?), # sólo si usas string id
      entity: domain_audit.entity,
      action: domain_audit.action,
      entity_id: begin
                   # intentar usar ObjectId si el string es un ObjectId válido
                   BSON::ObjectId.from_string(domain_audit.entity_id.to_s)
                 rescue BSON::ObjectId::Invalid
                   domain_audit.entity_id
                 end,
      metadata: domain_audit.metadata || {},
      timestamp: domain_audit.timestamp,
      service: domain_audit.service
    )
  end
end