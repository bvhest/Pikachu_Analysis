<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:variable name="currdatetime" select="substring(string(current-dateTime()),1,19)"/>
  <!-- -->    
	<xsl:template match="root">
		<xsl:apply-templates/>
	</xsl:template>
  <!-- -->    
	<xsl:template match="entries">
		<entries>
			<xsl:copy-of copy-namespaces="no" select="@*"/>
			<xsl:apply-templates/>
		</entries>
	</xsl:template>
  <!-- -->      
	<xsl:template match="entry">
		<entry>
			<xsl:copy-of copy-namespaces="no" select="@*"/>
      <!--xsl:variable name="ts" select="substring(@ts,1,19)"/-->
      <xsl:variable name="current-mlm" select="substring(currentmasterlastmodified_ts/sql:rowset/sql:row/sql:masterlastmodified_ts,1,19)"/>
      <xsl:variable name="current-lm" select="substring(currentlastmodified_ts/sql:rowset/sql:row/sql:lastmodified_ts,1,19)"/>      
      <xsl:variable name="incoming-lm" select="substring(content/Product/@lastModified,1,19)"/>
      <!--+
          |
          |  Process only those products whose lastmodified timestamp matches the masterlastmodified_ts timestamp in the OCTL table.
          |  
          +-->
			<xsl:choose>
				<xsl:when test="not ($current-mlm) ">
          <!-- Ignore: new product -->
					<xsl:attribute name="valid">false</xsl:attribute>
					<result>New Product</result>
          <incoming-lm><xsl:value-of select="$incoming-lm"/></incoming-lm>
          <current-mlm><xsl:value-of select="$current-mlm"/></current-mlm>           
				</xsl:when>
				<xsl:when test="$incoming-lm &gt; $current-mlm">
          <!-- Ignore: newer product -->        
					<xsl:attribute name="valid">false</xsl:attribute>          
					<result>Newer Product</result>
          <incoming-lm><xsl:value-of select="$incoming-lm"/></incoming-lm>
          <current-mlm><xsl:value-of select="$current-mlm"/></current-mlm>          
				</xsl:when>          
				<xsl:when test="$incoming-lm &lt; $current-mlm">
          <!-- Ignore: older product -->        
					<xsl:attribute name="valid">false</xsl:attribute>          
					<result>Older Product</result>          
          <incoming-lm><xsl:value-of select="$incoming-lm"/></incoming-lm>
          <current-mlm><xsl:value-of select="$current-mlm"/></current-mlm>          
				</xsl:when>                    
				<xsl:when test="$incoming-lm eq $current-mlm">        
          <!-- Process: timestamp is unchanged, but content should be fixed -->                
					<xsl:attribute name="valid">true</xsl:attribute>                 
					<result>OK</result>                      
					<!--xsl:copy-of copy-namespaces="no" select="content"/-->
          <xsl:apply-templates select="content"/>
          <xsl:apply-templates select="currentmasterlastmodified_ts|currentlastmodified_ts|process|global"/>
          <octl-attributes>
            <xsl:copy-of copy-namespaces="no" select="octl-attributes/node()[not(local-name() = 'lastmodified_ts' or local-name() = 'masterlastmodified_ts')]"/>
            <lastmodified_ts><xsl:value-of select="$current-lm"/></lastmodified_ts>
            <masterlastmodified_ts><xsl:value-of select="$current-mlm"/></masterlastmodified_ts>
            <remark><xsl:value-of select="concat('RELOADED from source XML on ',$currdatetime)"/></remark> 
          </octl-attributes>            
					<xsl:copy-of copy-namespaces="no" select="process"/>
				</xsl:when>
				<xsl:otherwise>
          <!-- Ignore: some other error -->                
					<xsl:attribute name="valid">false</xsl:attribute>
					<result>ERROR</result>
          <incoming-lm><xsl:value-of select="$incoming-lm"/></incoming-lm>
          <current-mlm><xsl:value-of select="$current-mlm"/></current-mlm>
				</xsl:otherwise>
			</xsl:choose>
		</entry>
	</xsl:template>
  <!-- -->  
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
