class Book
  attr_accessor(:id, :author, :title, :checkout_id)
  define_method(:initialize) do |attrib|
    @id = attrib[:id]
    @title = attrib[:title]
    @checkout_id = attrib[:checkout_id]
  end

  define_method(:==) do |book2|
   self.id == book2.id
  end


  define_singleton_method(:all) do
    all_books = []
    returned_books = DB.exec('SELECT * FROM books')
    returned_books.each() do |book|
      id = book["id"].to_i
      title = book["title"]
      checkout_id = book["checkout_id"]
      book_rm = Book.new({:id=>id,:title=>title,:checkout_id=>checkout_id})
      all_books.push(book_rm)
    end
    all_books
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO books (title, checkout_id) VALUES ('#{@title}','#{@checkout_id}') RETURNING id;")
    @id = result.first.fetch('id').to_i
    #if author is selected, set auth_id to val, else
    # auth_id = DB.exec("INSERT INTO author (name) VALUES ('#{@author}') RETURNING id;").first.fetch('id').to_i
    # DB.exec("INSERT INTO authorbook (author_id, book_id) VALUES ('#{auth_id}','#{@id}');")
  end

  define_singleton_method(:find) do |id|
    found = nil
    Book.all.each() do |book|
      if book.id == id
        found = book
      end
    end
    found
  end

  define_method(:authors) do
    authors = []
    returned_authors = DB.exec("SELECT id FROM authorbook WHERE book_id=#{self.id};")
    returned_authors.each() do |author_id|
      auth_id = author_id['id'].to_i
      found_author = DB.exec("SELECT * FROM author WHERE id=#{auth_id};")
      authors.push(found_author.first['name'])
    end
    authors
  end

  define_method(:update) do |attrib|
    #updates title
    @title = attrib.fetch(:title, @title)
    DB.exec("UPDATE books SET title='#{@title}' WHERE id='#{self.id}'")

    #updates author in authorbook
    attrib.fetch(:author_ids,[]).each() do |author_id|
      DB.exec("INSERT INTO authorbook (author_id, book_id) VALUES (#{author_id}, #{self.id})")
    end
  end

end
