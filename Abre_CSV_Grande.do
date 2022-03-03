clear all
set more off
set rmsg on, permanently

glo ruta_input "D:\aronData\Data\Gasto"
glo ruta_output "D:\aronData\Data\Gasto"

// salto
glo salto 50000
// archivo
glo archivo "2019-Gasto"

*glo delimitador "|" // OE
glo delimitador "," // Datos Abiertos MEF o OE 2016

// base vacia
import delimited using "${ruta_input}\\${archivo}", clear rowrange(1:2) varnames(1) delimiters("${delimitador}")
drop in 1
cap erase "${ruta_output}\\${archivo}_Filtrado"
save "${ruta_output}\\${archivo}_Filtrado", replace

forvalues x=0(${salto})1000000000 {
	local y=`x'+1
	local z=`x'+${salto}
	di in red "=========="
	di in red "`y':`z'"
	import delimited using "${ruta_input}\\${archivo}", clear rowrange(`y':`z') varnames(1) delimiters("${delimitador}")
	quietly: d
	if (`r(N)'==0) {
		di in red "YA NO HAY OBS"
		continue, break
	}
	keep if sector==36
	append using "${ruta_output}\\${archivo}_Filtrado"
	save "${ruta_output}\\${archivo}_Filtrado", replace
	di in red "=========="
}
use "${ruta_output}\\${archivo}_Filtrado", clear
export excel using "${ruta_output}\\${archivo}_Filtrado.xlsx", replace first(var) sheet(BD)
