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
      person1 = Person.new({:id=>nil, :author=>'Aziz Ansari', :title=>'Modern Romance', :check_in=>nil})
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
end
