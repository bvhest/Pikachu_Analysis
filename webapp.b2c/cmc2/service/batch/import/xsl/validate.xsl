<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:param name="reload"/>  
  <!-- -->    
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->
  <xsl:template match="entry[@valid='true']">
     <xsl:copy copy-namespaces="no">
       <xsl:apply-templates select="@*[not(local-name()='valid')] "/>
        <xsl:choose>
          <!-- Do not do the compare if this is a reload -->        
          <xsl:when test="not($reload='true')">     
             <xsl:choose>
              <xsl:when test="not (currentmasterlastmodified_ts/sql:rowset/sql:row/sql:masterlastmodified_ts) or string-length(currentmasterlastmodified_ts/sql:rowset/sql:row/sql:masterlastmodified_ts) = 0">
                <xsl:attribute name="valid">false</xsl:attribute>
                <result>No Placeholder</result>
              </xsl:when>
              <!-- octl-attributes/masterlastmodified_ts will contain the lastmodified_ts from the file -->
              <xsl:when test="octl-attributes/masterlastmodified_ts &gt; currentmasterlastmodified_ts/sql:rowset/sql:row/sql:masterlastmodified_ts ">
                <xsl:apply-templates select="@valid|result"/>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:attribute name="valid">false</xsl:attribute>
                <xsl:element name="result">More recent document exists</xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>           
          <xsl:otherwise>
            <xsl:apply-templates select="@*[local-name()='valid']|result "/>        
          </xsl:otherwise>          
        </xsl:choose>  
        <xsl:apply-templates select="node()[not(local-name()='result')] "/>
      </xsl:copy>
  </xsl:template>
  <!-- -->  
  <xsl:template match="currentmasterlastmodified_ts">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="sql:rowset/sql:row/sql:masterlastmodified_ts"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="currentlastmodified_ts">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="./sql:rowset/sql:row/sql:lastmodified_ts"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->  
    <xsl:template match="currentmarketingversion">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="./sql:rowset/sql:row/sql:marketingversion"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
