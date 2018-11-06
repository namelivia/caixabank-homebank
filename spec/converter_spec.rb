require_relative '../lib/converter'
describe Converter do
  it 'should export a file to qif' do
    ui = double('User Interface')
    categories = double('Categories')
    input_file = double('Input File')
    arguments = double('Arguments')

    expect(ui).to receive(:set_locale)
    input_path = '/input/file/path'
    output_path = '/output/file/path'
	format = 'qif'
	options = {:input => input_path, :output => output_path, :format => format }
    expect(arguments).to receive(:read).and_return(options)
    expect(categories).to receive(:load)
    expect(input_file).to receive(:load).with(input_path)
    writer = double('Writer')
    expect(ui).to receive(:localized_message).with(:info_wont_be_saved)
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

  it 'should export a file to csv' do
    ui = double('User Interface')
    categories = double('Categories')
    input_file = double('Input File')
    arguments = double('Arguments')

    expect(ui).to receive(:set_locale)
    input_path = '/input/file/path'
    output_path = '/output/file/path'
	format = 'csv'
	options = {:input => input_path, :output => output_path, :format => format }
    expect(arguments).to receive(:read).and_return(options)
    expect(categories).to receive(:load)
    expect(input_file).to receive(:load).with(input_path)
    writer = double('Writer')
    allow(CSV).to receive(:open).with(output_path, 'wb').and_yield(writer)

    rows = double('Rows')
    expect(input_file).to receive(:file).and_return(rows)
    row = double('Row')
    expect(rows).to receive(:each).with(InputFile::HEADER_ROWS_NUMBER).and_yield(row)

    # TODO: Would it be nice to check the parameters passed on this chain?
    allow(Transaction).to receive_message_chain(:new,
                                                :set_attributes,
                                                :set_category,
                                                :to_csv).and_return('new_transaction')

    expect(writer).to receive(:<<).with('new_transaction')

    expect(ui).to receive(:localized_message).with(:file_generated)

    Converter.new(ui, categories, input_file, arguments).run
  end
end
