require 'date'
require_relative 'Car'

class Rental
    attr_reader :id, :price, :commission

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
        @commission = calculate_commission
        @@instances << self
    end

    # method to export the appropriate data for the report
    def export
        {
            "id": @id,
            "price": @price,
            "commission": @commission
        }
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
    
    private

    # method to compute the correct price amount
    def calculate_price
        total = @distance * @car.price_km

        (1..@duration).each do |day|
            case day
            when 0...2
                total += @car.price_day
            when 2..4
                total += @car.price_day * 0.9
            when 4..10
                total += @car.price_day * 0.7
            else 
                total += @car.price_day * 0.5
            end
        end
        total.to_i
    end

    # method to calculate the number of days for the rental
    def duration_in_days
       (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
    end

    def calculate_commission
        base_commission = @price * 0.3
        insurance_fee = base_commission / 2
        assistance_fee = 100 * @duration
        drivy_fee = base_commission - (insurance_fee + assistance_fee)
        {
            "insurance_fee" => insurance_fee.to_i,
            "assistance_fee" => assistance_fee.to_i,
            "drivy_fee" => drivy_fee.to_i 
        }
    end
end