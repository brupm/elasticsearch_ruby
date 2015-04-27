require 'tire'
require 'debugger'

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
  q.query { all }
  q.fields(:first)
end
debugger

p s.results.first.first.join


