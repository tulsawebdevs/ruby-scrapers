require 'nokogiri'
require 'open-uri'

URL = "http://tulsamugs.com/"

class Person
  attr_accessor :name, :age, :city, :date, :charges

  def initialize(person)
    the_person = person.split(':')
    first_chunk(the_person.first)
    self.date = second_chunk(the_person[1])
    self.charges = the_person.last.strip
  end

  def first_chunk(stuff)

    self.city = stuff.split(',').last.gsub('ARRESTED', '').strip
    data = []
    stuff.split(',').first.each_line do |line|
      data << line
    end

    self.name = data.first.strip
    self.age = data.last.strip
  end

  def second_chunk(date)
    return date.gsub('CHARGES','')
  end
end

@first_run = true

def run_scrape(url="")
  @doc = Nokogiri::HTML(open("#{URL}/#{url}"))

  @people = []
  @doc.xpath("//div[@class='picture']").each do |person|
    @people << person.content
  end

  @final_people = []
  @people.each do |p|
    @final_people << Person.new(p)
  end

  @final_people.each do |p|
    puts "#{p.name} (#{p.age}) - #{p.charges}"
  end

  sleep 1
  if(@first_run)
    @first_run = false
    run_scrape(@doc.xpath("//div[@class='wrapper']//h2//font//a")[0].to_s.split('"')[1])
  else
    run_scrape(@doc.xpath("//div[@class='wrapper']//h2//font//a").to_s.split('"')[3])
  end
end

run_scrape
