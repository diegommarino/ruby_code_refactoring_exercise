require 'spec_helper'

RSpec.describe Driver, :model do
  describe 'methods' do
    describe '#statement' do
      let(:driver) { build(:driver, name: 'John') }
      let(:car_saloon) { build(:car, title: 'Car', style: :saloon) }
      let(:car_suv) { build(:car, title: 'Car', style: :suv) }
      let(:car_hatchback) { build(:car, title: 'Car', style: :hatchback) }

      context 'bonus points' do
        context 'for SALOON (0) car style' do
          it 'should earn 1 point no matter how many rent days' do
            rental = build(:rental, car: car_saloon, days_rented: 10)
            driver.add_rental(rental)
            expect(driver.statement).to include('points: 1')
          end
        end

        context 'for SUV (1) car style' do
          it 'should earn 1 point for 1 day rent' do
            rental = build(:rental, car: car_suv, days_rented: 1)
            driver.add_rental(rental)
            expect(driver.statement).to include('points: 1')
          end

          it 'should earn 1 extra point for more than 1 day rent' do
            rental = build(:rental, car: car_suv, days_rented: 10)
            driver.add_rental(rental)
            expect(driver.statement).to include('points: 2')
          end
        end

        context 'for HATCHBACK (2) car style' do
          it 'should earn 1 point no matter how many rent days' do
            rental = build(:rental, car: car_hatchback, days_rented: 10)
            driver.add_rental(rental)
            expect(driver.statement).to include('points: 1')
          end
        end
      end

      context 'rent price' do
        context 'for SALOON (0) car style' do
          context 'for 2 days or less' do
            it 'should be €20' do
              rental = build(:rental, car: car_saloon, days_rented: 2)
              driver.add_rental(rental)
              expect(driver.statement).to include('€20')
            end
          end

          context 'for more than 2 days' do
            it 'should charge €20 and more €15 for each aditional day' do
              rental = build(:rental, car: car_saloon, days_rented: 10)
              driver.add_rental(rental)
              expect(driver.statement).to include("€#{20 + (15 * (10 - 2))}")
            end
          end
        end

        context 'for SUV (1) car style' do
          context 'no matter how long' do
            it 'should always be €30 dayly' do
              rental = build(:rental, car: car_suv, days_rented: 10)
              driver.add_rental(rental)
              expect(driver.statement).to include("€#{30 * 10}") # (value * days)
            end
          end
        end

        context 'for HATCHBACK (2) car style' do
          context 'for 3 days or less' do
            it 'should be €15' do
              rental = build(:rental, car: car_hatchback, days_rented: 3)
              driver.add_rental(rental)
              expect(driver.statement).to include('€15')
            end
          end

          context 'for more than 3 days' do
            it 'should charge €15 and more €15 for each aditional day' do
              rental = build(:rental, car: car_hatchback, days_rented: 10)
              driver.add_rental(rental)
              expect(driver.statement).to include("€#{15 + (15 * (10 - 3))}")
            end
          end
        end
      end

      context 'string returned' do
        it 'should include some specific phrases' do
          rental = build(:rental, car: car_saloon, days_rented: 2)
          driver.add_rental(rental)
          statement = driver.statement
          expect(statement).to include 'Car rental record for'
          expect(statement).to include 'Amount owed is €'
          expect(statement).to include 'Earned bonus points: '
        end

        it 'should output the total amount of all rentals' do
          driver.add_rental(build(:rental, car: car_saloon, days_rented: 1)) # €20
          driver.add_rental(build(:rental, car: car_suv, days_rented: 1)) # €30
          driver.add_rental(build(:rental, car: car_hatchback, days_rented: 1)) # €15
          expect(driver.statement).to include "Amount owed is €#{20 + 30 + 15}"
        end

        it 'should output the amount of each rental' do
          driver.add_rental(build(:rental, car: car_saloon, days_rented: 1)) # €20
          driver.add_rental(build(:rental, car: car_suv, days_rented: 1)) # €30
          driver.add_rental(build(:rental, car: car_hatchback, days_rented: 1)) # €15
          expect(driver.statement).to include '20'
          expect(driver.statement).to include '30'
          expect(driver.statement).to include '15'
        end

        it 'should output the total bonus points acumulated' do
          driver.add_rental(build(:rental, car: car_saloon, days_rented: 10)) # 1 point
          driver.add_rental(build(:rental, car: car_suv, days_rented: 10)) # 2 points
          driver.add_rental(build(:rental, car: car_hatchback, days_rented: 10)) # 1 point
          expect(driver.statement).to include "Earned bonus points: #{1 + 2 + 1}"
        end
      end
    end
  end
end
