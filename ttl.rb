require 'tire'

Tire.configure { logger STDERR }

Tire.index 'query' do
  delete
  create mappings: {
    document: {
      _ttl:  { enabled: true, default: "2s" },
      properties: {
        title: { type: 'string' }
      }
    }
  },
  settings: { indices: { ttl: { interval: "3s" } } }

  store title: 'my one', _ttl: "4s"
  store title: 'two my', _ttl: "120s"

  refresh
end

s = Tire.search 'query' do
  query do
    match :title, 'my'
  end
end

p s.results.to_a.map(&:title)

sleep 63

s = Tire.search 'query' do
  query do
    match :title, 'my'
  end
end

p s.results.to_a.map(&:title)
