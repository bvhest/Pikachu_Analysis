<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >

  <xsl:param name="ctn" />
  <xsl:param name="locale" />

  <xsl:template match="/">
     <sql:execute-query name="getPMTMasterAndTranslatedData">
       <sql:query>
         SELECT * FROM ( 
               SELECT NVL(O.DATA,'NULL') pmtmaster
                    , NVL(P.DATA,'NULL') pmttrltd 
                 FROM OCTL P
                 LEFT OUTER JOIN OCTL_STORE O
                   ON O.OBJECT_ID = P.OBJECT_ID 
                   AND P.MARKETINGVERSION = O.MARKETINGVERSION
                WHERE O.CONTENT_TYPE = 'PMT_Master'
                  AND O.LOCALISATION = 'master_global'
                  AND O.OBJECT_ID    = '<xsl:value-of select="$ctn"/>'
                  AND P.CONTENT_TYPE = 'PMT_Translated'
                  AND P.LOCALISATION = '<xsl:value-of select="$locale"/>'  
                  ORDER BY O.LASTMODIFIED_TS desc
             ) WHERE ROWNUM = 1
       </sql:query>
     </sql:execute-query>
                 
     <sql:execute-query name="getPMTMasterAndTranslatedData_warning">
       <sql:query>       
         SELECT * FROM ( 
               SELECT NVL(O.DATA,'NULL') pmtmaster_warning
                    , NVL(P.DATA,'NULL') pmttrltd_warning 
                 FROM OCTL P
                 LEFT OUTER JOIN OCTL_STORE O
                   ON O.OBJECT_ID = P.OBJECT_ID 
                   AND SUBSTR(P.MARKETINGVERSION, 0, INSTR(P.MARKETINGVERSION, '.', 1) -1) = 
                       SUBSTR(O.MARKETINGVERSION, 0, INSTR(O.MARKETINGVERSION, '.', 1) -1)
                WHERE O.CONTENT_TYPE = 'PMT_Master'
                  AND O.LOCALISATION = 'master_global'
                  AND O.OBJECT_ID    = '<xsl:value-of select="$ctn"/>'
                  AND P.CONTENT_TYPE = 'PMT_Translated'
                  AND P.LOCALISATION = '<xsl:value-of select="$locale"/>'  
                  ORDER BY O.LASTMODIFIED_TS desc
             ) WHERE ROWNUM = 1   
       </sql:query>       
     </sql:execute-query>
     
     <sql:execute-query name="getPMTMasterAndTranslatedData_error">
       <sql:query> 
         SELECT * FROM (              
            SELECT NVL(O.DATA,'NULL') pmtmaster_error
                 , NVL(P.DATA,'NULL') pmttrltd_error 
              FROM OCTL O
              LEFT OUTER JOIN OCTL P
                ON O.OBJECT_ID = P.OBJECT_ID
             WHERE O.CONTENT_TYPE = 'PMT_Master'
               AND O.LOCALISATION = 'master_global'
               AND O.OBJECT_ID    = '<xsl:value-of select="$ctn"/>'
               AND P.CONTENT_TYPE = 'PMT_Translated'
               AND P.LOCALISATION = '<xsl:value-of select="$locale"/>' 
               ORDER BY O.LASTMODIFIED_TS desc
             ) WHERE ROWNUM = 1  
       </sql:query>       
     </sql:execute-query>
     
  </xsl:template>
</xsl:stylesheet>