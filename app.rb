require('sinatra')
require('sinatra/reloader')
require('./lib/book')
require('./lib/person')
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
  #update
  @books = Book.all
  erb(:all_books)
end

get('/books/:id') do
  @book = Book.find(params[:id].to_i)
  erb(:one_book)
end

patch('/books/:id') do
  #update existing book off params
  @book = Book.find(params[:id].to_i)
  erb(:all_books)
end

delete('/books/:id') do
  #delete book
  @book = Book.find(params[:id].to_i)
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
