/* Creación de usuario si está trabajando con BD Oracle XE */
CREATE USER guia_P7 IDENTIFIED BY "guia_P7"
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";
ALTER USER guia_P7 QUOTA UNLIMITED ON USERS;
GRANT CREATE SESSION TO guia_P7;
GRANT "RESOURCE" TO guia_P7;
ALTER USER guia_P7 DEFAULT ROLE "RESOURCE";

/* Creación de usuario si está trabajando con BD Oracle Cloud */
CREATE USER MDY3131_P7 IDENTIFIED BY "MDY3131.practica_7"
DEFAULT TABLESPACE "DATA"
TEMPORARY TABLESPACE "TEMP";
ALTER USER MDY3131_P7 QUOTA UNLIMITED ON DATA;
GRANT CREATE SESSION TO MDY3131_P7;
GRANT "RESOURCE" TO MDY3131_P7;
ALTER USER MDY3131_P7 DEFAULT ROLE "RESOURCE"