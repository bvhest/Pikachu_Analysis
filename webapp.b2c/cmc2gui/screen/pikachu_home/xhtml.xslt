<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:me="http://apache.org/a">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <!-- -->
  <xsl:variable name="colorcodeRunning" select="'#00FF00'"/><!--Groen-->
  <xsl:variable name="colorcodeSuspect" select="'#FFA500'"/><!--Oranje-->
  <xsl:variable name="colorcodeError" select="'#FF0000'"/><!--Rood-->
  <xsl:variable name="colorcodeWarning" select="'#FF00FF'"/><!--Magenta-->
  <xsl:variable name="sectionurl">
      <xsl:choose>
         <xsl:when test="$section and $section='home'">
            <xsl:value-of select="'section/pikachu/'"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('section/', $section, '/')"/>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>	  
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>Pika-Chu <xsl:value-of select="if($section=('pikachu','home')) then '' else concat($section,' ')"/>channel overview</h2>
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
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_log_dir/', sql:location, '/logs')"/></xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'section/pikachu', '/pikachu_log_dir/', sql:location, '/logs')"/></xsl:attribute>
          <xsl:value-of select="sql:name"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="concat(sql:type, ' / ', if (contains(sql:machineaffinity, '(') )
                                                    then ( substring-before(sql:machineaffinity, '(') )
                                                    else sql:machineaffinity )"/>
      </td>
      <td>
  		<xsl:variable name="checkDuration">
			<xsl:if test="sql:startexec2 > sql:endexec2">
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
    		<xsl:choose>
    			<xsl:when test="sql:resultcode = 0">          
				  </xsl:when>
				  <xsl:otherwise>
					<xsl:attribute name="bgcolor" select="$colorcodeWarning"/>
				  </xsl:otherwise>              
				</xsl:choose>
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
      <xsl:when test="me:strip($dt_a) > me:strip($dt_b)">
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
