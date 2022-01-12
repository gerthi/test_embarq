require 'json'

require_relative 'lib/Car'
require_relative 'lib/Rental'
require_relative 'lib/Option'


def generate_output_file
    input = JSON.parse(File.read(File.join(__dir__, 'data', 'input.json')))

    # creating the cars from the input data
    input.dig('cars').each do |data|
        Car.new(data)
    end 
    
    # creating the options from the input data
    input.dig('options').each do |option|
        Option.new(option)
    end
    
    # creating the rentals from the input data
    input.dig('rentals').each do |data|
        Rental.new(data)
    end
    
    # generating the output file
    file_output = File.join(__dir__, './data/output.json')
    
    File.open(file_output, 'wb') do |file|
        file.write(JSON.generate(Rental.generate_report))
    end
end

generate_output_file
