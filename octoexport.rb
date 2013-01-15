require_relative 'octopost'
require 'json'
require 'date'
require 'mongo'
include Mongo

path = "/Users/eddie/Projects/eddieroger.com/source/_posts"

@client = MongoClient.new('localhost', 27017)
@db = @client['blog']
@coll = @db['posts']

Dir.foreach(path) do |file|
  next if file == "." or file == ".."

  p = OctoPost.new

  p.read_yaml(path, file)

  d = DateTime.parse p.data["date"]
  pHash = Hash.new
  pHash[:author]  = "Eddie Roger"
  pHash[:title]   = p.data["title"]
  pHash[:slug]    = p.data["title"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  pHash[:published_at]    = Time.mktime(d.year, d.month, d.day, d.hour, d.min)
  pHash[:categories] = p.data["categories"].split(",")      unless p.data["categories"].nil? || p.data["categories"].class == Array
  pHash[:content]    = p.content

  # Categories need their own block
  if p.data["categories"].class == String
    pHash[:categories] = p.data["categories"].split(",")
    pHash[:categories].each_with_index do |c, i|
      pHash[:categories][i] = pHash[:categories][i].strip!
    end
  elsif p.data["categories"].class == Array
    pHash[:categories] = p.data["categories"]
  end
  puts pHash.to_json

  @coll.insert(pHash)

end