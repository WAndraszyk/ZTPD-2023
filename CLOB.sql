--1
create table DOKUMENTY (
 id NUMBER(12) primary key,
 dokument CLOB
);

--2
declare
 lobd clob := 'Oto tekst. ';
 l_counter NUMBER := 0;
 textd VARCHAR(15) := 'Oto tekst. ';
begin
 loop
  l_counter := l_counter + 1;
  IF l_counter > 999 THEN
    exit;
  end if;
  lobd := lobd || textd;
 end loop;
 insert into dokumenty values(1, lobd);
end;

--3
select * from dokumenty;

select upper(dokument) from dokumenty;

select length(dokument) from dokumenty;

select dbms_lob.getlength(dokument) as filesize from dokumenty;

select SUBSTR(dokument, 5, 1000) from dokumenty;

select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--4
insert into dokumenty values(2, EMPTY_CLOB());

--5
insert into dokumenty values(3, null);
commit;

--6 -> jak w 3
--7
DECLARE
 lobd clob;
 dokumentd BFILE := BFILENAME('TPD_DIR','dokument.txt');
 doffset integer := 1;
 soffset integer := 1;
 langctx integer := 0;
 warn integer := null;
BEGIN
 select dokument into lobd
 from dokumenty 
 where id=2
 for update;
 DBMS_LOB.FILEOPEN(dokumentd, DBMS_LOB.file_readonly);
 DBMS_LOB.LOADCLOBFROMFILE(lobd, dokumentd, DBMS_LOB.LOBMAXSIZE,
    doffset, soffset, 0, langctx, warn);
 DBMS_LOB.FILECLOSE(dokumentd);
 commit;
 DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

--8
update dokumenty
set dokument = to_clob(BFILENAME('TPD_DIR','dokument.txt'))
where id = 3;

--9
select * from dokumenty;

--10
select id, dbms_lob.getlength(dokument) as filesize from dokumenty;

--11
drop table dokumenty;

--12
create or replace procedure clob_censor(clobd in out clob, patternd VARCHAR2)
is
 l_counter NUMBER := 1;
 textd VARCHAR2(30000) := '.';
 amountd NUMBER := dbms_lob.getlength(patternd);
 positiond NUMBER;
begin
 DBMS_OUTPUT.PUT_LINE('Length: '||amountd);
 loop
  l_counter := l_counter + 1;
  IF l_counter > amountd THEN
    exit;
  end if;
  textd := textd || '.';
 end loop;
 DBMS_OUTPUT.PUT_LINE('Tekst: '||textd);
 loop
  positiond := dbms_lob.instr(clobd, patternd);
  DBMS_OUTPUT.PUT_LINE('Pozycja: '||positiond);
  IF positiond = 0 THEN
    exit;
  end if;
  dbms_lob.write(clobd, amountd, positiond, textd);
 end loop;
end;
 
 --13
create table BIOGRAPHIES as select * from ztpd.BIOGRAPHIES;

declare
 lobd clob;
begin
 select bio into lobd
 from BIOGRAPHIES 
 where id=1
 for update;
 
 clob_censor(lobd, 'Cimrman');
end;

select * from biographies;

--14
drop table biographies;
 
 
 



