class Oystercard
  
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  attr_reader :balance, :journeys

  def initialize
    @balance = 0
    @in_use = false
    @journeys = Hash.new
  end
  
  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    !!@in_use
  end

  def touch_in(station)
    fail "Minimum balance of #{MINIMUM_BALANCE} required to touch in" if @balance < MINIMUM_BALANCE
    @in_use = true
    @journeys.store(:entry_station, station)
  end

  def touch_out(station)
    @in_use = false
    deduct(MINIMUM_BALANCE)
    @journeys.store(:exit_station, station)
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end