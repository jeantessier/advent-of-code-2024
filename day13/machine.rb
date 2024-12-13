class Machine
  attr_reader :ax, :ay, :bx, :by, :px, :py

  BUTTON_A_REGEX = /Button A: X\+(?<ax>\d+), Y\+(?<ay>\d+)/
  BUTTON_B_REGEX = /Button B: X\+(?<bx>\d+), Y\+(?<by>\d+)/
  PRIZE_REGEX = /Prize: X=(?<px>\d+), Y=(?<py>\d+)/

  def initialize(machine_configuration, prize_correction = 0)
    machine_configuration.map { |line| BUTTON_A_REGEX.match(line) }.compact.each do |match|
      @ax = match[:ax].to_f
      @ay = match[:ay].to_f
    end

    machine_configuration.map { |line| BUTTON_B_REGEX.match(line) }.compact.each do |match|
      @bx = match[:bx].to_f
      @by = match[:by].to_f
    end

    machine_configuration.map { |line| PRIZE_REGEX.match(line) }.compact.each do |match|
      @px = match[:px].to_f + prize_correction
      @py = match[:py].to_f + prize_correction
    end
  end

  def a = @a ||= ((bx * py) - (by * px)) / ((bx * ay) - (by * ax))
  def b = @b ||= ((ax * py) - (ay * px)) / ((ax * by) - (ay * bx))

  def valid?
    @valid ||= a == a.floor && b == b.floor
  end

  def minimum_tokens = @minimum_tokens ||= (3 * a.to_i) + b.to_i
end
