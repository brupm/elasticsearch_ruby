require '/Users/Bruno/Code/Doximity/tire/tire-doximity/lib/tire.rb'

#require 'tire'
require 'debugger'

Tire.configure do
  logger STDERR
end

Tire.index 'filtered_test' do
  delete
  create
  store id: 1, colleague: 'jey',   content: "funny"
  store id: 2, colleague: 'mohan', content: "funny"

  refresh
end

s = Tire.search 'development_users' do
  indexed_terms_filter(:terms, :id, id: "5", index: "development_target_lists", path: "user_targets", type: "target_list" )
end

p s.results.to_a.map(&:id)

