require 'date'
require_relative 'Car'
require_relative 'Option'


class Rental
    attr_reader :id, :base_price, :commission, :duration

    # defining a class variable to store instances
    @@instances = []

    # defining an action hash common to every instances
    @@actions = {
        'driver'     => "debit",
        'owner'      => "credit",
        'insurance'  => "credit",
        'assistance' => "credit",
        'drivy'      => "credit",
    }

    def initialize(attributes)
        @id = attributes['id']
        @car = Car.all.find{ |car| car.id == attributes["car_id"] }
        @start_date = attributes['start_date']
        @end_date = attributes['end_date']
        @distance = attributes['distance']
        @duration = duration_in_days
        @base_price = calculate_price
        @options = Option.all.select{ |o| o.rental_id == @id }
        @commission = calculate_commission_with_options
        @@instances << self
    end

    # method to export the appropriate data for the report
    def export
        {
            "id" => @id,
            "options" => get_options,
            "actions" => dispatch_actions,
        }
    end
            
    # calculating options prices if needed
    def compute_options
        owner_option_fee = 0
        drivy_option_fee = 0
        if @options
            owner_option_fee = (@options.select { |o| o.details.first == "owner" }.map{ |o| o.details.last }.sum * @duration).to_i
            drivy_option_fee = (@options.select { |o| o.details.first == "drivy" }.map{ |o| o.details.last }.sum * @duration).to_i
        end
        {
            "total" => owner_option_fee + drivy_option_fee,
            "drivy" => drivy_option_fee,
            "owner" => owner_option_fee
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

    # fetch rental's options types 
    def get_options
        @options.map { |opt| opt.type }
    end

    # calculate the number of days for the rental
    def duration_in_days
       (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
    end

    # compute the correct price amount depending of duration & distance
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

    # compute commision distribution including options
    def calculate_commission_with_options
        base_commission = @base_price * 0.3
        insurance_fee = base_commission / 2
        assistance_fee = 100 * @duration
        drivy_fee = base_commission - (insurance_fee + assistance_fee) + compute_options["drivy"]
        {
            "insurance_fee" => insurance_fee.to_i,
            "assistance_fee" => assistance_fee.to_i,
            "drivy_fee" => drivy_fee.to_i
        }
    end

    # building actions array for the output file
    def dispatch_actions
        @@actions.entries.map do |action| 
            case action.first
            when "driver"
                amount = @base_price + compute_options["total"]
            when "owner"
                amount = @base_price * 0.7 + compute_options["owner"]
            else
                amount = @commission.select { |k,v| k.include? action.first }.values[0]
            end
            {
                "who" => action.first,
                "type" => action.last,
                "amount" => amount.to_i 
            }
        end
    end

end
