<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
  <xsl:template match="/root">
    <root xmlns:cinclude="http://apache.org/cocoon/include/1.0">
      <xsl:variable name="derivedcategorization_id"         select="sql:rowset/sql:row[sql:content_type = 'DerivedCategorization']/sql:id"/>
      <cinclude:include src="cocoon://cmc2/content_type/DerivedCategorization?schedule_id={$derivedcategorization_id}"/>
    </root>
  </xsl:template>
</xsl:stylesheet>
