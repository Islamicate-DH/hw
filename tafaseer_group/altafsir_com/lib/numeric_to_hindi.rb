# Remember: every line of code one liability!
# Extends Ruby's base class Numeric, so it'll be available both for Integers and for Floats.

class Numeric
  def to_hindi
    (self.to_s.chars.map {|c| [c.ord+1584].pack('U')}).join
  end
end
