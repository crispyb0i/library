require("rspec")
require("pg")
require("book")
require("person")
require('author')

DB = PG.connect({:dbname => "library_test"})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM people *;")
    DB.exec("DELETE FROM checkouts *;")
    DB.exec("DELETE FROM author *;")
    DB.exec("DELETE FROM authorbook *;")
  end
end
