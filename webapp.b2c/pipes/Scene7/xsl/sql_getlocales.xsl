<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <!-- 
    Get the configured locales from channel_catalogs table.
    Also get the start time of the channel invocation.
    
    If locale is specified process only that locale.
  -->
   <xsl:param name="channel"/>
   <xsl:param name="locale"/>  

   <xsl:template match="/">
      <root>
         <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query name="get-locales">
      select 
            distinct cc.locale, 
            to_char(c.startexec,'yyyymmddhh24miss')  ts
      from 
            CHANNEL_CATALOGS cc
      inner join 
            CHANNELS c on c.id = cc.customer_id
      where 
            c.name = '<xsl:value-of select="$channel"/>' 
      
        <xsl:if test="$locale != ''">
        <!-- Specific to locale we want to export -->
      and 
          cc.locale = '<xsl:value-of select="$locale"/>'
        </xsl:if>
        
        <!-- Pick only locales that are enabled -->
      and 
            cc.enabled = 1
       
      order by 
          cc.locale
            </sql:query>
         </sql:execute-query>
      </root>
   </xsl:template>
</xsl:stylesheet>