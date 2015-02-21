### Configuración

**GET /api/sait/boveda/config**

Lista la información de TODAS las empresas usando el OCF

<--
[ {rfc, key, user, pass, addr, port},
  {rfc, key, user, pass, addr, port},
  ...,
]

----------
**GET /api/sait/boveda/config/:rfc**

Regresa la configuración de la empresa indicada en el rfc.

<-- {rfc, key, user, pass, addr, port}

----------
**POST /api/sait/boveda/config/:rfc**

Crea la base de datos para la empresa indicada en :rfc  y define su variables de configuración.

--> {key, user, pass, addr, port}

<-- {rfc, key, user, pass, addr, port}

----------
**/api/sait/boveda/config/:rfc**
Actualiza la información de la empresa
**Vervo** *PUT*
**Body:**

    JSON {key, user, pass, addr, port}

**Repuesta:**

    JSON {rfc, key, user, pass, addr, port}

----------
**/api/sait/boveda/config/respaldar/:inicio/:fin**
Actualiza la información de la empresa
**Vervo** *GET*
**Parametros**

    :inicio Fecha inicial en el formato yyyymmddd
    :fin Fecha final en el formato yyyymmddd

**Body:**

    n/a

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
