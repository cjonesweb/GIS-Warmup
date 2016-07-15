require 'nokogiri'
require 'open-uri'
## Parsing a Google Image search.
## GOOG does a lot of funny things with their image search... like embedding
## image data in the page as b64 data on images added to the page via ajax calls
## However, for the purpose of this warmup, we can rely on the data Big G
## provides via a GET request.

html_doc = Nokogiri::HTML(open("https://www.google.com/search?site=&tbm=isch&source=hp&biw=1202&bih=639&q=puppies"))

## Redundant, but lets us know that Nokogiri has caught an XMLFish, or in this
## case, an HTMLalibut.
puts "html_doc is a #{html_doc.class}"

img_array = html_doc.xpath("//img")

img_array.each do |i|
  uri = URI.parse(i["src"])
  str = uri.read
  
  output_name = i.parent["href"].split("//").last.split("&").first.gsub("/", "-")
  
  #output_name = i["src"].slice(-14..-1)
  
  File.open(output_name, "wb") do |f|
    f.write(str)
  end
end