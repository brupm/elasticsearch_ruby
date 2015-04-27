require 'tire'

Tire.configure { logger STDERR }

Tire.index 'index' do
  delete
  create mappings: {
    document: {
      properties: {
        states_ties: { type: 'string' }
      }
    }
  }

  store id: 1, states_ties: ["Bruno Miranda"]
  store id: 2, states_ties: ["Maria B"]

  refresh
end

s = Tire.search 'index', per_page: 10 do
  query do
    terms(:states_ties, ["Maria B"])
  end
end

s.results.to_a.select {|x| puts "#{x.id}: #{x.states_ties}"}
