require 'optparse'
require 'ostruct'

class Arguments
  attr_accessor :input
  attr_accessor :output
  attr_accessor :format

  def initialize(ui)
    @ui = ui
  end

	#TODO: Validate file formats?
  def read
		options = OpenStruct.new
		options.format = 'csv'
		opt_parser = OptionParser.new do |opts|
			#TODO: Write a proper (localized banner)
			opts.banner = 'banner'

			opts.separator ''
			opts.separator 'Usage:'

			opts.on("-i", "--input INPUT_FILE", "INPUT_FILE is required") do |input|
        options.input = input
      end

			opts.on("-o", "--output OUTPUT_FILE", "OUTPUT_FILE is required") do |output|
        options.output = output
      end

			opts.on("-f", "--format [FORMAT]", [:csv, :qif], "Format for the output file") do |format|
				options.format = format
			end
		end
		opt_parser.parse!(ARGV)
		@input = options.input
		@output = options.output
		@format = options.format
  end
end
