---- 1
-- A
SELECT
    lpad('-', 2 *(level - 1), '|-')
    || t.owner
    || '.'
    || t.type_name
    || ' (FINAL:'
    || t.final
    || ', INSTANTIABLE:'
    || t.instantiable
    || ', ATTRIBUTES:'
    || t.attributes
    || ', METHODS:'
    || t.methods
    || ')'
FROM
    all_types t
START WITH
    t.type_name = 'ST_GEOMETRY'
CONNECT BY PRIOR t.type_name = t.supertype_name
           AND PRIOR t.owner = t.owner;
           
-- B
SELECT DISTINCT
    m.method_name
FROM
    all_type_methods m
WHERE
    m.type_name LIKE 'ST_POLYGON'
    AND m.owner = 'MDSYS'
ORDER BY
    1;

-- C
CREATE TABLE myst_major_cities (
    fips_cntry VARCHAR2(2),
    city_name  VARCHAR2(40),
    stgeom     st_point
);

-- D
INSERT INTO myst_major_cities
    SELECT
        fips_cntry,
        city_name,
        st_point(geom)
    FROM
        major_cities;

---- 2
--A
INSERT INTO myst_major_cities VALUES (
    'PL',
    'Szczyrek',
        NEW st_point ( 19.036107, 49.718655, 8307 )
);

---- 3
-- A
CREATE TABLE myst_country_boundaries (
    fips_cntry VARCHAR2(2),
    cntry_name VARCHAR2(40),
    stgeom     st_multipolygon
);

-- B
INSERT INTO myst_country_boundaries
    SELECT
        fips_cntry,
        cntry_name,
        st_multipolygon(geom)
    FROM
        country_boundaries;

-- C
SELECT
    b.stgeom.st_geometrytype() typ_obiektu,
    COUNT(*)                   ile
FROM
    myst_country_boundaries b
GROUP BY
    b.stgeom.st_geometrytype();
    
-- D
SELECT
    b.stgeom.st_issimple()
FROM
    myst_country_boundaries b;

---- 4
-- A
SELECT
    a.cntry_name,
    COUNT(*)
FROM
    myst_country_boundaries a,
    myst_major_cities       b
WHERE
    a.stgeom.st_contains(b.stgeom) = 1
GROUP BY
    a.cntry_name;

-- B
SELECT
    a.cntry_name a_name,
    b.cntry_name b_name
FROM
    myst_country_boundaries a,
    myst_country_boundaries b
WHERE
        a.stgeom.st_touches(b.stgeom) = 1
    AND b.cntry_name = 'Czech Republic';
    
-- C
SELECT DISTINCT
    b.cntry_name,
    r.name
FROM
    myst_country_boundaries b,
    rivers                  r
WHERE
        b.cntry_name = 'Czech Republic'
    AND st_linestring(r.geom).st_intersects(b.stgeom) = 1;

-- D
SELECT
    TREAT(b.stgeom.st_union(a.stgeom) AS st_polygon).st_area() powierzchnia
FROM
    myst_country_boundaries a,
    myst_country_boundaries b
WHERE
        a.cntry_name = 'Czech Republic'
    AND b.cntry_name = 'Slovakia';

-- E
SELECT
    b.stgeom.st_difference(st_geometry(w.geom))                   obiekt,
    b.stgeom.st_difference(st_geometry(w.geom)).st_geometrytype() wegry_bez
FROM
    myst_country_boundaries b,
    water_bodies            w
WHERE
        b.cntry_name = 'Hungary'
    AND w.name = 'Balaton';
    
---- 5
-- A
EXPLAIN PLAN
    FOR
SELECT
    b.cntry_name a_name,
    COUNT(*)
FROM
    myst_country_boundaries b,
    myst_major_cities       c
WHERE
        sdo_within_distance(c.stgeom, b.stgeom, 'distance=100 unit=km') = 'TRUE'
    AND b.cntry_name = 'Poland'
GROUP BY
    b.cntry_name;

SELECT
    *
FROM
    TABLE ( dbms_xplan.display );

-- B
INSERT INTO user_sdo_geom_metadata
    SELECT
        'MYST_MAJOR_CITIES',
        'STGEOM',
        t.diminfo,
        t.srid
    FROM
        all_sdo_geom_metadata t
    WHERE
        t.table_name = 'MAJOR_CITIES';

-- C
CREATE INDEX myst_major_cities_idx ON
    myst_major_cities (
        stgeom
    )
        INDEXTYPE IS mdsys.spatial_index;

-- D
SELECT
    b.cntry_name a_name,
    COUNT(*)
FROM
    myst_country_boundaries b,
    myst_major_cities       c
WHERE
        sdo_within_distance(c.stgeom, b.stgeom, 'distance=100 unit=km') = 'TRUE'
    AND b.cntry_name = 'Poland'
GROUP BY
    b.cntry_name;