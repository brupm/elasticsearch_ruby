require 'tire'

Tire.configure { logger STDERR }

Tire.index 'search' do
  delete

  create mappings: {
    document: {
      properties: {
        first: { type: 'string', index: "not_analyzed" }
      }
    }
  }

  store id: 1, first: 'Kimberly'
  store id: 2, first: ['Nancy', 'Bruno M', 'Mario']

  refresh
end


s = Tire.search 'search' do
  query do
    string 'Bruno',
      fields: ["first^2.0"],
      default_operator: "AND",
      use_dis_max: false

    #match [:first, :last], 'Nancy Poll', operator: "AND", use_dis_max: false
    #boolean do
    #  should { match :first, 'Nancy shark', operator: "AND" }
    #  should { match :last, 'Nancy shark', operator: "AND" }
    #end

  end
end

p s.results.to_a.collect { |x| x.id }
