<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >

  <xsl:param name="userID" />
  <xsl:param name="ctnRestriction" select="''"/>
  <xsl:param name="since" />
  
  <xsl:variable name="apos">'</xsl:variable>

  <xsl:template match="/root">
    <root>
      <products>    
          <xsl:variable name="ctns" select="replace($ctnRestriction, 
                                                    ',', 
                                                    concat($apos, ',', $apos)
                                            )"/>
	      <sql:execute-query>
	        <sql:query>
	          select object_id ctn, lastmodified_ts lastmodifieddate
	          from octl
	          where content_type='PMS'
	          and localisation='none' 
	          and lastmodified_ts &gt; to_date('<xsl:value-of select="$since"/>','yyyy-mm-dd"T"hh24:mi:ss')
	          <xsl:if test="$ctns != ''">
                and object_id in ('<xsl:value-of select="$ctns"/>')  
              </xsl:if>
              order by lastmodified_ts desc, object_id asc
	        </sql:query>
	      </sql:execute-query>
	  </products>
    </root>
  </xsl:template>
</xsl:stylesheet>
