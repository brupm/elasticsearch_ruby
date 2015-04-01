require 'tire'
require 'benchmark'

Tire.configure { logger STDERR }

documents = (1..2000).map { |i| { id: i, location: 'United States', title: "Document #{i}", color: 'red' } }

Tire.index 'benchmark' do
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

  a = Benchmark.measure {
    import documents, per_page: 100
  }
  refresh


  puts "=========================="
  puts a
  puts "=========================="
  puts "count: #{Tire.search('benchmark', search_type: "count") {}.results.total}"
end
