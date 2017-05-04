require('sinatra')
require('sinatra/reloader')
require('./lib/book')
require('./lib/person')
require('./lib/author')
require('pry')
also_reload('lib/**/*.rb')
require('pg')

DB = PG.connect({:dbname => 'library'})
# DB.exec("DELETE FROM books *;")
# DB.exec("DELETE FROM people *;")
# DB.exec("DELETE FROM checkouts *;")
# DB.exec("DELETE FROM author *;")
# DB.exec("DELETE FROM authorbook *;")

get('/') do
  @people = Person.all
  erb(:index)
end

post('/') do
  new_person = Person.new({:name=>params[:person_name]})
  new_person.save
  @people = Person.all
  erb(:index)
end

get('/patrons/:patron_id') do
  @person = Person.find(params[:patron_id].to_i)
  @checkouts = @person.all_checkouts
  @books = Book.all
  erb(:one_person)
end

post ('/patrons/:patron_id') do
  @person = Person.find(params[:patron_id].to_i)
  @all_checked_books = params.fetch("books_ids",[])
  @person.checkout(@all_checked_books)
  @checkouts = @person.all_checkouts
  @books = Book.all
  erb(:one_person)
end

patch ('/patrons/:patron_id') do
  @person = Person.find(params[:patron_id].to_i)
  @checkin_books = params.fetch("checkedout_books_ids",[])
  @person.checkin(@checkin_books)
  @checkouts = @person.all_checkouts
  @books = Book.all
  erb(:one_person)
end

get('/patrons/:patron_id/history') do
  @person = Person.find(params[:patron_id].to_i)
  @history = @person.history
  erb(:history)
end

# Librarian views
get('/books') do
  @books = Book.all
  erb(:all_books)
end

post('/books') do
  new_book = Book.new({
    :id => nil,
    :title => params[:title],
    :checkout_id => 0
    })
  new_auth = Author.new({
    :id => nil,
    :name => params[:author]
    })
  new_book.save
  new_auth.save
  new_book.update({:author_ids=>[new_auth.id.to_i]})
  @books = Book.all
  erb(:all_books)
end

get('/books/:id') do
  @book = Book.find(params[:id].to_i)
  erb(:one_book_lib)
end

patch('/books/:id') do
  @book = Book.find(params[:id].to_i)
  #passes blank strings into update method
  @book.update({:title=>params[:update_title], :author_ids=>[Author.auth_update(params[:update_author])]})
  erb(:one_book_lib)
end

delete('/books/:id') do
  @book = Book.find(params[:id].to_i)
  DB.exec("DELETE FROM authorbook WHERE author_id=#{params[:author_id]};")

  erb(:one_book_lib)
end

delete('/books') do
  @book = Book.find(params[:id].to_i)
  @book.delete
  @books = Book.all
  erb(:all_books)
end
