<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <!--
    Add all derived doctypes to the PMT_LocContent data in order to process derived types accordingly. 
  -->
  
  <xsl:param name="doctypeconfig"/>
  
  <xsl:variable name="doctypes" select="if ($doctypeconfig!='') then document($doctypeconfig)/doctypes else ()"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>	

  <xsl:template match="octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/Visuals/Visual">
    <xsl:variable name="operation" select="@operation"/>
    <xsl:copy-of copy-namespaces="no" select="."/>
    
    <!-- Find all derived types for the doctype of this Visual -->
    <xsl:for-each select="$doctypes/doctype[@master=current()/@doctype]">
      <Visual operation="{$operation}" doctype="{@code}"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>