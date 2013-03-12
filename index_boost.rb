require 'tire'

Tire.configure { logger STDERR }


1.upto(2) do
  Tire.index 'search' do
    delete
    create mappings: {
      document: {
        properties: {
          first: { type: 'string' },
          last: { type: 'string', boost: 2.0 }
        }
      }
    },
    settings: { number_of_shards: 1 }

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


  search = 'mark leighton'
  s = Tire.search 'search' do
    query do
      #string search
      match [:last, :first], search
    end
  end

  p s.results.to_a.collect {|x| [x.first, x.last].join(" ")}
end

