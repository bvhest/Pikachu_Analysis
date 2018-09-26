<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:me="http://apache.org/a" xmlns:h="http://apache.org/cocoon/request/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:param name="SearchContent"/>
  <xsl:variable name="v_gui_url" select="if ($section) then concat($gui_url,'section/', $section, '/') else $gui_url"/>
  
	<xsl:param name="id"/>
	<xsl:param name="param1" select="search"/>
	<xsl:template match="/root">
		<html>
			<body>
      <br/>
      <!--
        <h2>Search for objects by partial object ID</h2><hr/>
				<form method="POST" enctype="multipart/form-data">
					<xsl:attribute name="action"><xsl:value-of select="concat($v_gui_url, 'search_id_post')"/></xsl:attribute>
					<table>
						<tr>
							<td style="width: 140px">Object ID Part<br/>At least 3 characters</td>
							<td style="width: 205px">
								<input name="SearchID" size="60" type="text" value="{$id}"/>
							</td>
						</tr>
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
        -->
        <h2>Retrieve detailed information by exact CTN</h2><hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($v_gui_url, 'search_post/search?id=', @id)"/></xsl:attribute>          
          <table>
            <tr>
              <td style="width: 140px">Enter&#160;an&#160;exact&#160;CTN&#160;to&#160;retrieve<br/>detailed&#160;content&#160;type&#160;and&#160;catalog&#160;info:</td>
              <td style="width: 40px">
                <input name="SearchContent" size="60" type="text" value="{$id}"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px"></td>
              <td style="width: 40px">
              </td>
            </tr>
            <tr>
              <td colspan="2" align="center">
                <input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
              </td>
            </tr>
          </table>
        </form>        
				<br/>
				<br/>
				<h2>Content Search Result</h2>
				<hr/>
				<table cellpadding="0" cellspacing="0">
					<xsl:apply-templates select="/root/sql:rowset[@name = 'search_content']/sql:row"/>
				</table>
        
				<br/>
				<h2>Catalog Search Result</h2>
				<hr/>
				<table cellpadding="0" cellspacing="0">
        
					<xsl:apply-templates select="/root/sql:rowset[@name = 'catalogs']"/>
        
				</table>        
        
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'search_content']/sql:row">
		<tr>
			<td>
				<b>
					<xsl:value-of select="sql:object_id"/> - <xsl:value-of select="sql:content_type"/>
				</b>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="sql:rowset[@name = 'search_content_data']"/>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset[@name = 'search_content_data']">
		<table style="gui_main" cellpadding="0" cellspacing="0">
			<tr>
				<td width="150"><b>Locale</b></td>
				<td width="100"><b>View</b></td>
				<td width="100"><b>Trace</b></td>
				<td width="150"><b>Status</b></td>
				<td width="100"><b>Version</b></td>
				<td width="140"><b>MstrLastMod</b></td>
				<td width="140"><b>LastMod</b></td>
				<td width="80"><b>NeedsProc<br />(Batch)</b></td>
				<td width="80"><b>NeedsProc<br />(FL)</b></td>
				<td width="80"><b>IsLocalized</b></td>        
				<td width="80"><b>Active</b></td>
			</tr>
			<xsl:for-each select="sql:row">
        <xsl:variable name="object_preview" select="if(starts-with(sql:content_type,'Range')) then 'range_preview' else 'object_preview'"/>
				<tr>
					<td>
						<xsl:value-of select="sql:localisation"/>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="sql:dataavailable=1">
								<a target="_default">
									<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/object_store/',sql:content_type, '/', sql:localisation,'/',translate(sql:object_id,'/','_'),'.xml?id=',sql:object_id,'&amp;masterlastmodified_ts=',sql:masterlastmodified_ts,'&amp;lastmodified_ts=',sql:lastmodified_ts)"/></xsl:attribute>
									<xsl:text>Raw </xsl:text>
								</a>
								<a target="_default">
									<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/',$object_preview,'/',sql:content_type, '/', sql:localisation,'/',translate(sql:object_id,'/','_'),'.html?id=',sql:object_id,'&amp;masterlastmodified_ts=',sql:masterlastmodified_ts,'&amp;lastmodified_ts=',sql:lastmodified_ts)"/></xsl:attribute>
									<xsl:text>| Preview</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="sql:dataavailable=1">
								<a target="_default">
									<xsl:attribute name="href"><xsl:value-of select="concat($v_gui_url,'ltrace/',sql:content_type, '/', sql:localisation,'/',translate(sql:object_id,'/','_'),'.html?id=',sql:object_id)"/></xsl:attribute>
									<xsl:text>L </xsl:text>
								</a>
								<a target="_default">
									<xsl:attribute name="href"><xsl:value-of select="concat($v_gui_url,'rtrace/',sql:content_type, '/', sql:localisation,'/',translate(sql:object_id,'/','_'),'.html?id=',sql:object_id)"/></xsl:attribute>
									<xsl:text>| R</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</td>
					<td>
						<xsl:value-of select="sql:status"/>
					</td>
					<td>
						<xsl:value-of select="sql:marketingversion"/>
					</td>
					<td>
						<xsl:value-of select="sql:masterlastmodified_ts"/>
					</td>
					<td>
						<xsl:value-of select="sql:lastmodified_ts"/>
					</td>
					<td>
						<xsl:value-of select="sql:needsprocessing_flag_b"/>
					</td>
					<td>
						<xsl:value-of select="sql:needsprocessing_flag_fl"/>
					</td>
					<td><xsl:attribute name="style"><xsl:value-of select="if(sql:islocalized='1') then 'background-color: #FFAA00' else ()"/></xsl:attribute>
						<xsl:value-of select="sql:islocalized"/>
					</td>          
					<td>
						<xsl:value-of select="sql:active_flag"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
  
  
  
 <xsl:template match="/root/sql:rowset[@name = 'catalogs']">
 <br />
 <xsl:choose>
  <xsl:when test="sql:row">
    <table>
      <tr>
        <td>Product CTN</td>
        <td>Locale</td>
        <td>Catalog</td>
        <td>Consumer site</td>
        <td>PDF</td>
        <td>SOP<br/>EOP<br/>LastModified</td>
        <td>Local going price</td>
        <td>Prio</td>
        <td>Deleted</td>
        <td>Division</td>
      </tr>
      <xsl:apply-templates/>
    </table>
    </xsl:when>
    <xsl:otherwise>
      No catalog assignments found for <xsl:value-of select="$SearchContent"/>
    </xsl:otherwise>    
    </xsl:choose>
    <p> </p>
  </xsl:template>
  <!-- -->
  <!--
  <xsl:template match="/root/sql:rowset[@name = 'category]/sql:row">
    <tr>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product_nice/nor_product/','master','/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
          <xsl:value-of select="sql:id"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="sql:catalogname"/>
      </td>
      <td>
        <xsl:value-of select="sql:groupname"/>
      </td>
      <td>
        <xsl:value-of select="sql:categoryname"/>
      </td>
      <td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'section/home/pikachu_master_subcat_products?subcat=',sql:subcategorycode)"/></xsl:attribute>
          <xsl:value-of select="sql:subcategoryname"/>
        </a>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="/root/sql:rowset[@name = 'data']/sql:row">
    <tr>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product_nice/',sql:urlpart,'/',sql:locale,'/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
          <xsl:value-of select="sql:id"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="sql:data_type"/>
      </td>
      <td>
        <xsl:value-of select="sql:locale"/>
      </td>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product/',sql:urlpart,'/',sql:locale,'/',translate(sql:id,'/','_'),'.xml?id=',sql:id)"/></xsl:attribute>
				xUCDM
			</a>
      </td>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product_broker/',sql:urlpart,'/',sql:locale,'/',translate(sql:id,'/','_'),'.xml?id=',sql:id)"/></xsl:attribute>Broker xUCDM</a>
      </td>
      <td>
        <xsl:value-of select="substring(sql:masterlastmodified, 1, 16)"/>
      </td>
      <td>
        <xsl:value-of select="substring(sql:lastmodified, 1, 16)"/>
      </td>
      <td>
        <xsl:value-of select="sql:status"/>
      </td>
    </tr>
  </xsl:template>
  -->
  <xsl:template match="/root/sql:rowset[@name = 'catalogs']/sql:row">
    <tr>
      <td>
        <a>
        <xsl:choose>
          <xsl:when test="sql:lpexists = 'true'">
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/pikachu_product_nice/nor_product/',sql:locale,'/',translate(sql:ctn,'/','_'),'.html?id=',sql:ctn)"/></xsl:attribute>
          </xsl:when>
        </xsl:choose>
          <xsl:value-of select="sql:ctn"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="sql:locale"/>
      </td>
      <td>
        <xsl:value-of select="sql:catalog_type"/>
      </td>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat('http://www.consumer.philips.com/consumer/',lower-case(substring(sql:locale,1,2)),'/',lower-case(substring(sql:locale,4,2)),'/consumer/cc/_productid_',translate(sql:ctn,'/','_'),'_',upper-case(substring(sql:locale,4,2)),'_',sql:catalog_type,'/')"/></xsl:attribute>Consumer site</a>
      </td>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat('http://www.p4c.philips.com/cgi-bin/dcbint/get?id=',sql:ctn,'&amp;doctype=PSS&amp;laco=',sql:language)"/></xsl:attribute>Leaflet</a>
      </td>
      <td>
        <table width="100%">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="sql:deleted = 1">
                  <xsl:attribute name="bgcolor">#0000FF</xsl:attribute>
                </xsl:when>
                <xsl:when test="me:compDate(fn:current-dateTime(), sql:sop) and me:compDate(sql:eop, fn:current-dateTime())">
                  <xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
                </xsl:when>
                <xsl:when test="me:compDate(sql:sop, fn:current-dateTime()) and me:compDate(sql:eop, fn:current-dateTime())">
                  <xsl:attribute name="bgcolor">#00FFFF</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="bgcolor">#FFFF00</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="sql:sop"/>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="sql:deleted = 1">
                  <xsl:attribute name="bgcolor">#0000FF</xsl:attribute>
                </xsl:when>
                <xsl:when test="me:compDate(fn:current-dateTime(), sql:sop) and me:compDate(sql:eop, fn:current-dateTime())">
                  <xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
                </xsl:when>
                <xsl:when test="me:compDate(sql:sop, fn:current-dateTime()) and me:compDate(sql:eop, fn:current-dateTime())">
                  <xsl:attribute name="bgcolor">#00FFFF</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="bgcolor">#FFFF00</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="sql:eop"/>
            </td>
          </tr>
          <tr>
            <td><xsl:value-of select="substring(sql:lastmodified,1,16)"/></td>
          </tr>
        </table>
      </td>
      <td>
        <xsl:value-of select="sql:local_going_price"/>
      </td>
      <td>
        <xsl:value-of select="sql:priority"/>
      </td>
      <td>
        <xsl:value-of select="sql:deleted"/>
      </td>
      <td>
        <xsl:value-of select="sql:division"/>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:function name="me:strip" as="xs:string">
    <xsl:param name="d"/>
    <xsl:value-of select="substring(translate(translate(translate(translate(substring($d,1,19),'-',''),'T',''),':',''),' ',''),1,15)"/>
  </xsl:function>
  <!-- -->
  <xsl:function name="me:compDate" as="xs:boolean">
    <xsl:param name="dt_a" as="xs:string"/>
    <xsl:param name="dt_b" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="me:strip($dt_a) gt me:strip($dt_b)">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  
  
</xsl:stylesheet>
