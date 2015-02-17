* Funcion para cargar el historial de actividades relacionadas con la orden
* Recibe como parametro el numero de orden
* Regresa el historial de actividades en forma de Str

Function CargarHistorial
LParameter cNumOrden
Local nArea,m.Historial,nTDurMin,nServs

	nAlias = Select()
	m.Historial = ''
	nTDurMin = 0
	nServs = 0
	
	* Busca en CRM las actividades de la orden
	If Not SqlMsl('Temp','Select Crm.ID,Crm.FECHA,Crm.FECHAFIN,Contactos.NOMCONT,Usuarios.NOMUSER,Crm.TIPO,Crm.OBS ' +;
		'From Crm '+;
		' Left Join Contactos On Crm.NUMCONT == Contactos.NUMCONT ' +;
		' Left Join Usuarios On Crm.NUMUSER == Usuarios.NUMUSER ' +;
		'Where '+;
		'Crm.ACTIVIDAD = .T. ' + ' and '+;
		'Crm.NUMORDEN == m.Val1 ',;
		cNumOrden)
        Return
	Endif

	* Recorre el temporal
	Select Temp
	Scan
		
		dH1 = {}
		dH2 = {}
		m.DurMin = ''
		
		* Almacena las fechas
		dH1 = Temp.FECHA
		dH2 = Temp.FECHAFIN
		
		* Calcula la duracion de la actividad
		If dH2 <> dH1
			m.DurMin = Allt(Str(Val(Str(dH2-dH1))/60))
			nTDurMin = nTDurMin+(Val(Str(dH2-dH1-60))/60)+1
			nServs = nServs+1
		Else
			m.DurMin = '0'
		EndIf
		
		* Almacena en una variable el historial de actividades de la orden
		m.Historial = m.Historial+'Fecha: '+MexDate2(SToD(DToS(Temp.FECHA)))+' '+;
			SubStr(TToC(Temp.FECHA),12,5)+'-'+SubStr(TToC(Temp.FECHAFIN),12,5)+;
			' ('+m.DurMin+')'+Chr(13)+;
			'Contacto: '+Proper(Allt(Temp.NOMCONT))+Chr(13)+;
			'Usuario: '+Proper(Allt(Temp.NOMUSER))+Chr(13)+;
			'Tipo: '+Allt(Temp.TIPO)+Chr(13)+;
			'Descripción del servicio realizado:'+Chr(13)+Temp.OBS+Chr(13)+'--------------------'+Chr(13)+Chr(13)
		
	EndScan
	
	* Devolverme al area actual
	Select (nAlias)
	
Return m.Historial+'^'+Allt(Str(nTDurMin))+'^'+Allt(Str(nServs))
