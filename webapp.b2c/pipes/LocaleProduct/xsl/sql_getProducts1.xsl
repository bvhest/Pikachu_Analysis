<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--xsl:param name="locale"/>
	<xsl:param name="ctnList"/ -->

	<xsl:template match="/ProductRequestMessage">
	<xsl:variable name="locale" select="locale"/>
	<xsl:variable name="ctnList" select="ctnList"/>
	<xsl:variable name="sep" >' ctn FROM dual union SELECT '</xsl:variable>
	<xsl:variable name="notExists" >&lt;Product  IsMaster="" IsAccessory="" lastModified="" Status="Not Exists" Country="<xsl:value-of select="substring-after($locale,'_')"/>" Locale="<xsl:value-of select="$locale"/>"&gt;&lt;CTN&gt;'
	||ctnList.ctn||
	'&lt;/CTN&gt;&lt;status&gt;Does Not exits&lt;/status&gt;&lt;/Product&gt;</xsl:variable>

		<Products>
                    <xsl:copy-of select="."/>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="product">
SELECT lp.id
     , ll.LANGUAGE language
     , TO_CHAR(lc.sop,'yyyy-mm-dd"T"hh24:mi:ss') sop
     , TO_CHAR(lc.eop,'yyyy-mm-dd"T"hh24:mi:ss') eop
	  , nvl(lp.DATA,to_clob('<xsl:value-of select="$notExists"/>')) data
  FROM LOCALIZED_PRODUCTS lp
     , (SELECT ctn FROM (SELECT '<xsl:value-of select="replace($ctnList,',',$sep)"/>' ctn FROM dual)
       ) ctnList
	  , locale_language ll
     , mv_local_catalog lc
WHERE lp.locale(+)  = '<xsl:value-of select="$locale"/>'
AND   ctnList.ctn   = lp.ID(+)
AND   ll.LOCALE     = '<xsl:value-of select="$locale"/>'
AND   ctnList.ctn   = lc.CTN (+)
AND   lc.COUNTRY(+) = '<xsl:value-of select="substring-after($locale,'_')"/>'
AND   lc.CATALOG_TYPE = 'LCB_CATALOG' -- fixed value in the mv_local_catalog
AND   lc.deleted = 0
AND   lc.division = ( 
                    SELECT DIVISION FROM MV_LOCAL_CATALOG 
                    WHERE ID = lp.id 
                    AND COUNTRY(+) = '<xsl:value-of select="substring-after($locale,'_')"/>'
                    AND CATALOG_TYPE = 'LCB_CATALOG'
                    AND DELETED = 0 
                    AND ROWNUM = 1 )
            </sql:query>
		  <sql:execute-query>
					<sql:query name="cat">
SELECT sc.GROUPCODE, sc.GROUPNAME, sc.CATEGORYCODE, sc.CATEGORYNAME, sc.SUBCATEGORYCODE, sc.SUBCATEGORYNAME
FROM SUBCAT_PRODUCTS sp
INNER JOIN SUBCAT sc on sp.SUBCATEGORYCODE = sc.SUBCATEGORYCODE
WHERE sp.ID = '<sql:ancestor-value name="id" level="1"/>'</sql:query>
				</sql:execute-query>
			</sql:execute-query>
		</Products>
	</xsl:template>
</xsl:stylesheet>
