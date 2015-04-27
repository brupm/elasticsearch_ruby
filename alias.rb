require 'tire'
require 'debugger'

Tire.configure { logger STDERR }


def index_elasticsearch(class_name)
  Tire.index([class_name, "_", Time.now.strftime('%Y%m%d%H%M%S')].join) do
    store first: 'Kimberly', last: "miranda", middle: "middle"

    refresh
  end
end

class_name = "users"


# Find Alias
index_alias = Tire::Alias.find(class_name)

if index_alias

  # Alias exist, find the index
  old_index = index_alias.indices

  to_be_delete = old_index.first

  # Create a new index
  new_index = index_elasticsearch(class_name)

  # Assign our alias to the new index
  a = Tire::Alias.new
  a.name(class_name)
  a.index(new_index.name)
  a.save

  # Remove our alias from the old index
  old_index.each do |index|
    index_alias.indices.delete index
  end

  index_alias.save

  # Delete old index
  index_to_be_deleted = Tire::Index.new(to_be_delete)
  index_to_be_deleted.delete if index_to_be_deleted.exists?

else
  # Alias not found, so let's create an index and an alias
  index = index_elasticsearch(class_name)

  a = Tire::Alias.new
  a.name(class_name)
  a.index(index.name)
  a.save
end
