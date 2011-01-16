require 'dm-core'
require './searchable'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/ausnom')

class Food
  include DataMapper::Resource
  include Searchable

  has n, :nutrients, :child_key => [:food_id]

  property :food_id, String, :key => true
  property :name, String, :length => 255
  property :description, Text

  searchable [:name, :description]
end

class Nutrient
  include DataMapper::Resource

  belongs_to :food, :child_key => [:food_id]

  property :food_id, String, :key => true
  property :nutrient_id, String, :key => true
  property :description, Text
  property :scale, String
  property :value, Float
end
