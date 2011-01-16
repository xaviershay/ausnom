require 'sinatra'
require 'json'
require './models'

get '/' do
  @q = params[:q]
  @foods = @q ? Food.search(@q) : []
  erb :index
end

get '/foods/:id.json' do
  @food = Food.get!(params[:id])
  @food.attributes.merge(
    :nutrients => @food.nutrients.map {|x| x.attributes.except(:food_id) }
  ).to_json
end

get '/foods/:id' do
  @food = Food.get!(params[:id])
  erb :show
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
