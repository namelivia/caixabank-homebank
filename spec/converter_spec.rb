require_relative '../lib/converter'
describe Converter do
  it 'should run' do
    ui = double('User Interface')
    categories = double('Categories')
    input_file = double('Input File')

    expect(ui).to receive(:set_locale)
    expect(categories).to receive(:load)

    Converter.new(ui, categories, input_file).run
  end
end
