require_relative '../lib/transaction'
describe Transaction do
  it 'should set attributes from a row' do
    row = ['name', Date.new(2018, 0o2, 23), 'ignore', 'memo', -27.82]
    ui = double('UserInterface')
    categories = double('Categories')
    transaction = Transaction.new(ui, categories).set_attributes(row)
    expect(transaction.name).to eq('name')
    expect(transaction.date).to eq('23-02-2018')
    expect(transaction.memo).to eq('memo')
    expect(transaction.amount).to eq('-27.82')
  end

  it 'should transform a transaction into a Qif transaction' do
    ui = double('UserInterface')
    categories = double('Categories')
    allow(Qif::Transaction).to receive(:new).with(
      date: nil,
      amount: nil,
      category: nil,
      memo: nil
    )
    Transaction.new(ui, categories).to_qif
  end

  it 'should display a transaction' do
    ui = double('UserInterface')
    categories = double('Categories')
    expect(ui).to receive(:localized_message).with(:name)
    expect(ui).to receive(:message).with("name\n")
    expect(ui).to receive(:localized_message).with(:date)
    expect(ui).to receive(:message).with("date\n")
    expect(ui).to receive(:localized_message).with(:amount)
    expect(ui).to receive(:message).with("amount\n")
    transaction = Transaction.new(ui, categories)
    transaction.name = 'name'
    transaction.date = 'date'
    transaction.amount = 'amount'
    transaction.display
  end

  it 'should automatically fetch the category' do
    ui = double('UserInterface')
    categories = double('Categories')
    expect(categories).to receive(:find_by_name).with('name').and_return('category')
    transaction = Transaction.new(ui, categories)
    transaction.name = 'name'
    transaction.set_category
    expect(transaction.category).to eq('category')
  end

  it 'should set picked category' do
    ui = double('UserInterface')
    categories = double('Categories')
    expect(categories).to receive(:find_by_name).with('name').and_return(nil)
    expect(ui).to receive(:user_confirms).with(:select_category).and_return(true)
    expect(categories).to receive(:select).with('name').and_return('category')
    transaction = Transaction.new(ui, categories)
    allow(transaction).to receive(:display)
    transaction.name = 'name'
    transaction.set_category
    expect(transaction.category).to eq('category')
  end

  it 'should set not category but memo' do
    ui = double('UserInterface')
    categories = double('Categories')
    expect(categories).to receive(:find_by_name).with('name').and_return(nil)
    expect(ui).to receive(:user_confirms).with(:select_category).and_return(false)
    expect(ui).to receive(:localized_message).with(:input_info)
    expect(ui).to receive(:read_input).and_return('memo')
    transaction = Transaction.new(ui, categories)
    allow(transaction).to receive(:display)
    transaction.name = 'name'
    transaction.set_category
    expect(transaction.category).to eq(nil)
    expect(transaction.memo).to eq('memo')
  end
end