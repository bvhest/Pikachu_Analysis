<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel"></xsl:param>
	<xsl:param name="locale"></xsl:param>	
	<!-- -->
	<xsl:template match="/">
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
SELECT    cle.locale, cle.batch, COUNT (o.object_id) number_ctns,
       (select  max(cle2.batch)  from customer_locale_export cle2 
            where cle2.customer_id = '<xsl:value-of select="$channel"/>' 
            AND cle2.locale = '<xsl:value-of select="$locale"/>') maxbatch
    FROM customer_locale_export cle 
    left outer JOIN octl o 
      on o.content_type = 'PMT' 
     and o.localisation = cle.locale 
     and o.object_id = cle.ctn 
     and o.lastmodified_ts > NVL (cle.lasttransmit, TO_DATE ('1900-01-01', 'yyyy-mm-dd'))
   WHERE cle.customer_id = '<xsl:value-of select="$channel"/>' 
     AND cle.locale = '<xsl:value-of select="$locale"/>'
     AND NVL (cle.batch, 0) > 0
GROUP BY cle.batch, cle.locale 
order by cle.locale asc, cle.batch asc							
			</sql:query>
		</sql:execute-query>				
</xsl:template>
</xsl:stylesheet>