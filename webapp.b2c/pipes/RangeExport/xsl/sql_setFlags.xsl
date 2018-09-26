<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
  xmlns:dir="http://apache.org/cocoon/directory/2.0" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="fullexport"/>  
  <xsl:variable name="fulldate" select="concat(substring($exportdate,1,4)
                                               ,'-'
                                               ,substring($exportdate,5,2)
                                               ,'-'
                                               ,substring($exportdate,7,2)
                                               ,'T'
                                               ,substring($exportdate,10,2)
                                               ,':'
                                               ,substring($exportdate,12,2)
                                               ,':00')"/>
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
            and LOCALE='<xsl:value-of select="$locale"/>'
            and FLAG=1
        </sql:query>
      </sql:execute-query>
      
      <!-- Add a row for each new Range -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          <xsl:choose>
            <xsl:when test="$locale = 'MASTER'">
              insert into customer_locale_export (CUSTOMER_ID, LOCALE, CTN, FLAG, LASTTRANSMIT)
               select distinct '<xsl:value-of select="$channel"/>',
                               '<xsl:value-of select="$locale"/>',
                               o.object_ID,
                               0,
                               to_date('1900-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')
                 from octl o
                left outer join (SELECT * FROM customer_locale_export WHERE CUSTOMER_ID='<xsl:value-of select="$channel"/>' AND LOCALE = '<xsl:value-of select="$locale"/>') cle
                   on cle.ctn=O.OBJECT_ID
                where o.content_type = 'RangeText_Raw'
                  and o.status != 'PLACEHOLDER'      
                  and cle.ctn is null
            </xsl:when>
            <xsl:otherwise>
              insert into customer_locale_export (CUSTOMER_ID, LOCALE, CTN, FLAG, LASTTRANSMIT)
               select distinct '<xsl:value-of select="$channel"/>',
                               '<xsl:value-of select="$locale"/>',
                               o.object_ID,
                               0,
                               to_date('1900-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')
                 from octl o
                left outer join (SELECT * FROM customer_locale_export WHERE CUSTOMER_ID='<xsl:value-of select="$channel"/>' AND LOCALE = '<xsl:value-of select="$locale"/>') cle
                   on cle.ctn=O.OBJECT_ID
                  and cle.locale = o.localisation
                where o.content_type = 'RangeText'
                  and o.localisation = '<xsl:value-of select="$locale"/>'
                  and o.status != 'PLACEHOLDER'      
                  and cle.ctn is null
            </xsl:otherwise>                           
          </xsl:choose>
        </sql:query>
      </sql:execute-query>      
      <!-- Set flag to 1 if the last export was before the last modified date -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          <xsl:choose>
            <xsl:when test="$locale = 'MASTER'">        
              UPDATE CUSTOMER_LOCALE_EXPORT cle
              set 
                FLAG=1
              where customer_id = '<xsl:value-of select="$channel"/>'
              and locale = '<xsl:value-of select="$locale"/>'
              and ctn in 
              (
               select distinct o.object_id
                 from octl o
                where o.content_type = 'RangeText_Raw'     
                  and o.status != 'PLACEHOLDER'   
              <xsl:if test="not($fullexport = 'yes')">
                  and (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
              </xsl:if>                                                       
              )
            </xsl:when>
            <xsl:otherwise>
              UPDATE CUSTOMER_LOCALE_EXPORT cle
              set 
                FLAG=1
              where customer_id = '<xsl:value-of select="$channel"/>'
              and locale = '<xsl:value-of select="$locale"/>'
              and ctn in 
              (
               select distinct o.object_id
                 from octl o
                where o.content_type = 'RangeText'     
                  and o.status != 'PLACEHOLDER'           
                  and o.localisation = '<xsl:value-of select="$locale"/>'
              <xsl:if test="not($fullexport = 'yes')">                  
                  and (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
              </xsl:if>                                                       
              )            
            </xsl:otherwise>                           
          </xsl:choose>            
        </sql:query>
      </sql:execute-query>
    <!-- -->
    </root>
</xsl:template>
</xsl:stylesheet>