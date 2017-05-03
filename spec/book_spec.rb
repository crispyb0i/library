require('spec_helper')

describe(Book) do
  describe('#==') do
    it('returns true if book ids are the same') do
      book1 = Book.new({:id=>nil, :title=>'Modern Romance', :checkout_id=>0})
      book2 = Book.new({:id=>nil, :title=>'The Shining', :checkout_id=>0})
      expect(book1).to(eq(book2))
    end
  end

  describe('.all') do
    it('is empty at first') do
      expect(Book.all).to(eq([]))
    end
  end

  describe("#save") do
    it("adds a book to the database of saved books") do
      book1 = Book.new({:id=>nil, :title=>'Modern Romance', :checkout_id=>0})
      book1.save()
      expect(Book.all()).to(eq([book1]))
    end
  end

  describe('.find') do
    it('returns an object with a matching id to passed argument') do
      book1 = Book.new({:id=>nil, :title=>'Modern Romance', :checkout_id=>0})
      book2 = Book.new({:id=>nil, :title=>'The Shining', :checkout_id=>0})
      book1.save
      book2.save
      expect(Book.find(book2.id)).to(eq(book2))
    end
  end

  describe('#authors') do
    it('returns array of all authors associated with self') do
      book1 = Book.new({:id=>nil, :title=>'Modern Romance', :checkout_id=>0})
      book1.save
      author1 = Author.new({:id=>nil, :name=>'Bob Bob'})
      author1.save
      book1.update({:author_ids=>[author1.id]})
      expect(book1.authors).to(eq(['Bob Bob']))
    end
  end


end
