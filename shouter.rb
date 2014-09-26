require 'rubygems'
require 'active_record'
require 'sinatra'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'shouter.sqlite'
)

class User < ActiveRecord::Base
  has_many :shouters

  validates :name, presence: true, allow_nil: false, allow_blank: false 
  validates :handle, presence: true, uniqueness: true, allow_nil: false, allow_blank: false
  validates :password, presence: true, length: { minimum: 8 }
end

class Shouter < ActiveRecord::Base
  belongs_to :user
end

get '/' do

end

get '/new_user' do
 
end
