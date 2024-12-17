class ReverseComputer
  attr_reader :a, :b, :c, :output

  INSTRUCTIONS = %i[adv bxl bst jnz bxc out bdv cdv].freeze

  def initialize(output)
    @a = 0
    @b = 0
    @c = 0
    @instruction_pointer = output.size
    @output = output.clone

    # Heuristic:
    # there is only one *jump* instruction as last instruction.
    @jump_location = output.size - 2
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

  def rewind
    # Heuristic:
    # There is only one *jump* instruction in the program,
    # and it jumps to *0*.
    @instruction_pointer = @instruction_pointer.zero? ? @jump_location : @instruction_pointer - 2
  end

  def adv(operand)
    @a <<= combo_operand(operand)
  end

  def bxl(operand)
    @b ^= literal_operand(operand)
  end

  def bst(operand)
    case operand
    when 0..3 then nil # do nothing
    when 4 then @a = (a >> 3 << 3) + b
    when 5 then nil # Do nothing
    when 6 then @c = (c >> 3 << 3) + b
    when 7 then raise('Reserved operand')
    else raise("Unknown operand: #{operand}")
    end
  end

  def jnz(_)
    # Do nothing.
    # Un-jumping is handled in #rewind
  end

  def bxc(_)
    @b ^= c
  end

  def out(operand)
    value = output.pop

    case operand
    when 0..3 then nil # do nothing
    when 4 then @a = (a >> 3 << 3) + value
    when 5 then @b = (b >> 3 << 3) + value
    when 6 then @c = (c >> 3 << 3) + value
    when 7 then raise('Reserved operand')
    else raise("Unknown operand: #{operand}")
    end
  end

  def bdv(operand)
    @a = (b << combo_operand(operand)) + (a / 2**combo_operand(operand))
  end

  def cdv(operand)
    @a = c << combo_operand(operand) + (a / 2**combo_operand(operand))
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

  def reverse_run(program)
    puts 'Running program in reverse:'
    dump_program(program)
    puts

    puts sprintf('%<pc>03d: HALT', pc: @instruction_pointer)
    puts self

    until @instruction_pointer.zero? && output.empty?
      rewind

      opcode = program[@instruction_pointer]
      operand = program[@instruction_pointer + 1]
      instruction = instruction(opcode)

      public_send(instruction, operand)

      dump_instruction @instruction_pointer, opcode, operand
      puts self

      # puts '[Enter] to continue'
      # $stdin.gets
    end

    puts
  end

  def to_s
    "     A:#{a} B:#{b} C:#{c} PC:#{@instruction_pointer} >> #{output.join(',')}"
  end
end
