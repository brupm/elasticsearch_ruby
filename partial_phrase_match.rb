# gem install elasticsearch
# gem install hashie

require 'elasticsearch'
require 'hashie'

client = Elasticsearch::Client.new log: false

client.indices.delete index: "myindex" rescue nil


client.index  index: 'myindex', type: 'mytype', id: 1, body: { title: "this is a title" }
client.index  index: 'myindex', type: 'mytype', id: 2, body: { title: "is a title this" }
client.index  index: 'myindex', type: 'mytype', id: 3, body: { title: "some other document" }
client.index  index: 'myindex', type: 'mytype', id: 4, body: { title: "this one is for the hommies" }
client.index  index: 'myindex', type: 'mytype', id: 5, body: { title: "this is the end" }


client.indices.refresh index: "myindex"

["for my hommies this is a title and you know it"].each do |q|
  results = Hashie::Mash.new(client.search(index: 'myindex', body: {
    query: {
      match: {
        title: {
          query: q,
          minimum_should_match: "40%"
          # http://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-minimum-should-match.html
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
