<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:import href="../service-base.xsl"/>
  
  <xsl:template match="/root">
    <root>
      <sql:execute-query>
        <sql:query>

select ll.locale, 
       ll.languagecode as languagefamily,
       ll.ccr_language_code as languagecode, 
       ll.ccr_language_name as languagename, 
       ll.country,
       lt.division,
       decode(lt.isdirect,1,0,1) as istranslated,
       decode(lt.enabled,1,1,0) as isenabled
from locale_language ll
inner join language_translations lt on ll.locale = lt.locale
order by locale, division        

        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
