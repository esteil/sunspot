module Sunspot
  module DSL
    class RestrictionWithNear < Restriction
      def initialize(field, scope, query, negated)
        super(field, scope, negated)
        @query = query
      end

      # ==== Score, boost, and sorting with location search
      #
      # The concept of relevance scoring is a familiar one from fulltext search;
      # Solr (or Lucene, actually) gives each result document a score based on
      # how relevant the document's text is to the search phrase. Sunspot's
      # location search also uses scoring to determine geographical relevance;
      # using boosts, longer prefix matches (which are, in general,
      # geographically closer to the search origin) are assigned higher
      # relevance. This means that the results of a pure location search are
      # <em>roughly</em> in order of geographical distance, as long as no other
      # sort is specified explicitly.
      #
      # This geographical relevance plays on the same field as fulltext scoring;
      # if you use both fulltext and geographical components in a single search,
      # both types of relevance will be taken into account when scoring the
      # matches. Thus, a very close fulltext match that's further away from the
      # geographical origin will be scored similarly to a less precise fulltext
      # match that is very close to the geographical origin. That's likely to be
      # consistent with the way most users would expect a fulltext geographical
      # search to work.
      #
      # ==== Options
      #
      # <dt><code>:distance</code></dt>
      # <dd>Distance in kilometers</dd>
      # <dt><code>:exact</code></dt>
      # <dd>Perform exact (also more computationally intensive) distance calculations</dd>
      # <dt><code>:boost</code></dt>
      # <dd>The boost to apply to maximum-precision matches. Default is 1.0. You
      # can use this option to adjust the weight given to geographic
      # proximity versus fulltext matching, if you are doing both in a
      # search.</dd>
      #
      # ==== Example
      #
      #   Sunspot.search(Post) do
      #     fulltext('pizza')
      #     with(:location).near(-40.0, -70.0, :boost => 2, :distance => 1)
      #   end
      #
      def near(lat, lng, options = {})
        @query.fulltext.add_location(@field, lat, lng, options)
      end
    end
  end
end
