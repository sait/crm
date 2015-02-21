### Llamadas de Configuración


**GET /api/sait/boveda/config**  
Regresa la información de TODAS las empresas usando el OCF.
```  
[
  {rfc, key, user, pass, addr, port},
  {rfc, key, user, pass, addr, port},  
  ..., 
] 
HTTP: 200,500
```


**GET /api/sait/boveda/config/:rfc**  
Regresa la configuración de la empresa indicada por rfc:.
```
{rfc, key, user, pass, addr, port}
HTTP: 200,204,500
```


**POST /api/sait/boveda/config/:rfc**  
Crea la base de datos para la empresa indicada en :rfc  y define su variables de configuración. Regresa los valores definidos.
```
Recibe:
{key, user, pass, addr, port}

Regresa:
{rfc, key, user, pass, addr, port}

HTTP: 200,500
```


**PUT /api/sait/boveda/config/:rfc**  
Actualiza la configuración de la empresa indicada por :rfc, regresa los valores actualizados.
```
Recibe:
{key, user, pass, addr, port}

Regresa:
{rfc, key, user, pass, addr, port}

HTTP: 200,500
```



**GET /api/sait/boveda/config/respaldar/:inicio/:fin**  
Genera un respaldo de la información, bla bla bla
```
Parametros en URL
  :inicio Fecha inicial en el formato yyyymmddd
  :fin Fecha final en el formato yyyymmddd
Regresa:
  []Byte archivo zip
```


**POST /api/sait/boveda/config/mailtest**  
Comprueba la conexión con el servidor de correos.
```
Recibe:
  {user, pass, addr, port}

Regresa:
  {"result":"OK"}
```


**POST /api/sait/boveda/config/bovedatest**  
Comprueba la conexión con el servidor de boveda.sait.mx, usando el APIKEY que se manda.
```
Recibe:
  {key}

Regresa:
  {"result":"OK}
```

