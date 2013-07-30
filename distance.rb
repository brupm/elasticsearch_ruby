require 'tire'

Tire.configure { logger STDERR }

Tire.index 'search' do
  delete
  create mappings: {
    document: {
      properties: {
        name: { type: 'string' },
        lat_lon: { type: 'geo_point' }
      }
    }
  }

  store name: 'Kimberly', lat_lon: { lat: 29.76, lon: -95.36 }

  refresh
end


s = Tire.search 'search' do
  filter(:geo_distance, lat_lon: { lat: 32.80, lon: -96.61 }, distance: "222.5mi")

end

p s.results.to_a
