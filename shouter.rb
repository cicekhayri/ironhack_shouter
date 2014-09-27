require 'rubygems'
require 'active_record'
require 'sinatra'
require 'sinatra/reloader'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'shouter.sqlite'
)

class User < ActiveRecord::Base
  has_many :shouts

  validates :name, presence: true, allow_nil: false, allow_blank: false 
  validates :handle, presence: true, uniqueness: true, allow_nil: false, allow_blank: false
  validates :password, presence: true, length: { minimum: 8 }
end

class Shout < ActiveRecord::Base
  belongs_to :user

  validates :message, presence: true, allow_nil: false, allow_blank: false, 
            length: { in: 1...200 }
  validates :created_at, presence: true

  validates :likes, numericality: true

end

get '/' do
  @shout = Shout.order(id: :desc)
  @user = User.all
  
  erb :index
end

post '/' do
  shout = Shout.new
  shout.created_at = Date.today
  shout.message = params[:text]
  user = User.find_by_password(params[:password])
  shout.user_id = user.id
  shout.likes = 0

  if shout.save
    redirect '/'
  else
    "OOOOPPPPSSS there was an error"
  end
  
end

get '/like/:id' do
  @shout = Shout.find(params[:id])
  @shout.increment!(:likes)
  redirect '/'
end

get '/dislike/:id' do
  @shout = Shout.find(params[:id])
  @shout.decrement!(:likes)
  redirect '/'
end

get '/best' do
  @shout = Shout.order(likes: :desc)

  erb :best
end

get '/handle' do
  @user = User.all
  erb :handle
end

get '/handle/:id' do
  @user = User.find(params[:id])
  @shout = Shout.where(:user_id => params[:id])

  erb :handle_user
end

private
def decrement
  update_attributes(:likes => likes - 1)
end

def increment
  update_attributes(:likes => likes + 1)
end

