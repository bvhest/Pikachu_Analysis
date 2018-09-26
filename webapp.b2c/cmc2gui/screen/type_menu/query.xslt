<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>

  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
SELECT   ID, cts.content_type,
         CASE
            WHEN cts.COUNT = 1
               THEN ct.content_type
            ELSE ct.content_type || ' (' || cts2.description || ')'
         END AS description
    FROM content_types ct
         INNER JOIN
         (SELECT   cts.content_type, COUNT (*) COUNT
              FROM content_types ct INNER JOIN content_type_schedule cts ON ct.content_type = cts.content_type
          GROUP BY cts.content_type
            HAVING COUNT (*) > 1
          UNION
          SELECT   cts.content_type, COUNT (*) COUNT
              FROM content_types ct INNER JOIN content_type_schedule cts ON ct.content_type = cts.content_type
          GROUP BY cts.content_type
            HAVING COUNT (*) = 1) cts ON ct.content_type = cts.content_type
         INNER JOIN content_type_schedule cts2 ON ct.content_type = cts2.content_type
ORDER BY UPPER (ct.content_type)
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>