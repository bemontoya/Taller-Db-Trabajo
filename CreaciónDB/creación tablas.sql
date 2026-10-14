-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-08-26 10:59:55 CLT
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE CALIFICACION 
    ( 
     id_clasificacion       NUMBER  NOT NULL , 
     puntuacion             NUMBER (1)  NOT NULL , 
     resena                 CLOB , 
     fecha_calificacion     DATE  NOT NULL , 
     CONTENIDO_id_contenido NUMBER  NOT NULL , 
     PERFIL_id_perfil       NUMBER  NOT NULL 
    ) 
;

ALTER TABLE CALIFICACION 
    ADD CONSTRAINT CALIFICACION_PK PRIMARY KEY ( id_clasificacion ) ;

CREATE TABLE CAPITULO 
    ( 
     id_capitulo                    NUMBER  NOT NULL , 
     numero_episodio                INTEGER  NOT NULL , 
     titulo                         VARCHAR2 (150)  NOT NULL , 
     duracion_minutos               INTEGER  NOT NULL , 
     sinopsis                       CLOB  NOT NULL , 
     TEMPORADA_id_temporada         NUMBER  NOT NULL , 
     PISTA_AUDIO_id_audio           NUMBER  NOT NULL , 
     PISTA_SUBTITULOS_id_subtitulos NUMBER  NOT NULL , 
     CONTENIDO_id_contenido         NUMBER  NOT NULL 
    ) 
;

ALTER TABLE CAPITULO 
    ADD CONSTRAINT CAPITULO_PK PRIMARY KEY ( id_capitulo, PISTA_AUDIO_id_audio, CONTENIDO_id_contenido ) ;

CREATE TABLE CATEGORIA 
    ( 
     id_categoria NUMBER  NOT NULL , 
     nombre       VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE CATEGORIA 
    ADD CONSTRAINT CATEGORIA_PK PRIMARY KEY ( id_categoria ) ;

CREATE TABLE CLASIF_EDAD 
    ( 
     id_clasif_edad NUMBER  NOT NULL , 
     nombre         VARCHAR2 (50)  NOT NULL , 
     descripcion    VARCHAR2 (250)  NOT NULL 
    ) 
;

ALTER TABLE CLASIF_EDAD 
    ADD CONSTRAINT CLASIF_EDAD_PK PRIMARY KEY ( id_clasif_edad ) ;

CREATE TABLE CONTENIDO 
    ( 
     id_contenido                     NUMBER  NOT NULL , 
     titulo                           VARCHAR2 (150)  NOT NULL , 
     sinopsis                         CLOB  NOT NULL , 
     anio_lanzamiento                 INTEGER  NOT NULL , 
     duracion_minutos                 INTEGER  NOT NULL , 
     PRODUCTORA_id_productora         NUMBER  NOT NULL , 
--  ERROR: Column name length exceeds maximum allowed length(30) 
     TIPO_CONTENIDO_id_tipo_contenido NUMBER  NOT NULL , 
     CLASIF_EDAD_id_clasif_edad       NUMBER  NOT NULL 
    ) 
;

ALTER TABLE CONTENIDO 
    ADD CONSTRAINT CONTENIDO_PK PRIMARY KEY ( id_contenido ) ;

CREATE TABLE CONTENIDO_CATEGORIA 
    ( 
     CONTENIDO_id_contenido NUMBER  NOT NULL , 
     CATEGORIA_id_categoria NUMBER  NOT NULL 
    ) 
;

ALTER TABLE CONTENIDO_CATEGORIA 
    ADD CONSTRAINT CONTENIDO_CATEGORIA_PK PRIMARY KEY ( CONTENIDO_id_contenido, CATEGORIA_id_categoria ) ;

CREATE TABLE DISPOSITIVO 
    ( 
     id_dispositivo      NUMBER  NOT NULL , 
     nombre_dispositivo  VARCHAR2 (100)  NOT NULL , 
     tipo_dispositivo    VARCHAR2 (50)  NOT NULL , 
     fecha_ultimo_acceso DATE  NOT NULL , 
     USUARIO_id_usuario  NUMBER  NOT NULL 
    ) 
;

ALTER TABLE DISPOSITIVO 
    ADD CONSTRAINT DISPOSITIVO_PK PRIMARY KEY ( id_dispositivo ) ;

CREATE TABLE HISTORIAL_REPRODUCCION 
    ( 
     id_historial                    NUMBER  NOT NULL , 
     segundo_actual                  INTEGER  NOT NULL , 
     completado                      CHAR (1)  NOT NULL , 
     fecha_ultima_reproduccion       DATE  NOT NULL , 
     PERFIL_id_perfil                NUMBER  NOT NULL , 
     CAPITULO_id_capitulo            NUMBER  NOT NULL , 
     CAPITULO_PISTA_AUDIO_id_audio   NUMBER  NOT NULL , 
--  ERROR: Column name length exceeds maximum allowed length(30) 
     CAPITULO_CONTENIDO_id_contenido NUMBER  NOT NULL 
    ) 
;

ALTER TABLE HISTORIAL_REPRODUCCION 
    ADD CONSTRAINT HISTORIAL_REPRODUCCION_PK PRIMARY KEY ( id_historial ) ;

CREATE TABLE IDIOMA 
    ( 
     id_idioma  NUMBER  NOT NULL , 
     nombre     VARCHAR2 (50)  NOT NULL , 
     codigo_iso VARCHAR2 (10)  NOT NULL 
    ) 
;

ALTER TABLE IDIOMA 
    ADD CONSTRAINT IDIOMA_PK PRIMARY KEY ( id_idioma ) ;

CREATE TABLE MI_LISTA 
    ( 
     PERFIL_id_perfil       NUMBER  NOT NULL , 
     CONTENIDO_id_contenido NUMBER  NOT NULL , 
     fecha_agregado         DATE  NOT NULL 
    ) 
;

ALTER TABLE MI_LISTA 
    ADD CONSTRAINT MI_LISTA_PK PRIMARY KEY ( PERFIL_id_perfil, CONTENIDO_id_contenido ) ;

CREATE TABLE PARTICIPACION 
    ( 
     id_participacion       NUMBER  NOT NULL , 
     nombre_personaje       VARCHAR2 (100)  NOT NULL , 
     CONTENIDO_id_contenido NUMBER  NOT NULL , 
     ROL_id_rol             NUMBER  NOT NULL , 
     PERSONA_id_persona     NUMBER  NOT NULL 
    ) 
;

ALTER TABLE PARTICIPACION 
    ADD CONSTRAINT PARTICIPACION_PK PRIMARY KEY ( id_participacion ) ;

CREATE TABLE PERFIL 
    ( 
     id_perfil          NUMBER  NOT NULL , 
     nombre_perfil      VARCHAR2 (50)  NOT NULL , 
     avatar_url         VARCHAR2 (255)  NOT NULL , 
     es_infantil        CHAR (1)  NOT NULL , 
     USUARIO_id_usuario NUMBER  NOT NULL 
    ) 
;

ALTER TABLE PERFIL 
    ADD CONSTRAINT PERFIL_PK PRIMARY KEY ( id_perfil ) ;

CREATE TABLE PERSONA 
    ( 
     id_persona       NUMBER  NOT NULL , 
     nombre_completo  VARCHAR2 (150)  NOT NULL , 
     fecha_nacimiento DATE  NOT NULL 
    ) 
;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_PK PRIMARY KEY ( id_persona ) ;

CREATE TABLE PISTA_AUDIO 
    ( 
     id_audio             NUMBER  NOT NULL , 
     formato_audio        VARCHAR2 (50)  NOT NULL , 
     es_original          CHAR (1)  NOT NULL , 
     es_audio_descriptivo CHAR (1)  NOT NULL , 
     IDIOMA_id_idioma     NUMBER  NOT NULL 
    ) 
;

ALTER TABLE PISTA_AUDIO 
    ADD CONSTRAINT PISTA_AUDIO_PK PRIMARY KEY ( id_audio ) ;

CREATE TABLE PISTA_SUBTITULOS 
    ( 
     id_subtitulos    NUMBER  NOT NULL , 
     es_forzado       CHAR (1)  NOT NULL , 
     es_para_sordos   CHAR (1)  NOT NULL , 
     IDIOMA_id_idioma NUMBER  NOT NULL 
    ) 
;

ALTER TABLE PISTA_SUBTITULOS 
    ADD CONSTRAINT PISTA_SUBTITULOS_PK PRIMARY KEY ( id_subtitulos ) ;

CREATE TABLE PLAN_SUSCRIPCION 
    ( 
     id_plan_suscripcion NUMBER  NOT NULL , 
     nombre              VARCHAR2 (100)  NOT NULL , 
     descripcion         VARCHAR2 (250)  NOT NULL , 
     precio              NUMBER  NOT NULL 
    ) 
;

ALTER TABLE PLAN_SUSCRIPCION 
    ADD CONSTRAINT PLAN_SUSCRIPCION_PK PRIMARY KEY ( id_plan_suscripcion ) ;

CREATE TABLE PRODUCTORA 
    ( 
     id_productora NUMBER  NOT NULL , 
     nombre        VARCHAR2 (100)  NOT NULL , 
     web           VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE PRODUCTORA 
    ADD CONSTRAINT PRODUCTORA_PK PRIMARY KEY ( id_productora ) ;

CREATE TABLE ROL 
    ( 
     id_rol     NUMBER  NOT NULL , 
     nombre_rol VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE ROL 
    ADD CONSTRAINT ROL_PK PRIMARY KEY ( id_rol ) ;

CREATE TABLE TEMPORADA 
    ( 
     id_temporada     NUMBER  NOT NULL , 
     numero_temporada INTEGER  NOT NULL , 
     titulo           VARCHAR2 (100)  NOT NULL , 
     anio_lanzamiento INTEGER  NOT NULL 
    ) 
;

ALTER TABLE TEMPORADA 
    ADD CONSTRAINT TEMPORADA_PK PRIMARY KEY ( id_temporada ) ;

CREATE TABLE TIPO_CONTENIDO 
    ( 
     id_tipo_contenido NUMBER  NOT NULL , 
     nombre            VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE TIPO_CONTENIDO 
    ADD CONSTRAINT TIPO_CONTENIDO_PK PRIMARY KEY ( id_tipo_contenido ) ;

CREATE TABLE USUARIO 
    ( 
     id_usuario                           NUMBER  NOT NULL , 
     email                                VARCHAR2 (150)  NOT NULL , 
     contrasena                           VARCHAR2 (255)  NOT NULL , 
     fecha_registro                       DATE  NOT NULL , 
     metodo_pago                          VARCHAR2 (50) , 
--  ERROR: Column name length exceeds maximum allowed length(30) 
     PLAN_SUSCRIPCION_id_plan_suscripcion NUMBER  NOT NULL 
    ) 
;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PK PRIMARY KEY ( id_usuario ) ;

ALTER TABLE CALIFICACION 
    ADD CONSTRAINT CALIFICACION_CONTENIDO_FK FOREIGN KEY 
    ( 
     CONTENIDO_id_contenido
    ) 
    REFERENCES CONTENIDO 
    ( 
     id_contenido
    ) 
;

ALTER TABLE CALIFICACION 
    ADD CONSTRAINT CALIFICACION_PERFIL_FK FOREIGN KEY 
    ( 
     PERFIL_id_perfil
    ) 
    REFERENCES PERFIL 
    ( 
     id_perfil
    ) 
;

ALTER TABLE CAPITULO 
    ADD CONSTRAINT CAPITULO_CONTENIDO_FK FOREIGN KEY 
    ( 
     CONTENIDO_id_contenido
    ) 
    REFERENCES CONTENIDO 
    ( 
     id_contenido
    ) 
;

ALTER TABLE CAPITULO 
    ADD CONSTRAINT CAPITULO_PISTA_AUDIO_FK FOREIGN KEY 
    ( 
     PISTA_AUDIO_id_audio
    ) 
    REFERENCES PISTA_AUDIO 
    ( 
     id_audio
    ) 
;

ALTER TABLE CAPITULO 
    ADD CONSTRAINT CAPITULO_PISTA_SUBTITULOS_FK FOREIGN KEY 
    ( 
     PISTA_SUBTITULOS_id_subtitulos
    ) 
    REFERENCES PISTA_SUBTITULOS 
    ( 
     id_subtitulos
    ) 
;

ALTER TABLE CAPITULO 
    ADD CONSTRAINT CAPITULO_TEMPORADA_FK FOREIGN KEY 
    ( 
     TEMPORADA_id_temporada
    ) 
    REFERENCES TEMPORADA 
    ( 
     id_temporada
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE CONTENIDO_CATEGORIA 
    ADD CONSTRAINT CONTENIDO_CATEGORIA_CATEGORIA_FK FOREIGN KEY 
    ( 
     CATEGORIA_id_categoria
    ) 
    REFERENCES CATEGORIA 
    ( 
     id_categoria
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE CONTENIDO_CATEGORIA 
    ADD CONSTRAINT CONTENIDO_CATEGORIA_CONTENIDO_FK FOREIGN KEY 
    ( 
     CONTENIDO_id_contenido
    ) 
    REFERENCES CONTENIDO 
    ( 
     id_contenido
    ) 
;

ALTER TABLE CONTENIDO 
    ADD CONSTRAINT CONTENIDO_CLASIF_EDAD_FK FOREIGN KEY 
    ( 
     CLASIF_EDAD_id_clasif_edad
    ) 
    REFERENCES CLASIF_EDAD 
    ( 
     id_clasif_edad
    ) 
;

ALTER TABLE CONTENIDO 
    ADD CONSTRAINT CONTENIDO_PRODUCTORA_FK FOREIGN KEY 
    ( 
     PRODUCTORA_id_productora
    ) 
    REFERENCES PRODUCTORA 
    ( 
     id_productora
    ) 
;

ALTER TABLE CONTENIDO 
    ADD CONSTRAINT CONTENIDO_TIPO_CONTENIDO_FK FOREIGN KEY 
    ( 
     TIPO_CONTENIDO_id_tipo_contenido
    ) 
    REFERENCES TIPO_CONTENIDO 
    ( 
     id_tipo_contenido
    ) 
;

ALTER TABLE DISPOSITIVO 
    ADD CONSTRAINT DISPOSITIVO_USUARIO_FK FOREIGN KEY 
    ( 
     USUARIO_id_usuario
    ) 
    REFERENCES USUARIO 
    ( 
     id_usuario
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE HISTORIAL_REPRODUCCION 
    ADD CONSTRAINT HISTORIAL_REPRODUCCION_CAPITULO_FK FOREIGN KEY 
    ( 
     CAPITULO_id_capitulo,
     CAPITULO_PISTA_AUDIO_id_audio,
     CAPITULO_CONTENIDO_id_contenido
    ) 
    REFERENCES CAPITULO 
    ( 
     id_capitulo,
     PISTA_AUDIO_id_audio,
     CONTENIDO_id_contenido
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE HISTORIAL_REPRODUCCION 
    ADD CONSTRAINT HISTORIAL_REPRODUCCION_PERFIL_FK FOREIGN KEY 
    ( 
     PERFIL_id_perfil
    ) 
    REFERENCES PERFIL 
    ( 
     id_perfil
    ) 
;

ALTER TABLE MI_LISTA 
    ADD CONSTRAINT MI_LISTA_CONTENIDO_FK FOREIGN KEY 
    ( 
     CONTENIDO_id_contenido
    ) 
    REFERENCES CONTENIDO 
    ( 
     id_contenido
    ) 
;

ALTER TABLE MI_LISTA 
    ADD CONSTRAINT MI_LISTA_PERFIL_FK FOREIGN KEY 
    ( 
     PERFIL_id_perfil
    ) 
    REFERENCES PERFIL 
    ( 
     id_perfil
    ) 
;

ALTER TABLE PARTICIPACION 
    ADD CONSTRAINT PARTICIPACION_CONTENIDO_FK FOREIGN KEY 
    ( 
     CONTENIDO_id_contenido
    ) 
    REFERENCES CONTENIDO 
    ( 
     id_contenido
    ) 
;

ALTER TABLE PARTICIPACION 
    ADD CONSTRAINT PARTICIPACION_PERSONA_FK FOREIGN KEY 
    ( 
     PERSONA_id_persona
    ) 
    REFERENCES PERSONA 
    ( 
     id_persona
    ) 
;

ALTER TABLE PARTICIPACION 
    ADD CONSTRAINT PARTICIPACION_ROL_FK FOREIGN KEY 
    ( 
     ROL_id_rol
    ) 
    REFERENCES ROL 
    ( 
     id_rol
    ) 
;

ALTER TABLE PERFIL 
    ADD CONSTRAINT PERFIL_USUARIO_FK FOREIGN KEY 
    ( 
     USUARIO_id_usuario
    ) 
    REFERENCES USUARIO 
    ( 
     id_usuario
    ) 
;

ALTER TABLE PISTA_AUDIO 
    ADD CONSTRAINT PISTA_AUDIO_IDIOMA_FK FOREIGN KEY 
    ( 
     IDIOMA_id_idioma
    ) 
    REFERENCES IDIOMA 
    ( 
     id_idioma
    ) 
;

ALTER TABLE PISTA_SUBTITULOS 
    ADD CONSTRAINT PISTA_SUBTITULOS_IDIOMA_FK FOREIGN KEY 
    ( 
     IDIOMA_id_idioma
    ) 
    REFERENCES IDIOMA 
    ( 
     id_idioma
    ) 
;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PLAN_SUSCRIPCION_FK FOREIGN KEY 
    ( 
     PLAN_SUSCRIPCION_id_plan_suscripcion
    ) 
    REFERENCES PLAN_SUSCRIPCION 
    ( 
     id_plan_suscripcion
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            21
-- CREATE INDEX                             0
-- ALTER TABLE                             44
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   7
-- WARNINGS                                 0
