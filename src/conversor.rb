require 'bundler/setup'
require 'spreadsheet'
require 'csv'
require 'locale'
require 'i18n'
require 'qif'

class Conversor

	def convertir()
		###############LOCALE##########
		#Sets the available locales
		I18n.config.available_locales = 'es', 'en'
		#Autodetects the locale or sets the default
		begin 
			I18n.locale = Locale.current.language
		rescue 
			I18n.locale = I18n.default_locale
		end
		#Loads the locale
		I18n.load_path << Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales')) + '/*.yml']
		#################################
		##############INITIALIZES CATEGORIES####################################
		categorias = CSV.read(File.join(File.dirname(__FILE__), '../categorias'))
		@categoriasEditado = false
		#######################################################################
		##############CHECKS INPUT#############################################
		if ARGV.length != 1 || ARGV[0].split(//).last(4).join != '.xls'
			print I18n.t(:invalid_params)
			exit 
		end
		#######################################################################
		###########################OPENS THE INPUT FILE########################
		input = Spreadsheet.open(ARGV.first).worksheet 0;
		###################################################
		###########################OPENS THE OUTPUT FILE########################
		Qif::Writer.open(File.join(File.dirname(__FILE__), '../resultado.qif'), 'Bank') do |writer|
			#File operation
			#skips the first 3 rows
			3.upto(input.row_count - 1) do |row|
				#Gets fields
				nombre = input[row, 0].to_s
				info = input[row, 3].to_s
				fecha = input[row, 1].strftime("%d-%m-%Y")
				importe = input[row, 4].to_s

				################## CATEGORY SELECTION #############################
				#automatic category selection by name
				categoria = '' 
				categorias.each do |tipoCategoria|
					if tipoCategoria.include? nombre
						categoria = tipoCategoria[0]
					end
				end

				#Si no ha encontrado categoría, preguntará si añadirla a una existente.
				if categoria == ''
					print(I18n.t(:name) + nombre + "\n");
					print(I18n.t(:date) + fecha + "\n");
					print(I18n.t(:amount) + importe + "\n");
					if pregunta(I18n.t(:select_category))
						#Selecciona la categoría usando el selector de categorías
						categoria = selectorCategorias(categorias,nombre)
					else
						print(I18n.t(:input_info))
						info = $stdin.gets.strip
					end
				end
				###############################################
				
				#Writes on the file
				writer << Qif::Transaction.new(
					:date => fecha,
					:amount => importe,
					:category => nombre,
					:memo => info
				)
			end
		end

		#############################UPDATES THE CATEGORY FILE##################################
		#Does this always generate new values?
		if (@categoriasEditado)
			CSV.open(File.join(File.dirname(__FILE__), "../categorias"), "w") do |categoriasNuevo|
				categorias.each do |tipoCategoria|
					categoriasNuevo << tipoCategoria 
				end
			end
			print(I18n.t(:categories_file_updated))
		end
		print(I18n.t(:file_generated))
	end
	###############################################

	######################CONFIRM DIALOG#########################
	def pregunta(texto)
		while true
			print texto+I18n.t(:confirm_or_deny)
			case $stdin.gets.strip.upcase
			when I18n.t(:confirm_char)
				return true
			when I18n.t(:deny_char)
				return false
			end
		end
	end
	#############################################################

	#####################CATEGORY SELECTOR########################
	def selectorCategorias(categorias,nombre)
		while true
			print I18n.t(:choose_category)
			categorias.each_with_index do |categoria,index|
				print index.to_s+":"+categoria[0]+"\n"
			end
			selected = $stdin.gets.strip.to_i
			if selected.between?(0,categorias.length-1)
				categorias[selected] << nombre
				@categoriasEditado = true
				return categorias[selected][0]
			end
		end
	end
	##############################################################
end
