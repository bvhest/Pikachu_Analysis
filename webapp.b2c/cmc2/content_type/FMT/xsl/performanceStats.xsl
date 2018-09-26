<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ts"/>
  <xsl:template match="/">
    <xsl:variable name="endts" select="//sql:rowset/sql:row/sql:end"/>
    <entries ts="{concat(substring($ts,1,8),'T',substring($ts,9,6))}">      
      <entry includeinreport='yes'>    
        <xsl:variable name="start" select="xs:dateTime(concat( substring($ts,1,4)
                                                                ,'-'
                                                                ,substring($ts,5,2)
                                                                ,'-'
                                                                ,substring($ts,7,2)
                                                                ,'T'
                                                                ,substring($ts,9,2)
                                                                ,':'
                                                                ,substring($ts,11,2)
                                                                ,':'
                                                                ,substring($ts,13,2)))" as="xs:dateTime"/>            

        <xsl:variable name="end" select="xs:dateTime(concat( substring($endts,1,4)
                                                                ,'-'
                                                                ,substring($endts,5,2)
                                                                ,'-'
                                                                ,substring($endts,7,2)
                                                                ,'T'
                                                                ,substring($endts,9,2)
                                                                ,':'
                                                                ,substring($endts,11,2)
                                                                ,':'
                                                                ,substring($endts,13,2)))" as="xs:dateTime"/>      
        <xsl:variable name="elapsed" select="$end - $start"/>
        <xsl:variable name="elapsed_sec" select="$elapsed div xdt:dayTimeDuration('PT1S')"/>
  			<start><xsl:value-of select="$start"/></start>
        <end><xsl:value-of select="$end"/></end>      
        <count><xsl:value-of select="//sql:rowset/sql:row/sql:count"/></count>
        <elapsed_sec><xsl:value-of select="$elapsed_sec"/></elapsed_sec>
        <avgrate><xsl:value-of select="number($elapsed_sec) div number(//sql:rowset/sql:row/sql:count)" as="xs:decimal"/></avgrate>        
      </entry>
    </entries>
  </xsl:template>
</xsl:stylesheet>