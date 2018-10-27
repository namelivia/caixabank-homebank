require 'csv'

class CategoriesCollection
	attr_accessor :modified
	attr_accessor :categories

	def initialize(ui)
		@ui = ui
		@modified = false
		@categories = false
	end

	def load()
		@categories = CSV.read(File.join(File.dirname(__FILE__), '../categorias'))
	end
	def save()
		CSV.open(File.join(File.dirname(__FILE__), "../categories"), "w") do |new_categories|
			self.categories.each do |category|
				new_categories << category
			end
		end
	end
	def save_if_modified()
		if @modified
			self.save()
			@ui.localized_message(:categories_file_updated)
		end
	end
	#TODO: This is actually not a good name
	def find_by_name(item_name)
		@categories.each do |category|
			if category.include? item_name
				return category[0]
			end
		end
		return nil
	end
	def select(item_name)
		while true
			@ui.localized_message(:choose_category)
			@categories.each_with_index do |category, index|
				@ui.message(index.to_s + ":" + category[0] + "\n")
			end
			selected = $stdin.gets.strip.to_i
			if selected.between?(0, @categories.length - 1)
				@categories[selected] << item_name
				@modified = true
				return @categories[selected][0]
			end
		end
	end
end
