# Remember: every line of code one liability!
#
# Synopsis: convert an Arabic string into a Latin script
# string fit to be used as a filename while still being
# somewhat decipherable. It's supposed to be primitive.
#
# Usage example: `puts ASCIIArabic.translit('السلام عليكم')`


class ASCIIArabic
  def initialize(str_ara)
    @arabic = str_ara || String.new
    @replacements = [
      # The Abjad
      ['ا', 'a' ], ['ب', 'b' ], ['ت', 't' ], ['ث', 'th'], ['ج', 'j' ],
      ['ح', 'H' ], ['خ', 'kh'], ['د', 'd' ], ['ذ', 'dh'], ['ر', 'r' ],
      ['ز', 'z' ], ['س', 's' ], ['ش', 'sh'], ['ص', 'S' ], ['ض', 'D' ],
      ['ط', 'T' ], ['ظ', 'Z' ], ['ع', '3' ], ['غ', 'gh'], ['ف', 'f' ],
      ['ق', 'q' ], ['ك', 'k' ], ['ل', 'l' ], ['م', 'm' ], ['ن', 'n' ],
      ['ه', 'h' ], ['و', 'w' ], ['ي', 'y' ],
      # Various forms of Hamza
      ['ء', '2' ], ['أ', '2' ], ['آ', '2a'], ['ؤ', '2' ], ['ئ', '2' ],
      # Word-end forms of 'a'/'at'
      ['ى', 'a' ], ['ة', 'a' ],
      # Space
      [' ', '_' ],
      # Most important diacritica
      ['َ', 'a'  ], ['ِ', 'i'  ], ['ُ', 'u'  ],
      ['ً', 'an' ], ['ٍ', 'in' ], ['ٌ', 'un' ]
    ]
  end

  def self.translit(str_ara)
    instance = self.new(str_ara)
    return instance.translit
  end

  def translit
    @replacements.each do |needle, replacement|
      @arabic = @arabic.gsub(needle, replacement)
    end
    @arabic = @arabic.gsub(/[^_[[:alnum:]]]/, '') # Only Latin script
    strip_underscores(@arabic)
  end

  private

  def strip_underscores(string)
    string.gsub(/\A_+|_+\z/, '')
  end
end
