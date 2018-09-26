<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>

  <xsl:template match="/">
  <root>
    <xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        select ll.locale
             , ll.languagecode
             , ll.country
             , ll.ccr_language_code
             , ll.ccr_language_name
             , lt.division
             , decode(lt.isdirect,1,'No','Yes') istranslated
             , decode(lt.enabled,1,'Yes','No') enabled 
             , lt.enabled
             , decode(ll.islatin,1,'Yes','No') islatin
         from locale_language ll 
        inner join language_translations lt 
           on ll.locale =lt.locale
        order by ll.locale, lt.division
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>