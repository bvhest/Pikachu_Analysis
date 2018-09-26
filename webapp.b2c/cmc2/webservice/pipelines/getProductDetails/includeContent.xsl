<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                exclude-result-prefixes="sql"
                version="2.0">
                
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="products">
    <xsl:element name="products">
      <xsl:variable name="accounts" select="distinct-values(//sql:row/sql:owner)"/>
    
      <xsl:element name="accounts">
        <xsl:for-each select="$accounts">
          <xsl:element name="account">
            <xsl:attribute name="accountID" select="current()"/>
            <inc:include>
              <xsl:attribute name="src" select="concat('cocoon:/PeopleFinderService?accountID=', current())" />
            </inc:include>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="octl/sql:rowset/sql:row[sql:content_type = 'PMS']"> 
    
    <xsl:element name="sql:row">
      <xsl:variable name="accounts" select="distinct-values(//ContentDetail/Publisher[@accountID != '']/@accountID)"/>
    
      <xsl:element name="accounts">
        <xsl:for-each select="$accounts">
          <xsl:element name="account">
            <xsl:attribute name="accountID" select="current()"/>
            <inc:include>
              <xsl:attribute name="src" select="concat('cocoon:/PeopleFinderService?accountID=', current())" />
            </inc:include>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
