#
# Below are 3 classes used for making a car rental program
#
# 1. Improve and simplify the code but don't change the output. We're looking for demonstrated knowledge of Ruby idioms, general good coding practices, and testing
# 2. Add a new method (json_statement) to Driver which gives you back the statement in JSON format
# 3. Create a rake task that runs your tests.
#

class Car
  SALOON = 0
  SUV = 1
  HATCHBACK = 2

  attr_reader :title
  attr_accessor :style

  def initialize(title, style)
    @title = title
    @style = style
  end
end

class Rental
  attr_reader :car, :days_rented

  def initialize(car, days_rented)
    @car = car
    @days_rented = days_rented

    if !(@days_rented > 0)
      raise 'Error: days_rented invalid'
    end
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

  def statement
    total = 0
    bonus_points = 0
    result = "Car rental record for #{@name.to_s}\n"
    for r in @rentals
      this_amount = 0
      case r.car.style
        when Car::SUV
          this_amount += r.days_rented * 30
        when Car::HATCHBACK
          this_amount += 15
          if r.days_rented > 3
            this_amount += (r.days_rented - 3) * 15
          end
        when Car::SALOON
          this_amount += 20
          if r.days_rented > 2
            this_amount += (r.days_rented - 2) * 15
          end
        else

      end

      if this_amount < 0
        bonus_points -= 10
      end

      bonus_points = bonus_points + 1
      if r.car.style == Car::SUV && r.days_rented > 1
        bonus_points = bonus_points + 1
      end

      result += r.car.title.to_s + "," + this_amount.to_s + "\n"
      total += this_amount
    end

    result += "Amount owed is €" + "#{total.to_s}" + "\n"
    result += "Earned bonus points: " + bonus_points.to_s
    result
  end
end
