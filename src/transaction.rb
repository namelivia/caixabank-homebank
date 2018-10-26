class Transaction
	attr_accessor :name
	attr_accessor :memo
	attr_accessor :date
	attr_accessor :amount
	attr_accessor :category
	def display(ui)
		ui.localized_message(:name)
		ui.message(@name)
		ui.message("\n")

		ui.localized_message(:date)
		ui.message(@date)
		ui.message("\n")

		ui.localized_message(:amount)
		ui.message(@amount)
		ui.message("\n")
	end
end
