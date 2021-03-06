#!/usr/bin/env ruby

require 'pathname'

database = Pathname('../../corpora/altafsir_com/processed/corpus.sqlite3')
query = Pathname('./wordcount_whole_corpus.sql')
big_output_file = Pathname('./data_automated/wordcounts/wordcount_ratios_perAuthorPerPage.csv')
command = "/usr/bin/env sqlite3 -header -csv #{database} < #{query} > #{big_output_file}"

puts "Running query..."
`#{command}`

# Example line:
# 02-15,"ابن الجوزي",002:110,6,2864427,0.00021

header = ''

File.readlines(big_output_file).each_with_index do |line,i|
  if i == 0
    header = line
    puts "header is #{header}"
  else
    author = line.split(',')[0]
  end

  if i > 0
    File.open(Pathname("./data_automated/wordcounts/wordcount_ratios_perPageForAuthor_#{author}.csv"), 'a') do |file|
      if file.size == 0
        puts "writing file for #{author}"
        file.write header
      end
      file.write line
    end
  end
end
