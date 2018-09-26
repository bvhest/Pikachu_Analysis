<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="exportdate"/>
	<xsl:param name="param1"/>
	<xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>		
	<!-- -->
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Translation Status Detail for <xsl:value-of select="$param1"/>
				</h2>
				<hr/>                 
				<table class="small main">        
					<tr class="header">
						<td>CTN</td>            						
            <!--<td>Division</td>                                    -->
						<td>Search</td>
						<td>Translation Files</td>
						<td>PMT_Localised LastModified</td>            
						<td>PMT_Translated MasterLastModified</td>						
            <td>PMT_Translated LastModified</td>
						<td>PMT_Translated NeedsProcessingFlag</td>            
						<td>PMT_Translated Status</td>                        
					</tr>
					<xsl:apply-templates/>          
				</table>          
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:row">
		<tr class="{if (position() mod 2 = 0) 'even' else 'odd'}">
			<td>
				<a target="_blank" title="Click to retrieve PMT_Translated raw xml">
					<xsl:attribute name="href">
            <xsl:value-of select="concat(   $gui_url
                                          , 'xmlraw/object_store/'
                                          , 'PMT_Translated'
                                          , '/'
                                          , sql:translocale
                                          , '/'
                                          , translate(sql:object_id,'/','_')
                                          , '.xml?id='
                                          , sql:object_id
                                          , '&amp;masterlastmodified_ts='
                                          , sql:translatedmlm
                                          , '&amp;lastmodified_ts='
                                          , sql:translatedlm)
            "/>                              
          
          <!--<xsl:value-of select="concat($gui_url,'icp/pikachu_product_nice/nor_product/','master','/',translate(sql:ctn,'/','_'),'.html?id=',sql:ctn)"/>-->          
          
          </xsl:attribute>
					<xsl:value-of select="sql:object_id"/>
				</a>
			</td>
      <!--
			<td>
				<xsl:value-of select="sql:division"/>
			</td>      
      -->
			<td>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,$sectionurl,'section/home/pikachu_search_post/search?id=',sql:object_id)"/></xsl:attribute>
					Search
				</a>
			</td>
			<td>
      <table>
      <tr><td>
          		<a target="_blank">
          		<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'pals_get_file/upload/',sql:teremark,'?file=',sql:teremark)"/></xsl:attribute>
          		<xsl:value-of select="concat('Export file: ', sql:teremark)"/>
          		</a>	
      </td></tr>		
      <tr><td>
        <xsl:choose>
          <xsl:when test="sql:transstatus='Final Published' and string-length(sql:teremark) &gt; 0">
          		<a target="_blank">
          		<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'pals_get_file/download/',sql:teremark,'?file=',sql:teremark)"/></xsl:attribute>
          		<xsl:value-of select="concat('Import file: ', sql:teremark)"/>
          		</a>			
           </xsl:when>
        <xsl:otherwise/>
        </xsl:choose>      
      </td></tr>
      </table>
      </td>
			<td>
				<xsl:choose>
					<xsl:when test="sql:localisedlm gt sql:translatedmlm">
						<xsl:attribute name="bgcolor">#FF0000</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="sql:localisedlm"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="sql:localisedlm gt sql:translatedmlm">
						<xsl:attribute name="bgcolor">#FF0000</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="sql:translatedmlm"/>
			</td>
			<td>
				<xsl:value-of select="sql:translatedlm"/>
			</td>      
			<td>
				<xsl:value-of select="sql:needsprocessing_flag"/>
			</td>
			<td>
				<xsl:value-of select="sql:transstatus"/>
			</td>      
		</tr>
	</xsl:template>
</xsl:stylesheet>
