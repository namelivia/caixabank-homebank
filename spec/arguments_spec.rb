require_relative '../lib/arguments'

describe Arguments do
  # TODO: How do I set allows on ARGV?
  it 'should validate and read the arguments' do
    ui = double('UserInterface')
    ARGV = %w[one two three].freeze
    Arguments.new(ui)
  end
end
