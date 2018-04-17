require 'spec_helper'
require 'faker'

FactoryBot.define do
  factory :car, class: Car do
    title { Faker::Vehicle.manufacture }
    style { Car::CAR_STYLES.keys[(rand * 3).floor] }

    initialize_with { new(title, style) }
  end
end
