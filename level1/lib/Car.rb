class Car
    attr_reader :id, :price_day, :price_km

    # defining a class variable to store instances
    @@instances = []

    def initialize(attributes)
        @id = attributes['id']
        @price_day = attributes['price_per_day']
        @price_km = attributes['price_per_km']
        @@instances << self
    end

    private

    # defining a class method to return every instances
    def self.all
        @@instances
    end
end