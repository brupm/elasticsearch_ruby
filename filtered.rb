require 'tire'

Tire.configure do
  logger STDERR
end

Tire.index 'filtered_test' do
  delete
  create
  store user_id: 1, colleague: 'jey',   content: "funny"
  store user_id: 1, colleague: 'ellis', content: "funny"
  store user_id: 2, colleague: 'mohan', content: "funny"

  refresh
end

s = Tire.search 'filtered_test' do
  query do
    filtered do
      filter :term, user_id: 1
      query { string 'funny' }
    end
  end
end

p s.results.to_a.map(&:user_id)

