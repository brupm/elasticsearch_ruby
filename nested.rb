require 'tire'
require 'debugger'

Tire.configure { logger STDERR }

klass = Tire.index 'search' do
  delete

  store first: 'Kimberly', last: "Smith", middle: "middle"
  store first: 'Barbara', last: "Venezuela", middle: "middle"
  store first: 'John', last: "Maria", middle: "middle"
  store first: 'Nancy', last: "Smith", middle: "middle"

  refresh
end

search = Tire::Search::Search.new

@queries = []

def query(&block)
  @queries << block
end

def term
  query do

      filter :term, first: "nancy"

  end
end

def term_2
  query do

      filter :term, last: "maria"

  end
end

term
term_2
debugger
queries = @queries


s = Tire.search 'search' do
  query do
    boolean do
      queries.each do |q|
        instance_eval(&q)
      end
    end
  end
end


p s.results.to_a.collect { |x| "#{x.first} #{x.last}" }
