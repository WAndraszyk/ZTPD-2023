--Æwiczenie 1
-- A
create table figury(
    id NUMBER(1) primary key,
    ksztalt MDSYS.SDO_geometry
);

-- B
insert into figury values(
    1,
    MDSYS.SDO_GEOMETRY(2003, NULL, NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,4),
    MDSYS.SDO_ORDINATE_ARRAY(5,7, 7,5, 3,5)
    )
);

insert into figury values(
    2,
    MDSYS.SDO_GEOMETRY(2003, NULL, NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
    MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);

insert into figury values(
    3,
    MDSYS.SDO_GEOMETRY(2002, NULL, NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1, 5,2,2),
    MDSYS.SDO_ORDINATE_ARRAY(3,2, 6,2, 7,3, 8,2, 7,1)
    )
);

-- C
insert into figury values(
    4,
    MDSYS.SDO_GEOMETRY(2003, NULL, NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1, 5,2,2),
    MDSYS.SDO_ORDINATE_ARRAY(3,2, 6,2, 7,3, 8,2, 7,1)
    )
);

-- D
select SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01) VALID,id 
from figury;

-- E
delete from figury where id = 4;

-- F
commit;