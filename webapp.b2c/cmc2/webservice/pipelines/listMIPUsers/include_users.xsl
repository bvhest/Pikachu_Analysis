<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
               >
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:role_code">
    <xsl:element name="role">
        <xsl:value-of select="current()"/>
    </xsl:element>
  </xsl:template> 
  
  <xsl:template match="sql:rowset">
    <xsl:for-each-group select="sql:row" group-by="sql:user_account">
        <xsl:element name="user">
            <xsl:element name="account">
                <xsl:value-of select="current()/sql:user_account"/>
            </xsl:element>
            <inc:include src="http://pww.xmlsearch.philips.com/?a=query&amp;databasematch=PEOPLEFINDER&amp;fieldtext=MATCH%7B{encode-for-uri(current()/sql:user_account)}%7D%3APF_PERSON_LOGIN"/>
            <xsl:element name="login-count">
                <xsl:value-of select="current()/sql:rowset/sql:row/sql:logincount"/>
            </xsl:element>
            <xsl:element name="first-login">
                <xsl:if test="current()/sql:rowset/sql:row/sql:logincount != '0'">
                    <xsl:value-of select='xs:dateTime("1970-01-01T00:00:00") + number(current()/sql:rowset/sql:row/sql:firstlogin) * xs:dayTimeDuration("PT0.001S")'/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="last-login">
                <xsl:if test="current()/sql:rowset/sql:row/sql:logincount != '0'">
                    <xsl:value-of select='xs:dateTime("1970-01-01T00:00:00") + number(current()/sql:rowset/sql:row/sql:lastlogin) * xs:dayTimeDuration("PT0.001S")'/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="roles">
                <xsl:if test="current-group()/sql:role_code != ''">
	               <xsl:apply-templates select="current-group()/sql:role_code"/>
	            </xsl:if>
	        </xsl:element>
        </xsl:element>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>
