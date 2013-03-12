require 'tire'

Tire.configure do
  logger STDERR
end

Tire.index 'filtered_test' do
  delete
  create
  store tags: ['ruby'], content: 'ruby is awesome'
  store tags: ['java'], content: 'java is awesome'
  store tags: ['perl'], content: 'perl is awesome'

  refresh
end

s = Tire.search 'filtered_test' do
  filter :terms, :tags => ['ruby']
  query { string 'awesome' }
end

s = Tire.search 'filtered_test' do
  query do
    filtered do
      query { string 'awesome' }
      filter :terms, :tags => ['ruby']
    end
  end
end

p s.results.to_a.map(&:content)

#https://gist.github.com/brupm/95653d2351c8e42e3abd
