#!/usr/bin/env ruby

require 'csv'

mfw_list_dir = '/home/jrs/ba/analysis/output' # TODO: bring into hw!!!
stopwords = CSV.read(File.join('data', 'stopwords.csv')).flatten
output = File.join('data', "top#{n_max}mfw.csv")
n_max=200

CSV.open(output, 'w') do |csv|
  files = Dir.glob(mfw_list_dir + '/wordcount-???-???.csv')
  header = ['pos']
  files.each do |f|
    id = f.scan(/\/wordcount-(\d+)-(\d+).csv/).join('-') # category-author
    header += ["#{id}_occs", "#{id}_word"]
  end
  csv << header
  rows = []
  files.each do |f|
    puts f
    n = 1
    CSV.foreach(f) do |row|
      if not stopwords.include? row[2] and not n > 200
        n += 1
        rows[n] = (rows[n] ||= []) << [row[1], row[2]] # number of occurances, word
      end
    end
  end
  puts 'writing to output file...'
  rows.compact.each_with_index do |row,n|
    csv << [n+1] + row.flatten
  end
end
