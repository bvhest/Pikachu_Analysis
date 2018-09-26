PROMPT Creating View 'LOCALIZED_PRODUCTS'
CREATE OR REPLACE FORCE VIEW LOCALIZED_PRODUCTS
 (ID
 ,STATUS
 ,LOCALE
 ,LASTMODIFIED
 ,DATA
 ,COUNTRY
 ,DIVISION
 ,BRAND
 ,MASTERLASTMODIFIED)
 AS SELECT o.object_id id,
o.status status,
o.localisation locale,
o.lastmodified_ts lastmodified,
os.data data,
NULL country,
obj.division division,
obj.brand brand,
o.MASTERLASTMODIFIED_TS masterlastmodified
from octl o, octl_store os, object_master_data obj
  WHERE o.CONTENT_TYPE='PMT'
and o.OBJECT_ID = obj.OBJECT_ID
and o.CONTENT_TYPE = os.CONTENT_TYPE
and o.LOCALISATION = os.LOCALISATION
and o.OBJECT_ID = os.OBJECT_ID
and o.MASTERLASTMODIFIED_TS = os.MASTERLASTMODIFIED_TS
and o.LASTMODIFIED_TS = os.LASTMODIFIED_TS
/

PROMPT Creating View 'SUBCAT_PRODUCTS'
CREATE OR REPLACE FORCE VIEW SUBCAT_PRODUCTS
 (ID
 ,SUBCATEGORYCODE
 ,SOURCE
 ,ISAUTOGEN
 ,LASTMODIFIED)
 AS SELECT OBT.OBJECT_ID ID
          ,OBT.SUBCATEGORY SUBCATEGORYCODE
          ,OBT.SOURCE SOURCE
          ,OBT.ISAUTOGEN ISAUTOGEN
          ,O.LASTMODIFIED_TS LASTMODIFIED
FROM OBJECT_CATEGORIZATION OBT
    ,OCTL O
  WHERE O.CONTENT_TYPE = 'ObjectCategorization'
AND O.LOCALISATION = 'none'
AND O.OBJECT_ID = OBT.OBJECT_ID
/

PROMPT Creating View 'CUSTOMER_CATALOG'
CREATE OR REPLACE FORCE VIEW CUSTOMER_CATALOG
 (CUSTOMER_ID
 ,COUNTRY
 ,CTN
 ,DIVISION
 ,SOP
 ,EOP
 ,SOS
 ,EOS
 ,BUY_ONLINE
 ,LIST_PRICE
 ,LOCAL_GOING_PRICE
 ,ONLINE_PRICE
 ,DELETED
 ,DELETE_AFTER_DATE
 ,PRIORITY
 ,LASTMODIFIED)
 AS SELECT COT.CUSTOMER_ID CUSTOMER_ID
          ,COT.COUNTRY COUNTRY
          ,COT.OBJECT_ID CTN
          ,COT.DIVISION DIVISION
          ,COT.SOP SOP
          ,COT.EOP EOP
          ,COT.SOS SOS
          ,COT.EOS EOS
          ,COT.BUY_ONLINE BUY_ONLINE
          ,COT.LIST_PRICE LIST_PRICE
          ,COT.LOCAL_GOING_PRICE LOCAL_GOING_PRICE
          ,COT.ONLINE_PRICE ONLINE_PRICE
          ,COT.DELETED DELETED
          ,COT.DELETE_AFTER_DATE DELETE_AFTER_DATE
          ,COT.PRIORITY PRIORITY
          ,COT.LASTMODIFIED LASTMODIFIED
FROM CATALOG_OBJECTS COT
  WHERE CUSTOMER_ID IS NOT NULL
/

PROMPT Creating View 'SUBCAT'
CREATE OR REPLACE FORCE VIEW SUBCAT
 (CATALOGCODE
 ,CATALOGNAME
 ,GROUPCODE
 ,GROUPNAME
 ,CATEGORYCODE
 ,CATEGORYNAME
 ,SUBCATEGORYCODE
 ,SUBCATEGORYNAME
 ,SOURCE
 ,GROUPRANK
 ,CATEGORYRANK
 ,SUBCATEGORYRANK
 ,RELATEDSUBCAT
 ,LASTMODIFIED)
 AS SELECT CATALOGCODE,
CATALOGNAME,
 GROUPCODE,
 GROUPNAME,
 CATEGORYCODE,
 CATEGORYNAME,
 SUBCATEGORYCODE,
 SUBCATEGORYNAME,
  'UCDM Categorization' ,
  GROUPRANK,
  CATEGORYRANK,
   SUBCATEGORYRANK,
    RELATEDSUBCAT
   ,O.LASTMODIFIED_TS LASTMODIFIED
FROM CATEGORIZATION OBT, OCTL O
  WHERE O.CONTENT_TYPE = 'Categorization_Raw'
AND O.LOCALISATION = 'none'
AND O.OBJECT_ID = obt.CATALOGCODE
AND obt.SUBCATEGORY_STATUS != 'Draft'
/

PROMPT Creating View 'LOCAL_CATALOG'
CREATE OR REPLACE FORCE VIEW LOCAL_CATALOG
 (CTN
 ,COUNTRY
 ,CATALOG_TYPE
 ,DIVISION
 ,SOP
 ,EOP
 ,SOS
 ,EOS
 ,DELETED)
 AS SELECT CC.ctn
           , CC.country
           , 'LCB_CATALOG' as CATALOG_TYPE
           , min(X.division) as DIVISION
           , min(CC.SOP) as SOP
           , max(CC.EOP) as EOP
           , min(CC.SOS) as SOS
           , max(CC.EOS) as EOS
           , min(CC.DELETED) as DELETED
    from 
        (select object_id ctn, country, SOP, EOP, EOS, SOS, DELETED from catalog_objects) CC
    inner join (select    object_id CTN
                        , COUNTRY
                        , case 
                            when division = 'N/A' 
                                then
                                    case 
                                        when    (select distinct division from catalog_objects inner
  WHERE inner.object_id = outer.object_id and inner.country = outer.country and division != 'N/A') is null 
                                            then 'CE'    
                                        else  
                                                (select distinct division from catalog_objects inner 
                                                 where inner.object_id = outer.object_id and inner.country = outer.country and division != 'N/A')      
                                    end
                            else division  
                         end as division
                from catalog_objects outer
                ) X
        on  CC.ctn = X.ctn
        and CC.country = X.country
    group by CC.ctn, CC.country, X.division
/

PROMPT Creating View 'STORE_V'
CREATE OR REPLACE FORCE VIEW STORE_V
 (CONTENT_TYPE
 ,LOCALISATION
 ,OBJECT_ID
 ,NEEDSPROCESSING_FLAG
 ,DERIVESECONDARY_FLAG
 ,NEEDSPROCESSING_TS
 ,INTRANSACTION_FLAG
 ,MASTERLASTMODIFIED_TS
 ,LASTMODIFIED_TS
 ,STARTOFPROCESSING
 ,ENDOFPROCESSING
 ,ACTIVE_FLAG
 ,STATUS
 ,REMARK
 ,ISLOCALIZED
 ,DATA)
 AS SELECT content_type, localisation, object_id, needsprocessing_flag,DERIVESECONDARY_FLAG,
          needsprocessing_ts, intransaction_flag, masterlastmodified_ts,
          lastmodified_ts, startofprocessing, endofprocessing, active_flag,
          status, remark, islocalized, TO_CLOB ('X') DATA from octl
/

PROMPT Creating View 'RAW_MASTER_PRODUCTS'
CREATE OR REPLACE FORCE VIEW RAW_MASTER_PRODUCTS
 (CTN
 ,DATA_TYPE
 ,STATUS
 ,LASTMODIFIED
 ,DATA
 ,DIVISION
 ,BRAND)
 AS SELECT O.OBJECT_ID CTN
          ,O.CONTENT_TYPE DATA_TYPE
          ,O.STATUS STATUS
          ,O.LASTMODIFIED_TS LASTMODIFIED
          ,OS.DATA DATA
          ,OBJ.DIVISION DIVISION
          ,OBJ.BRAND BRAND
FROM OCTL O
    ,OCTL_STORE OS
    ,OBJECT_MASTER_DATA OBJ
  WHERE o.content_type = 'WebSiteNavigation'
      AND o.localisation = 'master_global'
      AND o.object_id = obj.object_id
      AND o.content_type = os.content_type
      AND o.localisation = os.localisation
      AND o.object_id = os.object_id
      AND o.masterlastmodified_ts = os.masterlastmodified_ts
      AND o.lastmodified_ts = os.lastmodified_ts
/

PROMPT Creating View 'MASTER_PRODUCTS'
CREATE OR REPLACE FORCE VIEW MASTER_PRODUCTS
 (ID
 ,STATUS
 ,LASTMODIFIED
 ,DATA
 ,DIVISION
 ,BRAND)
 AS SELECT O.OBJECT_ID ID
          ,O.STATUS STATUS
          ,O.LASTMODIFIED_TS LASTMODIFIED
          ,OS.DATA DATA
          ,OBJ.DIVISION DIVISION
          ,OBJ.BRAND BRAND
FROM OCTL O
    ,OCTL_STORE OS
    ,OBJECT_MASTER_DATA OBJ
  WHERE o.CONTENT_TYPE='PMT_Enriched'
and o.LOCALISATION='master_global'
and o.OBJECT_ID = obj.OBJECT_ID
and o.CONTENT_TYPE = os.CONTENT_TYPE
and o.LOCALISATION = os.LOCALISATION
and o.OBJECT_ID = os.OBJECT_ID
and o.MASTERLASTMODIFIED_TS = os.MASTERLASTMODIFIED_TS
and o.LASTMODIFIED_TS = os.LASTMODIFIED_TS
/

