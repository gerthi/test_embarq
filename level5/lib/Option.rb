require_relative 'Rental'

class Option
    attr_reader :id, :type, :price, :rental_id

    @@instances = []
    
    def initialize(attributes)
        @id = attributes["id"]
        @rental_id = attributes["rental_id"]
        @type = attributes["type"]
        @details = details
        @@instances << self
    end

    def details
        case @type
        when "gps"
            {
                "who" => "owner",
                "price" => 500
            }
        when "baby_seat"
            {
                "who" => "owner",
                "price" => 200
            }
        when "additional_insurance"
            {
                "who" => "drivy",
                "price" => 1000
            }
        else
            {
                "who" => "",
                "price" => 0
            }
        end
    end

    def self.all
        @@instances
    end
end