class Author
  attr_accessor(:id, :name)
  define_method(:initialize) do |attrib|
    @id = attrib[:id]
    @name = attrib[:name]
  end

  # define_method(:==) do |auth2|
  #  self.id == auth2.id
  # end

  define_singleton_method(:all) do
    all_authors = []
    returned_authors = DB.exec('SELECT * FROM author')
    returned_authors.each() do |author|
      id = author["id"].to_i
      name = author["name"]
      author_rm = Author.new({:id=>id,:name=>name})
      all_authors.push(author_rm)
    end
    all_authors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO author (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  define_singleton_method(:find) do |id|
    found = nil
    Author.all.each() do |author|
      if author.id == id
        found = author
      end
    end
    found
  end

  define_singleton_method(:auth_update) do |name|
    found_author = nil;
    Author.all.each() do |author|
      if author.name==name
        found_author = author
      end
    end

    if found_author!=nil
      found_author.id
    else
      new_auth = Author.new(:id=>nil, :name=>name)
      new_auth.save
      new_auth.id
    end
  end
end
