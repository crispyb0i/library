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

  define_method(:all_checkouts) do
    all_books = []
    returned_books = DB.exec("SELECT * FROM books WHERE person_id=#{self.id};")
    returned_books.each() do |book|
      puts(book)
      all_books.push(book)
    end
    all_books
  end

  define_method(:checkout) do |array|
    array.each do |id|
      DB.exec("INSERT INTO checkouts (person_id, book_id) VALUES ('#{self.id}', '#{id}')")
      DB.exec("UPDATE books SET person_id ='#{self.id}' WHERE id=#{id};")
      DB.exec("UPDATE books SET return = '#{Time.now+(3600*24*7)}' WHERE id=#{id};")
    end
  end

  define_method(:checkin) do |array|
    array.each do |book_id|
      DB.exec("UPDATE books SET person_id ='0' WHERE id=#{book_id};")
      DB.exec("UPDATE books SET return =null WHERE id=#{book_id};")    
    end
  end

  define_method(:history) do
    all_book_ids = []
    all_books = []
    checkouts = DB.exec("SELECT * FROM checkouts WHERE person_id=#{self.id};")
    checkouts.each do |checkout|
      all_book_ids.push(checkout['book_id'])
    end
    all_book_ids.each do |book_id|
      returned_book = DB.exec("SELECT * FROM books WHERE id=#{book_id};")
      all_books.push(returned_book.first)
    end
    all_books
  end
end
