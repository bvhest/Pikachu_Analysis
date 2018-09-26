<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
    <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>
  <!-- -->
  <xsl:variable name="fulldate">
  <xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
        select o.object_id id
              , 'MASTER' as language
              , o.content_type
              , o.data
         from octl o 
         inner join CUSTOMER_LOCALE_EXPORT cle
            on cle.ctn=o.object_id
            inner join object_categorization oc
                on  oc.object_id=o.object_id
                and oc.deleted = 0
              inner join CATEGORIZATION ca
                on ca.subcategorycode=oc.subcategory
                and ca.groupcode='LIGHTING_GR'
         where cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
           and cle.locale = 'MASTER'
           and cle.flag=1
           and o.content_type='PMT_Master'
           and o.localisation='master_global'

         </sql:query>
       </sql:execute-query>
    </Products>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
