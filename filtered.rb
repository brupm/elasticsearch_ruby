require 'tire'
require 'debugger'
Tire.configure do
  logger STDERR
end

#Tire.index 'filtered_test' do
#  delete
#  create
#  store user_id: 1, colleague: 'jey',   content: "funny"
#  store user_id: 1, colleague: 'ellis', content: "funny"
#  store user_id: 2, colleague: 'mohan', content: "funny"

#  refresh
#end

s = Tire.search 'development_users' do
  query do
    filtered do
      filter(:bool, must: [
        {
          nested: {
            path: "kol_tags.scored",
            filter: {
              bool: {
                must: [
                  {
                    term: {
                      "kol_tags.scored.client" => "Merck"
                    }
                  },
                  {
                    term: {
                      "kol_tags.scored.name" => "KOL Score"
                    }
                  },
                  {
                    range: {
                      "kol_tags.scored.score" => {
                        "gte" => 25,
                        "lte" => 70
                      }
                    }
                  }
                ]
              }
            }
          }
        },
        {
          nested: {
            path: "kol_tags.scored",
            filter: {
              bool: {
                must: [
                  {
                    term: {
                      "kol_tags.scored.client" => "Merck"
                    }
                  },
                  {
                    term: {
                      "kol_tags.scored.name" => "Digital"
                    }
                  },
                  {
                    range: {
                      "kol_tags.scored.score" => {
                        "gte" => 40,
                        "lte" => 100
                      }
                    }
                  }
                ]
              }
            }
          }
        }
      ])
    end
  end
end

p s.results.to_a.map(&:full_name)
