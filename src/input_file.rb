require 'spreadsheet'

class InputFile
  HEADER_ROWS_NUMBER = 3

  attr_accessor :file

  # TODO: Properly close the file
  def load(path)
    @file = Spreadsheet.open(path).worksheet(0)
  end
end
