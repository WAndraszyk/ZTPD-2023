--1
create table MOVIES as select * from ztpd.movies;

--2
describe movies;

--3
select id, title from movies
where cover is null;

--4
select id, title, dbms_lob.getlength(cover) as filesize
from movies where cover is not null;

--5
select id, title, dbms_lob.getlength(cover) as filesize
from movies where cover is null;

--6
select directory_name, directory_path from all_directories;

--7
update movies 
set cover = EMPTY_BLOB(),
    mime_type = 'image/jpeg'
where id=66;

commit;

--8
select id, title, dbms_lob.getlength(cover) as filesize
from movies where id in (65,66);

--9
DECLARE
 blobd blob;
 cover_file BFILE := BFILENAME('TPD_DIR','escape.jpg');
BEGIN
 select cover into blobd
 from movies 
 where id=66
 for update;
 DBMS_LOB.FILEOPEN(cover_file, DBMS_LOB.file_readonly);
 DBMS_LOB.LOADFROMFILE(blobd,cover_file,DBMS_LOB.GETLENGTH(cover_file));
 DBMS_LOB.FILECLOSE(cover_file);
 commit;
END;

--10
create table TEMP_COVERS (
 movie_id NUMBER(12),
 image BFILE,
 mime_type VARCHAR2(50)
);

--11
INSERT INTO TEMP_COVERS
VALUES (65, BFILENAME('TPD_DIR','eagles.jpg'), 'image/jpeg');

COMMIT;

--12
select movie_id, dbms_lob.getlength(image) as filesize
from TEMP_COVERS; 

--13
DECLARE
 cover_file BFILE;
 mime VARCHAR2(50);
 blobd BLOB;
BEGIN
 select image, mime_type
 into cover_file, mime
 from temp_covers
 where movie_id = 65;
 
 dbms_lob.createtemporary(blobd, TRUE);
 
 DBMS_LOB.FILEOPEN(cover_file, DBMS_LOB.file_readonly);
 DBMS_LOB.LOADFROMFILE(blobd,cover_file,DBMS_LOB.GETLENGTH(cover_file));
 DBMS_LOB.FILECLOSE(cover_file);
 
 update movies 
 set cover = blobd,
    mime_type = mime
 where id=65;
 
 dbms_lob.freetemporary(blobd);
 
 commit;
END;

--14
select id, title, dbms_lob.getlength(cover) as filesize
from movies where id in (65,66);

--15
drop table movies;