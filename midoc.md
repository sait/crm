### Configuración

**GET /api/sait/boveda/config**

Lista la información de TODAS las empresas usando el OCF

[ {rfc, key, user, pass, addr, port},
  {rfc, key, user, pass, addr, port},
  ...,
]

HTTP: 200,500

----------
**GET /api/sait/boveda/config/:rfc**

Regresa la configuración de la empresa indicada en el rfc.

{rfc, key, user, pass, addr, port}

HTTP: 200,204,500


----------
**POST /api/sait/boveda/config/:rfc**

{key, user, pass, addr, port}

Crea la base de datos para la empresa indicada en :rfc  y define su variables de configuración. Regresa los valores definidos:

{rfc, key, user, pass, addr, port}

HTTP: 200,500

----------
**PUT /api/sait/boveda/config/:rfc**

{key, user, pass, addr, port}

Actualiza la configuración de la empresa indicada por :rfc, regresa los valores actualizados:

{rfc, key, user, pass, addr, port}

HTTP: 200,500

----------
** GET /api/sait/boveda/config/respaldar/:inicio/:fin**

Genera un respaldo de la información des
**Parametros**

    :inicio Fecha inicial en el formato yyyymmddd
    :fin Fecha final en el formato yyyymmddd


**Repuesta:**

    []Byte archivo zip

 ----------
**/api/sait/boveda/config/mailtest**
Verifica que la información de correo electrónico sea válida
**Vervo** *POST*
**Body:**

    JSON {user, pass, addr, port}

**Repuesta:**

    JSON {result}

 ----------
**/api/sait/boveda/config/bovedatest**
Verifica que la información de bóveda sea válida
**Vervo** *POST*
**Body:**

    JSON {key}

**Repuesta:**

    JSON {result}
