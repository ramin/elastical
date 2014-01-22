module Elastical
  class Mapping
    ALLOWED_FIELDS = %i(type boost analyzer index store properties dynamic)
    DEFAULTS = { type: :string }

    class << self
      def options_to_mapping_with_defaults(args = {})
        allowed = args.slice(*ALLOWED_FIELDS)
        allowed.any? ? DEFAULTS.merge(allowed) : {}
      end
    end
  end
end
