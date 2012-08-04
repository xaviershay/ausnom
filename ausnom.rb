require 'sinatra'
require 'json'
require './models'

LAST_MODIFIED = Time.mktime(2011,1,24).httpdate
TOP_NUTRIENTS = %w(ENERGY-04DF PROT FE FAT)

get '/' do
  last_modified LAST_MODIFIED
  @q = params[:q]
  @foods = @q ? Food.search(@q) : []
  if @foods.length == 1
    redirect "/foods/#{@foods[0].food_id}"
  else
    erb :index
  end
end

get '/foods/:id.json' do
  last_modified LAST_MODIFIED
  @food = Food.get!(params[:id])
  @food.attributes.merge(
    :nutrients => @food.nutrients.map {|x| x.attributes.except(:food_id) }
  ).to_json
end

get '/foods/:id' do
  last_modified LAST_MODIFIED
  @food = Food.get!(params[:id])
  all_nutrients = @food.nutrients.all(:order => [:description.asc])
  @top_nutrients = all_nutrients.select {|x| TOP_NUTRIENTS.include?(x.nutrient_id) }.sort_by {|x| TOP_NUTRIENTS.index(x.nutrient_id) }
  @other_nutrients = all_nutrients - @top_nutrients
  erb :show
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def format_value v
    if v > 10
      v.round
    else
      v
    end
  end

  def page_title
    if @food
      @food.name
    elsif @q
      "Search for '#{@q}'"
    else
      "AU and NZ nutrional data web service"
    end
  end
end
