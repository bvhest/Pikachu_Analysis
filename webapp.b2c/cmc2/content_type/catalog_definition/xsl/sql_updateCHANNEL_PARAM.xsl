<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="destination"/>
  <!-- -->
  <xsl:template match="Catalogs">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="Catalog">
    <xsl:variable name="country" select="@Country"/>
    <xsl:variable name="customerId" select="@CatalogTypeName"/>
    <xsl:for-each select="CatalogProduct[CustomerSpecificField]">
      <xsl:call-template name="CatalogProduct">
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="customerId" select="$customerId"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <!-- -->
  <xsl:template name="CatalogProduct">
    <xsl:param name="country"/>
    <xsl:param name="customerId"/>
      <sql:execute-query>
        <sql:query name="sql_updateCHANNEL_PARAM">
          MERGE INTO CHANNEL_PARAM cp
          using (
            select 
              '<xsl:value-of select="$customerId"/>' as channel,
              '<xsl:value-of select="@CTN"/>' as id,
              '<xsl:value-of select="CustomerSpecificField[1]/Value"/>' as var1,
              '<xsl:value-of select="CustomerSpecificField[2]/Value"/>' as var2,
              '<xsl:value-of select="CustomerSpecificField[3]/Value"/>' as var3,
              '<xsl:value-of select="CustomerSpecificField[4]/Value"/>' as var4,
              '<xsl:value-of select="CustomerSpecificField[5]/Value"/>' as var5
            from dual) s
          on (cp.channel=s.channel and cp.id =s.id)
          when matched then
            update set
              cp.var1 = s.var1,
              cp.var2 = s.var2,
              cp.var3 = s.var3,
              cp.var4 = s.var4,
              cp.var5 = s.var5
          when not matched then
            insert (cp.channel,cp.id,cp.var1,cp.var2,cp.var3,cp.var4,cp.var5)
            values (s.channel,s.id,s.var1,s.var2,s.var3,s.var4,s.var5)
        </sql:query>
      </sql:execute-query>                            
  </xsl:template>
</xsl:stylesheet>