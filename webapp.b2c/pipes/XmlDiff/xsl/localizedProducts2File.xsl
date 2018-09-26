<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel"/>
	<xsl:param name="locale"/>
	<xsl:param name="dir"/>
	<xsl:param name="table"/>	
	<xsl:param name="join"/>		
	<xsl:param name="exportdate"/>
	<!-- -->
	<xsl:variable name="v_table" select="if($table eq 'LP') then 'LOCALIZED_PRODUCTS' else if($table eq 'TLP') then 'TRIGO_LOCALIZED_PRODUCTS' else ()"/>		
	<xsl:template match="/root">
		<root>
			<xsl:apply-templates select="sql:rowset/sql:row"/>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:row">
		<xsl:variable name="ctn" select="translate(sql:id,'/-. ','___')"/>
		
		<source:write>
			<source:source><xsl:value-of select="$dir"/><xsl:value-of select="$join"/>.<xsl:value-of select="$locale"/>.<xsl:value-of select="$ctn"/>.xml</source:source>
			<source:fragment>
				<Product>
					<sql:execute-query>
						<sql:query>
							<xsl:choose>
								<xsl:when test="$join eq 'INNER'">						
									SELECT LP.id, to_char(LP.lastmodified,'YYYY-MM-DD"T"HH24:MI:SS')  AS LPLASTMOD, LP.data AS LPDATA
									             ,to_char(TLP.lastmodified,'YYYY-MM-DD"T"HH24:MI:SS') AS TLPLASTMODFROM, TLP.DATA AS TLPDATA
									from LOCALIZED_PRODUCTS LP INNER JOIN TRIGO_LOCALIZED_PRODUCTS TLP on LP.ID = TLP.ID AND LP.LOCALE = TLP.LOCALE
									where LP.id='<xsl:value-of select="sql:id"/>' and LP.locale = '<xsl:value-of select="$locale"/>'
									order by LP.ID
								</xsl:when>
							</xsl:choose>						
						</sql:query>
					</sql:execute-query>
				</Product>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
