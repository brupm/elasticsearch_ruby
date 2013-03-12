require 'tire'
require "tire/queries/custom_filters_score"

Tire.configure { logger STDERR }

Tire.index 'index' do
  delete
  create mappings: {
    document: {
      properties: {
        state_abbreviation: { type: 'string', index: "not_analyzed" },
        states_ties: { type: 'string', index: "not_analyzed" }
      }
    }
  }

  store id: 1, states_ties: ["CA"],       state_abbreviation: "CA"
  store id: 2, states_ties: ["CA", "FL"], state_abbreviation: "FL"
  store id: 3, states_ties: ["CA", "NY"], state_abbreviation: "NY"

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
      score_mode 'multiply'
    end
  end
end

s.results.to_a.select {|x| puts "#{x.id}: #{x._score}"}

#search.results.to_a.select {|x| puts "#{x.id}: #{x._score}: state: #{x.state_abbreviation}, trained: #{x.states_trained}, worked: #{x.states_worked}"}
