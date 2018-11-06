require_relative '../lib/input_file'

describe InputFile do
  it 'should open the file by path' do
    path = 'input/file/path'
    ui = double('UserInterface')
    worksheet = double('Worskheet')
    allow(Spreadsheet).to receive(:open).with(path).and_return(Spreadsheet)
    allow(Spreadsheet).to receive(:worksheet).with(0).and_return(worksheet)
    input_file = InputFile.new(ui)
    input_file.load(path)
    expect(input_file.file).to eq(worksheet)
  end
end
