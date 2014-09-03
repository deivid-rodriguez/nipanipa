#
# Bit mask functionality
#
class ArrayMask
  def initialize(mask)
    @mask = mask
  end

  def mask(array)
    (array & @mask).map { |a| power_of_two(@mask, a) }.sum
  end

  def unmask(id)
    @mask.reject { |a| ((id || 0) & power_of_two(@mask, a)).zero? }
  end

  private

  def power_of_two(array, element)
    2**array.index(element)
  end
end
