$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'tire'
require 'tire/http/clients/curb'

Tire.configure { client Tire::HTTP::Client::Curb }

class Book
  include Tire::Model::Persistence
  property :title
end

Book.tire.index.delete

Book.create title: 'Foo'
Book.create title: 'Bar'
Book.create title: 'Car'
Book.create title: 'Mar'
Book.create title: 'Lar'
Book.create title: 'Tar'
Book.create title: 'Dar'


Book.tire.index.refresh

threads = []

%w| foo bar car mar lar tar dar |.each do |q|
  threads << Thread.new do
    p Book.search( q ).results.to_a
    puts '-----'
  end
end

threads.each { |t| t.join() }
