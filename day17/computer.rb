class Computer
  attr_reader :a, :b, :c, :output

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
    when 0..3 then operand
    when 4 then a
    when 5 then b
    when 6 then c
    when 7 then raise('Reserved operand')
    else raise("Unknown operand: #{operand}")
    end
  end

  def adv(operand)
    @a = (a / 2**combo_operand(operand)).to_i
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
    if a.zero?
      @instruction_pointer += 2
    else
      @instruction_pointer = literal_operand(operand)
    end
  end

  def bxc(_)
    @b ^= c
    @instruction_pointer += 2
  end

  def out(operand)
    @output << combo_operand(operand) % 8
    @instruction_pointer += 2
  end

  def bdv(operand)
    @b = (a / 2**combo_operand(operand)).to_i
    @instruction_pointer += 2
  end

  def cdv(operand)
    @c = (a / 2**combo_operand(operand)).to_i
    @instruction_pointer += 2
  end

  def instruction(opcode)
    INSTRUCTIONS[opcode] || raise("Unknown opcode: #{opcode}")
  end

  def dump_program(program)
    (0...(program.size)).step(2).each do |i|
      dump_instruction i, program[i], program[i + 1]
    end
  end

  def dump_instruction(pc, opcode, operand)
    operand_ref = case opcode
                  when 0, 2, 5, 6, 7 then '0123ABC'[operand]
                  when 1, 3 then operand.to_s
                  else ''
                  end
    puts format('%<pc>03d: %<instr>s %<ref>s', pc:, instr: instruction(opcode), ref: operand_ref)
  end

  def run(program)
    puts 'Running program:'
    dump_program(program)
    puts

    while @instruction_pointer < program.size
      opcode = program[@instruction_pointer]
      operand = program[@instruction_pointer + 1]
      instruction = instruction(opcode)

      puts self
      dump_instruction @instruction_pointer, opcode, operand

      public_send(instruction, operand)
    end

    puts self
    puts sprintf('%<pc>03d: HALT', pc: @instruction_pointer)
    puts
  end

  def to_s
    "     A:#{a} B:#{b} C:#{c} PC:#{@instruction_pointer} >> #{output.join(',')}"
  end
end
