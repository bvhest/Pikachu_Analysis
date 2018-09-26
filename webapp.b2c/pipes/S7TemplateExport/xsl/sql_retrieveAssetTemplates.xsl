<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="type"/>
  <!--   
  <xsl:variable name="quot">'</xsl:variable>
  <xsl:variable name="template-config-keys-list" select="string-join(for $i in distinct-values(Templates/keys/key/keyname) return concat($quot,$i,$quot),',')"/>
  --> 
  <xsl:template match="/">
    <root>
      <!--template-config><xsl:copy-of select="."/></template-config-->
      <sql:execute-query>
        <sql:query>
            select o.content_type
                 , o.localisation
                 , o.object_id
                 , o.data
              from customer_locale_export cle
        inner join octl o       
                on cle.ctn = o.object_id        
               and cle.locale = o.localisation      
               and cle.customer_id = '<xsl:value-of select="$channel"/>'
               and cle.flag = 1
             where o.content_type = 'AssetTemplate'
               and NVL(o.status, 'XXX') != 'PLACEHOLDER'
            <!--and k.key in (<xsl:value-of select="$template-config-keys-list"/>) 
            order by k.ctn-->
          order by 1,2,3
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>