require_relative '../lib/arguments'

describe Arguments do
	#TODO: How do I set allows on ARGV?
  it 'should validate and read the arguments' do
    ui = double('UserInterface')
		ARGV = ['one', 'two', 'three']
    arguments = Arguments.new(ui)
  end
end
