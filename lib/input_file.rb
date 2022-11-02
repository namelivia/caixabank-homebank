require_relative 'reader_extensions'

class InputFile

  attr_accessor :file

  def initialize(ui)
    @ui = ui
  end

  def get_header_rows_number()
    return 3
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
