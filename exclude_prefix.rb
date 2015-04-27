require 'tire'

Tire.configure { logger STDERR }

klass = Tire.index 'search' do
  delete

  store first: 'Kimberly', last: "Smith"
  store first: 'Kimberly', last: "Dtson"
  store first: 'Ellis', last: "Smith"

  refresh
end


s = Tire.search 'search' do |tire|
  #tire.filter(:term, first: "ellis")

  tire.query do
    boolean do
      must_not do
       string 'last:dt* or sm*'
      end
    end
  end
end

p s.results.to_a.collect { |x| "#{x.first} #{x.last}" }
