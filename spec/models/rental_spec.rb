require 'spec_helper'

RSpec.describe Rental, :model do
  context 'Rental build' do
    it 'with valid attributes' do
      expect(build(:rental)).to be_a Rental
    end

    it 'with days_rented <= 0 raise an error' do
      begin
        build(:rental, days_rented: 0)
      rescue RuntimeError => e
        expect(e.message).to eq \
          'Error: days_rented invalid'
      end
    end
  end

  describe 'methods' do
    let(:driver) { build(:driver, 'John') }
    let(:car_saloon) { build(:car, title: 'Car', style: :saloon) }
    let(:car_suv) { build(:car, title: 'Car', style: :suv) }
    let(:car_hatchback) { build(:car, title: 'Car', style: :hatchback) }

    describe '#bonus_points' do
      context 'for SALOON (0) car style' do
        it 'should return 1 point no matter how many rent days' do
          rental = build(:rental, car: car_saloon, days_rented: 10)
          expect(rental.bonus_points).to eq 1
        end
      end

      context 'for SUV (1) car style' do
        it 'should return 1 point for 1 day rent' do
          rental = build(:rental, car: car_suv, days_rented: 1)
          expect(rental.bonus_points).to eq 1
        end

        it 'should return 1 extra point for more than 1 day rent' do
          rental = build(:rental, car: car_suv, days_rented: 10)
          expect(rental.bonus_points).to eq 2
        end
      end

      context 'for HATCHBACK (2) car style' do
        it 'should return 1 point no matter how many rent days' do
          rental = build(:rental, car: car_hatchback, days_rented: 10)
          expect(rental.bonus_points).to eq 1
        end
      end
    end

    describe '#amount' do
      context 'for SALOON (0) car style' do
        context 'for 2 days or less' do
          it 'should return 20' do
            rental = build(:rental, car: car_saloon, days_rented: 2)
            expect(rental.amount).to eq 20
          end
        end

        context 'for more than 2 days' do
          it 'should return 20 for the first 2 days and more 15 for each aditional day' do
            rental = build(:rental, car: car_saloon, days_rented: 10)
            expect(rental.amount).to eq (20 + (15 * (10 - 2)))
          end
        end
      end

      context 'for SUV (1) car style' do
        context 'no matter how long' do
          it 'should always return 30 dayly' do
            rental = build(:rental, car: car_suv, days_rented: 10)
            expect(rental.amount).to eq (30 * 10) # (value * days)
          end
        end
      end

      context 'for HATCHBACK (2) car style' do
        let(:car) { Car.new('Car', 2) }

        context 'for 3 days or less' do
          it 'should return 15' do
            rental = build(:rental, car: car_hatchback, days_rented: 3)
            expect(rental.amount).to eq 15
          end
        end

        context 'for more than 3 days' do
          it 'should charge 15 for the first 3 days and more 15 for each aditional day' do
            rental = build(:rental, car: car_hatchback, days_rented: 10)
            expect(rental.amount).to eq (15 + (15 * (10 - 3)))
          end
        end
      end
    end
  end
end
