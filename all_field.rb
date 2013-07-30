require 'tire'

Tire.configure { logger STDERR }

Tire.index 'search' do
  delete

  store first: 'Kimberly', description: '123 I wish I had a house right now'
  store first: 'Barbara',  description: '123 I wish I had a house right now'
  store first: 'John',     description: '123 I wish I had a house right now'
  store first: 'Nancy',    description: '123 I wish I had a house right now'
  store first: 'Lawrence', description: '123 I wish I had a house right now'
  store first: 'Louis',    description: '123 I wish I had a house right now'
  store first: 'Leighton', description: '123 I wish I had a house right now'
  store first: 'Leighton', description: '123 I wish I had a house right now'

  refresh
end


s = Tire.search 'search' do
  query do
    string 'house'
  end
end

p s.results.to_a.collect { |x| x.first }
