require 'date'
require_relative 'Car'

class Rental
    attr_reader :id, :price

    # defining a class variable to store instances
    @@instances = []

    def initialize(attributes)
        @id = attributes['id']
        @car = Car.all.find{ |car| car.id == attributes["car_id"] }
        @start_date = attributes['start_date']
        @end_date = attributes['end_date']
        @distance = attributes['distance']
        @duration = duration_in_days
        @price = calculate_price
        @@instances << self
    end

    # method to export the appropriate data for the report
    def export
        {
            "id": @id,
            "price": @price,
        }
    end
    
    private

    # method to compute the correct price amount
    def calculate_price
        @duration * @car.price_day + @distance * @car.price_km
    end

    # method to calculate the number of days for the rental
    def duration_in_days
       (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
    end

    # class method to return every instances
    def self.all
        @@instances
    end

    # class method to generate the appropriate output
    def self.generate_report
        output = {
            "rentals": @@instances.map{ |r| r.export }
        }
    end
end