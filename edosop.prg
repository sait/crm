*set path to e:\empresas\msl; e:\sistemas\msllib60; 
close data
set path to
set path to n:\sait\cia003
? 10

select ;
	id, crm.numcont, tipo, fecha, ;
	contactos.numcont, contactos.numcli ;
from crm ;
	left join contactos on crm.numcont == contactos.numcont ;
where ;
	left(lower(tipo),14)='poliza soporte' and ;
	numcli== ' 2052'