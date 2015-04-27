require 'tire'
require 'debugger'

Tire.configure { logger STDERR }

klass = Tire.index 'search' do
  delete

  store last: "ju", first: 'Kimberly', score: 10
  store last: "ju", first: 'Maria', score: 45
  store last: "ju", first: 'Beth', score: 88
  store last: "ju", first: 'Carla', score: 95

  refresh
end

s = Tire.search 'search' do
  #scored_tags_filters = []
  #scored_tags_filters << { and: [ { term: { last:  "ju" } },
  #                                { range: { score:  { gte: 0, lte: 30 } } } ] }
  #debugger

  #filter(:or => scored_tags_filters)
  filter :term, last: "ju"
  filter :range, score: { gte: 0 }
end

p s.results.to_a.collect { |x| "#{x.first} #{x.last}" }
