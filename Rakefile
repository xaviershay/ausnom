namespace :ausnom do
  desc "Load data files"
  task :load do
    require 'csv'
    require 'dm-core'
    require 'dm-migrations'
    require 'dm-transactions'
    require './models'

    DataMapper.auto_migrate!
    Food.all.destroy!
    Nutrient.all.destroy!

    Food.transaction do
      CSV.foreach("data/food file.txt") do |row|
        food = Food.new
        food.attributes = {
          :food_id     => row[0],
          :name        => row[1],
          :description => row[3]
        }
        food.save
        puts food.name
      end

      CSV.foreach("data/Nutrient file.txt") do |row|
        nutrient = Nutrient.new
        nutrient.attributes = {
          :food_id     => row[0],
          :nutrient_id => row[1],
          :description => row[2],
          :scale       => row[3],
          :value       => row[4]
        }
        nutrient.save
      end
    end
  end
end

