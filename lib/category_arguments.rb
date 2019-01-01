require 'optparse'
require 'ostruct'
require 'i18n'

class CategoryArguments
  attr_accessor :options

  def read
    @options = OpenStruct.new
    @options[:format] = 'csv'
    opt_parser = OptionParser.new do |opts|
      opts.banner = I18n.t(:banner)
      opts.separator ''
      opts.separator I18n.t(:params)

      opts.on('-c', '--create=' + I18n.t(:create_param), I18n.t(:create)) do |create|
        @options[:create] = create
      end

      opts.on('-d', '--delete=' + I18n.t(:delete_param), I18n.t(:delete)) do |delete|
        @options[:delete] = delete
      end

      opts.on('-l', '--list', I18n.t(:list)) do |list|
        @options[:list] = list
      end
      opts.separator ''
      opts.separator I18n.t(:category_example)
    end
    begin
      opt_parser.parse!(ARGV)
      mandatory = []
      missing = mandatory.select { |param| options[param].nil? }
      raise OptionParser::MissingArgument.new unless missing.empty?
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument, OptionParser::MissingArgument
      puts opt_parser
      exit
    end
    @options
  end
end
