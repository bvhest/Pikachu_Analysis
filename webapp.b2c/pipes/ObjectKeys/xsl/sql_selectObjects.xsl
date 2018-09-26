<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="sourceCT"/>
  <xsl:param name="full"/>

  <xsl:variable name="l-full" select="$full = 'true'"/>
  
  <xsl:template match="/">
    <root>
      <xsl:variable name="source" select="if ($sourceCT != '') then $sourceCT else 'PMT'" />
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="flag-objects">
        merge into CUSTOMER_LOCALE_EXPORT tgt
        using (
          select distinct '<xsl:value-of select="$channel"/>' customer_id, o.localisation locale, o.object_id ctn, 1 as flag
          from octl o
          
          inner join catalog_objects co
             on co.object_id=o.object_id
            and co.country=substr(o.localisation, 4)
          
          inner join channels ch
             on ch.name='<xsl:value-of select="$channel"/>'
            and (ch.catalog='ALL' or ch.catalog=co.customer_id)
          
         <xsl:if test="not($l-full)">
          left outer join customer_locale_export cle
            on cle.ctn=o.object_id
           and cle.locale=o.localisation
           and cle.customer_id='<xsl:value-of select="$channel"/>'
         </xsl:if>  
          where o.content_type='<xsl:value-of select="$source"/>'
            and o.status!='PLACEHOLDER'
--and co.country='BE'
         <xsl:if test="not($l-full)">
            and (cle.lasttransmit is null
                 or cle.lasttransmit &lt; o.lastmodified_ts
                 or cle.lasttransmit &lt; co.lastmodified
                )
         </xsl:if>
        ) src
        on (tgt.CUSTOMER_ID = src.CUSTOMER_ID and tgt.locale = src.locale and tgt.ctn = src.ctn)
        when matched then update
          set tgt.flag = 1
        when not matched then insert 
          (tgt.customer_id, tgt.locale, tgt.ctn, tgt.flag) values (src.customer_id, src.locale, src.ctn, src.flag)
        </sql:query>
      </sql:execute-query>
      
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="count-objects">
          select count(*) totalcount
          from customer_locale_export
          where customer_id='<xsl:value-of select="$channel"/>'
            and flag=1 
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>

</xsl:stylesheet>