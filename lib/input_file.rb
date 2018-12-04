require_relative 'reader_extensions'

class InputFile
  HEADER_ROWS_NUMBER = 3

  attr_accessor :file

  def initialize(ui)
    @ui = ui
  end

  # TODO: Properly close the file
  def load(path)
    @file = Spreadsheet.open(path).worksheet(0)
  rescue
    @ui.localized_message(:file_not_found)
    @ui.message(path)
    exit
  end
end
