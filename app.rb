# Based on http://www.jonathanleighton.com/articles/2011/awesome-active-record-bug-reports/

# Run this script with `bundle exec ruby app.rb`
require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'time'

#require classes
require './models/post.rb'
require './models/user.rb'
require './models/comment.rb'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'
# Use `binding.pry` anywhere in this script for easy debugging
require 'csv'

# Connect to a sqlite3 database
# If you feel like you need to reset it, simply delete the file sqlite makes
# ActiveRecord::Base.establish_connection(
#   adapter: 'sqlite3',
#   database: 'db/bakery.db'
# )

if ENV['DATABASE_URL']
require 'pg'
 ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
require 'sqlite3'
 ActiveRecord::Base.establish_connection(
	adapter: 'sqlite3'
	database: 'db/development.db'
	)
end

register Sinatra::Reloader
enable :sessions

get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    erb :homepage
  else
    erb :not_allowed
  end
end

# erb :post
get '/user/post' do
    @user = User.find(session[:user_id])
    erb :post
end

# https://images.unsplash.com/photo-1525925709472-86e4e2a971e0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60
post '/user/post' do
  timeNow = Time.now
  myuser =   User.create(name: params["user_name"], email: params["user_email"], dob: timeNow, opening: timeNow, password: "1256")
  mypost = Post.create(user_id: myuser.id, title: "One Way", image: params["image"], author: "Jack", time: timeNow, my_post: params["paragraph"])
  @post = mypost.my_post
  @userName = myuser.name
  puts myuser.inspect
  @imageUrl = mypost.image
  # puts params
  redirect '/allblogs'
end

get "/allblogs" do
  @user = User.find(session[:user_id])
  @blog_instance = Post.all.reverse
  erb :my_user_post
end
# get '/user/blog/myblog' do
#   @blog = Blog.where(user_id: session[:user_id])
#  erb :my_blog
# end

get "/readblog" do
  if session[:user_id]
    @user = User.find(session[:user_id])
    @all_sales = User.all.reverse
    erb :all
  else
    erb :not_allowed
  end

end

get '/readblog/delete/:id' do
  Comment.find(params["id"]).destroy
  redirect '/readblog'
end

post '/readblog' do
  puts ">>>>>"
  puts params
  puts ">>>>>"

  # make a customer record
#   User.create(name: userName, email: "one@one.com", dob: noww,
#      opening: noww, password: "123456")
# userName = params["first_name"] + params["last_name"]
# # dob to determine the horoscope
#
# timeNow = Time.now
#
#   user_instance = User.create(
#     name: userName,
#     email: params["email"],
#     dob: params["dob"],
#     opening: now,
#     phone_number: params["phone_number"],
#   )
  # make a car record
  car_instance = Car.create(
    make: params["make"],
    model: params["model"],
    year: params["year"],
    sale_markup: params["sale_markup"],
    cost_price: params["cost_price"]
  )
  # make a Transaction with both
  Sale.create(car: car_instance, customer: customer_instance)

  redirect '/sales'
end

get '/login' do
  erb :login
end

post '/users/login' do
# dob to determine the horoscope
user_instance = User.find_by(email: params["email"], password: params["password"])

timeNow = Time.now

  puts ">>>>>>>>>>>>"
  puts user_instance.inspect
  puts ">>>>>>>>>>>>"
  if user_instance
    session[:user_id] = user_instance.id
    redirect '/'
  else
    redirect '/login'
  end
end

# sign uo route

get '/signup' do
  erb :signup
end


# user signup route

post '/users/signup' do
  timeNow = Time.now
  temp_user = User.find_by(email: params["email"])
  if temp_user
    redirect '/login'
  else
    user = User.create(name: params["username"], email: params["email"], dob: timeNow, opening: timeNow, password: params["password"])
    session[:user_id] = user.id
    redirect '/homepage'
  end
end


# logout rout
get '/logout' do
  session[:user_id] = nil
  redirect '/login'
end
