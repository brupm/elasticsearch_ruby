require 'tire'

Tire.configure { logger STDERR }

Tire.index 'random-sort' do
  delete
  create mappings: {
    document: {
      properties: {
        random_sort: { type: 'float' },
        location: { type: 'string' }
      }
    }
  }

  store title: '1', location: 'US'
  store title: '2', location: 'US'
  store title: '3', location: 'BR'
  store title: '4', location: 'BR'
  store title: '5', location: 'BR'

  refresh
end

s = Tire.search 'random-sort' do
  filter(:term, location: 'br')
  fields :title, :location
  script_field :random_sort, script: "Math.random()"
  sort { by :random_sort, "asc" }
end

p s.results.to_a
