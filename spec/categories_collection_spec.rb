require_relative '../lib/categories_collection'
describe CategoriesCollection do
  it 'should get the catefories file path' do
    ui = double('User Interface')
    # TODO: categories file path from a config
    CategoriesCollection.new(ui).get_path
  end

  it 'should load categories from file' do
    ui = double('User Interface')
    file_path = 'categories/file/path'
    categories = CategoriesCollection.new(ui)
    allow(categories).to receive('get_path').and_return(file_path)
    allow(CSV).to receive(:read).with(file_path)
    categories.load
  end

  it 'should save categories to a file' do
    ui = double('User Interface')
    file_path = 'categories/file/path'
    new_categories = double('NewCategories')
    # TODO: categories file path from a config
    categories = CategoriesCollection.new(ui)
    allow(categories).to receive('get_path').and_return(file_path)
    allow(CSV).to receive(:open).with(file_path, 'w').and_yield(new_categories)
    categories.categories = ['category']
    expect(new_categories).to receive(:<<).with('category')
    expect(ui).to receive(:localized_message).with(:categories_file_updated)
    categories.save
  end

  it 'should save the file if modified' do
    ui = double('User Interface')
    categories = CategoriesCollection.new(ui)
    categories.modified = true
    allow(categories).to receive('save')
    categories.save_if_modified
    categories.modified = false
    categories.save_if_modified
  end

  it 'should find a category by item name' do
    ui = double('User Interface')
    item_name = 'some item'
    categories = CategoriesCollection.new(ui)
    categories.categories = [['category', item_name]]
    expect(categories.find_by_name(item_name)).to eq('category')
    expect(categories.find_by_name('foobar')).to eq(nil)
  end

  it 'should add an item to a selected category' do
    ui = double('User Interface')
    item_name = 'some item'
    selected = 0
    categories = CategoriesCollection.new(ui)
    categories.categories = [['category']]
    expect(categories.modified).to eq(false)
    expect(categories.add_item(item_name, selected)).to eq('category')
    expect(categories.modified).to eq(true)
    expect(categories.categories[selected][1]).to eq(item_name)
  end

  it 'should display all categories' do
    ui = double('User Interface')
    categories = CategoriesCollection.new(ui)
    categories.categories = [['category']]
    expect(ui).to receive(:message).with("0:category\n")
    categories.display_all
  end

  it 'should ask the user to select a category for adding an item' do
    item_name = 'item'
    selected = 0
    ui = double('User Interface')
    categories = CategoriesCollection.new(ui)
    categories.categories = [['category']]
    expect(ui).to receive(:localized_message).with(:choose_category)
    allow(categories).to receive(:display_all)
    expect(ui).to receive(:read_input).and_return(selected)
    allow(categories).to receive(:add_item).with(item_name, selected)
    categories.select(item_name)
  end
end
