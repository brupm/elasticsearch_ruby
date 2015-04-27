require 'tire'

Tire.configure { logger STDERR }

Tire.index 'search' do
  delete

  store first: 'Kimberly', last: "Smith", middle: "middle"#, specialty:
  store first: 'Barbara', last: "Venezuela", middle: "middle"
  store first: 'John', last: "Maria", middle: "middle"
  store first: 'Nancy', last: "Smith", middle: "middle"

  refresh
end


s = Tire.search 'search' do
  query do
    string 'middle', default_operator: "OR"
  end

  facet 'last_name' do
    terms :last
  end
end

p s.results.to_a.collect { |x| "#{x.first} #{x.last}" }

s.results.facets['last_name']['terms'].each do |f|
  puts "#{f['term'].ljust(10)} #{f['count']}"
end
