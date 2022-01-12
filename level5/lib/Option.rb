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
            ["owner", 500]
        when "baby_seat"
            ["owner", 200]
        when "additional_insurance"
            ["drivy", 1000]
        else
            ["", 0]
        end
    end

    def self.all
        @@instances
    end
end