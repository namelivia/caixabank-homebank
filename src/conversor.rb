require 'bundler/setup'
require 'spreadsheet'
require 'csv'
require 'locale'
require 'i18n'
require 'qif'

class Conversor

	def convertir()
		#Sets the available locales
		I18n.config.available_locales = 'es', 'en'
		#Autodetects the locale or sets the default
		begin 
			I18n.locale = Locale.current.language
		rescue 
			I18n.locale = I18n.default_locale
		end
		I18n.load_path << Dir[File.expand_path(File.join(File.dirname(__FILE__), "../locales")) + "/*.yml"]
		categorias = CSV.read(File.join(File.dirname(__FILE__), "../categorias"))
		@categoriasEditado = false
		if ARGV.length != 1 || ARGV[0].split(//).last(4).join != '.xls'
			print I18n.t(:invalid_params)
			exit 
		end
		input = Spreadsheet.open(ARGV.first).worksheet 0;
		Qif::Writer.open(File.join(File.dirname(__FILE__), "../resultado.qif"), "Bank") do |writer|
			3.upto(input.row_count-1) do |row|
				nombre = input[row,0].to_s
				info = input[row,3].to_s
				fecha = input[row,1].strftime("%d-%m-%Y")
				importe = input[row,4].to_s

				#Asigna la categoría en funcion del nombre
				categoria = '' 
				categorias.each do |tipoCategoria|
					if tipoCategoria.include? nombre
						categoria = tipoCategoria[0]
					end
				end

				if categoria == ''
					#Si no ha encontrado categoría, preguntará si añadirla a una existente.
					print(I18n.t(:name)+nombre+"\n");
					print(I18n.t(:date)+fecha+"\n");
					print(I18n.t(:amount)+importe+"\n");
					if pregunta(I18n.t(:select_category))
						#Selecciona la categoría
						categoria = selectorCategorias(categorias,nombre)
					else
						print(I18n.t(:input_info))
						info = $stdin.gets.strip
					end
				end
				writer << Qif::Transaction.new(
					:date => fecha,
					:amount => importe,
					:category => nombre,
					:memo => info
				)
			end
		end
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
end
