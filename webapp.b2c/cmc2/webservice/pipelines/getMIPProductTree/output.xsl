<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:csv="http://apache.org/cocoon/csv/1.0"
                >

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root|csv:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>  
  
  <xsl:template match="csv:document">
    <xsl:element name="Categorization">
      <xsl:attribute name="DocTimestamp" select="current-dateTime()"/>
      
      <xsl:element name="Catalog">
        <xsl:attribute name="IsMaster" select="'false'"/>
        <xsl:attribute name="Language" select="'en'"/>
        
        <xsl:element name="CatalogCode">
          <xsl:value-of select="'MIPProductTree'"/>
        </xsl:element>
        <xsl:element name="CatalogName">
          <xsl:value-of select="'MIPProductTree'"/>
        </xsl:element>
        <xsl:element name="CatalogType">
        
        </xsl:element>
        
        <xsl:element name="FixedCategorization">
          <xsl:apply-templates select="csv:record"/>
        
          <xsl:for-each-group select="csv:record[@number != 1]" group-by="csv:field[@number = 1]">
            <xsl:if test="current()/csv:field[@number = 1] = ('0100','0200')">
              <xsl:element name="ProductDivision">
                <xsl:element name="ProductDivisionCode">
                  <xsl:value-of select="current()/csv:field[@number = 1]"/>
                </xsl:element>
                <xsl:element name="ProductDivisionName">
                  <xsl:value-of select="current()/csv:field[@number = 8]"/>
                </xsl:element>
                <xsl:element name="ProductDivisionRank">
                  <xsl:value-of select="position()"/>
                </xsl:element>
                
                <xsl:for-each-group select="current-group()" group-by="csv:field[@number = 2]">
                  <xsl:if test="not(csv:field[@number = 10]) and current()/csv:field[@number = 2] != '-'">
                    <xsl:element name="BusinessGroup">
                      <xsl:element name="BusinessGroupCode">
	                    <xsl:value-of select="current()/csv:field[@number = 2]"/>
  	                  </xsl:element>
	                  <xsl:element name="BusinessGroupName">
	                    <xsl:value-of select="current()/csv:field[@number = 8]"/>
	                  </xsl:element>
	                  <xsl:element name="BusinessGroupRank">
	                    <xsl:value-of select="position()"/>
	                  </xsl:element>
	                  
	                  <xsl:for-each-group select="current-group()" group-by="csv:field[@number = 3]">
		                <xsl:if test="not(csv:field[@number = 10]) and current()/csv:field[@number = 3] != '-'">
		                  <xsl:element name="Group">
		                    <xsl:element name="GroupCode">
		                      <xsl:value-of select="current()/csv:field[@number = 3]"/>
		                    </xsl:element>
		                    <xsl:element name="GroupReferenceName">
		                      <xsl:value-of select="current()/csv:field[@number = 8]"/>
		                    </xsl:element>
		                    <xsl:element name="GroupName">
                              <xsl:value-of select="current()/csv:field[@number = 8]"/>
                            </xsl:element>
		                    <xsl:element name="GroupRank">
		                      <xsl:value-of select="position()"/>
		                    </xsl:element>
		                    
		                    <xsl:for-each-group select="current-group()" group-by="csv:field[@number = 4]">
		                      <xsl:if test="not(csv:field[@number = 10]) and current()/csv:field[@number = 4] != '-'">
		                        <xsl:element name="Category">
		                          <xsl:element name="CategoryCode">
		                            <xsl:value-of select="current()/csv:field[@number = 4]"/>
		                          </xsl:element>
		                          <xsl:element name="CategoryReferenceName">
		                            <xsl:value-of select="current()/csv:field[@number = 8]"/>
		                          </xsl:element>
		                          <xsl:element name="CategoryName">
		                            <xsl:value-of select="current()/csv:field[@number = 8]"/>
		                          </xsl:element>
		                          <xsl:element name="CategoryRank">
		                            <xsl:value-of select="position()"/>
		                          </xsl:element>
		                          <xsl:element name="L3">
		                            <xsl:element name="L4">
		                              <xsl:element name="L5">
		                                <xsl:element name="L6">
		                                  <xsl:for-each-group select="current-group()" group-by="csv:field[@number = 5]">
			                                <xsl:if test="not(csv:field[@number = 10]) and current()/csv:field[@number = 5] != '-'">
			                                  <xsl:element name="SubCategory">
			                                    <xsl:attribute name="status" select="'active'"/>
			                                    <xsl:element name="SubCategoryCode">
			                                      <xsl:value-of select="current()/csv:field[@number = 5]"/>
			                                    </xsl:element>
			                                    <xsl:element name="SubCategoryReferenceName">
			                                      <xsl:value-of select="current()/csv:field[@number = 8]"/>
			                                    </xsl:element>
			                                    <xsl:element name="SubCategoryName">
			                                      <xsl:value-of select="current()/csv:field[@number = 8]"/>
			                                    </xsl:element>
			                                    <xsl:element name="SubCategoryRank">
			                                      <xsl:value-of select="position()"/>
			                                    </xsl:element>
			                                  </xsl:element>
			                                </xsl:if>
			                              </xsl:for-each-group>
		                                </xsl:element>
		                              </xsl:element>
		                            </xsl:element>  
		                          </xsl:element>  
		                        </xsl:element>
		                      </xsl:if>
		                    </xsl:for-each-group>
		                  </xsl:element>
		                </xsl:if>
                      </xsl:for-each-group>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each-group>
              </xsl:element>
            </xsl:if>
          </xsl:for-each-group>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
