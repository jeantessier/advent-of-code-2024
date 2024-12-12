Region = Struct.new(:type_of_plant) do
  def plots = @plots ||= []

  def neighbourhood = plots.collect(&:neighbors).flatten

  def area = @area ||= plots.size
  def perimeter = @perimeter ||= plots.map(&:fences).sum
  def price = @price ||= area * perimeter

  def number_of_sides
    @number_of_sides ||= case
                         when area == 1 then 4
                         when area == 2 then 4
                         when Set.new(plots.map(&:x)).size == 1 then 4
                         when Set.new(plots.map(&:y)).size == 1 then 4
                         else compute_number_of_sides
                         end
  end

  def compute_number_of_sides
    [
      plots.select { |plot| plot.up&.type_of_plant != type_of_plant },
      plots.select { |plot| plot.right&.type_of_plant != type_of_plant },
      plots.select { |plot| plot.down&.type_of_plant != type_of_plant },
      plots.select { |plot| plot.left&.type_of_plant != type_of_plant },
    ].map { |plots| count_connected_segments(plots) }.sum
  end

  def count_connected_segments(plots)
    segments = plots.map { |p| [p] }

    previous_number_of_segments = segments.size

    # puts 'Segments'
    # puts '--------'
    # segments.each { |segment| puts "[#{segment.map(&:to_s).join(', ')}]" }
    # puts

    while true do
      (0...segments.size).each do |i|
        ((i + 1)...segments.size).each do |j|
          if segments[i].any? { |pi| segments[j].any? { |pj| ((pi.x - pj.x).abs + (pi.y - pj.y).abs) == 1 } }
            segments[i].concat(segments[j])
            segments[j].delete_if { true }
          end
        end
      end

      break if previous_number_of_segments == segments.reject { |segment| segment.empty? }.size

      previous_number_of_segments = segments.reject { |segment| segment.empty? }.size
    end

    # puts 'Segments'
    # puts '--------'
    # segments.each { |segment| puts "[#{segment.map(&:to_s).join(', ')}]" }
    # puts

    # puts "Number of segments: #{segments.reject { |segment| segment.empty? }.size}"

    segments.reject { |segment| segment.empty? }.size
  end

  def discounted_price = @discounted_price ||= area * number_of_sides

  def to_s
    "#{type_of_plant} [#{plots.map { |p| "(#{p.x}, #{p.y})" }.join(', ')}]"
  end
end
