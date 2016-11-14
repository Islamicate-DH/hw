#!/usr/bin/env ruby

require 'yaml'
require 'csv'
require 'pandoc-ruby'
require 'fileutils'

path = File.join('..', '..', 'corpora', 'altafsir_com', 'processed')

number_of_madahib = 10
number_of_suwar  = 114
number_of_tafaseer_per_madhab = [8, 20, 10, 2, 7, 7, 4, 3, 5, 2]
number_of_aayaat_per_sura = [7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99, 128, 111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30, 73, 54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29, 18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12, 12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, 22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6]

def flat_hash(h,f=[],g={})
  return g.update({ f=>h }) unless h.is_a? Hash
  h.each { |k,r| flat_hash(r,f+[k],g) }
  g
end

(1..number_of_madahib).each do |m|
  (1..number_of_tafaseer_per_madhab[m-1]).each do |t|
    pattern = File.join(path, 'quran_???', 'aaya_???', "madhab_#{"%02d" % m}", "tafsir_#{"%02d" % t}.yml")
    files = Dir.glob(pattern).sort
    files.each_with_index do |infile,i|
      puts "#{infile}"
      @yaml = YAML.load(File.open(infile))
      header = []
      values = []
      outname = "%03d-%03d" % [m, t]
      flat_hash(@yaml).each do |k,v|
        col = k.join('_')
        # Convert into formats requiring just the one column
        if col == 'text'
          %w{plain}.each do |format|
            case format
              when 'plain' then ext = 'txt'
              when 'markdown' then ext = 'md'
              else ext = format
            end
            outpath = File.join(path, ext)
            outfile = File.join(outpath, outname+'.'+ext)
            puts "\t>> #{outfile}"
            FileUtils.mkdir_p(outpath)
            File.open(outfile, 'a') do |txt|
              txt.write PandocRuby.convert(v, from: :html, to: format)
            end
          end
        end
        # Prepare format required by CSV
        header << col if i == 0 # Only write a header into the first row!
        values << v
      end
      # Convert into CSV
      outpath = File.join(path, 'csv')
      outfile = File.join(outpath, outname+'.csv')
      puts "\t>> #{outfile}"
      FileUtils.mkdir_p(outpath)
      CSV.open(outfile, 'ab') do |csv|
        csv << header if csv.lineno == 0
        csv << values
      end
    end
  end
end
