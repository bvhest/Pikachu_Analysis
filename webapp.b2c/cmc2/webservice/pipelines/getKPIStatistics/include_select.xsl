<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:my="http://pww.cmc.philips.com/local-functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                >

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:element name="root">
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="root|sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>  
  
  <xsl:template match="owners/sql:rowset">
      <xsl:for-each select="sql:row/sql:owner">
        <inc:include>
          <xsl:attribute name="src" select="concat('cocoon:/getUrgencyStatistics?userID=', current(),'&amp;authorizationRestriction=I own','&amp;columnSelection=PUR')"/>
        </inc:include>
        <!-- PeopleFinder -->
        <xsl:element name="User">
          <xsl:attribute name="userID" select="current()"/>
          <xsl:attribute name="status" select="current()/../sql:status"/>
          
          <inc:include>
            <xsl:attribute name="src" select="concat('cocoon:/PeopleFinderService?accountID=', current())" />
          </inc:include>
        </xsl:element>
      </xsl:for-each>
      
      <xsl:for-each select="sql:row/sql:rowset/sql:row">
        <xsl:element name="LoginCount">
          <xsl:attribute name="userID" select="../../sql:owner"/>
          <xsl:attribute name="count" select="sql:logincount"/>
        </xsl:element>
      </xsl:for-each>  
  </xsl:template>  
  
  <xsl:template match="products/sql:rowset">
    <xsl:for-each select="sql:row">
      <xsl:element name="Product">
        <xsl:attribute name="ctn" select="current()/sql:ctn"/>
        <xsl:attribute name="owner" select="current()/sql:owner"/>
        <xsl:attribute name="crdate" select="current()/sql:cr_date"/>
        <xsl:attribute name="marketingclass" select="current()/sql:marketingclass"/>
        
        <xsl:attribute name="magcode" select="current()/sql:data/Product/MasterData/MAG"/>
        <xsl:attribute name="modified" select="current()/sql:data/Product/MasterData/LastPMTPublishdate"/>
        <xsl:attribute name="pmtversion" select="current()/sql:data/Product/MasterData/PMTVersion"/>
        
        <xsl:attribute name="rank" select="current()/sql:rank"/>
        <xsl:attribute name="categorycode" select="current()/sql:gcs_category_code"/>
        <xsl:attribute name="columnid" select="current()/sql:columnid"/>
        <xsl:attribute name="globallive" select="current()/sql:publication_status"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
