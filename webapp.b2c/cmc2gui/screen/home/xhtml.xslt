<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:me="http://apache.org/a">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:variable name="colorcodeRunning" select="'#00FF00'"/><!--Groen-->
  <xsl:variable name="colorcodeSuspect" select="'#FFA500'"/><!--Oranje-->
  <xsl:variable name="colorcodeError" select="'#FF0000'"/><!--Rood-->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>CMC2 content-type overview</h2>
        <hr/>
        <table class="main">
          <tr>
             <td width="300">Name</td>
             <td width="300">Type</td>
             <td width="170">StartExec</td>
             <td width="170">EndExec</td>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sql:row">
    <tr>
      <td>
        <a>
        <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'section/cmc2/log_dir/',sql:content_type,'/logs/',sql:idreal)"/></xsl:attribute>
        <xsl:value-of select="sql:content_type"/>
        </a>
      </td>      
      <td>
        <xsl:value-of select="concat(sql:description, ' / ', if (contains(sql:machineaffinity, '(') )
                                                    then ( substring-before(sql:machineaffinity, '(') )
                                                    else sql:machineaffinity )"/>
      </td>      
      <td>
		<xsl:variable name="checkDuration">
			<xsl:if test="sql:startexec2 &gt; sql:endexec2">
				<xsl:value-of select="me:compDuration(sql:minutes_duration, sql:avg_runtime, sql:max_runtime)"/>
			</xsl:if>
		</xsl:variable>
        <xsl:choose>
           <xsl:when test="$checkDuration='error'">
            <xsl:attribute name="bgcolor" select="$colorcodeError"/>
          </xsl:when>
         <xsl:when test="$checkDuration='suspect'">
            <xsl:attribute name="bgcolor" select="$colorcodeSuspect"/>
          </xsl:when>
          <xsl:when test="$checkDuration='correct'">
            <xsl:attribute name="bgcolor" select="$colorcodeRunning"/>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="sql:startexec"/>
      </td>
      <td>
        <xsl:value-of select="sql:endexec"/>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:function name="me:strip" as="xs:string">
    <xsl:param name="d"/>
    <xsl:value-of select="translate(translate(translate(translate(substring($d,1,19),'-',''),'T',''),':',''),' ','')"/>
  </xsl:function>
  <!-- -->
  <xsl:function name="me:compDate" as="xs:boolean">
    <xsl:param name="dt_a" as="xs:string"/>
    <xsl:param name="dt_b" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="me:strip($dt_a) &gt; me:strip($dt_b)">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <!-- -->
  <xsl:function name="me:compDuration" as="xs:string">
    <xsl:param name="dur" as="xs:string"/>
    <xsl:param name="avg_dur" as="xs:string"/>
    <xsl:param name="max_dur" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="number($dur) > number($max_dur)">
        <xsl:value-of select="'error'"/>
      </xsl:when>
      <xsl:when test="(number($dur) * 1.5) > number($avg_dur)">
        <xsl:value-of select="'suspect'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'correct'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
