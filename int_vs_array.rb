require 'tire'

#Tire.configure { logger STDERR }

Tire.index 'search' do
  delete
  create mappings: {
    document: {
      properties: {
        uid: { type: 'integer' }
      }
    }
  }

  store uid: [1,1]
  store uid: 2

  refresh
end


s = Tire.search 'search' do
   query { all }
end

p s.results.to_a.collect { |x| x.uid }
