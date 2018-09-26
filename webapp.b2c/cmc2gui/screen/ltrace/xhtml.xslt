<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"></xsl:param>
  <xsl:param name="param2"></xsl:param>
  <xsl:param name="id"></xsl:param>
  <xsl:param name="gui_url"/>
	<xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>	
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="(not ($param1 = '')) and ($param1 != 'yes')">
        <xsl:apply-templates select="/root/sql:rowset"/>
      </xsl:when>
      <xsl:otherwise>  
        <html>
          <body contentID="content">
            <h2>
              <xsl:text>Select a content type first!!</xsl:text>
            </h2>
          </body>
        </html>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
  
	<xsl:template match="sql:rowset">
	    <xsl:variable name="ct" select="$param1"/>
	    <xsl:variable name="l" select="$param2"/>
	    <xsl:variable name="o" select="$id"/>
	    
	    <html>
	      <head>
	        <title>
	          Left trace content_type: <xsl:value-of select="$ct"/> and localisation: <xsl:value-of select="$l"/>
	          <xsl:if test="$o"> and object_id: <xsl:value-of select="$o"/></xsl:if>
	        </title> 	
	      </head>
	      <body>
			<h2>
			Left trace content_type for <xsl:value-of select="$ct"/></h2><hr/>
			Content type: <xsl:value-of select="$ct"/><br/>
			Localisation: <xsl:value-of select="$l"/><br/>
	          <xsl:if test="$o">Object_id: <xsl:value-of select="$o"/></xsl:if>
			  <br/>
	        <table>
	          <tr>
	            <td>
	              <div style="color:rgb(256,256,256);background-color:rgb(175,150,265);border:1px solid black;margin:4px;padding:4px;width:100px;font-family:ariel,helvetica;font-size:10px">
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
	    <xsl:variable name="ct" select="sql:input_content_type"/>
	    <xsl:variable name="l" select="sql:input_localisation"/>
	    <xsl:variable name="o" select="sql:object_id"/>
	    <xsl:variable name="level" select="sql:level"/>
	    <xsl:variable name="np" select="sql:needsprocessing_flag"/>
	    <xsl:variable name="lm" select="sql:lastmodified_ts"/>
	    <xsl:variable name="sec" select="sql:issecundary"/>
	    <xsl:variable name="b1" select="150-($level*25)"/>
	    <xsl:variable name="b2" select="125-($level*25)"/>
	    <xsl:variable name="b3" select="260-($level*25)"/>
	    <tr>
	      <td>
			<xsl:choose>
				<xsl:when test="$np=1">
			        <div style="color:rgb(256,256,256);background-color:rgb(140,140,0);border:1px solid black;margin:4px;padding:4px;width:100px;font-family:ariel,helvetica;font-size:10px">
				        <xsl:value-of select="$ct"/><br/>
				        <xsl:value-of select="$l"/><br/>
				        <xsl:value-of select="$lm"/><br/>
				        <xsl:text>Needs Processing</xsl:text>
						<xsl:apply-templates select="sql:rowset[@name='secondaries']/sql:row"/>
			        </div>
				</xsl:when>
				<xsl:otherwise>
			        <div style="color:rgb(256,256,256);background-color:rgb({$b1},{$b2},{$b3});border:1px solid black;margin:4px;padding:4px;width:100px;font-family:ariel,helvetica;font-size:10px">
				        <xsl:value-of select="$ct"/><br/>
				        <xsl:value-of select="$l"/><br/>
				        <xsl:value-of select="$lm"/><br/>
						<xsl:choose>
							<xsl:when test="sql:dataavailable=1">
								<a style="color:rgb(256,256,256)" target="_default">
									<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/object_store/',sql:content_type, '/', sql:localisation,'/',translate(sql:object_id,'/','_'),'.xml?id=',sql:object_id,'&amp;masterlastmodified_ts=',sql:masterlastmodified_ts,'&amp;lastmodified_ts=',sql:lastmodified_ts)"/></xsl:attribute>
									<xsl:text>Raw </xsl:text>
								</a>
								<a style="color:rgb(256,256,256)" target="_default">
									<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/object_preview/',sql:content_type, '/', sql:localisation,'/',translate(sql:object_id,'/','_'),'.html?id=',sql:object_id,'&amp;masterlastmodified_ts=',sql:masterlastmodified_ts,'&amp;lastmodified_ts=',sql:lastmodified_ts)"/></xsl:attribute>
									<xsl:text>| Preview</xsl:text>
								</a>
								<xsl:apply-templates select="sql:rowset[@name='secondaries']/sql:row"/>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
			        </div>
				</xsl:otherwise>
			</xsl:choose>
			</td>
	      <td>
	        <table>
	          <xsl:apply-templates select="parent::node()/sql:row[sql:level=$level + 1][sql:output_content_type=$ct][sql:output_localisation=$l]"/>
	        </table>
	      </td>
	    </tr>    
  </xsl:template>
  
	<xsl:template match="sql:rowset[@name='secondaries']/sql:row">
		<xsl:variable name="cont" select="sql:input_content_type"/>
		<br/><a style="color:rgb(255,255,0)" target="_default">
			<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/object_store/',$cont, '/', sql:input_localisation,'/',translate(sql:input_object_id,'/','_'),'.xml?id=',sql:input_object_id,'&amp;masterlastmodified_ts=',sql:masterlastmodified_ts,'&amp;lastmodified_ts=',sql:lastmodified_ts)"/></xsl:attribute>
			<xsl:text>Sec: </xsl:text><xsl:value-of select="$cont"/>
		</a>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>