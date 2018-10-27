require 'csv'

class CategoriesCollection
  attr_accessor :modified
  attr_accessor :categories

  def initialize(ui)
    @ui = ui
    @modified = false
    @categories = []
  end

  def get_path
    File.join(File.dirname(__FILE__), '../categories')
  end

  def load
    @categories = CSV.read(get_path)
  end

  def save
    CSV.open(get_path, 'w') do |new_categories|
      @categories.each do |category|
        new_categories << category
      end
    end
    @ui.localized_message(:categories_file_updated)
  end

  def save_if_modified
    if @modified
      save
    end
  end

  # TODO: This is actually not a good name
  def find_by_name(item_name)
    @categories.each do |category|
      return category[0] if category.include? item_name
    end
    nil
  end

  def add_item(item_name, selected)
    @categories[selected] << item_name
    @modified = true
    @categories[selected][0]
  end

  def display_all
    @categories.each_with_index do |category, index|
      @ui.message(index.to_s + ':' + category[0] + "\n")
    end
  end

  def select(item_name)
    loop do
      @ui.localized_message(:choose_category)
      display_all
      selected = @ui.read_input.to_i
      if selected.between?(0, @categories.length - 1)
        return add_item(item_name, selected)
      end
    end
  end
end
