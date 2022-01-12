require 'json'
require 'Car'
require 'Rental'

describe "TESTS LEVEL 2" do
    before(:all) do
        @car1 = Car.new({ "id"=> 1, "price_per_day"=> 2000, "price_per_km"=> 10 })
        @rental1 = Rental.new( { "id"=> 1, "car_id"=> 1, "start_date"=> "2017-12-8", "end_date"=> "2017-12-8", "distance"=> 100 })
    end

    context "- Car model" do
        it "a car instance has an id, a price_day & a price_km property" do
            expect(Car.all.first.id).to be_an(Integer)
            expect(Car.all.first.price_day).to be_an(Integer)
            expect(Car.all.first.price_km).to be_an(Integer)
        end

        it "the all method returns an array of car instances" do
            expect(Car.all).to eq [@car1]
        end
    end

    context "- Rental model" do
        it 'has an all method that returns an array of rental instances' do
            expect(Rental.all).to eq [@rental1]
        end

        it 'is initialized with the discounted price if appropriate' do
            expect(@rental1.price).to eq 3000
        end

        it 'has an export method that returns its id & price' do
            expect(@rental1.export.dig(:id)).to eq 1
            expect(@rental1.export.dig(:price)).to be_an(Integer)
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