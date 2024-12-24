class Gate
  attr_reader :input1, :input2, :output

  def initialize(input1, input2, output)
    @input1 = input1
    @input2 = input2
    @output = output
    @indeterminate = true
  end

  def check(wires)
    unless wires[input1].nil? || wires[input2].nil?
      wires[output] = operate(wires[input1], wires[input2])
      @indeterminate = false
    end
  end

  def indeterminate?
    @indeterminate
  end
end

class AndGate < Gate
  def operate(input1, input2) = input1 & input2

  def to_s
    "#{input1} AND #{input2} --> #{output} (#{indeterminate? ? 'indeterminate' : 'DETERMINATE'})"
  end
end

class OrGate < Gate
  def operate(input1, input2) = input1 | input2

  def to_s
    "#{input1} OR #{input2} --> #{output} (#{indeterminate? ? 'indeterminate' : 'DETERMINATE'})"
  end
end

class XorGate < Gate
  def operate(input1, input2) = input1 ^ input2

  def to_s
    "#{input1} XOR #{input2} --> #{output} (#{indeterminate? ? 'indeterminate' : 'DETERMINATE'})"
  end
end
