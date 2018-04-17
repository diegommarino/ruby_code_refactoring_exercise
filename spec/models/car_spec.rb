require 'spec_helper'

RSpec.describe Car, :model do
  context 'Car build' do
    it 'with valid attributes' do
      car = build(:car)
      expect(car).to be_a Car
    end

    it 'with invalid style raise an error' do
      begin
        build(:car, style: :invalid_style)
      rescue RuntimeError => e
        expect(e.message).to eq \
          "Invalid car type. Options are :#{Car::CAR_STYLES.keys.join(', :')}."
      end
    end
  end
end
