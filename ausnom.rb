require 'sinatra'
require 'json'
require './models'

LAST_MODIFIED = Time.mktime(2011,1,20).httpdate

get '/' do
  @q = params[:q]
  @foods = @q ? Food.search(@q) : []
  erb :index
end

get '/foods/:id.json' do
  header 'Expires' => (Time.now + 60*60*24*365*3).httpdate
  last_modified LAST_MODIFIED
  @food = Food.get!(params[:id])
  @food.attributes.merge(
    :nutrients => @food.nutrients.map {|x| x.attributes.except(:food_id) }
  ).to_json
end

get '/foods/:id' do
  headers 'Expires' => (Time.now + 60*60*24*365*3).httpdate
  last_modified LAST_MODIFIED
  @food = Food.get!(params[:id])
  erb :show
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
