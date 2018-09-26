<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:param name="channel"></xsl:param>
	<xsl:param name="locale">none</xsl:param>
	<!-- -->
	<xsl:template match="/">
	<root>
	<!-- clear all-->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
				update CUSTOMER_LOCALE_EXPORT
				set FLAG=0
				where 
					CUSTOMER_ID='<xsl:value-of select="$channel"/>'
			</sql:query>
		</sql:execute-query>

	<!-- Insert a record into CLE if there is a new product for this channel and locale -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
                insert into CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
                select distinct '<xsl:value-of select="$channel"/>'
                     , o.localisation
                     , o.object_id id
                     , 0
                  from octl o
       left outer join customer_locale_export cle
                    on cle.customer_id = '<xsl:value-of select="$channel"/>'
                   and cle.ctn = o.object_id
                   and cle.locale = o.localisation
                 where o.content_type in ('RichText_Raw','RichText')
                   and cle.CUSTOMER_ID is null
                   and NVL(o.status, 'XXX') != 'PLACEHOLDER'
			</sql:query>
		</sql:execute-query>
					
		<!-- Set flag to 1 if the row is new, or if the product's rich text has changed since last export -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
					
					update customer_locale_export 
					set flag = 1
					where rowid in 
					(  select distinct cle.ROWID  from octl o  
						inner join customer_locale_export cle
						on cle.ctn=o.object_id
						and cle.locale=o.localisation
						where o.content_type in ('RichText','RichText_Raw')
						and cle.customer_id='<xsl:value-of select="$channel"/>'
						and (cle.LASTTRANSMIT is null or cle.LASTTRANSMIT &lt; o.LASTMODIFIED_TS)
						and cle.flag=0
					)
			</sql:query>
		</sql:execute-query>
	<!-- -->
	</root>
</xsl:template>
</xsl:stylesheet>
