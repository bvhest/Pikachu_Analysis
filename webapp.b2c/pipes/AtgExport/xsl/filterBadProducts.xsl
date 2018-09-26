<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--  -->
  <xsl:template match="Product[count(CSChapter/CSItem/CSValue/CSValueCode) != count(CSChapter/CSItem/CSValue/CSValueName)]"/>
	<!--  Empty ProductName (bug in PFS) -->  
  <xsl:template match="Product[ProductName='' and (not(NamingString/Descriptor/DescriptorName) or NamingString/Descriptor/DescriptorName = '')]"/>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
   <!--  -->
  </xsl:stylesheet>