class ASCIIArabic
  def initialize(str_ara = String.new)
    @str_ara = str_ara
  end

  def self.translit(str_ara)
    instance = self.new(str_ara)
    return instance.translit(str_ara)
  end

  def translit(str_ara = String.new)
    s = String.new
    str_ara ||= String.new
    str_ara.chars.map do |c|
      case c
      when 'ا' then s << 'a'
      when 'ب' then s << 'b'
      when 'ت' then s << 't'
      when 'ث' then s << 'th'
      when 'ج' then s << 'j'
      when 'ح' then s << 'H'
      when 'خ' then s << 'kh'
      when 'د' then s << 'd'
      when 'ذ' then s << 'dh'
      when 'ر' then s << 'r'
      when 'ز' then s << 'z'
      when 'س' then s << 's'
      when 'ش' then s << 'sh'
      when 'ص' then s << 'S'
      when 'ض' then s << 'D'
      when 'ط' then s << 'T'
      when 'ظ' then s << 'Z'
      when 'ع' then s << '3'
      when 'غ' then s << 'gh'
      when 'ف' then s << 'f'
      when 'ق' then s << 'q'
      when 'ك' then s << 'k'
      when 'ل' then s << 'l'
      when 'م' then s << 'm'
      when 'ن' then s << 'n'
      when 'ه' then s << 'h'
      when 'و' then s << 'w'
      when 'ي' then s << 'y'
      when 'ء' then s << '2'
      when 'أ' then s << '2'
      when 'آ' then s << '2a'
      when 'ؤ' then s << '2'
      when 'ئ' then s << '2'
      when 'ى' then s << 'a'
      when 'ة' then s << 'a'
      when ' ' then s << '_'
      when 'َ' then s << 'a'
      when 'ِ' then s << 'i'
      when 'ُ' then s << 'u'
      when 'ً' then s << 'an'
      when 'ٍ' then s << 'in'
      when 'ٌ' then s << 'un'
      end
    end
    return s
  end
end
