require 'tire'

Tire.configure { logger STDERR }

klass = Tire.index 'search' do
  delete

  store first: '2', date: "2013-09-22T13:36:52.000Z"
  store first: '1', date: "2013-09-20T13:36:52.000Z"
  store first: '3', date: "2013-09-25T13:36:52.000Z"


  refresh
end


s = Tire.search 'search' do
  sort {
    by :date, :asc
  }
end

p s.results.to_a.collect { |x| x.first }
