require 'i18n'
require 'locale'

class UserInterface
	def set_locale()
		I18n.config.available_locales = 'es', 'en'
		begin 
			I18n.locale = Locale.current.language
		rescue 
			I18n.locale = I18n.default_locale
		end
		I18n.load_path << Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales')) + '/*.yml']
	end

	def message(message)
		print message
	end

	def localized_message(message)
		print I18n.t(message)
	end

	def user_confirms(question)
		while true
			self.localized_message(question)
			self.localized_message(:confirm_or_deny)
			case self.read_input().upcase
			when I18n.t(:confirm_char)
				return true
			when I18n.t(:deny_char)
				return false
			end
		end
	end

	def read_input()
		return $stdin.gets.strip
	end
end
