require 'spreadsheet'
module ReaderExtensions
	def set_row_address worksheet, work, pos, len
		#Do nothing
	end
end

Spreadsheet::Excel::Reader.class_eval do
	prepend ReaderExtensions
end
