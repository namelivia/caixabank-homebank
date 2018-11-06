require 'optparse'
require 'ostruct'
require 'i18n'

class Arguments
  attr_accessor :options

  def read
    @options = OpenStruct.new
    @options[:format] = 'csv'
    opt_parser = OptionParser.new do |opts|
      opts.banner = I18n.t(:banner)
      opts.separator ''
      opts.separator I18n.t(:params)

      opts.on('-i', '--input=' + I18n.t(:input_param), I18n.t(:input)) do |input|
        @options[:input] = input
      end

      opts.on('-o', '--output=' + I18n.t(:output_param), I18n.t(:output)) do |output|
        @options[:output] = output
      end

      opts.on('-f', '--format=' + I18n.t(:format_param), %i[csv qif], I18n.t(:format)) do |format|
        @options[:format] = format
      end
      opts.separator ''
      opts.separator I18n.t(:example)
    end
	begin
    	opt_parser.parse!(ARGV)
		mandatory = [:input, :output, :format]
		missing = mandatory.select{ |param| options[param].nil? }
		unless missing.empty?
			raise OptionParser::MissingArgument.new()
		end
  	rescue OptionParser::InvalidOption, OptionParser::InvalidArgument, OptionParser::MissingArgument
		puts opt_parser
		exit
	end

  end
end
