<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
   
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <!-- -->
   <xsl:param name="ct"/>  
   <xsl:param name="basedir"/>  
   <!-- -->

   <xsl:template match="/root">
      <root>
         <xsl:apply-templates select="sql:rowset/sql:row"/>
      </root>
   </xsl:template>

   <xsl:template match="sql:rowset/sql:row">
      <xsl:variable name="ts" select="replace(replace(replace(substring(xs:string(sql:startexec),1,19),':',''),'-',''),' ','')"/>
      <xsl:variable name="documentPath" select="concat($basedir,'/Report_',$ts,'.xml')" />
<xsl:text><xsl:value-of select="$documentPath" />
</xsl:text>
      <xsl:variable name="runReport" select="document($documentPath)/report" />
<xsl:text><xsl:value-of select="$runReport" />
</xsl:text>
      <xsl:variable name="volume_in" select="count($runReport/item/id)" />
      <xsl:variable name="volume_out" select="count($runReport/item[remark='OK**'])" />

      <cinclude:include src="cocoon:/setEndTime/{$ct}/{$volume_in}/{$volume_out}"/>
   </xsl:template>

</xsl:stylesheet>