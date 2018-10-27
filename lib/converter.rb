require 'bundler/setup'
require 'qif'

require_relative 'transaction'
require_relative 'categories_collection'
require_relative 'user_interface'
require_relative 'input_file'

class Converter
  def initialize(ui, categories, input_file)
    @ui = ui
    @categories = categories
    @input_file = input_file
  end

  def get_input
    if ARGV.length != 1 || ARGV[0].split(//).last(4).join != '.xls'
      @ui.localized_message(:invalid_params)
      exit
    end
    ARGV.first
  end

  def get_output_path
    File.join(File.dirname(__FILE__), '../resultado.qif')
  end

  def run
    @ui.set_locale

    @categories.load
    @input_file.load(get_input)

    Qif::Writer.open(get_output_path, 'Bank') do |writer|
      @input_file.file.each InputFile::HEADER_ROWS_NUMBER do |row|
        writer << Transaction.new(@ui, @categories)
                             .set_attributes(row)
                             .set_category
                             .to_quif
      end
    end

    @ui.localized_message(:file_generated)
  end
end
