# Microservicio de Audits - FactuMarket

Microservicio para la gestión y auditoria de eventos en el sistema de facturación electrónica, implementado con Ruby on Rails 7 siguiendo principios de Clean Architecture.

## 🏗️ Arquitectura

Este microservicio implementa **Clean Architecture** con las siguientes capas:

```
┌─────────────────────────────────────┐
│   Presentación (Controllers)        │  ← API REST con MVC
├─────────────────────────────────────┤
│   Aplicación (Use Cases)            │  ← Lógica de aplicación
├─────────────────────────────────────┤
│   Dominio (Entities, Validators)    │  ← Lógica de negocio
├─────────────────────────────────────┤
│   Infraestructura (Repositories)    │  ← Acceso a datos
└─────────────────────────────────────┘
```

![Diagrama de la arquitectura](diagrama.png)

## 📁 Estructura de Carpetas

```
app/
├── controllers/api/v1/          # Capa de Presentación (MVC)
├── use_cases/audits/            # Capa de Aplicación
├── domain/
│   ├── entities/                # Entidades de dominio
│   ├── repositories/            # Interfaces de repositorios
│   └── validators/              # Validadores de negocio
└── infrastructure/
    ├── repositories/            # Implementaciones de repositorios
    └── http/                    # Audites HTTP
```

## 🚀 Tecnologías

- **Ruby**: 3.2.2
- **Rails**: 7.1.0
- **Base de datos**: MongoDB
- **Comunicación**: HTTP REST (HTTParty)
- **Testing**: RSpec

## 📋 Prerequisitos

- Ruby 3.2.2
- MongoDB
- Bundler
- Docker

## ⚙️ Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/mariaabonilla11/audits-service-app
cd audits-service-app
```

### 2. Ejecutar imagen y correr contenedor 🐳

### Construir imagen

```bash
cd audits-service-app
docker compose up --build
```

### 3. Configurar variables de entorno

```bash
Si se desea cambiar las credenciales de MongoDB cambiar credenciales en docker-compose.yml y config/mongoid.yml
```

El servicio estará disponible en `http://IPLOCAL:3003`

## Colección de Postman

Puedes importar la colección de Postman desde este archivo:
[📥 Descargar colección de Postman](./Microservices.postman_collection.json)

## 📡 API Endpoints

### Crear Audite

```http
POST /api/v1/audits
Content-Type: application/json

{
    "action": "POST",
    "entity_id": "1",
    "metadata": "Ejemplo",
    "timestamp": "2035-09-09T14:34:15Z",
    "service": "Audits-service"
}
```

**Respuesta exitosa (201)**:

```json
{
  "message": "Audite creado exitosamente",
  "data": {
    "id": 1,
    "name": "Empresa Test S.A.",
    "identification": "900123456-7",
    "type_identification": "NIT",
    "email": "contacto@empresatest.com",
    "address": "Calle 123 # 45-67",
    "state": "active",
    "created_at": "2024-11-05T10:30:00Z",
    "updated_at": "2024-11-05T10:30:00Z"
  }
}
```

### Consultar Audite por entityID para Invoices

```http
GET /api/v1/audits/1
```

**Respuesta exitosa (200)**:

```json
{
  "message": "Auditoría encontrada exitosamente",
  "audit": {
    "id": "5b31e1bb-6c9f-4c9f-95dc-e46662f519e6",
    "entity": "Client",
    "action": "POST",
    "entity_id": "1",
    "metadata": {},
    "timestamp": "2035-09-09T14:34:15.000Z",
    "service": "invoices-service"
  }
}
```

## 🧪 Testing

### Ejecutar todos los tests

```bash
bundle exec rspec
```

### Ejecutar tests específicos

```bash
# Tests de entidades
bundle exec rspec spec/domain/entities/

# Tests de use cases
bundle exec rspec spec/use_cases/

# Test específico
bundle exec rspec spec/domain/entities/audit_spec.rb
```

### Cobertura de tests

```bash
bundle exec rspec --format documentation
```

## 📊 Flujo de Datos

1. **Request HTTP** → Controller (`AuditsController`)
2. **Controller** → Use Case (`CreateAudit`, `FindAudit`, `ListAudits`)
3. **Use Case** → Domain Entity (`Audit`) + Validator
4. **Use Case** → Repository (`OracleAuditRepository`)
5. **Repository** → Base de datos Oracle
6. **Use Case** → HTTP Audit (`AuditService`)
7. **Response** ← Controller

## 🎯 Principios Aplicados

### Clean Architecture

- ✅ Separación en capas (Presentación, Aplicación, Dominio, Infraestructura)
- ✅ Regla de dependencias (capas internas no conocen las externas)
- ✅ Entidades de dominio puras sin dependencias de framework

### MVC

- ✅ Controllers manejan requests HTTP
- ✅ Models representan datos persistentes
- ✅ Serialización de respuestas JSON

### SOLID

- ✅ Single Responsibility: cada clase tiene una única responsabilidad
- ✅ Dependency Inversion: use cases dependen de abstracciones (interfaces)
- ✅ Interface Segregation: repositorios con métodos específicos

## 🛡️ Validaciones de Negocio

- Entity: requerido
- Entity ID requerido
- Action: requerido
- Metadata: requerido
- Timestamp: requerido
- Service: requerido

## 🔧 Manejo de Errores

El servicio maneja los siguientes errores:

- **422 Unprocessable Entity**: Datos inválidos o reglas de negocio no cumplidas
- **404 Not Found**: Audite no encontrado
- **400 Bad Request**: Parámetros faltantes
- **500 Internal Server Error**: Errores del sistema

## 🚦 Health Check

```http
GET /health
```

Respuesta: `200 OK`

## 👥 Autor

Maria Bonilla
