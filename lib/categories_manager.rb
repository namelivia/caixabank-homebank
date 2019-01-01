require 'bundler/setup'

require_relative 'categories_collection'
require_relative 'user_interface'
require_relative 'category_arguments'

class CategoriesManager
  def initialize(ui, categories, categoryArguments)
    @ui = ui
    @categories = categories
    @categoryArguments = categoryArguments
  end

  def run
    @ui.set_locale
    options = @categoryArguments.read
    @categories.load
		puts @categories

   # if options[:format] == 'qif'
   # end

    @categories.save_if_modified
    @ui.localized_message(:categories_file_updated)
  end
end
