<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:me="http://apache.org/a">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="id"/>
    <xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>	
	<xsl:param name="param1" select="search"/>
	<!-- -->
	<xsl:template match="/" priority="7">
		<xsl:apply-templates/>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root" priority="10">
		<html>
			<body contentID="content">
      <script language="javascript">
        function togglecolumn(id)
        {
          var collapsedcol = document.getElementById(id + '_collapsed');
          var expandedcol = document.getElementById(id + '_expanded');
          if(collapsedcol.style.display != 'none')
          {
            collapsedcol.style.display = 'none';
            expandedcol.style.display = 'block';
          }
          else
          {
            collapsedcol.style.display = 'block';
            expandedcol.style.display = 'none';
          }          
        }
      </script>
				<h2>New Pikachu CTN Search</h2>
				<hr/>
				<form method="POST" enctype="multipart/form-data">
					<xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_id_post/', $param1)"/></xsl:attribute>
					<table>
						<tr>
							<td style="width: 140px">CTN Part<br/>At least 3 characters</td>
							<td style="width: 205px">
								<xsl:choose>
									<xsl:when test="string-length($id) = 0">
										<input name="SearchID" size="60" type="text" value="{@id}"/>
									</xsl:when>
									<xsl:otherwise>
										<input name="SearchID" size="60" type="text" value="{$id}"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<!--
			<tr>
              <td style="width: 140px">Locale</td>
              <td style="width: 205px">
                <input name="Locale" size="60" type="text" value="Master"/>
              </td>
            </tr>
			-->
						<tr>
							<td style="width: 140px"/>
							<td style="width: 205px"/>
						</tr>
						<tr>
							<td style="width: 140px">
								<input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
							</td>
							<td style="width: 205px"/>
						</tr>
					</table>
				</form>
				<br/><br/>
				<h2>Pikachu Status Result</h2>
				<hr/><br/>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'status']">
		<h2>Status overview: <xsl:value-of select="sql:row[1]/sql:object_id"/></h2>
		<table>
    <colgroup>
    <col/>
    <col id="catalog_expanded" span="7" style="background-color:#FFFF99; display:none"/>
    <col id="catalog_collapsed" span="1" style="background-color:#FFFF99"/>        
    <col id="pmtraw_expanded" span="6" style="background-color:#CFF; display:none"/>        
    <col id="pmtraw_collapsed" span="1" style="background-color:#CFF"/>            
    <col id="pmtenriched_expanded" span="6" style="background-color:#CFC; display:none"/>        
    <col id="pmtenriched_collapsed" span="1" style="background-color:#CFC"/>    
    <col id="pmtlocalised_expanded" span="6" style="background-color:#CFF; display:none"/>        
    <col id="pmtlocalised_collapsed" span="1" style="background-color:#CFF"/>    
    <col id="pmttranslated_expanded" span="7" style="background-color:#CFC; display:none"/>        
    <col id="pmttranslated_collapsed" span="1" style="background-color:#CFC"/>        
    <col id="pmt_expanded" span="6" style="background-color:#CFF; display:none"/>        
    <col id="pmt_collapsed" span="1" style="background-color:#CFF"/>        
    <col id="exportchannels_collapsed" span="1" style="background-color:#FCF"/>            
    <col id="exportchannels_expanded" span="2" style="background-color:#FCF; display:none"/>        
    </colgroup>
			<tr style="background-image:url('/cmc2gui/themes/images/bg_nav.gif');
	               background-position: 0px -3px;
	               font-weight: bold;
	               height: 30px">
           <td style="background-image:none"/>
<td colspan="7" style="text-align:center">Catalog&#160;Data&#160;<a href="javascript:togglecolumn('catalog')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>
<td colspan="1" style="text-align:center">Catalog&#160;Data&#160;<a href="javascript:togglecolumn('catalog')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>
<td colspan="6" style="text-align:center">PMT_Raw&#160;<a href="javascript:togglecolumn('pmtraw')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>           
<td colspan="1" style="text-align:center">PMT_Raw&#160;<a href="javascript:togglecolumn('pmtraw')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
<td colspan="6" style="text-align:center">PMT_Enriched&#160;<a href="javascript:togglecolumn('pmtenriched')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>
<td colspan="1" style="text-align:center">PMT_Enriched&#160;<a href="javascript:togglecolumn('pmtenriched')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
<td colspan="6" style="text-align:center">PMT_Localised&#160;<a href="javascript:togglecolumn('pmtlocalised')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>
<td colspan="1" style="text-align:center">PMT_Localised&#160;<a href="javascript:togglecolumn('pmtlocalised')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
<td colspan="7" style="text-align:center">PMT_Translated&#160;<a href="javascript:togglecolumn('pmttranslated')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>           
<td colspan="1" style="text-align:center">PMT_Translated&#160;<a href="javascript:togglecolumn('pmttranslated')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
<td colspan="6" style="text-align:center">PMT&#160;<a href="javascript:togglecolumn('pmt')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>           
<td colspan="1" style="text-align:center">PMT&#160;<a href="javascript:togglecolumn('pmt')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
<td colspan="1" style="text-align:center">Export&#160;Channels&#160;<a href="javascript:togglecolumn('exportchannels')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
<td colspan="2" style="text-align:center">Export&#160;Channels&#160;<a href="javascript:togglecolumn('exportchannels')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>           
      </tr>                 
                 
	<tr style="background-image:url('/cmc2gui/themes/images/bg_nav.gif');
	               background-position: 0px -3px;
	               font-weight: bold;
	               height: 30px">

<td>Locale</td>
<td>Division<a href="javascript:return false" title="This is the catalog division for this product">?</a></td>
<td>Legacy<br/>Division<a href="javascript:return false" title="This is the legacy division for this product">?</a></td>
<td>Country<a href="javascript:return false" title="This is the country of assignment">?</a></td>
<td>SOP<a href="javascript:return false" title="This is the *earliest* Start of Publication date across all catalog assignments for the row's country">?</a></td>
<td>EOP<a href="javascript:return false" title="This is the *latest* End of Publication date across all catalog assignments for the row's country">?</a></td>
<td>Deleted<a href="javascript:return false" title="If this is 0, then at least one catalog assignment for this product/country has deleted = false.  If 1, then all assignments have deleted = true">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date of the most recent catalog assignment for this product/country">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date of the most recent catalog assignment for this product/country">?</a></td>
<td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
<td>Content<a href="javascript:return false" title="Click for either raw xml content or preview content (no content will be available when status = 'PLACEHOLDER')">?</a></td>
<td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
<td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
<td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
<td>Content<a href="javascript:return false" title="Click for either raw xml content or preview content (no content will be available when status = 'PLACEHOLDER')">?</a></td>
<td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
<td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
<td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
<td>Content<a href="javascript:return false" title="Click for either raw xml content or preview content (no content will be available when status = 'PLACEHOLDER')">?</a></td>
<td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
<td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
<td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
<td>Content<a href="javascript:return false" title="Click for either raw xml content or preview content (no content will be available when status = 'PLACEHOLDER')">?</a></td>
<td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
<td>Remark<a href="javascript:return false" title="If status = 'AwaitingTranslationImport', this contains the name of the file most recently exported.  If status = 'Final Published', this contains the name of the file most recently imported.">?</a></td>
<td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
<td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
<td>Content<a href="javascript:return false" title="Click for either raw xml content or preview content (no content will be available when status = 'PLACEHOLDER')">?</a></td>
<td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
<td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
<td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
<td>ATG Export<br/>Last&#160;Transmit<a href="javascript:return false" title="Date of last export to ATG">?</a></td>
<td>ATG Export<br/>Last&#160;Transmit<a href="javascript:return false" title="Date of last export to ATG">?</a></td>
<td>Rendering&#160;Export<br/>Last&#160;Transmit<a href="javascript:return false" title="Date of last export to Rendering">?</a></td>

			</tr>
			<xsl:apply-templates/>
		</table>
		<p> </p>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'status']/sql:row">
		<tr>
			<td><xsl:value-of select="concat(sql:country,'&#160;[',sql:locale,']')"/></td>
<td><xsl:value-of select="sql:division"/></td>
<td><xsl:value-of select="sql:legacydivision"/></td>
<td><xsl:value-of select="sql:country"/></td>
<td><xsl:if test="sql:soppass = '0'">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if><xsl:value-of select="sql:sop"/></td>
<td><xsl:if test="sql:eoppass = '0'">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if><xsl:value-of select="sql:eop"/></td>
<td>
<xsl:if test="sql:deleted = 1">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:deleted"/>
</td>
<td>
<xsl:value-of select="substring(sql:cobjlastmodified,1,19)"/>
</td>
<td>
<xsl:value-of select="substring(sql:cobjlastmodified,1,19)"/>
</td>

<td><xsl:value-of select="sql:raw_l"/></td>
					<td>
						<xsl:choose>
							<xsl:when test="sql:rawstatus!='PLACEHOLDER'">
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          , 'xmlraw/object_store/'
                                                                          , 'PMT_Raw'
                                                                          , '/'
                                                                          , sql:raw_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.xml?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:rawmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:rawlm,1,19),' ','T'))"/></xsl:attribute>
									<xsl:text>Raw&#160;XML&#160;</xsl:text>
								</a>
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          ,'icp/object_preview/'
                                                                          , 'PMT_Raw'
                                                                          , '/'
                                                                          , sql:raw_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.html?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:rawmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:rawlm,1,19),' ','T'))"/></xsl:attribute>
									<xsl:text>|&#160;Preview</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</td>
<td><xsl:if test="sql:rawstatus = 'PLACEHOLDER'">
  <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:rawstatus"/></td>
<td><xsl:if test="sql:rawnpf = 1">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:rawnpf"/></td>
<td><xsl:value-of select="if(substring(sql:rawmlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:rawmlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:rawlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:rawlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:rawlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:rawlm,1,19)"/></td>
<td><xsl:value-of select="sql:enriched_l"/></td>
					<td>
						<xsl:choose>
							<xsl:when test="sql:enrichedstatus!='PLACEHOLDER'">
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          , 'xmlraw/object_store/'
                                                                          , 'PMT_Enriched'
                                                                          , '/'
                                                                          , sql:enriched_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.xml?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:enrichedmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:enrichedlm,1,19),' ','T'))"/></xsl:attribute>
									<xsl:text>Raw&#160;XML&#160;</xsl:text>
								</a>
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          ,'icp/object_preview/'
                                                                          , 'PMT_Enriched'
                                                                          , '/'
                                                                          , sql:enriched_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.html?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:enrichedmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:enrichedlm,1,19),' ','T'))"/></xsl:attribute>
                  <xsl:text>|&#160;Preview</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</td>
<td><xsl:if test="sql:enrichedstatus = 'PLACEHOLDER'">
  <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:enrichedstatus"/>
</td>
<td><xsl:if test="sql:enrichednpf = 1">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:enrichednpf"/></td>
<td><xsl:value-of select="if(substring(sql:enrichedmlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:enrichedmlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:enrichedlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:enrichedlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:enrichedlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:enrichedlm,1,19)"/></td>
<td><xsl:value-of select="sql:localised_l"/></td>
					<td>
						<xsl:choose>
							<xsl:when test="sql:localisedstatus!='PLACEHOLDER'">
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          , 'xmlraw/object_store/'
                                                                          , 'PMT_Localised'
                                                                          , '/'
                                                                          , sql:localised_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.xml?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:localisedmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:localisedlm,1,19),' ','T'))"/></xsl:attribute>
									<xsl:text>Raw&#160;XML&#160;</xsl:text>
								</a>
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          ,'icp/object_preview/'
                                                                          , 'PMT_Localised'
                                                                          , '/'
                                                                          , sql:localised_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.html?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:localisedmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:localisedlm,1,19),' ','T'))"/></xsl:attribute>
                  <xsl:text>|&#160;Preview</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</td>
<td><xsl:if test="sql:localisedstatus = 'PLACEHOLDER'">
  <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:localisedstatus"/></td>
<td><xsl:if test="sql:localisednpf = 1">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:localisednpf"/></td>
<td><xsl:value-of select="if(substring(sql:localisedmlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:localisedmlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:localisedlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:localisedlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:localisedlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:localisedlm,1,19)"/></td>
<td><xsl:value-of select="sql:translated_l"/></td>
					<td>
						<xsl:choose>
							<xsl:when test="sql:translatedstatus!='PLACEHOLDER'">
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          , 'xmlraw/object_store/'
                                                                          , 'PMT_Translated'
                                                                          , '/'
                                                                          , sql:translated_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.xml?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:translatedmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:translatedlm,1,19),' ','T'))"/></xsl:attribute>
									<xsl:text>Raw&#160;XML&#160;</xsl:text>
								</a>
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          ,'icp/object_preview/'
                                                                          , 'PMT_Translated'
                                                                          , '/'
                                                                          , sql:translated_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.html?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:translatedmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:translatedlm,1,19),' ','T'))"/></xsl:attribute>
                  <xsl:text>|&#160;Preview</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</td>
<td><xsl:if test="sql:translatedstatus = 'PLACEHOLDER'">
  <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
</xsl:if>
<xsl:if test="sql:translatedstatus = 'AwaitingTranslationImport'">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if><xsl:value-of select="sql:translatedstatus"/></td>
<td><xsl:value-of select="sql:remark"/></td>
<td><xsl:if test="sql:translatednpf = 1">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:translatednpf"/></td>
<td><xsl:value-of select="if(substring(sql:translatedmlm,1,19) = '1900-01-01 00:00:00') then '' else sql:translatedmlm,1,19"/></td>
<td><xsl:value-of select="if(substring(sql:translatedlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:translatedlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:translatedlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:translatedlm,1,19)"/></td>
<td><xsl:value-of select="sql:pmt_l"/></td>
					<td>
						<xsl:choose>
							<xsl:when test="sql:translatedstatus!='PLACEHOLDER'">
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          , 'xmlraw/object_store/'
                                                                          , 'PMT'
                                                                          , '/'
                                                                          , sql:pmt_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.xml?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:pmtmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:pmtlm,1,19),' ','T'))"/></xsl:attribute>
									<xsl:text>Raw&#160;XML&#160;</xsl:text>
								</a>
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          ,'icp/object_preview/'
                                                                          , 'PMT'
                                                                          , '/'
                                                                          , sql:pmt_l
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.html?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:pmtmlm,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:pmtlm,1,19),' ','T'))"/></xsl:attribute>
                  <xsl:text>|&#160;Preview</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</td>
<td><xsl:if test="sql:pmtstatus = 'PLACEHOLDER'">
  <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
</xsl:if><xsl:value-of select="sql:pmtstatus"/></td>
<td><xsl:if test="sql:pmtnpf = 1">
  <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
</xsl:if>
<xsl:value-of select="sql:pmtnpf"/></td>
<td><xsl:value-of select="if(substring(sql:pmtmlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pmtmlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:pmtlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pmtlm,1,19)"/></td>
<td><xsl:value-of select="if(substring(sql:pmtlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pmtlm,1,19)"/></td>
<td>
  <xsl:choose>
    <xsl:when test="sql:atgexportenableflag=0"><xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute><xsl:value-of select="'Locale/div not exported to ATG'"/></xsl:when>
    <xsl:when test="sql:atgexportenableflag=1 and sql:atglastexport = ''"><xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>Not exported</xsl:when>
    <xsl:otherwise><xsl:value-of select="substring(sql:atglastexport,1,19)"/></xsl:otherwise>
  </xsl:choose>
</td>
<td>
  <xsl:choose>
    <xsl:when test="sql:atgexportenableflag=0"><xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute><xsl:value-of select="'Locale/div not exported to ATG'"/></xsl:when>
    <xsl:when test="sql:atgexportenableflag=1 and sql:atglastexport = ''"><xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>Not exported</xsl:when>
    <xsl:otherwise><xsl:value-of select="substring(sql:atglastexport,1,19)"/></xsl:otherwise>
  </xsl:choose>
</td>

<td>
  <xsl:choose>
    <xsl:when test="sql:renexportenableflag=0"><xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute><xsl:value-of select="'Locale/div not exported to Rend.'"/></xsl:when>
    <xsl:when test="sql:renexportenableflag=1 and sql:renlastexport = ''"><xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>Not exported</xsl:when>
    <xsl:otherwise><xsl:value-of select="substring(sql:renlastexport,1,19)"/></xsl:otherwise>
  </xsl:choose>
</td>		
</tr>
	</xsl:template>
	<!-- -->
	<!--xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template-->
	<!-- -->
</xsl:stylesheet>
