<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- Create correct routing code for entry based on categorization of first referenced product -->
  <xsl:template match="entry">
    <xsl:copy copy-namespaces="no">  
      <xsl:apply-templates select="@*[not(local-name()='category' or local-name()='routingCode' or local-name()='routingName')]"/>  
      <xsl:attribute name="category" select="sql:rowset[@name='getcategorization']/sql:row[1]/sql:categorycode"/>
      <xsl:attribute name="routingCode" select="if(sql:rowset[@name='getcategorization']/sql:row[1]/sql:groupcode != '') 
                                                then concat(sql:rowset[@name='getcategorization']/sql:row[1]/sql:groupcode,'/',sql:rowset[@name='getcategorization']/sql:row[1]/sql:categorycode)
                                                else content/Node/@routingCode"/>
      <xsl:attribute name="routingName" select="if(sql:rowset[@name='getcategorization']/sql:row[1]/sql:groupname != '')
      then concat(sql:rowset[@name='getcategorization']/sql:row[1]/sql:groupname,'/',sql:rowset[@name='getcategorization']/sql:row[1]/sql:categoryname)
      else sql:rowset[@name='getroutingname']/sql:row/sql:routingname"/>    
      <xsl:apply-templates select="node()"/>
    </xsl:copy>      
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:*"/>
  <xsl:template match="process"/>
  <!-- -->
 </xsl:stylesheet>
