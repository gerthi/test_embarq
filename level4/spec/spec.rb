require 'json'
require 'Car'
require 'Rental'
require_relative '../main.rb'

describe "TESTS LEVEL 4" do
    input = JSON.parse(File.read(File.join(__dir__, '../data/input.json')))
    cars = input.dig('cars')
    rentals = input.dig('rentals')

    before(:all) do
        @rental1 = Rental.all.first
        @car1 = Car.all.first
    end


    context "- Car model" do
        it "is initialized with an id, a price_day & a price_km property" do
            expect(Car.all.first.id).to be_an(Integer)
            expect(Car.all.first.price_day).to be_an(Integer)
            expect(Car.all.first.price_km).to be_an(Integer)
        end

        it "has an all method returns an array of car instances" do
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
            expect(@rental1.price).to eq 3000
        end

        it 'has an export method that returns its id & actions' do
            expect(@rental1.export.dig("id")).to eq 1
            expect(@rental1.export.dig("actions")).to be_an(Array)
        end

        it 'calculates the commission properly' do
            expect(@rental1.commission.keys.include?('insurance_fee')).to eq true
            expect(@rental1.commission.dig('insurance_fee')).to eq 450
            
            expect(@rental1.commission.keys.include?('assistance_fee')).to eq true
            expect(@rental1.commission.dig('assistance_fee')).to eq 100

            expect(@rental1.commission.keys.include?('drivy_fee')).to eq true
            expect(@rental1.commission.dig('drivy_fee')).to eq 350
        end

        it 'it dispatches actions with the correct amounts' do
            actions = @rental1.export.dig('actions')           
            
            expect(actions.select{ |a| a["who"].include?("driver")}.first["amount"]).to eq @rental1.price
            expect(actions.select{ |a| a["who"].include?("owner")}.first["amount"]).to eq @rental1.price * 0.7
            expect(actions.select{ |a| a["who"].include?("insurance")}.first["amount"]).to eq @rental1.commission['insurance_fee']
            expect(actions.select{ |a| a["who"].include?("assistance")}.first["amount"]).to eq @rental1.commission['assistance_fee']
            expect(actions.select{ |a| a["who"].include?("drivy")}.first["amount"]).to eq @rental1.commission['drivy_fee']
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