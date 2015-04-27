require 'tire'

Tire.configure { logger STDERR }

["development_seo_doctors_20130905092742", "development_seo_doctors"].each do |index_name|
  Tire.index index_name do
    #delete

    store first: 'Kimberly', last: "Smith"

    refresh
  end
end

s = Tire.search ['development_seo_doctors', 'development_seo_doctors_20130905092742'] do
  query do
    string 'Kimberly'
  end
end

p s.results.to_a.collect { |x| x.first }
