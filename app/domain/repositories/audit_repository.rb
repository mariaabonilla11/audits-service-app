module Domain
  module Repositories
    class AuditRepository
      def create(audit)
        raise NotImplementedError
      end

      def find_by_id(id)
        raise NotImplementedError
      end
    end
  end
end