require 'spec_helper'
require 'faker'

FactoryBot.define do
  factory :driver, class: Driver do
    name { Faker::Name.name }

    initialize_with { new(name) }
  end
end
