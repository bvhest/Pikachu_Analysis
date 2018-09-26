<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sql xsl source dir">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="targetDir"/>
  <xsl:param name="localetype"/>
  <xsl:param name="timestamp"/>
  
  <xsl:variable name="rundate" select="concat(substring($timestamp,1,4)
                                             ,'-'
                                             ,substring($timestamp,5,2)
                                             ,'-'
                                             ,substring($timestamp,7,2)
                                             ,'T'
                                             ,substring($timestamp,9,2)
                                             ,':'
                                             ,substring($timestamp,11,2)
                                             ,':00')"/>  
  
	<!-- -->
	<xsl:template match="/">
  <!-- Create fake master CTV file directly in the archive e.g. 20080130150123_Master-CTV-Ctg_1.xml -->
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($targetDir,'/',$timestamp,'/',$timestamp,'_',$localetype,'-CTV-Ctg_1.xml')"/>
			</source:source>
			<source:fragment>
<!--
<RenderProducts xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                DocTimeStamp="2008-01-30T15:01:00"
                XSDVersion="1.08"
                xsi:noNamespaceSchemaLocation="xUCDM_rendering_product_108.xsd">
   <Batch>
      <BatchDate>2008-01-30T15:01:00</BatchDate>
      <BatchType>Delta</BatchType>
      <PartNumber>1</PartNumber>
      <NumberOfPartsInBatch>1</NumberOfPartsInBatch>
   </Batch>
-->
      
    <RenderProducts DocTimeStamp="{$rundate}"
                    XSDVersion="1.08"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:noNamespaceSchemaLocation="xUCDM_rendering_product_108.xsd">
      <Batch>
        <BatchDate><xsl:value-of select="$rundate"/></BatchDate>
        <BatchType>Delta</BatchType>
        <PartNumber>1</PartNumber>
        <NumberOfPartsInBatch>1</NumberOfPartsInBatch>
      </Batch>
    </RenderProducts>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>