*
* ValHora
*
* Funcion para regresar la fecha y hora en formato DateTime()
*
* Recibe como parametro la fecha y la hora
*

Function ValHora2
LParameters dFecha,cHora
Local nDia,nMes,nAnio,nHora,nMin,cTipo,dFechaFin
	
	* Crear variables
	nDia = Day(dFecha)
	nMes = Month(dFecha)
	nAnio = Year(dFecha)
	nHora = Val(SubStr(cHora,1,2))
	nMin = Val(SubStr(cHora,4,2))
	cTipo = ''
	dFechaFin = {}
	
	* validar que la fecha y hora sean correctos
	cTipo = Type('DateTime(nAnio,nMes,nDia,nHora,nMin)')

	If nHora > 0
		* Calcular la fecha y hora en formato DateTime()
		If cTipo == 'T'
			dFechaFin = DateTime(nAnio,nMes,nDia,nHora,nMin)
		EndIf
	EndIf
			
Return dFechaFin
