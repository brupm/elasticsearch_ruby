require 'tire'
require 'benchmark'

Tire.configure { logger STDERR }

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
    (1..2000).map do |i|
      store id: i, location: 'United States', title: "Document #{i}", color: 'red'
    end
  }

  refresh

  puts "=========================="
  puts a
  puts "=========================="
  puts "count: #{Tire.search('benchmark', search_type: "count") {}.results.total}"
end

