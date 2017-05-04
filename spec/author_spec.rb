require('spec_helper')

describe(Author) do
  describe('#==') do
    it('returns true if person ids are the same') do
    author1 = Author.new({:id=>nil, :name=>'Bilbo Baggins'})
    author2 = Author.new({:id=>nil, :name=>'King Kong'})
      expect(author1).to(eq(author2))
    end
  end

  describe('.all') do
    it('is empty at first') do
      expect(Author.all).to(eq([]))
    end
  end

  describe("#save") do
    it("adds a author to the database of saved authors") do
      author1 = Author.new({:id=>nil, :author=>'Aziz Ansari', :title=>'Modern Romance', :check_in=>nil})
      author1.save()
      expect(Author.all()).to(eq([author1]))
    end
  end

  describe('.find') do
    it('returns an object with a matching id to passed argument') do
      author1 = Author.new({:id=>nil, :name=>'Bilbo Baggins'})
      author2 = Author.new({:id=>nil, :name=>'King Kong'})
      author1.save
      author2.save
      expect(Author.find(author2.id)).to(eq(author2))
    end
  end
end
