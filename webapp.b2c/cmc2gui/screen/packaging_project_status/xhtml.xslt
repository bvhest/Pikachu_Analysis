<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:me="http://apache.org/a">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="id"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl" select="if ($section ne '') then concat('section/', $section, '/') else ''"/>
	<xsl:param name="param1" select="search"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="/root">
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
				<h2>Project status for <xsl:value-of select="$id"/></h2>
				<hr/>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset">
		<table>
    <colgroup>
    <col/>
    <col id="ppconf_expanded" span="5" style="background-color:#CCDAFF; display:none"/>        
    <col id="ppconf_collapsed" span="1" style="background-color:#CCDAFF"/>            
    <col id="pplog_expanded" span="5" style="background-color:#ECFFB3; display:none"/>        
    <col id="pplog_collapsed" span="1" style="background-color:#ECFFB3"/>        
    <col id="ptextraw_expanded" span="5" style="background-color:#CCDAFF; display:none"/>        
    <col id="ptextraw_collapsed" span="1" style="background-color:#CCDAFF"/>    
    <col id="ptexttrans_expanded" span="5" style="background-color:#ECFFB3; display:none"/>        
    <col id="ptexttrans_collapsed" span="1" style="background-color:#ECFFB3"/>    
    <col id="pptrans_expanded" span="5" style="background-color:#CCDAFF; display:none"/>        
    <col id="pptrans_collapsed" span="1" style="background-color:#CCDAFF"/>        
    </colgroup>
		<tr style="background-image:url('/cmc2gui/themes/images/bg_nav.gif');
               background-position: 0px -3px;
               font-weight: bold;
               height: 30px">
      <td style="background-image:none"/>
      <td colspan="5" style="text-align:center">Configuration&#160;<a href="javascript:togglecolumn('ppconf')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>           
      <td colspan="1" style="text-align:center">Configuration&#160;<a href="javascript:togglecolumn('ppconf')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
      <td colspan="5" style="text-align:center">Log&#160;<a href="javascript:togglecolumn('pplog')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>
      <td colspan="1" style="text-align:center">Log&#160;<a href="javascript:togglecolumn('pplog')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
      <td colspan="5" style="text-align:center">Raw&#160;texts&#160;<a href="javascript:togglecolumn('ptextraw')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>
      <td colspan="1" style="text-align:center">Raw&#160;texts&#160;<a href="javascript:togglecolumn('ptextraw')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
      <td colspan="5" style="text-align:center">Translated&#160;texts&#160;<a href="javascript:togglecolumn('ptexttrans')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>           
      <td colspan="1" style="text-align:center">Translated&#160;texts&#160;<a href="javascript:togglecolumn('ptexttrans')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
      <td colspan="5" style="text-align:center">Project&#160;translations&#160;<a href="javascript:togglecolumn('pptrans')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>           
      <td colspan="1" style="text-align:center">Project&#160;translations&#160;<a href="javascript:togglecolumn('pptrans')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>           
    </tr>                 
  	<tr style="background-image:url('/cmc2gui/themes/images/bg_nav.gif');
  	               background-position: 0px -3px;
  	               font-weight: bold;
  	               height: 30px">
      <td>Locale</td>
      
      <td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
      <td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
      <td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
      <td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>

      <td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
      <td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
      <td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
      <td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>

      <td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
      <td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
      <td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
      <td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>

      <td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
      <td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
      <td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
      <td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>

      <td>Localisation<a href="javascript:return false" title="This is the localisation of the OCTL for the content type under which it falls">?</a></td>
      <td>Status<a href="javascript:return false" title="This is the status of the OCTL for the content type under which it falls">?</a></td>
      <td>NeedsProcessing<a href="javascript:return false" title="This indicates whether the OCTL needs processing">?</a></td>
      <td>MasterLastMod<a href="javascript:return false" title="This is the master last modified date (effectively: major version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
      <td>LastModified<a href="javascript:return false" title="This is the last modified date (effectively: minor version) of the OCTL for the content type under which it falls">?</a></td>
    </tr>
		<xsl:apply-templates/>
		</table>
		<p> </p>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'status']/sql:row">
		<tr>
      <td><xsl:value-of select="sql:ptext_translated_l"/></td>
      
      <td><xsl:value-of select="sql:ppconf_l"/></td>
      <td><xsl:if test="sql:ppconf_status = 'PLACEHOLDER'">
        <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="sql:ppconf_status"/></td>
      <td><xsl:if test="sql:ppconf_npf = 1">
        <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="sql:ppconf_npf"/></td>
      <td><xsl:value-of select="if(substring(sql:ppconf_mlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:ppconf_mlm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:ppconf_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:ppconf_lm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:ppconf_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:ppconf_lm,1,19)"/></td>
      
      <td><xsl:value-of select="sql:pplog_l"/></td>
      <td><xsl:if test="sql:pplog_status = 'PLACEHOLDER'">
        <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="sql:pplog_status"/>
      </td>
      <td><xsl:if test="sql:pplog_npf = 1">
        <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="sql:pplog_npf"/></td>
      <td><xsl:value-of select="if(substring(sql:pplog_mlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pplog_mlm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:pplog_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pplog_lm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:pplog_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pplog_lm,1,19)"/></td>
      
      <td><xsl:value-of select="sql:ptext_raw_l"/></td>
      <td><xsl:if test="sql:ptext_raw_status = 'PLACEHOLDER'">
        <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="sql:ptext_raw_status"/></td>
      <td><xsl:if test="sql:ptext_raw_npf = 1">
        <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="sql:ptext_raw_npf"/></td>
      <td><xsl:value-of select="if(substring(sql:ptext_raw_mlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:ptext_raw_mlm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:ptext_raw_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:ptext_raw_lm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:ptext_raw_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:ptext_raw_lm,1,19)"/></td>
      
      <td><xsl:value-of select="sql:ptext_translated_l"/></td>
      <td><xsl:if test="sql:ptext_translated_status = 'PLACEHOLDER'">
        <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
      </xsl:if><xsl:value-of select="sql:ptext_translated_status"/></td>
      <td><xsl:if test="sql:ptext_translated_npf = 1">
        <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="sql:ptext_translated_npf"/></td>
      <td><xsl:value-of select="if(substring(sql:ptext_translated_mlm,1,19) = '1900-01-01 00:00:00') then '' else sql:ptext_translated_mlm,1,19"/></td>
      <td><xsl:value-of select="if(substring(sql:ptext_translated_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:ptext_translated_lm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:ptext_translated_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:ptext_translated_lm,1,19)"/></td>
      
      <td><xsl:value-of select="sql:pp_translations_l"/></td>
      <td><xsl:if test="sql:pp_translations_status = 'PLACEHOLDER'">
        <xsl:attribute name="bgcolor">#E3E3E3</xsl:attribute>
      </xsl:if><xsl:value-of select="sql:pp_translations_status"/></td>
      <td><xsl:if test="sql:pp_translations_npf = 1">
        <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="sql:pp_translations_npf"/></td>
      <td><xsl:value-of select="if(substring(sql:pp_translations_mlm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pp_translations_mlm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:pp_translations_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pp_translations_lm,1,19)"/></td>
      <td><xsl:value-of select="if(substring(sql:pp_translations_lm,1,19) = '1900-01-01 00:00:00') then '' else substring(sql:pp_translations_lm,1,19)"/></td>
    </tr>
	</xsl:template>
	<!-- -->
	<!--xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template-->
	<!-- -->
</xsl:stylesheet>
