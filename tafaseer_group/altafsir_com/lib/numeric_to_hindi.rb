class Numeric
  def to_hindi
    (self.to_s.chars.map {|c| [c.ord+1584].pack('U')}).join
  end
end
