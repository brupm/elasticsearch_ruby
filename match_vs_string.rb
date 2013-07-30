require 'tire'

Tire.configure { logger STDERR }

Tire.index 'search' do
  delete

  store first: 'Kimberly', last: 'Stress'
  store first: 'Barbara', last: 'Smith'
  store first: 'John', last: 'Kusack'
  store first: 'Nancy', last: 'Poll', state: "FL"

  refresh
end


s = Tire.search 'search' do
  query do
    #string 'Nancy Car', default_operator: "OR"
    #match [:first, :last], 'Nancy Poll', operator: "AND", use_dis_max: false
    boolean do
      should { match :first, 'Nancy shark', operator: "AND" }
      should { match :last, 'Nancy shark', operator: "AND" }
    end
    match [:state]

  end
end

p s.results.to_a.collect { |x| x.first }
