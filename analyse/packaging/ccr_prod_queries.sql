-- find objects that are related to packaging information:
SELECT * 
FROM dba_objects 
WHERE owner NOT IN ('SYS', 'SYSTEM')
  AND object_type = 'TABLE' 
  AND (upper(object_name) LIKE '%LOGIS%'
    OR upper(object_name) LIKE '%PACK%')
;

/*
Results:
ORAP.M_PACKAGING
ORAP.M_PACKAGING_TYPE
ORAP.M_LOGISTIC_PASSPORT
*/

SELECT * FROM ORAP.M_PACKAGING WHERE ROWNUM <= 5;
SELECT * FROM ORAP.M_PACKAGING_TYPE;
SELECT * FROM ORAP.M_LOGISTIC_PASSPORT WHERE ROWNUM <= 5;

-- information combined:
SELECT lp.pm_name, lp.lp_commercial_code, lp.country_cd, lp.lp_gtin
     , p.PKG_GTIN
     , pt.pkgt_cd, pt.pkgt_name
     , p.PKG_NR_OF_ITEMS 
FROM ORAP.M_LOGISTIC_PASSPORT lp
INNER JOIN ORAP.M_PACKAGING p
   ON p.lp_id = lp.lp_id
INNER JOIN ORAP.M_PACKAGING_TYPE pt
   ON pt.pkgt_cd = p.pkgt_cd
WHERE lp.pm_name = 'SC2006/11'
  AND lp.country_cd = 'NL'
;


-- check how many rows are queried:
SELECT count(lp.pm_name) as count 
FROM ORAP.M_LOGISTIC_PASSPORT lp
INNER JOIN ORAP.M_PACKAGING p
   ON p.lp_id = lp.lp_id
INNER JOIN ORAP.M_PACKAGING_TYPE pt
   ON pt.pkgt_cd = p.pkgt_cd
;
# 255041