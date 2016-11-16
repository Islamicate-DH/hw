#!/usr/bin/env ruby

require 'yaml'
require 'csv'
require 'pandoc-ruby'
require 'fileutils'
require 'pp'
require_relative 'lib/asciiarabic'
require_relative 'lib/flat_hash'
require_relative 'lib/numeric_to_hindi'

class AlTafsirYAMLFiles
  def initialize
    @inpath  = File.join('..', '..', 'corpora', 'altafsir_com', 'processed', 'yaml')
    @outpath = File.join('..', '..', 'corpora', 'altafsir_com', 'processed')
    @number_of_madahib = 10
    @number_of_suwar  = 114
    @number_of_tafaseer_per_madhab = [8, 20, 10, 2, 7, 7, 4, 3, 5, 2]
    @number_of_aayaat_per_sura = [
      7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99, 128,
      111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30, 73,
      54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29, 18, 45, 60,
      49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12, 12, 30, 52, 52,
      44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, 22, 17, 19,
      26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5, 4, 7, 3,
      6, 3, 5, 4, 5, 6
    ]
    @hash = {}
    @yaml = ''
    @html = ''
    @header = %{<!doctype html><html lang="ar" dir="rtl" style="display:flex;justify-content:center;"><head><meta charset="utf-8"><style type="text/css">\nh1 {font-size:120%;}\nh2 {font-size:100%;}\n</style></head><body style="width:50%;margin=1em 0;font-family:'Traditional Arabic';font-size:16pt;line-height:1.3;">\n}
    @footer = %{</body></html>}
  end

  def self.convert_to(formats = [:csv])
    instance = self.new
    instance.convert_to(formats)
  end

  def convert_to(formats = [:csv])
    walk_tree__by_book(formats)
  end

  def cts_csv_writeline(madhab, tafseer, line_no)
    # @hash contents example:
    #
    # {"position_sura"=>1,
    #  "position_aaya"=>1,
    #  "position_madhab"=>1,
    #  "position_tafsir"=>1,
    #  "meta_title"=>"تفسير جامع البيان في تفسير القرآن",
    #  "meta_author"=>"الطبري",
    #  "meta_year"=>"310",
    #  "aaya"=>"بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    #  "text"=>
    #    "<section><p>القول فـي تأويـل { بِسْمِ }.
    #
    # CITE CTS URN example:
    #
    # urn:cts:arabLit:tafsir.author.work:1.2.1234
    author = ASCIIArabic.translit(@hash['meta_author'])
    book   = ASCIIArabic.translit(@hash['meta_title'])
    sura   = @hash['position_sura'].to_i
    aaya   = @hash['position_aaya'].to_i
    # No need to continue if we don't have the full URN
    return unless (!author.empty? && !book.empty?)
    urn = "urn:cts:arabLit:tafsir.#{author}.#{book}:#{sura}.#{aaya}.#{line_no}"
    header = ['urn', 'text', 'aaya']
    values = [urn, @hash['text'], @hash['aaya']]
    outname = "%03d-%03d.csv" % [madhab, tafseer]
    outpath = File.join(@outpath, 'csv', 'cts+aaya')
    outfile = File.join(outpath, outname)
    FileUtils.mkdir_p(outpath)
    write_header = !(File.file?(outfile))
    CSV.open(outfile, 'ab') do |csv|
      if write_header
        csv << header
      end
      csv << values
    end
  end

  def html5_addline
    @html += "<h1>#{@hash['meta_title']} ل#{@hash['meta_author']} (ت. #{@hash['meta_year'].to_i.to_hindi})</h1>" if @html.empty?
    @html += "<h2 class='quran'>#{@hash['aaya']}</h2>\n#{@hash['text']}\n"
  end

  def html5_write(madhab, tafseer)
    print 'html5 '
    outname = "%03d-%03d.html" % [madhab, tafseer]
    outpath = File.join(@outpath, 'html5')
    outfile = File.join(outpath, outname)
    unless File.file?(outfile)
      FileUtils.mkdir_p(outpath)
      File.write(outfile, @header+@html+@footer)
    end
    outfile
  end

  def other_formats_write(infile, madhab, tafseer, formats)
    outname = "%03d-%03d" % [madhab, tafseer]
    %w{csv html5}.each {|f| formats.delete(f)}
    formats.each do |format|
      print "#{format} "
      case format
        when 'plain'    then ext = 'txt'
        when 'markdown' then ext = 'md'
        when 'latex'    then ext = 'tex'
        else ext = format
      end
      outpath = File.join(@outpath, format)
      outfile = File.join(outpath, "#{outname}.#{ext}")
      FileUtils.mkdir_p(outpath)
      File.open(outfile, 'w') do |file|
        file.puts PandocRuby.html([infile]).convert({to: format}, 'no-wrap')
      end
    end
  end

  def walk_tree__by_book(formats)
    otherformats = formats.any? {|x| x != 'csv'}
    puts "Writing books:"
    (1..@number_of_madahib).each do |m|
      (1..@number_of_tafaseer_per_madhab[m-1]).each do |t|
        t0 = Time.now
        print "  madhab #{m}, tafseer #{t} csv "
        pattern = File.join(@inpath, 'sura_???', 'aaya_???', "madhab_#{"%02d" % m}", "tafsir_#{"%02d" % t}.yml")
        files = Dir.glob(pattern).sort
        @html = '' # Wipe last BOOK's data
        i = 0 # Line number should be available after loop
        files.each do |infile|
          i += 1 # Next file = next line in the CSV
          @hash = {} # Wipe last FILE's data
          @yaml = YAML.load(File.open(infile))
          flat_hash(@yaml).each do |k,v|
            col = k.join('_')
            @hash[col] = v
          end
          # Note that for purposes of the DH Leipzig/Maryland/etc. research 
          # groups (be able to use To Pan, etc.) the CSV files must comply
          # with CITE CTS. The specs are at
          # http://cite-architecture.github.io/ctsurn_spec/specification.html.
          cts_csv_writeline(m, t, i) if formats.include?('csv')
          html5_addline if otherformats
        end # sura, aaya
        other_formats_write(html5_write(m, t), m, t, formats) if otherformats
        puts "(%s files, %ss)" % [i, (Time.now-t0).round(1)]
      end # tafaseer
    end # madahib
  end
end

# Add/Remove formats as desired (see pandoc help for available ones)
AlTafsirYAMLFiles.convert_to(%w{csv html5 plain}) # plain latex docx})
