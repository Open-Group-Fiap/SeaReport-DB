CREATE TABLE T_OP_SR_AUTH (
    ID_AUTH VARCHAR2(255) PRIMARY KEY ,
    EMAIL VARCHAR2(255) NOT NULL
);
 
-- O campo XP se refere a experiencia do usuario dentro da nossa plataforma gamificada
CREATE TABLE T_OP_SR_USER (
    ID_USER NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    USER_NAME VARCHAR2(80) NOT NULL,
    PHONE_NUMBER VARCHAR2(20) NOT NULL,
    XP NUMBER(9) NOT NULL,
    ID_AUTH VARCHAR2(255) NOT NULL,
    CONSTRAINT FK_AUTH FOREIGN KEY (ID_AUTH) REFERENCES T_OP_SR_AUTH(ID_AUTH),
    CONSTRAINT UK_USER_ID_AUTH UNIQUE(ID_AUTH)
);
 
-- O campo APPROVED eh referente se as autoridades comprovaram a denuncia
CREATE TABLE T_OP_SR_REPORT (
    ID_REPORT NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    DESC_REPORT VARCHAR2(255) NOT NULL,
    LAT DECIMAL(8, 6) NOT NULL,
    LON DECIMAL(9, 6) NOT NULL,
    DATE_REPORT DATE NOT NULL,
    APPROVED CHAR(1),
    ID_USER NUMBER NOT NULL,
    CONSTRAINT FK_USER FOREIGN KEY (ID_USER) REFERENCES T_OP_SR_USER(ID_USER)
);
 
-- S�o notas de comunidade que so os admins poder�o fazer
-- O atributo CONTENT vai ser um markdown
CREATE TABLE T_OP_SR_POST (
    ID_POST NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    CONTENT_POST VARCHAR2(4000) NOT NULL,
    DATE_POST DATE NOT NULL
);
 
CREATE TABLE T_OP_SR_LIKES (
    ID_USER NUMBER,
    ID_POST NUMBER,
    PRIMARY KEY (ID_USER, ID_POST),
    CONSTRAINT FK_USER_LIKES FOREIGN KEY (ID_USER) REFERENCES T_OP_SR_USER(ID_USER),
    CONSTRAINT FK_POST FOREIGN KEY (ID_POST) REFERENCES T_OP_SR_POST(ID_POST)
);
 
DROP TABLE T_OP_SR_LIKES;
DROP TABLE T_OP_SR_POST;
DROP TABLE T_OP_SR_REPORT;
DROP TABLE T_OP_SR_USER;
DROP TABLE T_OP_SR_AUTH;