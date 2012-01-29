require 'nokogiri'
require 'open-uri'
require 'json'
require 'uuid'

require_relative 'person'
require_relative 'store'

URL = "http://tulsamugs.com/"

@first_run = false 
@uuid = UUID.new
def run_scrape(url="")
  @doc = Nokogiri::HTML(open("#{URL}/#{url}"))

  @people = []
  @doc.xpath("//div[@class='picture']").each do |person|
    if(person.content != "")
      @people << person.content
    end
    puts person.content
  end

  @final_people = []
  @people.each do |p|
    @final_people << Person.new(p)
  end

  @final_people.each do |p|
    couch_store(@uuid.generate, p.to_json)
  end

  sleep 2
  if(@first_run)
    @first_run = false
    run_scrape(@doc.xpath("//div[@class='wrapper']//h2//font//a")[0].to_s.split('"')[1])
  else
    run_scrape(@doc.xpath("//div[@class='wrapper']//h2//font//a").to_s.split('"')[3])
  end
end

run_scrape
