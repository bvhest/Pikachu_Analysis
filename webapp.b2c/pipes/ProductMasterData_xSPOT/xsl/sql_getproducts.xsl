<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="batch-size"/>
  <xsl:param name="batch-num"/>
  <xsl:param name="source"/>

  <xsl:variable name="l-batch-size" select="if (matches($batch-size, '\d+') and number($batch-size) > 0) then number($batch-size) else 500"/>
  
  <xsl:template match="/">
    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
          <!-- Select flagged products from CLE -->
          select cle.ctn, octl.data,
            case 
              when co.deleted = 1 then 'delete'
              when cle.flag = 2 then 'add'
              else 'update'
            end as action
          from (
            select customer_id, ctn, ceil(rownum/<xsl:value-of select="$l-batch-size"/>) as batchnum, flag
            from customer_locale_export cle1
            where cle1.flag > 0
              and cle1.customer_id='<xsl:value-of select="$channel"/>'
          ) cle

          inner join octl
             on octl.object_id=cle.ctn
            and octl.content_type='<xsl:value-of select="$source"/>'
            and octl.localisation='<xsl:value-of select="$locale"/>'

          inner join channels ch
             on ch.name = cle.customer_id

          inner join catalog_objects co
             on co.object_id = octl.object_id
            and co.catalog_id = ch.catalog
    
          where cle.batchnum = <xsl:value-of select="$batch-num"/>
        </sql:query>
      </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
