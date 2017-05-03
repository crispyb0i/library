class Person
  attr_accessor(:id, :name)
  define_method(:initialize) do |attrib|
    @id = attrib[:id]
    @name = attrib[:name]
  end

  define_method(:==) do |person2|
     self.id == person2.id
   end

  define_singleton_method(:all) do
    all_people = []
    returned_people = DB.exec('SELECT * FROM people')
    returned_people.each() do |person|
      id = person["id"].to_i
      name = person["name"]
      person_rm = Person.new({:id=>id,:name=>name})
      all_people.push(person_rm)
    end
    all_people
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO people (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  define_singleton_method(:find) do |id|
    found = nil
    Person.all.each() do |person|
      if person.id == id
        found = person
      end
    end
    found
  end

end
