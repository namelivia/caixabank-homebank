class Transaction
  attr_accessor :name
  attr_accessor :memo
  attr_accessor :date
  attr_accessor :amount
  attr_accessor :category

  def initialize(ui, categories)
    @ui = ui
    @categories = categories
  end

  def set_attributes(row)
    @name = row[0].to_s
    @memo = row[3].to_s
    @date = row[1].strftime('%d-%m-%Y')
    @amount = row[4].to_s
    self
  end

  def to_qif
    Qif::Transaction.new(
      date: @date,
      amount: @amount,
      category: @category,
      memo: @memo
    )
  end

  def display
    @ui.localized_message(:name)
    @ui.message(@name)
    @ui.message("\n")

    @ui.localized_message(:date)
    @ui.message(@date)
    @ui.message("\n")

    @ui.localized_message(:amount)
    @ui.message(@amount)
    @ui.message("\n")
  end

  def set_category
    @category = @categories.find_by_name(@name)
    if @category.nil?
      display
      if @ui.user_confirms(:select_category)
        @category = @categories.select(@name)
      else
        @ui.localized_message(:input_info)
        @memo = @ui.read_input
      end
    end
    self
  end
end
