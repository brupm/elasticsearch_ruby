require 'tire'
require "tire/queries/custom_filters_score"

Tire.configure { logger STDERR }

Tire.index 'index' do
  delete
  create mappings: {
    document: {
      properties: {
        state_abbreviation: { type: 'string', index: "not_analyzed" },
        states_ties: { type: 'string', index: "not_analyzed" },
        worked_in_states: { type: 'string', index: "not_analyzed" },
        training_in_states: { type: 'string', index: "not_analyzed" }
      }
    }
  }

  store id: 1, states_ties: ["CA"],             state_abbreviation: "CA", worked_in_states: ['CA'],       training_in_states: ['CA']
  store id: 2, states_ties: ["CA", "NY"],       state_abbreviation: "FL", worked_in_states: ['NY', 'CA'], training_in_states: ['NY', 'CA']
  store id: 3, states_ties: ["CA", "NY", "FL"], state_abbreviation: "NY", worked_in_states: ['NY', 'CA'], training_in_states: ['NY', "FL"]

  refresh
end

s = Tire.search 'index', per_page: 10 do

  query do
    custom_filters_score do
      query do
        terms(:states_ties, ["CA"])
      end
      filter do
        filter :term, state_abbreviation: "CA"
        boost 1.03
      end
      filter do
        filter :terms, worked_in_states: ["CA"]
        boost 1.02
      end
      filter do
        filter :terms, training_in_states: ["CA"]
        boost 1.01
      end
      score_mode 'multiply'
    end
  end
  sort do
    by "_score", "desc"
  end
end

s.results.to_a.select {|x| puts "#{x.id}: #{x._score}"}
