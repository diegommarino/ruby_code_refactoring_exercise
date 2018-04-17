require 'spec_helper'
require 'faker'

FactoryBot.define do
  factory :rental, class: Rental do
    car { build(:car) }
    days_rented { Faker::Number.between(1, 10) }

    initialize_with { new(car, days_rented) }
  end
end
