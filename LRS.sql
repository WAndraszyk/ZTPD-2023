---- 1
-- A
CREATE TABLE a6_lrs (
    geom SDO_GEOMETRY
);

-- B
INSERT INTO a6_lrs
    SELECT
        sr.geom
    FROM
        streets_and_railroads sr,
        major_cities          c
    WHERE
            sdo_relate(sr.geom,
                       sdo_geom.sdo_buffer(c.geom, 10, 1, 'unit=km'),
                       'MASK=ANYINTERACT') = 'TRUE'
        AND c.city_name = 'Koszalin';
        
-- C
SELECT
    sdo_geom.sdo_length(sr.geom, 1, 'unit=km') distance,
    st_linestring(sr.geom).st_numpoints()      st_numpoints
FROM
    a6_lrs sr;
    
-- D
UPDATE a6_lrs
SET
    geom = sdo_lrs.convert_to_lrs_geom(geom, 0, 276.681);
    
-- E
INSERT INTO user_sdo_geom_metadata VALUES (
    'A6_LRS',
    'GEOM',
    mdsys.sdo_dim_array(mdsys.sdo_dim_element('X', 12.603676, 26.369824, 1),
                        mdsys.sdo_dim_element('Y', 45.8464, 58.0213, 1),
                        mdsys.sdo_dim_element('M', 0, 300, 1)),
    8307
);
 
-- F
CREATE INDEX a6_lrs_idx ON
    a6_lrs (
        geom
    )
        INDEXTYPE IS mdsys.spatial_index;
    
---- 2
-- A
SELECT
    sdo_lrs.valid_measure(geom, 500) valid_500
FROM
    a6_lrs;
    
-- B
SELECT
    sdo_lrs.geom_segment_end_pt(geom) end_pt
FROM
    a6_lrs;
    
-- C
SELECT
    sdo_lrs.locate_pt(geom, 150, 0) km150
FROM
    a6_lrs;

-- D
SELECT
    sdo_lrs.clip_geom_segment(geom, 120, 160) clipped
FROM
    a6_lrs;
    
-- E
SELECT
    sdo_lrs.get_next_shape_pt(a6.geom, c.geom) wjazd_na_a6
FROM
    a6_lrs       a6,
    major_cities c
WHERE
    c.city_name = 'Slupsk';

-- F
SELECT
SDO_LRS.GEOM_SEGMENT_LENGTH(
    sdo_lrs.offset_geom_segment(a6.geom, m.diminfo, 50, 200, 50,
                                'unit=m arc_tolerance=1'))/1000 koszt
FROM
    a6_lrs                 a6,
    user_sdo_geom_metadata m
WHERE
        m.table_name = 'A6_LRS'
    AND m.column_name = 'GEOM';