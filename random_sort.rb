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


s = Tire.search 'search' do
  query { all }

  my_sort = {
    "kol_tags.scored.score" => { "order" => "desc", "mode" => "sum", "nested_filter" => { "term" => { "kol_tags.scored.name" => "Research" } } }
  }

  sort do
    by my_sort
  end

end

p s.results.to_a.collect { |x| "#{x.first} #{x.last}" }

