# gem install elasticsearch
# gem install hashie

require 'elasticsearch'
require 'hashie'

client = Elasticsearch::Client.new log: false

client.indices.delete index: "myindex" rescue nil


client.index  index: 'myindex', type: 'mytype', id: 1, body: { title: "this is a title" }
client.index  index: 'myindex', type: 'mytype', id: 2, body: { title: "this is a title with something appended" }
client.index  index: 'myindex', type: 'mytype', id: 3, body: { title: "prefix - this is a title" }
client.index  index: 'myindex', type: 'mytype', id: 4, body: { title: "prefix a - this is a title - suffix b" }

client.indices.refresh index: "myindex"

["this is a title"].each do |q|
  results = Hashie::Mash.new(client.search(index: 'myindex', body: {
    query: {
      match: {
        title: {
          query: q,
          operator: "and",
          type: "phrase"
        }
      }
    }
  }))

  if results.hits
    res = results.hits.hits.map(&:_id)
    scores = results.hits.hits.map(&:_score)
  end

  puts "Query: #{q} \t Found count: #{results.hits.total} \t Found: #{res} \t Scores: #{scores}"
end
