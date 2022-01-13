require 'json'
require 'Car'
require 'Rental'
require_relative '../main.rb'

describe "TESTS LEVEL 3" do
    input = JSON.parse(File.read(File.join(__dir__, '../data/input.json')))
    cars = input.dig('cars')
    rentals = input.dig('rentals')

    context "- Car model" do
        it "a car instance has an id, a price_day & a price_km property" do
            expect(Car.all.first.id).to be_an(Integer)
            expect(Car.all.first.price_day).to be_an(Integer)
            expect(Car.all.first.price_km).to be_an(Integer)
        end

        it "the all method returns an array of car instances" do
            expect(Car.all).to be_an(Array)
            expect(Car.all.size).to eq cars.size
        end
    end

    context "- Rental model" do
        it 'has an all method that returns an array of rental instances' do
            expect(Rental.all).to be_an(Array)
            expect(Rental.all.size).to eq rentals.size
        end

        it 'is initialized with the discounted price if appropriate' do
            expect(Rental.all.first.price).to eq 3000
        end

        it 'has an export method that returns its id & price' do
            expect(Rental.all.first.export.dig(:id)).to eq 1
            expect(Rental.all.first.export.dig(:price)).to be_an(Integer)
        end

        it 'calculates the commission properly' do
            expect(Rental.all.first.commission.keys.include?('insurance_fee')).to eq true
            expect(Rental.all.first.commission.dig('insurance_fee')).to eq 450
            
            expect(Rental.all.first.commission.keys.include?('assistance_fee')).to eq true
            expect(Rental.all.first.commission.dig('assistance_fee')).to eq 100

            expect(Rental.all.first.commission.keys.include?('drivy_fee')).to eq true
            expect(Rental.all.first.commission.dig('drivy_fee')).to eq 350
            
        end
    end

    context "- Output file" do
        it "is equal to the expected_output_file" do
            output = JSON.parse(File.read(File.join('data', 'output.json')))
            expected = JSON.parse(File.read(File.join('data', 'expected_output.json')))
            expect(output).to eq expected
        end
    end
end