set serveroutput on;

DECLARE
    CURSOR prod_cursor is
        select DESC_REPORT,  APPROVED from T_OP_SR_REPORT where APPROVED = 'T';
    rowp prod_cursor%rowtype;
    rows_found number := 0;
BEGIN
    OPEN prod_cursor();
    dbms_output.put_line('Aprovados:');
    LOOP
        FETCH prod_cursor into rowp;
        exit when prod_cursor%notfound;
        rows_found := rows_found + 1;
        dbms_output.put_line(rows_found || ' - Descrição: ' || rowp.DESC_REPORT);
        
    END LOOP;
    if rows_found = 0 then
        dbms_output.put_line('Nenhum aprovado');
    end if;
    CLOSE PROD_CURSOR;
END;

DECLARE
    CURSOR prod_cursor is
        select USER_NAME, XP from T_OP_SR_USER WHERE XP > 0 ORDER BY XP DESC;
    rowp prod_cursor%rowtype;
    rows_found number := 0;
BEGIN
    OPEN prod_cursor();
    dbms_output.put_line('RANK DOS MAIORES NÍVEIS:');
    LOOP
        FETCH prod_cursor into rowp;
        exit when prod_cursor%notfound;
        rows_found := rows_found + 1;
        dbms_output.put_line(rows_found || ' - NOME: ' || rowp.USER_NAME || ' - XP: ' || rowp.XP);
        
    END LOOP;
    if rows_found = 0 then
        dbms_output.put_line('Nenhum usuario com xp maior que 0');
    end if;
    CLOSE PROD_CURSOR;
END;

DECLARE
    CURSOR prod_cursor is
        select DISTINCT count(likes.id_post) qtdLikes, post.content_post from T_OP_SR_POST post inner join T_OP_SR_LIKES likes on post.id_post = likes.id_post order by count(likes.id_post) desc;
    rowp prod_cursor%rowtype;
    rows_found number := 0;
BEGIN
    OPEN prod_cursor();
    dbms_output.put_line('RANK DOS MAIORES NÍVEIS:');
    LOOP
        FETCH prod_cursor into rowp;
        exit when prod_cursor%notfound;
        rows_found := rows_found + 1;
        dbms_output.put_line(rows_found || ' - CONTEUDO: ' || rowp.content_post || ' - XP: ' || rowp.qtdLikes);
        
    END LOOP;
    if rows_found = 0 then
        dbms_output.put_line('Nenhum usuario com xp maior que 0');
    end if;
    CLOSE PROD_CURSOR;
END;

select DISTINCT count(likes.id_post) qtdLikes, post.content_post from T_OP_SR_POST post inner join T_OP_SR_LIKES likes on post.id_post = likes.id_post order by count(likes.id_post) desc;
