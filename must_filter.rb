require 'tire'

Tire.configure { logger STDERR }

klass = Tire.index 'search' do
  delete

  store first: 'Kimberly', last: "Smith", middle: "middle"
  store first: 'Nancy', last: "Kay", middle: "middle"

  refresh
end


s = Tire.search 'search' do
  filter :bool, should: { term: { first: "nancy" } }
  filter :bool, should: { term: { last: "kay" } }

  #filter(:bool, {
  #  should: { term: { first: "nancy" }},
  #  should: { term: { last: "kay" }}
  #})

end

p s.results.to_a.collect { |x| "#{x.first} #{x.last}" }

# http://stackoverflow.com/questions/12083434/elastic-search-tire-how-do-i-filter-a-boolean-attribute
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html
