class Computer
  attr_reader :output

  INSTRUCTIONS = %i[adv bxl bst jnz bxc out bdv cdv]

  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
    @instruction_pointer = 0
    @output = []
  end

  def literal_operand(operand)
    operand
  end

  def combo_operand(operand)
    case operand
    when 0 then 0
    when 1 then 1
    when 2 then 2
    when 3 then 3
    when 4 then @a
    when 5 then @b
    when 6 then @c
    when 7 then raise('Reserved operand')
    else raise("Unknown operand: #{operand}")
    end
  end

  def adv(operand)
    @a = (@a / 2**combo_operand(operand)).to_i
    @instruction_pointer += 2
  end

  def bxl(operand)
    @b ^= literal_operand(operand)
    @instruction_pointer += 2
  end

  def bst(operand)
    @b = combo_operand(operand) % 8
    @instruction_pointer += 2
  end

  def jnz(operand)
    if @a.zero?
      @instruction_pointer += 2
    else
      @instruction_pointer = literal_operand(operand)
    end
  end

  def bxc(_)
    @b ^= @c
    @instruction_pointer += 2
  end

  def out(operand)
    @output << combo_operand(operand) % 8
    @instruction_pointer += 2
  end

  def bdv(operand)
    @b = (@a / 2**combo_operand(operand)).to_i
    @instruction_pointer += 2
  end

  def cdv(operand)
    @c = (@a / 2**combo_operand(operand)).to_i
    @instruction_pointer += 2
  end

  def opcode(opcode)
    INSTRUCTIONS[opcode] || raise("Unknown opcode: #{opcode}")
  end

  def run(program)
    puts "program: #{program} (#{program.size})"

    puts 'Running program:'
    (0...(program.size)).step(2).each do |i|
      puts sprintf('%03d: %d %d', i, program[i], program[i + 1])
    end
    puts

    while @instruction_pointer < program.size
      opcode = program[@instruction_pointer]
      operand = program[@instruction_pointer + 1]
      instruction = opcode(opcode)

      puts self
      puts "#{@instruction_pointer}: #{opcode} '#{instruction}' #{operand}"

      public_send(instruction, operand)
    end

    puts self
    puts 'HALT'
    puts
  end

  def to_s
    "A:#{@a} B:#{@b} C:#{@c} PC:#{@instruction_pointer} >> #{@output.join(',')}"
  end
end
