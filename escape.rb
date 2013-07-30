require 'tire'

Tire.configure { logger STDERR }

Tire.index 'query' do
  delete
  create mappings: {
    document: {
      properties: {
        title: { type: 'string' }
      }
    }
  }

  store title: 'my-1/one'

  refresh
end

s = Tire.search 'query' do
  query { string "my-1/one" }
end

p s.results.to_a
