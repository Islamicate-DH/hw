#!/usr/bin/env ruby

require 'yaml'
require 'nokogiri'
require 'fileutils'

path = File.join('..', 'corpora', 'altafsir_com_corpus', 'extracted')
files = Dir.glob(File.join(path, '**', '*.yml'))
testfile = File.join(path, 'quran_001/aaya_001/madhab_01/tafsir_01.yml')

class TafsirFile
  def initialize(file)
    @in_file = file
  end
  
  def self.convert(file)
    instance = self.new(file)
    instance.read
    instance.clean_yaml
    instance.clean_html
    instance.write
  end
  
  def read
    begin
      @yaml = YAML.load(File.open(@in_file))
      @html = Nokogiri::HTML.fragment(@yaml['text']) do |config|
        config.strict.nonet.noent.noblanks
      end
      print "#{@in_file} => "
    rescue
      puts "Problem parsing '#{@in_file}', aborting."
      abort
    end
  end

  def write
    @out_file = @in_file.gsub(/extracted/, 'processed')
    @out_path = @out_file.gsub(/\/tafsir_\d{2}\.yml/, '')
    begin
      FileUtils.mkdir_p(@out_path)
      File.open(@out_file, 'w') {|f| f.write(@yaml.to_yaml)}
      puts @out_file
    rescue
      puts "Problem writing '#{@out_file}', aborting."
      abort
    end
  end

  def clean_yaml
    %w{sura aaya madhab tafsir}.each {|p| @yaml['position'][p] = @yaml['position'][p].to_i}
    @yaml['text'] = String.new
  end

  def clean_html
    @html.css('font').each do |node|
      node.remove if node.inner_text == ''
    end
    @html.css('section').each do |section|
      nodes = section.css('div[align="right"][dir="rtl"] font[color]')
      nodes.each do |node|
        node.name = 'p'
        case node['color']
          when 'Olive'
            node['class'] = 'poetry_or_grammar'
          when 'Red'
            node['class'] = 'hadith'
          when 'ForestGreen'
            node['class'] = 'quran'
        end
        node.xpath('@color|.//@color').remove
      end
      @yaml['text'] << nodes.to_html
    end
  end
end

# TafsirFile.convert(testfile)
files.each {|f| TafsirFile.convert(f)}
