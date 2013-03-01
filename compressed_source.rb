require 'tire'
require 'benchmark'

Tire.configure { logger STDERR }

documents = (1..300000).map { |i| { id: i, location: 'United States', title: "Some really extra super duper long title that is never going to end because we want to be able to test compression on this mofo. Document #{i}", color: 'red' } }

Tire.index 'types' do
  delete
  create mappings: {
    document: {
      properties: {
        id: { type: 'integer'},
        location: { type: 'string' },
        title: { type: 'string' },
        color: { type: 'string' }
      }
    }
  }
  `
  curl  -XPUT http://localhost:9200/types/document/_mapping -d '{
    "trade" : {
      "_source" : { "compress" : false }
    }
  }'
  `
  a = Benchmark.measure {
    import documents, per_page: 100
  }
  refresh

  puts "=========================="
  puts a
  puts "=========================="
  puts "count: #{Tire.search('types', search_type: "count") {}.results.total}"
end


#false: 114.6mb
#true:  113.9mb
