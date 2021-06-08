# dependencies     
require 'sinatra' # microframework
require 'sinatra/reloader' # only reloads this ruby file !!!
require 'bcrypt'
require 'pry'

require_relative "db/helpers.rb"

enable :sessions # there ya go crspy sinatra feature

def current_user
  if session[:user_id] == nil
    return {}
  end

  # ruby - implicit return
  return run_sql("SELECT * FROM users WHERE id = #{session[:user_id]};")[0]
end

def logged_in?
  if session[:user_id] == nil
    return false
  else
    return true
  end
end

get '/' do
  dishes = run_sql("SELECT * FROM dishes;")
  erb :index, locals: { dishes: dishes }
end


get '/dishes/new' do
  erb(:new_dish_form)
end

get '/dishes/:id' do
  res = run_sql("SELECT * FROM dishes WHERE id = $1;", [params["id"]])
  dish = res[0] # take the first item as a hash in the arr
  erb :show_dish, locals: { dish: dish }
end

post '/dishes' do
  redirect '/login' unless logged_in?

  sql = "INSERT INTO dishes (name, image_url, user_id) VALUES ($1, $2, $3);"
  run_sql(sql, [
    params['name'],
    params['image_url'],
    current_user()['id'] # same as session[:user_id]
  ])
  redirect '/'
end

delete '/dishes/:id' do
  # if !logged_in?
  #   redirect '/login'
  # end

  redirect '/login' unless logged_in? # syntactic sugar


  sql = "DELETE FROM dishes WHERE id = $1;"
  run_sql(sql, [params['id']])
  # redirect to a get route of your choice
  redirect '/'
end

get '/dishes/:id/edit' do
  # [{}]
  res = run_sql("SELECT * FROM dishes WHERE id = $1;", [params['id']])
  dish = res[0]
  erb :edit_dish_form, locals: { dish: dish }
end

put '/dishes/:id' do
  # grab contents of the form and the url
  # prepare sql
  sql = "UPDATE dishes SET name = $1, image_url = $2 WHERE id = $3;"
  
  # run it
  run_sql(sql, [
    params['name'],
    params['image_url'],
    params['id']
  ])

  # redirect
  redirect "/dishes/#{params['id']}"
end

get '/login' do
  erb :login
end

post '/session' do
  # got email & password
  # lookup the record by the email address
  records = run_sql("SELECT * FROM users WHERE email = $1;", [params['email']])

  if records.count > 0 && BCrypt::Password.new(records[0]['password_digest']) == params['password']
    # yeah
    # write it down that you are now logged in
    # session is like a global hash 
    # one for every user
    # we will make up a key and assign a value to remeber this user is logged in
    # single source of truth - storing only the id - get the rest from db
    logged_in_user = records[0]
    session[:user_id] = logged_in_user["id"]
    redirect '/'
  else
    # nah
    erb :login
  end

  
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end


# http - stateless - scaling
# session
# cookie


# httparty - makes http request
# pg - talks to your postgresql database only

# single request response cycle
