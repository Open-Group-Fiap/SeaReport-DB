-- insert error log
CREATE OR REPLACE PROCEDURE create_error_log (
    p_procedure_name t_op_sr_error_log.procedure_name%TYPE,
    p_error_code     t_op_sr_error_log.error_code%TYPE,
    p_error_message  t_op_sr_error_log.error_message%TYPE
) IS
BEGIN
    INSERT INTO t_op_sr_error_log (
        procedure_name,
        user_name,
        error_date,
        error_code,
        error_message
    ) VALUES (
        p_procedure_name,
        user,
        sysdate,
        p_error_code,
        p_error_message
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        raise_application_error(-20001, 'Erro ao cadastrar log: ' || sqlerrm);
END create_error_log;

-- insert user
CREATE OR REPLACE PROCEDURE create_user (
    p_user_name    t_op_sr_user.user_name%TYPE,
    p_phone_number t_op_sr_user.phone_number%TYPE,
    p_xp           t_op_sr_user.xp%TYPE,
    p_id_auth      t_op_sr_user.id_auth%TYPE
) IS
    parent_key_not_found EXCEPTION;
    PRAGMA exception_init ( parent_key_not_found, -02291 );
BEGIN
    INSERT INTO t_op_sr_user (
        user_name,
        phone_number,
        xp,
        id_auth
    ) VALUES (
        p_user_name,
        p_phone_number,
        p_xp,
        p_id_auth
    );

    COMMIT;
EXCEPTION
    WHEN value_error THEN
        ROLLBACK;
        create_error_log('create_user', sqlcode, sqlerrm);
        raise_application_error(-20001, 'Erro ao criar user: Tipo de atributo inv?lido');
    WHEN parent_key_not_found THEN
        ROLLBACK;
        create_error_log('create_user', sqlcode, sqlerrm);
        raise_application_error(-20002, 'Erro ao criar user: Chave estrangeira n?o existe');
    WHEN OTHERS THEN
        ROLLBACK;
        create_error_log('create_user', sqlcode, sqlerrm);
        raise_application_error(-20003, 'Erro ao criar user: ' || sqlerrm);
END create_user;

-- validate email
CREATE OR REPLACE FUNCTION is_valid_email (
    email IN VARCHAR2
) RETURN BOOLEAN IS
    regex_email VARCHAR2(255) := '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    resposta    BOOLEAN := regexp_like(email, regex_email);
BEGIN
    RETURN resposta;
END is_valid_email;

-- insert auth
CREATE OR REPLACE PROCEDURE create_auth (
    p_id_auth t_op_sr_user.user_name%TYPE,
    p_email   t_op_sr_user.phone_number%TYPE
) IS
    email_invalid EXCEPTION;
    PRAGMA exception_init ( email_invalid, -20010 );
BEGIN
    IF NOT is_valid_email(p_email) THEN
        raise_application_error(-20010, 'Erro na valida??o do email: formato inv?lido');
    END IF;
    INSERT INTO t_op_sr_auth (
        id_auth,
        email
    ) VALUES (
        p_id_auth,
        p_email
    );

    COMMIT;
EXCEPTION
    WHEN value_error THEN
        ROLLBACK;
        create_error_log('create_auth', sqlcode, sqlerrm);
        raise_application_error(-20001, 'Erro ao criar auth: Tipo de atributo inv?lido');
    WHEN email_invalid THEN
        ROLLBACK;
        create_error_log('create_auth', sqlcode, sqlerrm);
        raise_application_error(-20002, 'Erro ao criar auth: Email inv?lido');
    WHEN OTHERS THEN
        ROLLBACK;
        create_error_log('create_auth', sqlcode, sqlerrm);
        raise_application_error(-20003, 'Erro ao criar auth: ' || sqlerrm);
END create_auth;

--insert likes
CREATE OR REPLACE PROCEDURE create_likes (
    p_id_post t_op_sr_likes.id_post%TYPE,
    p_id_user t_op_sr_likes.id_user%TYPE
) IS
    parent_key_not_found EXCEPTION;
    PRAGMA exception_init ( parent_key_not_found, -02291 );
BEGIN
    INSERT INTO t_op_sr_likes (
        id_post,
        id_user
    ) VALUES (
        p_id_user,
        p_id_post
    );

    COMMIT;
EXCEPTION
    WHEN value_error THEN
        ROLLBACK;
        create_error_log('create_likes', sqlcode, sqlerrm);
        raise_application_error(-20001, 'Erro ao criar likes: Tipo de atributo inv?lido');
    WHEN parent_key_not_found THEN
        ROLLBACK;
        create_error_log('create_likes', sqlcode, sqlerrm);
        raise_application_error(-20002, 'Erro ao criar likes: Chave estrangeira n?o existe');
    WHEN OTHERS THEN
        ROLLBACK;
        create_error_log('create_likes', sqlcode, sqlerrm);
        raise_application_error(-20003, 'Erro ao criar likes: ' || sqlerrm);
END create_likes;

--insert report
CREATE OR REPLACE PROCEDURE create_report (
    p_desc_report t_op_sr_report.desc_report%TYPE,
    p_lat         t_op_sr_report.lat%TYPE,
    p_lon         t_op_sr_report.lon%TYPE,
    p_date_report t_op_sr_report.date_report%TYPE,
    p_approved    t_op_sr_report.approved%TYPE,
    p_id_user     t_op_sr_report.id_user%TYPE
) IS
    parent_key_not_found EXCEPTION;
    PRAGMA exception_init ( parent_key_not_found, -02291 );
BEGIN
    INSERT INTO t_op_sr_report (
        desc_report,
        lat,
        lon,
        date_report,
        approved,
        id_user
    ) VALUES (
        p_desc_report,
        p_lat,
        p_lon,
        p_date_report,
        p_approved,
        p_id_user
    );

    COMMIT;
EXCEPTION
    WHEN value_error THEN
        ROLLBACK;
        create_error_log('create_report', sqlcode, sqlerrm);
        raise_application_error(-20001, 'Erro ao criar relat?rio: Tipo de atributo inv?lido');
    WHEN parent_key_not_found THEN
        ROLLBACK;
        create_error_log('create_report', sqlcode, sqlerrm);
        raise_application_error(-20002, 'Erro ao criar relat?rio: Chave estrangeira n?o existe');
    WHEN OTHERS THEN
        ROLLBACK;
        create_error_log('create_report', sqlcode, sqlerrm);
        raise_application_error(-20003, 'Erro ao criar relat?rio: ' || sqlerrm);
END create_report;

--insert post
CREATE OR REPLACE PROCEDURE create_post (
    p_content_post t_op_sr_post.content_post%TYPE,
    p_date_post    t_op_sr_post.date_post%TYPE
) IS
    null_exception EXCEPTION;
    PRAGMA exception_init ( null_exception, -01400 );
BEGIN
    INSERT INTO t_op_sr_post (
        content_post,
        date_post
    ) VALUES (
        p_content_post,
        p_date_post
    );

    COMMIT;
EXCEPTION
    WHEN value_error THEN
        ROLLBACK;
        create_error_log('create_post', sqlcode, sqlerrm);
        raise_application_error(-20001, 'Erro ao criar postagem: Tipo de atributo inv?lido');
    WHEN null_exception THEN
        ROLLBACK;
        create_error_log('create_post', sqlcode, sqlerrm);
        raise_application_error(-20002, 'Erro ao criar postagem: N?o pode ser nulo');
    WHEN OTHERS THEN
        ROLLBACK;
        create_error_log('create_post', sqlcode, sqlerrm);
        raise_application_error(-20003, 'Erro ao criar postagem: ' || sqlerrm);
END create_post;

EXEC CREATE_AUTH('dgaiwd717949412418', 'Leo@email.com');
EXEC CREATE_USER('Leonardo Guerra', '11 9831983', 10, 'dgaiwd71794918');
EXEC CREATE_REPORT('Descri??o', 90.918731, 101.123456, SYSDATE, 'F', 7);
EXEC CREATE_POST('', SYSDATE);
EXEC CREATE_LIKES(7,1);

SELECT
    *
FROM
    t_op_sr_error_log;