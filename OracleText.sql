-- 1
CREATE TABLE cytaty
    AS
        SELECT
            *
        FROM
            ztpd.cytaty;

-- 2
SELECT
    autor,
    tekst
FROM
    cytaty
WHERE
    upper(tekst) LIKE '%OPTYMISTA%'
    AND upper(tekst) LIKE '%PESYMISTA%';
    
-- 3
CREATE INDEX cytaty_idx ON
    cytaty (
        tekst
    )
        INDEXTYPE IS ctxsys.context;

-- 4
SELECT
    c.autor,
    c.tekst
FROM
    cytaty c
WHERE
    contains(c.tekst, 'OPTYMISTA and PESYMISTA') > 0;
    
-- 5
SELECT
    c.autor,
    c.tekst
FROM
    cytaty c
WHERE
        contains(c.tekst, 'OPTYMISTA') = 0
    AND contains(c.tekst, 'PESYMISTA') > 0;
    
-- 6
SELECT
    c.autor,
    c.tekst
FROM
    cytaty c
WHERE
    contains(c.tekst, 'near((PESYMISTA, OPTYMISTA), 3)') > 0;

-- 7 
SELECT
    c.autor,
    c.tekst
FROM
    cytaty c
WHERE
    contains(c.tekst, 'near((PESYMISTA, OPTYMISTA), 10)') > 0;
    
-- 8
SELECT
    c.autor,
    c.tekst
FROM
    cytaty c
WHERE
    contains(c.tekst, '¿yci%') > 0;

-- 9
SELECT
    c.autor,
    c.tekst,
    score(1)
FROM
    cytaty c
WHERE
    contains(c.tekst, '¿yci%', 1) > 0;
    
-- 10
SELECT
    c.autor,
    c.tekst,
    score(1)
FROM
    cytaty c
WHERE
    contains(c.tekst, '¿yci%', 1) > 0
ORDER BY
    score(1) DESC
FETCH FIRST 1 ROWS ONLY;

-- 11
SELECT
    c.autor,
    c.tekst
FROM
    cytaty c
WHERE
    contains(c.tekst, '!probelm') > 0;
    
-- 12
INSERT INTO cytaty (
    id,
    autor,
    tekst
) VALUES (
    39,
    'Bertrand Russell',
    'To smutne, ¿e g³upcy s¹ tacy pewni siebie, a ludzie rozs¹dni tacy pe³ni w¹tpliwoœci.'
);

-- 13
SELECT
    c.autor,
    c.tekst
FROM
    cytaty c
WHERE
    contains(c.tekst, 'g³upcy') > 0;
    
-- 16
DROP INDEX cytaty_idx;

CREATE INDEX cytaty_idx ON
    cytaty (
        tekst
    )
        INDEXTYPE IS ctxsys.context;

SELECT
    c.autor,
    c.tekst
FROM
    cytaty c
WHERE
    contains(c.tekst, 'g³upcy') > 0;
    
-- 17
DROP INDEX cytaty_idx;

DROP TABLE cytaty;

--------------------
-- 1
CREATE TABLE quotes
    AS
        SELECT
            *
        FROM
            ztpd.quotes;
            
-- 2
CREATE INDEX quotes_idx ON
    quotes (
        text
    )
        INDEXTYPE IS ctxsys.context;
    
-- 3
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'work') > 0;

SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, '$work') > 0;

SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'working') > 0;

SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, '$working') > 0;
    
-- 4
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'it') > 0;
    
-- 5
SELECT
    *
FROM
    ctx_stoplists;
    
-- 6
SELECT
    *
FROM
    ctx_stopwords;

-- 7
DROP INDEX quotes_idx;

CREATE INDEX quotes_idx ON
    quotes (
        text
    )
        INDEXTYPE IS ctxsys.context PARAMETERS ( 'stoplist CTXSYS.EMPTY_STOPLIST' );

-- 8
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'it') > 0;

-- 9
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'fool and humans') > 0;
    
-- 10
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'fool and computer') > 0;

-- 11
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, '(fool and humans) within sentence') > 0;
    
-- 12
DROP INDEX quotes_idx;

-- 13
BEGIN
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
END; 

-- 14
CREATE INDEX quotes_idx ON
    quotes (
        text
    )
        INDEXTYPE IS ctxsys.context PARAMETERS ( 'section group nullgroup' );
        
-- 15
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, '(fool and humans) within sentence', 1) > 0;

SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, '(fool and computer) within sentence') > 0;
   
-- 16
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'humans') > 0; 
   
-- 17
DROP INDEX quotes_idx;

BEGIN
    ctx_ddl.create_preference('lex_z_m', 'BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m', 'printjoins', '_-');
    ctx_ddl.set_attribute('lex_z_m', 'index_text', 'YES');
END;

CREATE INDEX quotes_idx ON
    quotes (
        text
    )
        INDEXTYPE IS ctxsys.context PARAMETERS ( 'lexer lex_z_m' );

-- 18
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'humans') > 0; 

-- 19
SELECT
    author,
    text
FROM
    quotes
WHERE
    contains(text, 'non\-humans') > 0; 

-- 20
drop index quotes_idx;
begin
ctx_ddl.drop_preference('lex_z_m');
end;
drop table quotes;

















