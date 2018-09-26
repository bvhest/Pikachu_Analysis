<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="external_only"/>
	<!-- -->
	<!--
Directory requirements
drop directory ATG;
create directory ATG as ' ';
grant read on directory trigo to cmc2_dev1_schema;
grant write on directory trigo to cmc2_dev1_schema;

-->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="sql:rowset|column"/>
	
	<xsl:template match="table">
		<xsl:variable name="apos">'</xsl:variable>
		<xsl:if test="$external_only ='n' ">
			<sql:execute-query>
				<sql:query>
		drop table <xsl:value-of select="@name"/>
				</sql:query>
			</sql:execute-query>
			<sql:execute-query>
				<sql:query>
		create table <xsl:value-of select="@name"/> (
			<xsl:for-each select="column">
						<xsl:if test="position() != 1">,</xsl:if>
						<xsl:choose>
							<xsl:when test="@data-type='DATE'">
								<xsl:value-of select="concat(@name,' ',@data-type,' ')"/>
							</xsl:when>
							<xsl:when test="@data-type='CLOB'">
								<xsl:value-of select="concat(@name,' ',@data-type,' ')"/>
								<!--xsl:value-of select="concat(@name,' VARCHAR2(2000)  ')"/-->
							</xsl:when>
							<xsl:when test="@data-type='BLOB'">
								<xsl:value-of select="concat(@name,' ',@data-type,' ')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(@name,' ',@data-type,' (',@data-length,') ')  "/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
		)
			</sql:query>
			</sql:execute-query>
		</xsl:if>
		<sql:execute-query>
			<sql:query>
		drop table <xsl:value-of select="concat(@name,'_E')"/>
			</sql:query>
		</sql:execute-query>
		<sql:execute-query>
			<sql:query>
		create table <xsl:value-of select="concat(@name,'_E') "/> (
			<xsl:for-each select="column">
				<xsl:if test="position() != 1">,</xsl:if>
					<xsl:choose>
						<xsl:when test="@data-type='VARCHAR2'">
							<xsl:value-of select="concat(@name,' ',@data-type,' (',@data-length,') ')  "/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(@name,' ',@data-type,' ')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
		)
		ORGANIZATION EXTERNAL
		 ( TYPE ORACLE_LOADER     
		   DEFAULT DIRECTORY ATG     
		   ACCESS PARAMETERS   (
		RECORDS DELIMITED BY '\n' FIELDS TERMINATED BY '|'  MISSING FIELD VALUES ARE NULL (
			<xsl:for-each select="column">
				<xsl:if test="position() != 1">,</xsl:if>
				
					<xsl:choose>
						<xsl:when test="@data-type='DATE'">
							<xsl:value-of select="concat(@name,' date ',$apos,'yyyy-mm-dd&quot;T&quot;hh24:mi:ss',$apos ) "/>
						</xsl:when>
						<xsl:when test="@data-type='NUMBER'">
							<xsl:value-of select="@name"/>
						</xsl:when>
						<xsl:when test="@data-type='CLOB'">
							<xsl:value-of select="concat(@name,' char(500000) ') "/>
						</xsl:when>
						<xsl:when test="@data-type='BLOB'">
							<xsl:value-of select="concat(@name,' char(500000) ') "/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(@name,' char(',@data-length,') ') "/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
		))
		 LOCATION (ATG:'<xsl:value-of select="concat(@name,'.dat')"/>')  )
REJECT LIMIT 20
NOPARALLEL
NOMONITORING		
			</sql:query>
		</sql:execute-query>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
