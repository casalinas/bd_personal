

CREATE TABLE condena (
    id_condena          NUMBER(3) NOT NULL,
    fecha_condena       DATE,
    annos               NUMBER(3) NOT NULL,
    libertad_vigilada   CHAR(1 BYTE) NOT NULL,    
    id_penite           NUMBER(3) NOT NULL
);


CREATE UNIQUE INDEX  condena_pk ON
    condena (
        id_condena
    ASC );

ALTER TABLE condena ADD CONSTRAINT condena_pk PRIMARY KEY ( id_condena );

CREATE TABLE condena_imputados (
    id_condena    NUMBER NOT NULL,
    id_imputado   NUMBER NOT NULL
);

ALTER TABLE condena_imputados ADD CONSTRAINT cond_imput_pk PRIMARY KEY ( id_condena,
                                                                         id_imputado );

CREATE TABLE delito (
    id_delito      NUMBER(3) NOT NULL,
    descripcion    VARCHAR2(35 BYTE) NOT NULL,
    pena_id_pena   NUMBER NOT NULL
);

CREATE UNIQUE INDEX  delito_pk ON
    delito (
        id_delito
    ASC );

ALTER TABLE delito ADD CONSTRAINT delito_pk PRIMARY KEY ( id_delito );

CREATE TABLE delito_imputado (
    id_delito_imputado   NUMBER(3) NOT NULL,
    id_delito            NUMBER(3) NOT NULL,
    id_imputado          NUMBER(3) NOT NULL    
);

CREATE UNIQUE INDEX  delito_imputado_pk ON
    delito_imputado (
        id_delito_imputado
    ASC );

ALTER TABLE delito_imputado ADD CONSTRAINT delito_imputado_pk PRIMARY KEY ( id_delito_imputado );

CREATE TABLE imputados (
    id_imputado       NUMBER(3) NOT NULL,
    rut               VARCHAR2(45 BYTE) NOT NULL,
    nombre            VARCHAR2(45 BYTE) NOT NULL,
    apellido          VARCHAR2(45 BYTE) NOT NULL,
    sexo              CHAR(1 BYTE),
    f_nacimiento      DATE NOT NULL,
    id_nacionalidad   NUMBER(3) NOT NULL
);

CREATE UNIQUE INDEX  imputados_pk ON
    imputados (
        id_imputado
    ASC );

ALTER TABLE imputados ADD CONSTRAINT imputados_pk PRIMARY KEY ( id_imputado );

CREATE TABLE nacionalidad (
    id_nacionalidad   NUMBER(3) NOT NULL,
    descripcion       VARCHAR2(45 BYTE) NOT NULL
);

CREATE UNIQUE INDEX  nacionalidad_pk ON
    nacionalidad (
        id_nacionalidad
    ASC );

ALTER TABLE nacionalidad ADD CONSTRAINT nacionalidad_pk PRIMARY KEY ( id_nacionalidad );

CREATE TABLE pena (
    id_pena       NUMBER(3) NOT NULL,
    descripcion   VARCHAR2(45 BYTE) NOT NULL
);

CREATE UNIQUE INDEX  pena_pk ON
    pena (
        id_pena
    ASC );

ALTER TABLE pena ADD CONSTRAINT pena_pk PRIMARY KEY ( id_pena );

CREATE TABLE penitencieria (
    id_penitencieria   NUMBER(3) NOT NULL,
    nombre             VARCHAR2(35 BYTE) NOT NULL,
    direccion          VARCHAR2(50 BYTE) NOT NULL,
    capacidad          NUMBER(3) NOT NULL,
    num_internos       NUMBER(3) NOT NULL,
    comuna             VARCHAR2(30 BYTE) NOT NULL
);

CREATE UNIQUE INDEX  penitencieria_pk ON
    penitencieria (
        id_penitencieria
    ASC );

ALTER TABLE penitencieria ADD CONSTRAINT penitencieria_pk PRIMARY KEY ( id_penitencieria );

CREATE TABLE resumen_condena (
    sec_condena         NUMBER NOT NULL,
    id_condena          NUMBER,
    nombre_imputado     VARCHAR2(45),
    apellido_imputado   VARCHAR2(45),
    salida              NUMBER,
    salio               VARCHAR2(2),
    fecha_condena       DATE,
    annos_faltantes     NUMBER,
    beneficio           VARCHAR2(45)
);

ALTER TABLE resumen_condena ADD CONSTRAINT resumen_condena_pk PRIMARY KEY ( sec_condena );

CREATE TABLE resumen_visitas (
    sec_visita      NUMBER NOT NULL,
    id_condena      NUMBER(3),
    numero_visitas  NUMBER(3),
    fecha_primera_visita    DATE,
    fecha_ultima_visita     DATE
);

ALTER TABLE resumen_visitas ADD CONSTRAINT resumen_visitas_pk PRIMARY KEY ( sec_visita );

CREATE TABLE tramo_beneficios (
    id_tramo_beneficio   NUMBER(3) NOT NULL,
    anno_minimo          NUMBER(3) NOT NULL,    
    anno_maximo          NUMBER(3) NOT NULL,
    beneficio            VARCHAR2(45) NOT NULL
);

CREATE UNIQUE INDEX  tramo_beneficio_pk ON
    tramo_beneficios (
        id_tramo_beneficio
    ASC );

ALTER TABLE tramo_beneficios ADD CONSTRAINT tramo_beneficio_pk PRIMARY KEY ( id_tramo_beneficio );

CREATE TABLE visita (
    id_visita      NUMBER(3) NOT NULL,
    fecha          DATE,
    id_visitante   NUMBER(3) NOT NULL,
    id_condena     NUMBER(3) NOT NULL
);

CREATE UNIQUE INDEX  visita_pk ON
    visita (
        id_visita
    ASC );

ALTER TABLE visita ADD CONSTRAINT visita_pk PRIMARY KEY ( id_visita );

CREATE TABLE visitantes (
    id_visita   NUMBER(3) NOT NULL,
    rut         VARCHAR2(12 BYTE) NOT NULL,
    nombre      VARCHAR2(35 BYTE),
    apellido    VARCHAR2(35 BYTE),
    sexo        CHAR(1 BYTE)
);

CREATE UNIQUE INDEX  visitantes_pk ON
    visitantes (
        id_visita
    ASC );

ALTER TABLE visitantes ADD CONSTRAINT visitantes_pk PRIMARY KEY ( id_visita );

ALTER TABLE condena_imputados
    ADD CONSTRAINT condena_imputados_fk FOREIGN KEY ( id_condena )
        REFERENCES condena ( id_condena );

ALTER TABLE condena
    ADD CONSTRAINT condena_penitencieria_fk FOREIGN KEY ( id_penite )
        REFERENCES penitencieria ( id_penitencieria );

ALTER TABLE delito_imputado
    ADD CONSTRAINT delito_imput_imput_fk FOREIGN KEY ( id_imputado )
        REFERENCES imputados ( id_imputado );

ALTER TABLE delito
    ADD CONSTRAINT delito_pena_fk FOREIGN KEY ( pena_id_pena )
        REFERENCES pena ( id_pena );

ALTER TABLE imputados
    ADD CONSTRAINT imput_naci_fk FOREIGN KEY ( id_nacionalidad )
        REFERENCES nacionalidad ( id_nacionalidad );

ALTER TABLE delito_imputado
    ADD CONSTRAINT imputado_delito_imput_fk FOREIGN KEY ( id_delito )
        REFERENCES delito ( id_delito );

ALTER TABLE condena_imputados
    ADD CONSTRAINT imputados_delito_fk FOREIGN KEY ( id_imputado )
        REFERENCES delito_imputado ( id_delito_imputado );

ALTER TABLE visita
    ADD CONSTRAINT visita_condena_fk FOREIGN KEY ( id_condena )
        REFERENCES condena ( id_condena );

ALTER TABLE visita
    ADD CONSTRAINT visita_visitantes_fk FOREIGN KEY ( id_visitante )
        REFERENCES visitantes ( id_visita );
--------- Datos -------------

--- Visitantes
INSERT INTO visitantes VALUES(1,'12121212-3','Jorge Andres','Tapia Solis','M');
INSERT INTO visitantes VALUES(2,'23652223-7','Marcos Antonio','Candia Perez','M');
INSERT INTO visitantes VALUES(3,'10215421-1','Marcela Andrea','Solis Diaz','F');
INSERT INTO visitantes VALUES(4,'19745125-2','Raul Alfonso','Fuentes Ducco','M');
INSERT INTO visitantes VALUES(5,'08451254-1','Diego Mauricio','Ramirez Lara','M');
INSERT INTO visitantes VALUES(6,'09452145-3','Samanta Veronica','Segovia Salinas','F');
INSERT INTO visitantes VALUES(7,'11215410-2','Raul Pablo','Pedrero Fuentes','M');
INSERT INTO visitantes VALUES(8,'13201214-3','Sebastian Andres','Martinez Candia','M');
INSERT INTO visitantes VALUES(9,'12145412-6','Ricardo Pablo','Gonzalez Rivas','M');
INSERT INTO visitantes VALUES(10,'14298036-3','Tamara Andrea','Ulloa Gonzalez','F');
INSERT INTO visitantes VALUES(11,'16021197-k','Maria Ana','Perez Garcia','F');
INSERT INTO visitantes VALUES(12,'25412080-1','Patricia Barbara','Damasco Ortega','F');
INSERT INTO visitantes VALUES(13,'25687059-7','Jose Atanacio','Saldias Contreras','M');
INSERT INTO visitantes VALUES(14,'19320594-k','Daniel Horacio','Martin Villanueva','M');
INSERT INTO visitantes VALUES(15,'15012088-5','Camila Tamara','Zapata Candia','F');
INSERT INTO visitantes VALUES(16,'09420236-2','Hugo Antonio','Ramirez Sobarzo','M');

--- Penitencieria
INSERT INTO penitencieria values(1,'Colina 1','Carretera General San Martin 665',300,100,'Colina');
INSERT INTO penitencieria values(2,'Colina 2','Carretera General San Martin 765',400,140,'Colina');
INSERT INTO penitencieria values(3,'Punta Peuco','Camino Quilapilum, Parcela 25',80,10,'TilTil');
INSERT INTO penitencieria values(4,'Puente Alto','Irarrazabal 991',300,100,'Puente Alto');
INSERT INTO penitencieria values(5,'Santiago 1','Av. Nueva Centenario 1879',340,101,'Santiago');
INSERT INTO penitencieria values(6,'Santiago Sur','Av. Pedro Montt 1902',230,80,'Santiago');
INSERT INTO penitencieria values(7,'San Miguel','San Francisco 4759',380,90,'San Miguel');


--- Nacionalidad
INSERT INTO nacionalidad values(1,'Chileno');
INSERT INTO nacionalidad values(2,'Peruano');
INSERT INTO nacionalidad values(3,'Colombiano');
INSERT INTO nacionalidad values(4,'Hatiano');
INSERT INTO nacionalidad values(5,'Ecuatoriano');
INSERT INTO nacionalidad values(6,'Puerto Rico');

--- Pena
INSERT INTO pena values(1,'Presidio');
INSERT INTO pena values(2,'Reclusion');
INSERT INTO pena values(3,'Confinamiento');
INSERT INTO pena values(4,'Inhabilitacion');
INSERT INTO pena values(5,'Presidio Menor');
INSERT INTO pena values(6,'Reclusion Menor');
INSERT INTO pena values(7,'Confinamiento Menor');
INSERT INTO pena values(8,'Suspencion de Cargo');
INSERT INTO pena values(9,'Prision');

--- Tramo Beneficios
INSERT INTO tramo_beneficios values(1,1,5,'reclucion nocturna');
INSERT INTO tramo_beneficios values(2,6,10,'libertad vigilada');
INSERT INTO tramo_beneficios values(3,11,16,'curso capacitacion');
INSERT INTO tramo_beneficios values(4,17,50,'ninguna');
--- Delito
INSERT INTO delito values(1,'Parricidio',1);
INSERT INTO delito values(2,'Homicidio',1);
INSERT INTO delito values(3,'Infanticidio',1);
INSERT INTO delito values(4,'Secuestro',2);
INSERT INTO delito values(9,'Asalto',5);
INSERT INTO delito values(6,'Hurto',5);
INSERT INTO delito values(7,'Soborno',8);
INSERT INTO delito values(8,'Encubrimiento',7);
INSERT INTO delito values(5,'Robo Lugar Deshabitado',9);

-- Imputados
INSERT INTO IMPUTADOS values(1,'11111111-1','Jose','Perez','M','10-12-1970',1);
INSERT INTO IMPUTADOS values(2,'22222222-2','Andres','Ortega','M','04-06-1968',1);
INSERT INTO IMPUTADOS values(3,'33333333-3','Marcos','Lara','M','01-03-1955',1);
INSERT INTO IMPUTADOS values(4,'44444444-0','Aldo','Rios','M','12-08-1970',2);
INSERT INTO IMPUTADOS values(5,'55555555-5','Martin','Lita','M','09-04-1966',2);
INSERT INTO IMPUTADOS values(6,'66666666-6','Raul','Fariña','M','20-08-1975',3);
INSERT INTO IMPUTADOS values(7,'77777744-K','Dunis','Teron','M','11-04-1980',4);
INSERT INTO IMPUTADOS values(8,'88888888-8','Hugo','Peron','M','18-04-1990',5);
INSERT INTO IMPUTADOS values(9,'99999999-9','Ramis','Lorca','M','08-09-1966',5);
INSERT INTO IMPUTADOS values(10,'12343234-8','Person','Lobis','M','19-01-1978',4);
INSERT INTO IMPUTADOS values(11,'16987678-7','Roney','Usthon','M','11-05-1980',4);
INSERT INTO IMPUTADOS values(12,'19876578-K','Andrea','Tamayo','F','12-07-1990',3);
INSERT INTO IMPUTADOS values(13,'23476556-3','Thania','Rivas','F','19-09-1999',3);
INSERT INTO IMPUTADOS values(14,'21764367-K','Pamela','Machuca','F','28-08-1988',1);

-- Asociacion del Imputado con el delito cometido
INSERT INTO delito_imputado VALUES(1,9,8);
INSERT INTO delito_imputado VALUES(2,1,10);
INSERT INTO delito_imputado VALUES(3,1,4);
INSERT INTO delito_imputado VALUES(4,9,9);
INSERT INTO delito_imputado VALUES(5,3,6);
INSERT INTO delito_imputado VALUES(6,4,5);
INSERT INTO delito_imputado VALUES(7,2,1);
INSERT INTO delito_imputado VALUES(8,2,4);
INSERT INTO delito_imputado VALUES(9,6,3);
INSERT INTO delito_imputado VALUES(10,5,7);
INSERT INTO delito_imputado VALUES(11,5,9);
INSERT INTO delito_imputado VALUES(12,9,11);
INSERT INTO delito_imputado VALUES(13,3,12);
INSERT INTO delito_imputado VALUES(14,1,3);
INSERT INTO delito_imputado VALUES(15,2,7);
INSERT INTO delito_imputado VALUES(16,2,7);
INSERT INTO delito_imputado VALUES(17,1,9);

---Condenas
INSERT INTO CONDENA VALUES(1,'10/04/2015',15,'S',2);
INSERT INTO CONDENA VALUES(2,'03/08/2000',5,'N',1);
INSERT INTO CONDENA VALUES(3,'09/06/2000',10,'N',2);
INSERT INTO CONDENA VALUES(4,'11/04/2001',6,'N',2);
INSERT INTO CONDENA VALUES(5,'26/11/2012',7,'N',1);
INSERT INTO CONDENA VALUES(6,'20/01/2003',11,'S',2);
INSERT INTO CONDENA VALUES(7,'04/09/2008',10,'S',3);
INSERT INTO CONDENA VALUES(8,'10/11/2017',8,'S',1);
INSERT INTO CONDENA VALUES(9,'01/09/2001',5,'N',2);
INSERT INTO CONDENA VALUES(10,'14/07/2002',7,'S',1);
INSERT INTO CONDENA VALUES(11,'16/04/2008',9,'N',2);
INSERT INTO CONDENA VALUES(12,'25/12/2001',5,'S',4);
INSERT INTO CONDENA VALUES(13,'01/02/1999',10,'N',4);
INSERT INTO CONDENA VALUES(14,'14/05/2006',6,'S',5);

--- Asociacion de Condena con el Delito del Imputado
INSERT INTO condena_imputados VALUES(1,1);
INSERT INTO condena_imputados VALUES(1,4);
INSERT INTO condena_imputados VALUES(1,12);
INSERT INTO condena_imputados VALUES(2,16);
INSERT INTO condena_imputados VALUES(2,8);
INSERT INTO condena_imputados VALUES(6,15);
INSERT INTO condena_imputados VALUES(2,7);
INSERT INTO condena_imputados VALUES(3,9);
INSERT INTO condena_imputados VALUES(4,13);
INSERT INTO condena_imputados VALUES(4,5);
INSERT INTO condena_imputados VALUES(5,2);
INSERT INTO condena_imputados VALUES(5,14);
INSERT INTO condena_imputados VALUES(5,3);
INSERT INTO condena_imputados VALUES(5,17);
INSERT INTO condena_imputados VALUES(6,11);
INSERT INTO condena_imputados VALUES(6,10);
INSERT INTO condena_imputados VALUES(6,6);

--- Visitas Realizadas 
INSERT INTO VISITA VALUES(1,'10/05/15',1,1);
INSERT INTO VISITA VALUES(2,'08/06/15',2,1);
INSERT INTO VISITA VALUES(3,'10/09/15',8,1);
INSERT INTO VISITA VALUES(4,'12/01/16',6,1);
INSERT INTO VISITA VALUES(5,'25/05/16',1,1);
INSERT INTO VISITA VALUES(6,'10/08/00',4,2);
INSERT INTO VISITA VALUES(7,'04/09/00',7,2);
INSERT INTO VISITA VALUES(8,'05/10/00',7,2);
INSERT INTO VISITA VALUES(9,'09/11/00',4,2);
INSERT INTO VISITA VALUES(10,'20/12/00',7,2);
INSERT INTO VISITA VALUES(11,'21/02/01',4,2);
INSERT INTO VISITA VALUES(12,'10/07/00',16,3);
INSERT INTO VISITA VALUES(13,'14/08/00',16,3);
INSERT INTO VISITA VALUES(14,'20/10/00',16,3);
INSERT INTO VISITA VALUES(15,'10/12/00',11,3);
INSERT INTO VISITA VALUES(16,'04/03/01',11,3);
INSERT INTO VISITA VALUES(17,'08/04/01',16,3);
INSERT INTO VISITA VALUES(18,'15/06/02',11,3);
INSERT INTO VISITA VALUES(19,'20/05/01',14,4);
INSERT INTO VISITA VALUES(20,'06/06/01',14,4);
INSERT INTO VISITA VALUES(21,'09/07/01',15,4);
INSERT INTO VISITA VALUES(22,'05/09/01',15,4);
INSERT INTO VISITA VALUES(23,'10/02/02',14,4);
INSERT INTO VISITA VALUES(24,'23/05/02',15,4);


------------------------------------------------
