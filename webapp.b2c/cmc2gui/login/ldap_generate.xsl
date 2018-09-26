<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ldap="http://apache.org/cocoon/LDAP/1.0">
	<xsl:param name="password"/>
	<xsl:param name="name"/>
	<!-- -->
	<xsl:template match="authentication">
		<authentication xmlns:ldap="http://apache.org/cocoon/LDAP/1.0">
			<xsl:apply-templates/>
		</authentication>
	</xsl:template>
	<!-- -->
	<xsl:template match="data"/>
	<xsl:template match="role"/>
	<!-- -->
	<xsl:template match="ID">
		<ldap:execute-query>
			<ldap:initializer>com.sun.jndi.ldap.LdapCtxFactory</ldap:initializer>
			<ldap:authentication>simple</ldap:authentication>

			<ldap:version>3</ldap:version>

			<ldap:serverurl>ldap://LDAP.gdc1.ce.philips.com</ldap:serverurl>

			<ldap:port>389</ldap:port>
			<ldap:scope>SUBTREE_SCOPE</ldap:scope>

			<ldap:searchbase>ou=your,o=base,c=here</ldap:searchbase>

			<ldap:debug>FALSE</ldap:debug>

			<ldap:deref-link>TRUE</ldap:deref-link>

			<ldap:count-limit>0</ldap:count-limit>
			<ldap:time-limit>0</ldap:time-limit>
			<ldap:filter>(objectClass=orgPerson)</ldap:filter>

			<ldap:show-attribute>TRUE</ldap:show-attribute>

			<ldap:doc-element>LDAP</ldap:doc-element>
			<ldap:row-element>LDAPSET</ldap:row-element>
			<ldap:error-element>ELEMENT</ldap:error-element>

			<ldap:attribute>uid</ldap:attribute>
			<ldap:attribute>cn</ldap:attribute>
			<ldap:attribute>mail</ldap:attribute>

		</ldap:execute-query>
		<!--ldap:execute-query>
			<ldap:initializer>com.sun.jndi.ldap.LdapCtxFactory</ldap:initializer>
			<ldap:serverurl>ldap://LDAP.gdc1.ce.philips.com</ldap:serverurl>
			<ldap:authentication>simple</ldap:authentication>
			<ldap:version>3</ldap:version>
			<ldap:port>389</ldap:port>
			<ldap:scope>SUBTREE_SCOPE</ldap:scope>
			<ldap:searchbase>DC=corproot,DC=net</ldap:searchbase>
			<ldap:filter>(&amp;(objectclass=User)(cn=TFR*))</ldap:filter>
			<ldap:deref-link>TRUE</ldap:deref-link>
			<ldap:count-limit>0</ldap:count-limit>
			<ldap:time-limit>0</ldap:time-limit>
			<ldap:show-attribute>TRUE</ldap:show-attribute>
			<ldap:doc-element>users</ldap:doc-element>
			<ldap:row-element>user</ldap:row-element>
			<ldap:error-element>ELEMENT</ldap:error-element>
			<ldap:attribute>cn</ldap:attribute>
			<ldap:attribute>co</ldap:attribute>
			<ldap:attribute>sn</ldap:attribute>
			<ldap:attribute>employeeID</ldap:attribute>
			<ldap:attribute>title</ldap:attribute>
			<ldap:attribute>company</ldap:attribute>
			<ldap:attribute>givenname</ldap:attribute>
			<ldap:attribute>mail</ldap:attribute>
			<ldap:attribute>streetAddress</ldap:attribute>
			<ldap:attribute>postalCode</ldap:attribute>
			<ldap:attribute>st</ldap:attribute>
			<ldap:attribute>mobile</ldap:attribute>
		</ldap:execute-query-->
	</xsl:template>
</xsl:stylesheet>
