require('sinatra')
require('sinatra/reloader')
require('./lib/book')
require('./lib/person')
require('./lib/author')
require('pry')
also_reload('lib/**/*.rb')
require('pg')

DB = PG.connect({:dbname => 'library'})

get('/') do
  erb(:index)
end

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
  erb(:one_book)
end

patch('/books/:id') do
  @book = Book.find(params[:id].to_i)
  #passes blank strings into update method
  @book.update({:title=>params[:update_title], :author_ids=>[Author.auth_update(params[:update_author])]})
  erb(:one_book)
end

delete('/books/:id') do
  @book = Book.find(params[:id].to_i)
  DB.exec("DELETE FROM authorbook WHERE author_id=#{  params[:author_id]};")
  erb(:one_book)
end

delete('/books') do
  @book = Book.find(params[:id].to_i)
  @book.delete
  @books = Book.all
  erb(:all_books)
end

get('/patrons') do
  @people = Person.all
  erb(:all_people)
end

post('/patrons') do
  new_person = Person.new({:name=>params[:person_name]})
  new_person.save
  @people = Person.all
  erb(:all_people)
end

get('/patrons/:id') do
  @person = Person.find(params[:id].to_i)
  @books = Book.all
  erb(:one_person)
end

# get('/books/:id') do
#   @book = Book.find(params[:id].to_i)
#   erb(:one_book)
# end
