<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="authentication">
		<authentication>
			<xsl:apply-templates select="users"/>
		</authentication>
	</xsl:template>
	<xsl:template match="users">
		<users>
			<xsl:apply-templates select="user"/>
		</users>
	</xsl:template>
	<xsl:template match="user">
		<user>
			<name>
				<xsl:value-of select="cn"/>
			</name>
			<password>testa</password>
			<role>user</role>
			<title>
				<xsl:value-of select="title"/>
			</title>
			<firstname>
				<xsl:value-of select="givenName"/>
			</firstname>
			<lastname>
				<xsl:value-of select="sn"/>
			</lastname>
			<company>
				<xsl:value-of select="company"/>
			</company>
			<street>
				<xsl:value-of select="streetAddress"/>
			</street>
			<zipcode>
				<xsl:value-of select="postalCode"/>
			</zipcode>
			<city>
				<xsl:value-of select="st"/>
			</city>
			<country>
				<xsl:value-of select="co"/>
			</country>
			<phone>
				<xsl:value-of select="mobile"/>
			</phone>
			<fax/>
			<email>
				<xsl:value-of select="mail"/>
			</email>
			<bankid/>
			<bankname/>
			<accountid/>
		</user>
	</xsl:template>
</xsl:stylesheet>
