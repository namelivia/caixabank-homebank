class Arguments
  attr_accessor :input
  attr_accessor :output

  def initialize(ui)
    @ui = ui
  end

  def is_input_invalid
    ARGV[0].split(//).last(4).join != '.xls'
  end

  def is_output_invalid
    ARGV[1].split(//).last(4).join != '.qif'
  end

  def read
    if ARGV.length != 2 || is_input_invalid || is_output_invalid
      @ui.localized_message(:invalid_params)
      exit
    end
    @input = ARGV[0]
    @output = ARGV[1]
  end
end
