------ 1
-- A
INSERT INTO USER_SDO_GEOM_METADATA
VALUES (
'FIGURY',
'ksztalt',
MDSYS.SDO_DIM_ARRAY(
 MDSYS.SDO_DIM_ELEMENT('X', 0, 9, 0.01),
 MDSYS.SDO_DIM_ELEMENT('Y', 0, 8, 0.01) ),
 null
);

-- B
select SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000,8192,10,2,0) from figury;

-- C
CREATE INDEX figury_spatial_idx
ON FIGURY(ksztalt)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

-- D
select ID
from FIGURY
where SDO_FILTER(KSZTALT,
SDO_GEOMETRY(2001, null, 
SDO_POINT_TYPE(3,3,null), 
null, null)
) = 'TRUE';

-- E
select ID
from FIGURY
where SDO_RELATE(KSZTALT,
 SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null),
 'mask=ANYINTERACT') = 'TRUE';

------ 2
-- A
select A.city_name miasto, SDO_NN_DISTANCE(1) ODL 
from MAJOR_CITIES A, MAJOR_CITIES B
where A.city_name <> 'Warsaw'
and B.city_name = 'Warsaw'
and SDO_NN(
    A.GEOM, 
    MDSYS.SDO_GEOMETRY(
        2001, 
        8307, 
        B.GEOM.SDO_POINT,
        B.GEOM.SDO_ELEM_INFO,
        B.GEOM.SDO_ORDINATES),
    'sdo_num_res=10 unit=km', 1) = 'TRUE';

-- B
select A.city_name miasto
from MAJOR_CITIES A, MAJOR_CITIES B
where A.city_name <> 'Warsaw'
and B.city_name = 'Warsaw'
and SDO_WITHIN_DISTANCE(
    A.GEOM, 
    MDSYS.SDO_GEOMETRY(
        2001, 
        8307, 
        B.GEOM.SDO_POINT,
        B.GEOM.SDO_ELEM_INFO,
        B.GEOM.SDO_ORDINATES),
    'distance=100 unit=km') = 'TRUE';
    
-- C
SELECT
    b.cntry_name kraj,
    c.city_name miasto
FROM
    country_boundaries b,
    major_cities       c
WHERE
    sdo_relate(c.geom, b.geom, 'mask=INSIDE') = 'TRUE'
AND
    b.cntry_name = 'Slovakia';
    
-- D
SELECT
    b.cntry_name panstwo,
    SDO_GEOM.SDO_DISTANCE(b.GEOM, pl.GEOM, 1, 'unit=km') ODL
FROM
    country_boundaries b,
    country_boundaries pl
WHERE
    NOT sdo_relate(b.geom, pl.geom, 'mask=TOUCH') = 'TRUE'
AND
    pl.cntry_name = 'Poland'
AND 
    b.cntry_name <> 'Poland';

------ 3
-- A
SELECT
    b.cntry_name panstwo,
    SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(b.GEOM, pl.GEOM, 1), 1, 'unit=km') DLUGOSC_GRANICY
FROM
    country_boundaries b,
    country_boundaries pl
WHERE
    sdo_relate(b.geom, pl.geom, 'mask=TOUCH') = 'TRUE'
AND
    pl.cntry_name = 'Poland';
    
-- B
SELECT
    cntry_name panstwo
FROM
    country_boundaries
WHERE
    sdo_geom.sdo_area(geom, 1, 'unit=SQ_KM') = (
        SELECT
            MAX(sdo_geom.sdo_area(geom, 1, 'unit=SQ_KM'))
        FROM
            country_boundaries
    );
    
-- C
SELECT
    sdo_geom.sdo_area(sdo_aggr_mbr(a.geom), 1, 'unit=SQ_KM') SQ_KM
FROM
    major_cities a
WHERE
    a.city_name = 'Lodz'
OR
    a.city_name = 'Warsaw';

-- D   
SELECT
    sdo_geom.sdo_union(a.geom, b.geom, 1).sdo_gtype gtype
FROM
    major_cities       a,
    country_boundaries b
WHERE
    a.city_name = 'Prague'
AND 
    b.cntry_name = 'Poland';

-- E
SELECT
    a.city_name miasto,
    c.cntry_name panstwo
FROM
    major_cities a,
    country_boundaries c
WHERE
    SDO_GEOM.SDO_DISTANCE(a.GEOM, SDO_GEOM.SDO_CENTROID(c.geom, 1), 1, 'unit=km') = (
        SELECT
            MIN(SDO_GEOM.SDO_DISTANCE(a.GEOM, SDO_GEOM.SDO_CENTROID(c.geom, 1), 1, 'unit=km'))
        FROM
            major_cities a,
            country_boundaries c
    );
    
-- F
SELECT 
    a.name rzeka,
    SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(a.GEOM, pl.GEOM, 1), 1, 'unit=km')) dlugosc
FROM
    rivers a,
    country_boundaries pl
WHERE
    sdo_relate(a.geom, pl.geom, 'mask=ANYINTERACT') = 'TRUE'
AND
    pl.cntry_name = 'Poland'
GROUP BY a.name;