#
# Below are 3 classes used for making a car rental program
#
# 1. Improve and simplify the code but don't change the output. We're looking for demonstrated knowledge of Ruby idioms, general good coding practices, and testing
# 2. Add a new method (json_statement) to Driver which gives you back the statement in JSON format
# 3. Create a rake task that runs your tests.
#

class Car
  CAR_STYLES = { saloon: 'Saloon', suv: 'SUV', hatchback: 'Hatchback' }.freeze

  attr_reader :title
  attr_accessor :style

  def initialize(title, style)
    raise "Invalid car type. Options are :#{Car::CAR_STYLES.keys.join(', :')}."\
      unless CAR_STYLES.keys.include?(style)
    @title = title
    @style = style
  end
end

class Rental
  attr_reader :car, :days_rented

  def initialize(car, days_rented)
    raise 'Error: days_rented invalid' if days_rented <= 0
    @car = car
    @days_rented = days_rented
  end

  def bonus_points
    bonus_points = 1
    suv_rent_for_more_than_one_day = (car.style == :suv) && days_rented > 1
    bonus_points += 1 if suv_rent_for_more_than_one_day
    bonus_points
  end

  def amount
    amount = 0
    case Car::CAR_STYLES[car.style]
    when Car::CAR_STYLES[:suv]
      amount += days_rented * 30
    when Car::CAR_STYLES[:hatchback]
      amount += 15
      if days_rented > 3
        amount += (days_rented - 3) * 15
      end
    when Car::CAR_STYLES[:saloon]
      amount += 20
      if days_rented > 2
        amount += (days_rented - 2) * 15
      end
    end
    amount
  end
end

class Driver
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(rental)
    @rentals << rental
  end

  def total_amount
    @rentals.sum(&:amount)
  end

  def total_bonus_points
    @rentals.sum(&:bonus_points)
  end

  def statement
    result = "Car rental record for #{@name}\n"

    @rentals.each { |r| result += "#{r.car.title}, #{r.amount}\n" }

    result += "Amount owed is €#{total_amount}\n"
    result += "Earned bonus points: #{total_bonus_points}"
    result
  end

  def json_statement
    require 'json'
    rentals = @rentals.map { |r| { car: r.car.title, amount: r.amount } }
    hash_response = {
      name: @name,
      amount: total_amount,
      points: total_bonus_points,
      rentals: rentals,
      message: statement
    }
    JSON.generate(hash_response)
  end
end
