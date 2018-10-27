require_relative '../lib/converter'
describe Converter do
  it 'should run' do
    ui = double('User Interface')
    categories = double('Categories')
    input_file = double('Input File')
    arguments = double('Arguments')

    expect(ui).to receive(:set_locale)
    expect(arguments).to receive(:read)
    expect(categories).to receive(:load)
    input_path = '/input/file/path'
    expect(arguments).to receive(:input).and_return(input_path)
    expect(input_file).to receive(:load).with(input_path)

    output_path = '/output/file/path'
    expect(arguments).to receive(:output).and_return(output_path)

    writer = double('Writer')
    allow(Qif::Writer).to receive(:open).with(output_path, Converter::TRANSACTION_TYPE).and_yield(writer)

    rows = double('Rows')
    expect(input_file).to receive(:file).and_return(rows)
    row = double('Row')
    expect(rows).to receive(:each).with(InputFile::HEADER_ROWS_NUMBER).and_yield(row)

    # TODO: Would it be nice to check the parameters passed on this chain?
    allow(Transaction).to receive_message_chain(:new,
                                                :set_attributes,
                                                :set_category,
                                                :to_qif).and_return('new_transaction')

    expect(writer).to receive(:<<).with('new_transaction')

    expect(ui).to receive(:localized_message).with(:file_generated)

    Converter.new(ui, categories, input_file, arguments).run
  end
end
