require 'tire'

Tire.configure { logger STDERR }

klass = Tire.index 'search' do
  delete

  store first: 'Kimberly', last: "Smith", middle: "middle"
  store first: 'Barbara', last: "Venezuela", middle: "middle"
  store first: 'John', last: "Maria", middle: "middle"
  store first: 'Nancy', last: "Smith", middle: "middle"

  refresh
end


s = Tire.search 'search' do |q|
  q.query do |query|
    query.boolean do
      should { term(:middle, "middle") }
    end
  end
  q.size(1)
end

p s.results.to_a.collect { |x| "#{x.first} #{x.last}" }
