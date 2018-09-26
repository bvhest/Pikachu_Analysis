<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:saxon="http://saxon.sf.net/" xmlns:me="http://apache.org/a">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:template match="/">
    <html>
		<body>
		<p>
			<xsl:call-template name="term-matching">
				<xsl:with-param name="term">Pixel Plus</xsl:with-param> 
				<xsl:with-param name="segment">Pixel Plus 3 HD</xsl:with-param> 
			</xsl:call-template>  
		</p>
		<p>
			<xsl:call-template name="term-matching">
				<xsl:with-param name="term">Pixel Plus</xsl:with-param> 
				<xsl:with-param name="segment">'Pixel Plus' 3 HD</xsl:with-param> 
			</xsl:call-template>  
		</p>
		<p>
			<xsl:call-template name="term-matching">
				<xsl:with-param name="term">Pixel Plus</xsl:with-param> 
				<xsl:with-param name="segment">"Pixel Plus" 3 HD</xsl:with-param> 
			</xsl:call-template>  
		</p>
		<p>
			<xsl:call-template name="term-matching">
				<xsl:with-param name="term">Pixel Plus</xsl:with-param> 
				<xsl:with-param name="segment">Pixel Plus- 3 HD</xsl:with-param> 
			</xsl:call-template>  
		</p>
		<p>
			<xsl:call-template name="term-matching">
				<xsl:with-param name="term">Pixel Plus</xsl:with-param> 
				<xsl:with-param name="segment">0Pixel Plus- 3 HD</xsl:with-param> 
			</xsl:call-template>  
		</p>		</body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template name="term-matching">
				<xsl:param name="term"/> 
				<xsl:param name="segment"/> 
        <xsl:value-of select="replace($segment, concat('(^|[^a-zA-Z0-9])',$term,'($|[^a-zA-Z0-9])'), '$1HALLO$2')"/>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
