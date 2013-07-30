require 'tire'

Tire.configure { logger STDERR }

Tire.index 'search' do
  delete

  1.upto(1000) do |s|
    store first: "Kimberly #{s}", code: s
  end

  refresh
end


s = Tire.search 'search' do
  filter(:not, terms: { code: Array(2..1000) })
end

p s.results.to_a.collect { |x| x.first }
