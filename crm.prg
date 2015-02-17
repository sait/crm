*
* Modulo de CRM
*
*
* Dic2008
* Se agrego ventana de seguimiento a actividades. Para la recepcionista
*
* Sep2009
* Se agrego ventana de consulta de ordenes pendientes.
*
* AASO Ene2015 Se agrego control de oportunidades para ventas
	
	* Agregar el menu principal
	Define Pad PadCrm of _MSysMenu Prompt "C\<RM"  Key ALT-R
	On Pad PadCrm of _MSysMenu Activate PopUp Crm
	
	Define PopUp Crm Margin Relative Shadow 
	AddBar('Crm','Agregar \<Actividad', 				'Do DoForm	With "CrmAddActiv"		In Crm','CTRL+D')
	AddBar('Crm','Consultar Actividad',					'Do DoForm	With "CrmConsActiv"		In Crm')
	AddBar('Crm','Seguimiento de Actividades',			'Do DoForm	With "CrmSeguimActiv"	In Crm')
	AddBar('Crm','\-','')
	AddBar('Crm','Agregar Oportuni\<dad',				'Do DoModal	With "CrmCrearOport"	In Crm','CTRL+O')
	AddBar('Crm','Consultar Oportunidades',				'Do DoForm	With "CrmOportunidades"	In Crm')
	AddBar('Crm','\-','')
	AddBar('Crm','Agregar \<Orden de Servicio',			'Do DoForm	With "CrmAddOrden" 		In Crm','CTRL+S')
	AddBar('Crm','Consulta \<Individual de Ordenes',	'Do DoForm	With "CrmModOrden",2	In Crm')
	AddBar('Crm','Consulta \<General de Ordenes',		'Do DoForm	With "CrmConsOrden" 	In Crm')
	AddBar('Crm','Consultar Ordenes \<Pendientes',		'Do DoForm	With "CrmConsOrden2"	In Crm')
	AddBar('Crm','Agregar \<Servicio',					'Do DoForm	With "CrmServRealizado"	In Crm','CTRL+R')
	AddBar('Crm','\-','')
	AddBar('Crm','\<Reportes',							'Activate Popup CrmReportes')
	AddBar('Crm','Reportes de Or\<denes',				'Activate PopUp CrmRepOrdenes')
	AddBar('Crm','\-','')
	AddBar('Crm','Catálogo de Proyectos',				'Do DoForm with "CrmCatProy"		In Crm')
	AddBar('Crm','Catálogo de Contactos',				'Do DoForm with "CrmCatContactos" 	In Crm')
	AddBar('Crm','\-','')
	AddBar('Crm','\<Configurar',						'Activate Popup CrmConfig')
	
	* Definir submenu de configuracion
	DefineMenuConfig()
	
	* Definir submenu de reportes
	DefineMenuReportes()
	
	Set Procedure To Crm Additive
	
	* Manda llamar el metodo para crear las bases de datos
	CrearTablas()
	
Return



*
* DefineMenuConfig
*
* Muestra en el menu de configuracion del modulo
*
Procedure DefineMenuConfig
	
	* Crear el submenu
	Define Popup CrmConfig MARGIN RELATIVE SHADOW COLOR SCHEME 4
	AddBar('CrmConfig','Categorías', 							'Do DoForm with "CrmConfCat2"		In Crm')
	AddBar('CrmConfig','Tipos de Oportunidad', 					'Do DoForm with "CrmTiposOport"		In Crm')
	AddBar('CrmConfig','Probabilidad de Cierre de Oportunidades','Do DoForm with "CrmProbCierre"		In Crm')
	
	* Evaluar si tiene definidos los tipos de probabilidad de cierre de oportunidades
	Local cTiposProb
	cTiposProb = GetMsl('CrmProbCierre')
	If Empty(cTiposProb)
		PutMsl('CrmProbCierre','Sin interes^Indeciso^Interesado^Aprobado')
	EndIf
	
Return



*
* DefineMenuReportes
*
* Muestra en el menu los reportes del modulo
*
Procedure DefineMenuReportes
	Use Reportes 

	* Crear el menu para los reportes de CRM
	Define Popup CrmReportes MARGIN RELATIVE SHADOW COLOR SCHEME 4
	Scan
		If Allt(TIPO)=='CRM'
			AddBar('CrmReportes',Allt(Reportes.DESC), 'Do DoForm With "CrmReporte" in Crm')
		Endif
	EndScan
	AddBar('CrmReportes','\-','')
	AddBar('CrmReportes','Configurar reportes de CRM', 'Do Form "ConfRep" With "CRM"  ')
	
	* Crear el menu para los reportes de ordenes
	Define PopUp CrmRepOrdenes Margin Relative Shadow Color Scheme 4
	Scan
		If Allt(TIPO)=='REPORDENES'
			AddBar('CrmRepOrdenes', Allt(Reportes.DESC), 'Do DoForm With "CrmRepOrdenes" in Crm')
		Endif
	EndScan
	AddBar('CrmRepOrdenes','\-','')
	AddBar('CrmRepOrdenes','Configurar reportes de Ordenes', 'Do Form "ConfRep" With "REPORDENES" ')
	AddBar('CrmRepOrdenes','Configurar formatos de Ordenes', 'Do Form "ConfRep" With "ORDEN" ')
	
	Use
	
Return



*
* CrearTablas
*
* Crea las tablas y campos especiales
*
Procedure CrearTablas
	
	* Crear la tabla de Contactos.DBF
	If Not File('Contactos.dbf')
		Create Table Contactos(;
			NUMCONT		C(6),;
			NOMCONT		C(50),;
			EMPRESA		C(50),;
			TELEFONO	C(30),;
			NUMCLI		C(5),;
			MAIL		C(50))
		Select Contactos
		Index On NUMCONT Tag NUMCONT
		Index On UPPER(NOMCONT) Tag NOMCONT
		Use
		* Crear el archivo Contactos.Key usado en la generacion de indices por SAIT
		cProcKey = ;
			'Delete Tag All '+Chr(13)+;
			'Index On NUMCONT Tag NUMCONT '+Chr(13)+;
			'Index On UPPER(NOMCONT) Tag NOMCONT '+Chr(13)
		StrToFile(cProcKey, 'Contactos.Key')
	EndIf
	If Not File('Contactos.dbf')
		Alerta('No existe Contactos.DBF')
		QuitIt()
	EndIf
	
	* Crear la tabla de Crm.DBF
	If Not File('Crm.dbf')
		Create Table Crm(;
			ID			C(10),;
			NUMCONT		C(6),;
			TIPO		C(20),;
			FECHA		T(8),;
			FECHAFIN	T(8),;
			OBS			M(4),;
			IDTECNICO	C(5),;
			NUMUSER		C(5),;
			NUMUSERGEN	C(5),;
			NUMORDEN	C(10),;
			NUMCOTIZA	C(10),;	
			ACTIVIDAD	L(1),;
			TERMINADA	L(1),;
			REFER		C(10),;
			ORDENPOST	C(10),;
			STATUSCOT	N(1),;
			FOLIOSER	C(10),;
			SEGUIM		M(4),;
			NUMOPORT	C(10))
		Select Crm
		Index On ID Tag ID
		Index On NUMORDEN Tag NUMORDEN
		Use
		* Crear el archivo Crm.Key usado en la generacion de indices por SAIT
		cProcKey = ;
			'Delete Tag All '+Chr(13)+;
			'Index On ID Tag ID '+Chr(13)+;
			'Index On NUMORDEN Tag NUMORDEN '+Chr(13)
		StrToFile(cProcKey, 'Crm.Key')
	EndIf
	If Not File('Crm.dbf')
		Alerta('No existe Crm.DBF')
		QuitIt()
	EndIf
	
	* Crear Crm.NUMOPORT
	If Not ExisteCampo('Crm.NUMOPORT')
		Alter Table Crm Add NUMOPORT	C(10)
		Use In Select('Crm')
	EndIf
	If Not ExisteCampo('Crm.NUMOPORT')
		Alerta('No existe Crm.NUMOPORT')
		QuitIt()
	EndIf
	
	* Crear la tabla de Ordenes.DBF
	If Not File('Ordenes.dbf')
		Create Table Ordenes(;
			NUMORDEN	C(10),;
			NUMPROY		C(10),;
			NUMCONT		C(6),;
			CREADA		T(8),;
			CITA		T(8),;
			TERMINADA	T(8),;
			CERRADA		T(8),;
			NUMUSER		C(5),;
			ASESOR1		C(5),;
			ASESOR2		C(5),;
			ASESOR3		C(5),;
			PRIORIDAD	N(1),;
			CALIF		N(1),;
			AVANCE		N(3),;
			REABIERTA	N(2),;
			HRSSERV		N(6,2),;
			CANTSERV	N(3),;
			FACTURA		C(10),;
			IMPORTE		N(8,2),;
			HRSESTIM	N(6,2),;
			INGESTIM	N(8,2),;
			PROBLEMA	M(4),;
			EQUIPOREC	M(4),;
			CAUSAS		M(4),;
			PENDPOR		M(4),;
			TIPO		C(20))
		Select Ordenes
		Index On NUMORDEN Tag NUMORDEN
		Use
		* Crear el archivo Ordenes.Key usado en la generacion de indices por SAIT
		cProcKey = ;
			'Delete Tag All '+Chr(13)+;
			'Index On NUMORDEN Tag NUMORDEN '+Chr(13)
		StrToFile(cProcKey, 'Ordenes.Key')
	EndIf
	If Not File('Ordenes.dbf')
		Alerta('No existe Ordenes.DBF')
		QuitIt()
	EndIf
	
	* Crear la tabla de Proy.DBF
	If Not File('Proy.dbf')
		Create Table Proy(;
			NUMPROY		C(10),;
			NUMCLI		C(5),;
			NOMBRE		C(40),;
			INICIO		D(8),;
			META		D(8),;
			COMPLETO	L(1),;
			IDTECNICO	C(5),;
			NUMCONT		C(6),;
			NUMUSER		C(5))
		Select Proy
		Index On NUMPROY Tag NUMPROY
		Use
		* Crear el archivo Proy.Key usado en la generacion de indices por SAIT
	EndIf
	if not file('proy.key')
		cProcKey = ;
			'Delete Tag All '+Chr(13)+;
			'Index On NUMPROY Tag NUMPROY '+Chr(13)
		StrToFile(cProcKey, 'Proy.Key')
	endif
	If Not File('Proy.dbf')
		Alerta('No existe Proy.DBF')
		QuitIt()
	EndIf
	
	* Crear la tabla de Oport.DBF
	If Not File('Oport.dbf')
		Create Table Oport(;
			NUMOPORT	C(10),;
			NUMCLI		C(5),;
			NUMUSER		C(5),;
			NUMCONT		C(6),;
			TIPO		C(15),;
			ASUNTO		C(50),;
			OBS			M(10),;
			OBSCLI		M(10),;
			CONOCIOEN	M(10),;
			IMPORTE		N(12,2),;
			STATUS		N(1),;
			CREADA		D(8),;
			INICIADA	D(8),;
			GANADA		D(8),;
			PERDIDA		D(8),;
			SIGLLAMADA	D(8),;
			PROBCIERRE	C(15),;
			NUMCOT		C(10),;
			NUMFACT		C(10),;
			CAUSAPERD	M(10),;
			OBSMEJORAR	M(10))
			
		Select Oport
		Index On NUMOPORT Tag NUMOPORT
		Use
		* Crear el archivo Oport.Key usado en la generacion de indices por SAIT
		cProcKey = ;
			'Delete Tag All '+Chr(13)+;
			'Index On NUMOPORT Tag NUMOPORT '+Chr(13)
		StrToFile(cProcKey, 'Oport.Key')
	EndIf
	If Not File('Oport.dbf')
		Alerta('No existe Oport.DBF')
		QuitIt()
	EndIf
	
Return

Function BuscarContacto
Local cNumCont
	Do Form CrmBuscarContacto to cNumCont
Return cNumCont

Procedure Dumy
	Do Form CrmAddActiv
	Do Form CrmConsActiv
	Do Form CrmAddOrden
	Do Form CrmModOrden
	Do Form CrmServRealizado
	Do Form CrmVerifServ
	Do Form CrmServTelef
	Do Form CrmConsOrden
	Do Form CrmConsOrden2
	Do Form CrmAddProy
	Do Form CrmCatProy
	Do Form CrmHistCliente
	Do Form CrmHistContacto
	Do Form CrmReporte
	Do Form CrmRepOrdenes
	Do Form CrmConfCat2
	Do Form CrmCatContactos
	Do Form CrmContactos
	Do Form CrmBuscarContacto
	Do Form CrmFacturarOrden
	Do Form CrmSeguimActiv
	Do Form CrmCargaActiv
	Do Form CrmCerrarOrden
	Do Form CrmOportunidades
	Do Form CrmCrearOport
	Do Form CrmSeguimOport
	Do Form CrmTiposOport
	Do Form CrmProbCierre
Return

* Manda llamar las formas
*** Ejecuta una forma 
Function DoForm
Parameters FormName,Par1,Par2,Par3,Par4,Par5,Par6,Par7,Par8,Par9
	Do Case
	Case Parameters()=1
		Do Form (Formname) 
	Case Parameters()=2
		Do Form (FormName) with m.Par1 
	Case Parameters()=3
		Do Form (FormName) with m.Par1,m.Par2 
	Case Parameters()=4
		Do Form (FormName) with m.Par1,m.Par2,m.Par3 
	Case Parameters()=5
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4 
	Case Parameters()=6
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4,m.Par5 
	Case Parameters()=7
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4,m.Par5,Par6
	Case Parameters()=8
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4,m.Par5,Par6,Par7
	Case Parameters()=9
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4,m.Par5,Par6,Par7,Par8
	EndCase
Return .t.

*
* DoModal
*
* Ejecuta una ventana en modo Modal
*
Function DoModal
lParameters FormName,Par1,Par2,Par3,Par4,Par5,Par6,Par7
Local RetVal
	Do Case
	Case Parameters()=1
		Do Form (Formname) to m.RetVal
	Case Parameters()=2
		Do Form (FormName) with m.Par1 to m.RetVal
	Case Parameters()=3
		Do Form (FormName) with m.Par1,m.Par2 to m.RetVal
	Case Parameters()=4
		Do Form (FormName) with m.Par1,m.Par2,m.Par3 to m.RetVal
	Case Parameters()=5
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4 to m.RetVal
	Case Parameters()=6
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4,m.Par5 to m.RetVal
	Case Parameters()=7
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4,m.Par5,m.Par6 to m.RetVal
	Case Parameters()=8
		Do Form (FormName) with m.Par1,m.Par2,m.Par3,m.Par4,m.Par5,m.Par6,m.Par7 to m.RetVal
	EndCase
Return m.RetVal
