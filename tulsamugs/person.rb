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

  def to_json
    {'name' => self.name, 'age' => self.age, 'city' => self.city, 'date' => self.date, 'charges' => self.charges}.to_json
  end
end

