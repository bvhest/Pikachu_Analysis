<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml catalog.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>

  <!-- -->
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          UPDATE CUSTOMER_LOCALE_EXPORT
          set FLAG=0
          where
            CUSTOMER_ID='<xsl:value-of select="$channel"/>'
            and LOCALE='<xsl:value-of select="$locale"/>'
        </sql:query>
      </sql:execute-query>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="select">
          select ctn from CUSTOMER_LOCALE_EXPORT
          where
            CUSTOMER_ID='<xsl:value-of select="$channel"/>'
            and LOCALE='<xsl:value-of select="$locale"/>'
            order by 1
        </sql:query>
      </sql:execute-query>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="yesterday">
          select to_char(sysdate-1,'YYYY-MM-DD') yesterday FROM DUAL
        </sql:query>
      </sql:execute-query>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="today">
          select to_char(sysdate,'YYYY-MM-DD') today FROM DUAL
        </sql:query>
      </sql:execute-query>      
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="/catalog/product">
    <!-- default = PMT, otherwise select from sourceCT variabele.
     +-->
    <xsl:variable name="source" select="if ($sourceCT='PCT') then 'PCT' else 'PMT'" />

    <xsl:if test="@locale = $locale">
      <!-- Add a row if product/locale is new -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          insert into customer_locale_export(customer_id, locale, ctn, flag)
                 select '<xsl:value-of select="$channel"/>'
                        , o.localisation
                        , o.object_id
                        , 0
                   from OCTL o
              left join CUSTOMER_LOCALE_EXPORT cle
                     on o.object_ID=cle.ctn
                    and o.localisation=cle.locale
                    and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
             inner join CHANNELS ch 
                     on ch.name = '<xsl:value-of select="$channel"/>'
                  where o.content_type = '<xsl:value-of select="$source"/>'
<xsl:if test="$source= 'PMT'">               
                    and o.status = 'Final Published'
</xsl:if>               
                    and o.localisation='<xsl:value-of select="$locale"/>' 
                    and o.object_id='<xsl:value-of select="@ctn"/>'
                    and cle.CUSTOMER_ID is NULL 
        </sql:query>
      </sql:execute-query>
      <!-- Set flag to 1  -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
            update customer_locale_export cle
                 set FLAG=1
               where cle.ctn='<xsl:value-of select="@ctn"/>'
                 and   cle.locale = '<xsl:value-of select="$locale"/>'
                 and   cle.customer_id = '<xsl:value-of select="$channel"/>'
                 and exists ( select 1
                                from OCTL
                               where CONTENT_TYPE = 'PMT'
                                 and localisation = '<xsl:value-of select="$locale"/>'
<xsl:if test="$source= 'PMT'">               
                                 and status = 'Final Published'
</xsl:if>               
                                 and object_id = '<xsl:value-of select="@ctn"/>')    
        </sql:query>
      </sql:execute-query>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
