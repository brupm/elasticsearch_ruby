require 'tire'

Tire.configure { logger STDERR }

Tire.index 'boost' do
  delete
  create mappings: {
    document: {
      properties: {
        location: { type: 'string' },
        has_picture: { type: 'boolean' },
        has_account: { type: 'boolean' },
      }
    }
  }

  store id: 1, title: 'title 1', location: 'US', has_picture: true, has_account: false
  store id: 2, title: 'title 2', location: 'US', has_picture: true, has_account: true
  store id: 3, title: 'title 3', location: 'BR', has_picture: false, has_account: false

  refresh
end

s = Tire.search 'boost', per_page: 10 do

  query do
    boosting(negative_boost: 0.2) do
      positive { match :_all, 'title' }
      negative { term(:has_account, false) }
      negative { term(:has_account, false) }
    end
  end
end

p s.results.to_a.map(&:id)

