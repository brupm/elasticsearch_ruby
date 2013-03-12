require 'tire'

Tire.configure { logger STDERR }

Tire.index 'random-sort' do
  delete
  create mappings: {
    document: {
      properties: {
        random_sort: { type: 'float' },
        location: { type: 'string' },
        title: { type: 'string', index: :not_analyzed }
      }
    }
  }


  store title: 'xabc abc abc', location: 'US'
  store title: 'def', location: 'US'
  store title: 'dex', location: 'BR'
  store title: 'a', location: 'BR'
  store title: 'k', location: 'BR'

  refresh
end

s = Tire.search 'random-sort' do
  query do
    #string 'a'
    match :title, 'abc abc'
  end
  #filter(:term, location: 'br')
  #fields :title, :location
  #script_field :random_sort, script: "Math.random()"
  #sort { by :title, "asc" }
end

p s.results.to_a
