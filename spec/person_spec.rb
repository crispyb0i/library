require('spec_helper')

describe(Person) do
  describe('#==') do
    it('returns true if person ids are the same') do
    person1 = Person.new({:id=>nil, :name=>'Bilbo Baggins'})
    person2 = Person.new({:id=>nil, :name=>'King Kong'})
      expect(person1).to(eq(person2))
    end
  end

  describe('.all') do
    it('is empty at first') do
      expect(Person.all).to(eq([]))
    end
  end

  describe("#save") do
    it("adds a person to the database of saved persons") do
      person1 = Person.new({:id=>nil, :name=>'Bilbo Baggins'})
      person1.save()
      expect(Person.all()).to(eq([person1]))
    end
  end

  describe('.find') do
    it('returns an object with a matching id to passed argument') do
      person1 = Person.new({:id=>nil, :name=>'Bilbo Baggins'})
      person2 = Person.new({:id=>nil, :name=>'King Kong'})
      person1.save
      person2.save
      expect(Person.find(person2.id)).to(eq(person2))
    end
  end

  describe('#checkout') do
    it('updating person_id and adding a return id') do
      book1 = Book.new({:id=>nil, :title=>'Modern Romance', :checkout_id=>0})
      book2 = Book.new({:id=>nil, :title=>'Hello Kitty', :checkout_id=>0})
      person1 = Person.new({:id=>nil, :name=>'Jacob'})
      book1.save
      book2.save
      person1.save
      person1.checkout([book1.id,book2.id])
      expect(Book.find(book1.id).person_id).to(eq(person1.id.to_s))
    end
  end

  describe('#all_checkouts') do
    it('returns an array of books checked out by self') do
      book1 = Book.new({:id=>nil, :title=>'Modern Romance', :checkout_id=>0})
      book2 = Book.new({:id=>nil, :title=>'Hello Kitty', :checkout_id=>0})
      person1 = Person.new({:id=>nil, :name=>'Jacob'})
      book1.save
      book2.save
      person1.save
      person1.checkout([book1.id])
      person1.checkout([book2.id])
      expect(person1.all_checkouts).to(eq([book1,book2]))
    end
  end

  describe('#history') do
    it('dsfsgs') do
      book1 = Book.new({:id=>nil, :title=>'Modern Romance'})
      book2 = Book.new({:id=>nil, :title=>'Hello Kitty'})
      person1 = Person.new({:id=>nil, :name=>'Jacob'})
      book1.save
      book2.save
      person1.save
      person1.checkout([book1.id])
      person1.checkout([book2.id])
      expect(person1.history).to(eq([{'id'=>book1.id.to_s, 'title'=>'Modern Romance', 'person_id'=>person1.id.to_s, 'return'=>book1.return},{'id'=>book2.id.to_s, 'title'=>'Hello Kitty', 'person_id'=>person1.id.to_s, 'return'=>book1.return}]))
    end
  end
end
