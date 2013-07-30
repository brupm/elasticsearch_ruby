require 'tire'

Tire.configure { logger STDERR }

Tire.index 'index' do
  delete
  create mappings: {
    document: {
      properties: {
        firstname: { type: 'string' },
        middlename: { type: 'string' },
        lastname: { type: 'string' }
      }
    }
  }

  store id: 1, firstname: 'john', middlename: 'clark', lastname: 'smith'
  store id: 2, firstname: 'john', middlename: 'paladini', lastname: 'miranda'
  refresh
end

s = Tire.search 'index', per_page: 10 do

  query do
    # method 1 - does not work
    #match :firstname, 'john smith'
    #match :middlename, 'john smith'
    #match :lastname, 'john smith'

    # method 2 - does not work
    #match [:firstname, :lastname, :middlename], 'john smith', operator: "OR"

    # method 3 - does not work
    #boolean do
    #  should { terms(:firstname, ['john', 'smith']) }
    #  should { terms(:middlename, ['john', 'smith']) }
    #  should { terms(:lastname, ['john', 'smith']) }
    #end

    # method 4 - works but no control over the fiels
    # string 'john smith', default_operator: 'AND'

    # method 5
    string 'john smith', default_operator: 'AND', fields: [:firstname, :lastname, :middlename]
  end

end

s.results.to_a.select {|x| puts "RESULT: #{x.id}: #{x._score}"}





