<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel"></xsl:param>
	<xsl:param name="locale"></xsl:param>
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
						and LOCALE='<xsl:value-of select="$locale"/>'
				</sql:query>
			</sql:execute-query>	
			
			<!-- Insert a record into CLE if there is a new product for this channel and locale -->
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
						insert into CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
							select 
								'<xsl:value-of select="$channel"/>',
								LP.LOCALE,
								LP.ID,
								0	
							from (select * from LOCALIZED_PRODUCTS where locale = '<xsl:value-of select="$locale"/>') LP
							inner join MASTER_PRODUCTS MP
							on LP.ID = MP.ID
							left outer join (select * from CUSTOMER_LOCALE_EXPORT where customer_id = '<xsl:value-of select="$channel"/>' and locale = '<xsl:value-of select="$locale"/>') CLE
							on  LP.ID = CLE.CTN
							and LP.LOCALE = CLE.LOCALE
							where CLE.CTN IS NULL
					</sql:query>
			</sql:execute-query>
			
			<!-- Update flag if CLE record is new or LP product is updated -->
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>		
					update CUSTOMER_LOCALE_EXPORT cle
						set flag = 1
					    where customer_id = '<xsl:value-of select="$channel"/>'
	                    and flag = 0
	                    and locale = '<xsl:value-of select="$locale"/>'
	                    and (lasttransmit is null 
	                         or lasttransmit &lt;   (select lp.lastmodified 
													 from LOCALIZED_PRODUCTS lp 
													 inner join MASTER_PRODUCTS mp
													   on  lp.id = mp.id 
													 where lp.locale = '<xsl:value-of select="$locale"/>' and lp.id = cle.ctn)) 
					</sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
		
		
		
		