require 'tire'
require 'tire/http/clients/curb'
require 'debugger'

Tire.configure { client Tire::HTTP::Client::Curb }

class Book
  include Tire::Model::Persistence
  property :title
end

Book.tire.index.delete

Book.create title: 'Foo'
Book.create title: 'Bar'

Book.tire.index.refresh

threads = []

%w| foo bar |.each do |q|
  threads << Thread.new do
    p Book.search(q).results.to_a
  end
end

debugger
threads.each { |t| t.join() }
