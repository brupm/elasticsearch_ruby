# gem install elasticsearch
# gem install hashie

require 'elasticsearch'
require 'hashie'

client = Elasticsearch::Client.new log: false

client.index  index: 'myindex', type: 'mytype', id: 1, body: { firstname: 'bruno', lastname: 'miranda' }
client.index  index: 'myindex', type: 'mytype', id: 2, body: { firstname: 'dan', lastname: 'nill' }


[ "dan | bruno", "dan OR bruno", "dan AND bruno", "dan -bruno", "-dan bruno", "-dan -bruno",
  "\"dan tall\"", "'dan tall'", "'dan nill'", "+dan \| sharp", "bru* | dan", "bru* | di*" ].each do |q|

  results = Hashie::Mash.new(client.search(index: 'myindex', body: {
    query: {
      simple_query_string: {
        query: q,
        fields: ["firstname", "lastname"],
        default_operator: "and"
      }
    }
  }))

  if results.hits
    res = results.hits.hits.map(&:_source).map(&:firstname)
  end

  puts "Query: #{q} \t Found count: #{results.hits.total} \t Found: #{res}"
end
