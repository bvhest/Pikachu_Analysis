<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:template match="sql:rowset">
    <xsl:variable name="ct" select="sql:row[sql:level=1][1]/sql:input_content_type"/>
    <xsl:variable name="l" select="sql:row[sql:level=1][1]/sql:input_localisation"/>
    <xsl:variable name="o" select="sql:row[sql:level=1][1]/sql:object_id"/>
    
    <html>
      <head>
        <title>
          Reverse trace for content_type: <xsl:value-of select="$ct"/> and localisation: <xsl:value-of select="$l"/>
          <xsl:if test="$o"> and object_id: <xsl:value-of select="$o"/></xsl:if>
        </title> 
      </head>
      <body>
        <table>
          <tr>
            <td>
              <div style="border:1px solid black;margin:4px;padding:4px;width:120px;font-family:ariel,helvetica;font-size:10px">
              <xsl:if test="$o"><xsl:value-of select="$o"/><br/></xsl:if>
              <xsl:value-of select="$ct"/><br/>
              <xsl:value-of select="$l"/><br/>
              </div>
            </td>
            <td>
              <table>
                <xsl:apply-templates select="sql:row[sql:level=1]"/>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <xsl:variable name="ct" select="sql:output_content_type"/>
    <xsl:variable name="l" select="sql:output_localisation"/>
    <xsl:variable name="o" select="sql:object_id"/>
    <xsl:variable name="level" select="sql:level"/>
    <xsl:variable name="np" select="sql:needsprocessing_flag"/>
    <xsl:variable name="b" select="256-($level*16)"/>
    <tr>
      <td>
        <div style="background-color:rgb({$b},{$b},{$b});border:1px solid black;margin:4px;padding:4px;width:120px;font-family:ariel,helvetica;font-size:10px">
        <xsl:if test="$o"><xsl:value-of select="$o"/><br/></xsl:if>
        <xsl:value-of select="$ct"/><br/>
        <xsl:value-of select="$l"/><br/>
        <xsl:if test="$np=1"><img alt="Needs processing" src="resources/checkmark.jpg"/></xsl:if>
        </div>
      </td>
      <td>
        <table>
          <xsl:apply-templates select="parent::node()/sql:row[sql:level=$level + 1][sql:input_content_type=$ct][sql:input_localisation=$l]"/>
        </table>
      </td>
    </tr>    
  </xsl:template>
  
  <xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>