require 'tire'

Tire.configure { logger STDERR }

Tire.index 'search' do
  delete
  create mappings: {
    document: {
      properties: {
        first: { type: 'string' },
        last: { type: 'string', boost: 2.0 }
      }
    }
  }

  store first: 'Kimberly', last: 'Leighton'
  store first: 'Barbara', last: 'Leighton'
  store first: 'John', last: 'Leighton'
  store first: 'Nancy', last: 'Mark'
  store first: 'Lawrence', last: 'Mark'
  store first: 'Louis', last: 'Mark'
  store first: 'Leighton', last: 'Mark'
  store first: 'Leighton', last: 'Sweet'

  refresh

end


search = 'Mark Leighton'
s = Tire.search 'search' do
  query do
    string search
    #match [:first, :last], search
  end
end


p s.results


