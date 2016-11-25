#!/usr/bin/env ruby

require 'bundler/setup'
require 'yaml'
require 'csv'
require 'pandoc-ruby'
require 'fileutils'
require 'sanitize'
require 'pp'
require 'sqlite3'
require 'active_record'
require 'awesome_print'
require 'pry'
require 'nokogiri'
require_relative 'lib/asciiarabic'
require_relative 'lib/flat_hash'
require_relative 'lib/numeric_to_hindi'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: '../../corpora/altafsir_com/processed/corpus.sqlite3'
)

class CTSUnit < ActiveRecord::Base
  # CREATE TABLE units(
  #   id          INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
  #   cts_urn     CHAR(255) NOT NULL, 
  #   text        TEXT, 
  #   label       TEXT, 
  #   title       CHAR(255), 
  #   author_name CHAR(255), 
  #   author_era  INTEGER
  #   category_id INTEGER NOT NULL, 
  #   author_id   INTEGER NOT NULL, 
  #   sura_id     INTEGER NOT NULL,
  #   aaya_id     NOT NULL, 
  # );
  default_scope {order('id ASC')}
end

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
    @header = %{<!doctype html>
<html lang="ar" dir="rtl" style="display:flex;justify-content:center;">
<head>
<meta charset="utf-8">
  <style type="text/css">
    h1 {font-size:120%;}
    h2 {font-size:100%;}
    p.quran {color:#0E4E00;}
    p.hadith {color:#225F6B;}
    p.poetry_or_grammar {color:#671F10;}
  </style>
</head>
<body style="width:50%;margin=1em 0;font-family:'Traditional Arabic';font-size:16pt;line-height:1.3;">\n}
    @footer = %{</body>\n</html>}
  end

  def self.convert_to(formats)
    instance = self.new
    instance.convert_to(formats)
  end

  def convert_to(formats)
    walk_tree__by_book(formats)
  end

  def remove_specialchars(text)
    text = text.gsub(/[^ \p{Arabic}]/, '') # This is a *very* crude method which does not even match vowelisation!
    return text.squeeze
  end

  def urn(line_no)
    # CITE CTS URN example:
    # urn:cts:arabLit:tafsir.author.work:1.2.1234
    author = ASCIIArabic.translit(@hash['meta_author'])
    book   = ASCIIArabic.translit(@hash['meta_title'])
    sura   = @hash['position_sura'].to_i
    aaya   = @hash['position_aaya'].to_i
    # No need to continue if we don't have the full URN
    if (author.empty? || book.empty?)
      return false
    else
      return "urn:cts:arabLit:tafsir.#{author}.#{book}:#{sura}.#{aaya}.#{line_no}"
    end
  end

  # For purposes of the DH Leipzig/Maryland/etc. research groups (be
  # able to use To Pan, etc.) the CSV files must comply with CITE CTS.
  # The specs are at
  # http://cite-architecture.github.io/ctsurn_spec/specification.html.
  
  def cts_csv_writeline(madhab, tafseer, line_no, opts = {nospecialchars: false})
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
    return unless urn = encode_urn(line_no)
    outname = "%03d-%03d.csv" % [madhab, tafseer]
    optname = (opts.map {|k,v| k if v}).compact.join(',')
    outpath = File.join(@outpath, 'csv', ['cts+aaya', optname].reject {|i| i.empty?}.join('_'))
    text = @hash['text']
    text = remove_specialchars(text) if opts[:nospecialchars]
    values = [urn, text, @hash['aaya']]
    outfile = File.join(outpath, outname)
    FileUtils.mkdir_p(outpath)
    write_header = !(File.file?(outfile))
    header = ['urn', 'text', 'aaya']
    CSV.open(outfile, 'ab') do |csv|
      if write_header
        csv << header
      else
        csv << values
      end
    end
  end

  def cts_sqlite_writeline(madhab, tafseer, line_no)
    return unless urn = urn(line_no)
    CTSUnit.create(
      cts_urn: urn,
      text: remove_specialchars(@hash['text']),
      label:       @hash['aaya'],
      title:       @hash['meta_title'],
      author_name: @hash['meta_author'],
      author_era:  @hash['meta_year'],
      category_id: madhab,
      author_id:   tafseer,
      sura_id:     @hash['position_sura'].to_i,
      aaya_id:     @hash['position_aaya'].to_i
    )
  end

  def html5_addline
    @html += "<h1>#{@hash['meta_title']} ل#{@hash['meta_author']} (ت. #{@hash['meta_year'].to_i.to_hindi})</h1>" if @html.empty?
    @html += "<h2 class='quran'>#{@hash['aaya']}</h2>\n#{@hash['text']}\n"
  end

  def html5_write_unless_exists(madhab, tafseer)
    outname = "%03d-%03d.html" % [madhab, tafseer]
    outpath = File.join(@outpath, 'html5')
    outfile = File.join(outpath, outname)
    unless File.file?(outfile)
      print 'html5 '
      FileUtils.mkdir_p(outpath)
      File.write(outfile, @header+@html+@footer)
    end
    outfile
  end

  def plain_text_write(html_file, madhab, tafseer, opts = {nohadith: false})
    outname = "%03d-%03d.txt" % [madhab, tafseer]
    lastdir = opts[:nohadith] ? 'nohadith' : 'complete'
    outpath = File.join(@outpath, 'plain', lastdir)
    plain_file = File.join(outpath, outname)
    unless File.exist?(plain_file)
      html = Nokogiri::HTML(File.read(html_file))
      if opts[:nohadith]
        print 'plain_nohadith '
        hadith_paragraphs = html.at_css('p.hadith')
        hadith_paragraphs.remove if hadith_paragraphs
      else
        print 'plain '
      end
      html = html.at_css('body').text.strip
      FileUtils.mkdir_p(outpath)
      File.open(plain_file, 'w') do |outfile|
        outfile.puts Sanitize.fragment(html, {
          whitespace_elements: {
            'h1':      { before: "\n",   after: "\n\n" },
            'h2':      { before: "\n",   after: "\n"   },
            'section': { before: "\n\n", after: "\n"   },
            'p':       { before: "\n",   after: "\n"   }
        }})
      end
    end
  end

  def other_formats_write(infile, madhab, tafseer, formats)
    outname = "%03d-%03d" % [madhab, tafseer]
    fs = formats; %w{csv plain html5}.each {|f| fs.delete(f)}
    formats.each do |format|
      print "#{format} "
      case format
        when 'markdown' then ext = 'md'
        when 'latex'    then ext = 'tex'
        else ext = format
      end
      outpath = File.join(@outpath, format)
      outfile = File.join(outpath, "#{outname}.#{ext}")
      FileUtils.mkdir_p(outpath)
      File.open(outfile, 'w') do |file|
        file.puts PandocRuby.html([infile]).convert({to: format}, wrap: 'none')
      end
    end
  end

  def set_format_flags(formats)
    @formats = {other: formats.any? {|x| (x != 'csv' && x != 'csv_nospecialchars' && x != 'sqlite' && x != 'plain_nohadith')}}
    formats.each do |f|
      @formats[f.to_sym] = formats.include?(f)
    end
  end

  def walk_tree__by_book(formats)
    set_format_flags(formats)
    puts "Writing books:"
    (1..@number_of_madahib).each do |m|
      puts "  madhab #{m}"
      (1..@number_of_tafaseer_per_madhab[m-1]).each do |t|
        t0 = Time.now
        print "    tafseer #{t} "
        print 'csv ' if @formats[:csv] || @formats[:csv_nospecialchars]
        print 'sqlite ' if @formats[:sqlite]
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
          cts_csv_writeline(m, t, i) if @formats[:csv]
          cts_csv_writeline(m, t, i, nospecialchars: true) if @formats[:csv_nospecialchars]
          cts_sqlite_writeline(m, t, i) if @formats[:sqlite]
          html5_addline if @formats[:plain] || @formats[:plain_nohadith] || formats[:other]
        end # sura, aaya
        html_file = html5_write_unless_exists(m, t)
        plain_text_write(html_file, m, t) if @formats[:plain]
        plain_text_write(html_file, m, t, nohadith: true) if @formats[:plain_nohadith]
        other_formats_write(html_file, m, t, formats) if @formats[:other]
        puts "(%s files, %ss)" % [i, (Time.now-t0).round(1)]
      end # tafaseer
    end # madahib
  end
end

if (ARGV.include?('-h') || ARGV.empty?)
  puts "Usage: ./convert.rb [sqlite|csv|csv_nospecialchars|html5|plain|plain_nohadith|latex|docx]"
else
  AlTafsirYAMLFiles.convert_to(ARGV)
end
