#Conversor de mis cuentas, esta vez en Ruby
require 'bundler/setup'
require 'spreadsheet'
require 'csv'
require 'qif'

def pregunta(texto)
	while true
		print texto+" [s/n]: "
		case $stdin.gets.strip
		when 's', 'S'
			return true
		when /\A[nN]o?\Z/
			return false
		end
	end
end

def selectorCategorias(categorias,nombre)
	while true
		print "Seleccione la categoría:\n"
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

categorias = CSV.read("categorias")
@categoriasEditado = false
if ARGV.length != 1 || ARGV[0].split(//).last(4).join != '.xls'
	print "ERROR: Parámetro de entrada incurrecto\nUso: ruby conversor [archivo .xls de entrada]\n"
	exit 
end
input = Spreadsheet.open(ARGV.first).worksheet 0;
output = File.open("resultado.csv","w")
Qif::writer.open("resultado.qif","w") do |writer|
	writer << Qif::Transaction.new(
		:date => Time.now,
		:amount => 10,
		:name => 'Prueba'
	)
end

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
		print("Nombre: "+nombre+"\n");
		print("Fecha: "+fecha+"\n");
		print("Importe: "+importe+"\n");
		if pregunta("No se ha encontrado categoría para la transacción. ¿Desea añadirla a una existente?")
			#Selecciona la categoría
			categoria = selectorCategorias(categorias,nombre)
		else
			print("Introduzca un texto descriptivo de la transacción:\n")
			info = $stdin.gets.strip
		end
	end
	output.puts(fecha+";0;"+nombre+";;"+info+";"+importe+";"+categoria+";");
end
output.close
if (@categoriasEditado)
	CSV.open("categorias", "w") do |categoriasNuevo|
		categorias.each do |tipoCategoria|
			categoriasNuevo << tipoCategoria 
		end
	end
	print("El archivo categorias se ha actualizado\n")
end
print("Resultados escritos en el archivo resultado.csv\n")
