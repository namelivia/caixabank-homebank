require 'bundler/setup'
require 'qif'

require_relative 'transaction.rb'
require_relative 'categories_collection.rb'
require_relative 'user_interface.rb'
require_relative 'input_file.rb'

class Converter
  def initialize
    @ui = UserInterface.new
    @categories = CategoriesCollection.new(@ui)
    @input_file = InputFile.new
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
