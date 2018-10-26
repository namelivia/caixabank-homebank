require 'bundler/setup'
require 'spreadsheet'
require 'csv'
require 'locale'
require 'i18n'
require 'qif'

require_relative 'transaction.rb'
require_relative 'categories_collection.rb'
require_relative 'user_interface.rb'
require_relative 'input_file.rb'

class Converter

	def initialize()
		@ui = UserInterface.new
		@categories = CategoriesCollection.new
		@input_file = InputFile.new
	end

	def get_input(ui)
		if ARGV.length != 1 || ARGV[0].split(//).last(4).join != '.xls'
			ui.localized_message(:invalid_params)
			exit 
		end
		return ARGV.first
	end

	def parse_row(row, categories, ui, writer)
		transaction = Transaction.new
		transaction.name = row[0].to_s
		transaction.memo = row[3].to_s
		transaction.date = row[1].strftime('%d-%m-%Y')
		transaction.amount = row[4].to_s

		transaction.category = categories.find_by_name(transaction.name)

		#Category not found
		if transaction.category.nil?
			transaction.display(ui)
			if ui.user_confirms(:select_category)
				transaction.category = categories.select(ui, transaction.name)
			else
				ui.localized_message(:input_info)
				transaction.memo = ui.read_input()
			end
		end
		###############################################
				
		writer << Qif::Transaction.new(
			:date => transaction.date,
			:amount => transaction.amount,
			:category => transaction.category,
			:memo => transaction.memo
		)
	end

	def run()
		@categories.load()
		@ui.set_locale()
		@input_file.load(self.get_input(@ui));

		Qif::Writer.open(File.join(File.dirname(__FILE__), '../resultado.qif'), 'Bank') do |writer|
			@input_file.file.each InputFile::HEADER_ROWS_NUMBER do |row|
				self.parse_row(row, @categories, @ui, writer)
			end
		end

		if (@categories.modified)
			@categories.save()
			@ui.localized_message(:categories_file_updated)
		end
		@ui.localized_message(:file_generated)
	end
end
