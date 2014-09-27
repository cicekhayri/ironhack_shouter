require 'rubygems'
require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
enable :sessions

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'shouter.sqlite'
)

class User < ActiveRecord::Base
  has_many :shouts

  validates :name, presence: true 
  validates :handle, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8, maximum: 20 }
  before_create :random_password

  def random_password(size = 20)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (8...size).map{ charset.to_a[rand(charset.size)] }.join.downcase
  end

end

class Shout < ActiveRecord::Base
  belongs_to :user

  validates :message, presence: true,  
            length: { in: 1..200, message: "Must be 1 character and maximum 200"}
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
  shout.created_at = Time.now
  shout.message = params[:text]
  user = User.find_by_password(params[:password])
  shout.user_id = user.id
  shout.likes = 0

  if shout.save
    redirect '/'
  else
    @errors = shout.errors
    erb :data_not_valid
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

get '/:id/delete' do
  @shout = Shout.find(params[:id])

  erb :delete
end

delete '/:id' do
  @shout = Shout.find(params[:id])
  @user = User.find_by_password(params[:password])
  @shout.user_id = @user.id

  if @user 
    @shout.destroy    
    redirect '/'
  else
    redirect '/'
  end

end

private
def decrement
  update_attributes(:likes => likes - 1)
end

def increment
  update_attributes(:likes => likes + 1)
end

