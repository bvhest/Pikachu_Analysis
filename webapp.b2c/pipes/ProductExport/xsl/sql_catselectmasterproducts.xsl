<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml catalog.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- NOTE: this stylesheet contains some dynamic SQL that will fail if there are more than 1000 products selected. 
    |   The following code is present twice in this stylesheet:
    |   "where mp.ID in (x,y,x, ... )"
   -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel"/>
	<xsl:param name="country"/>
	<xsl:param name="locale"/>
	<xsl:param name="exportdate"/>
	<xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
	<!-- -->
	<xsl:template match="/">
		<root>
			<!-- clear all-->
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT
set FLAG=0
where
	CUSTOMER_ID='<xsl:value-of select="$channel"/>'
	and LOCALE='MASTER'
			</sql:query>
			</sql:execute-query>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="select">
          select ctn from CUSTOMER_LOCALE_EXPORT
          where
            CUSTOMER_ID='<xsl:value-of select="$channel"/>'
            and LOCALE='MASTER'
            order by 1
        </sql:query>
      </sql:execute-query>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="yesterday">
          select to_char(sysdate-1,'YYYY-MM-DD') yesterday FROM DUAL
        </sql:query>
      </sql:execute-query>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="today">
          select to_char(sysdate,'YYYY-MM-DD') today FROM DUAL
        </sql:query>
      </sql:execute-query>    
			<!-- -->
			<xsl:apply-templates/>
			<!-- -->
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template match="/catalog[product]">
						<!-- add all new products -->
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
SELECT distinct
  '<xsl:value-of select="$channel"/>',
  'MASTER',
  mp.ID,
  0
FROM CUSTOMER_LOCALE_EXPORT cle
right JOIN MASTER_PRODUCTS mp
   on mp.ID=cle.ctn
  and cle.locale='MASTER'
  and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
where mp.ID in (<xsl:for-each select="product">
  '<xsl:value-of select="@ctn"/>'<xsl:if test="following-sibling::*">, 
</xsl:if></xsl:for-each>)
  and cle.CUSTOMER_ID is NULL
			</sql:query>
			</sql:execute-query>
				<!-- set flag to 1 if the export was before the last modified date -->
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT cle
set 
  FLAG=1
where cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
and cle.locale='MASTER'
and cle.ctn in (<xsl:for-each select="product">
  '<xsl:value-of select="@ctn"/>'<xsl:if test="following-sibling::*">, 
</xsl:if></xsl:for-each>)
and exists 
(
  select 1
  from MASTER_PRODUCTS mp
  where
    mp.ID=cle.ctn 
    and mp.STATUS='Final Published'    
) 
				</sql:query>
			</sql:execute-query>
			<!-- -->
	</xsl:template>
</xsl:stylesheet>
