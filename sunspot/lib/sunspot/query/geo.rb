# Works with Solr 3.1 or greater only
module Sunspot
  module Query
    class Geo
      DEFAULT_DISTANCE = 1 #kilometers
      DEFAULT_EXACT = false #exact is more processing intensive

      def initialize(field, lat, lng, options)
        @field, @lat, @lng, @options = field, lat.to_f, lng.to_f, options
      end

      def to_params
        { :q => to_boolean_query }
      end

      def to_subquery
        "(#{to_boolean_query})"
      end

      private

      def to_boolean_query
        function = exact ? 'geofilt' : 'bbox'
        "{!#{function} sfield=#{@field.indexed_name} pt=#{@lat},#{@lng} d=#{distance}}"
      end

      def distance
        @options[:distance] || DEFAULT_DISTANCE
      end

      def exact
        @options[:exact] || DEFAULT_EXACT
      end

      def boost
        @options[:boost] || 1.0
      end
    end
  end
end
