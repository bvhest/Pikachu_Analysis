<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:me="http://apache.org/a">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
    <xsl:if test="$section">
      <xsl:value-of select="concat('section/', $section, '/')"/>
    </xsl:if>
  </xsl:variable>
  <xsl:param name="id"/>
  <xsl:param name="param1" select="search"/>
  <!-- -->
  <xsl:template match="/" priority="7">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->
  <xsl:template match="/root" priority="10">
    <html>
      <body contentID="content">
        <h2>Quick Catalog Search</h2>
        <hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'search_by_catalog_post/', $param1)"/></xsl:attribute>
          <table>
            <tr>
              <td style="width: 140px">Enter&#160;an&#160;exact&#160;CTN&#160;to&#160;retrieve<br/>catalog&#160;and&#160;subcat&#160;info:</td>
              <td style="width: 40px">
                <input name="Search" size="60" type="text" value="{$id}"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px"/>
              <td style="width: 40px"/>
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
        <xsl:variable name="v_ctn" select="if(/root/sql:rowset[@name = 'category']/sql:row[1]/sql:id) then /root/sql:rowset[@name = 'category']/sql:row[1]/sql:id
                                      else if(/root/sql:rowset[@name = 'catalogs']/sql:row[1]/sql:ctn) then /root/sql:rowset[@name = 'catalogs']/sql:row[1]/sql:ctn
                                      else 'No data found'"/>
        <h2>Search Result: <xsl:value-of select="$v_ctn"/>
        </h2>
        <hr/>
        <br/>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="/root/sql:rowset[@name = 'category']">
    <h2>Subcategory assignments and master content</h2>
    <table class="main">
      <tr>
        <td>Product CTN</td>
        <td>Raw&#160;content<a href="javascript:return false" title="Click for either raw xml content or preview content. This is 'PMT_Raw' content. No content will be available when status = 'PLACEHOLDER'.">?</a>
        </td>
        <td>Enriched&#160;content<a href="javascript:return false" title="Click for either raw xml content or preview content. This is 'PMT_Enriched' content. No content will be available when status = 'PLACEHOLDER'.">?</a>
        </td>
        <td>Catalog<a href="javascript:return false" title="The ATG catalog type to which the subcat belongs">?</a>
        </td>
        <td>Group<a href="javascript:return false" title="The subcat's group">?</a>
        </td>
        <td>Category<a href="javascript:return false" title="The subcat's category">?</a>
        </td>
        <td>Subcat<a href="javascript:return false" title="The subcategory name. Click to see all product assignments for this subcat">?</a>
        </td>
        <td>Master Leaflet<a href="javascript:return false" title="Click to retrieve the PSS in AEN for this CTN (note: this is not the GLL)">?</a>
        </td>
      </tr>
      <xsl:choose>
        <xsl:when test="sql:row">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <tr>
            <td colspan="5" align="center">
              <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>None found</td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
    </table>
    <br/>
    <br/>
    <p> </p>
    <p> </p>
  </xsl:template>
  <!-- -->
  <!-- -->
  <xsl:template match="/root/sql:rowset[@name = 'catalogs']">
    <h2>Catalog assignments (LCB/CCB)</h2>
    <table class="main">
      <!--tr style="background-image:url('/cmc2gui/themes/images/bg_nav_test.gif');
	               background-position: 0px -3px;
	               font-weight: bold;
	               height: 30px"-->
      <tr>
        <td>Product CTN</td>
        <td>Country<a href="javascript:return false" title="The country of assignment">?</a>
        </td>
        <td>Locale<a href="javascript:return false" title="A locale within the country of assignment">?</a>
        </td>
        <td>Catalog<a href="javascript:return false" title="The catalog type of assignment">?</a>
        </td>
        <td>Consumer site<a href="javascript:return false" title="Click to be directed to the consumer site for the CTN and locale">?</a>
        </td>
        <td>PDF<a href="javascript:return false" title="Click to retrieve the PSS for the CTN and locale">?</a>
        </td>
        <td>SOP<a href="javascript:return false" title="SOP: Start Of Publication. Yellow: the SOP is in the future. Green: the SOP is in the past">?</a>
        </td>
        <td>EOP<a href="javascript:return false" title="EOP: End Of Publication. Red: the EOP is in the past. Green: the EOP is in the future">?</a>
        </td>
        <td>LastModified<a href="javascript:return false" title="Date of last modification of the LCB record (i.e. the country/catalog *assignment* NOT the product itself)">?</a>
        </td>
        <td>Local going price</td>
        <td>Priority</td>
        <td>Deleted<a href="javascript:return false" title="Red: deleted = true. Green: deleted = false">?</a>
        </td>
        <td>DeleteAfterDate<a href="javascript:return false" title="Red: non-empty. Green: empty">?</a>
        </td>
        <td>Division</td>
      </tr>
      <xsl:apply-templates/>
    </table>
    <p> </p>
  </xsl:template>
  <!-- -->
  <xsl:template match="/root/sql:rowset[@name = 'category']/sql:row">
    <tr>
      <td>
        <xsl:value-of select="sql:id"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="sql:rawstatus!='PLACEHOLDER'">
            <a target="_blank">
              <xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          , 'xmlraw/object_store/'
                                                                          , 'PMT_Raw'
                                                                          , '/'
                                                                          , 'none'
                                                                          , '/'
                                                                          , translate(sql:id,'/','_')
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
                                                                          , 'none'
                                                                          , '/'
                                                                          , translate(sql:id,'/','_')
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
      <td>
        <xsl:choose>
          <xsl:when test="sql:enrichedstatus!='PLACEHOLDER'">
            <a target="_blank">
              <xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          , 'xmlraw/object_store/'
                                                                          , 'PMT_Enriched'
                                                                          , '/'
                                                                          , 'master_global'
                                                                          , '/'
                                                                          , translate(sql:id,'/','_')
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
                                                                          , 'master_global'
                                                                          , '/'
                                                                          , translate(sql:id,'/','_')
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
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl,'categorisation_object/',sql:subcategorycode)"/></xsl:attribute>
          <xsl:value-of select="sql:subcategoryname"/>
        </a>
      </td>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat('http://www.p4c.philips.com/cgi-bin/dcbint/get?id=',sql:id,'&amp;doctype=PSS&amp;laco=AEN')"/></xsl:attribute>Master Leaflet</a>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template match="/root/sql:rowset[@name = 'data']/sql:row">
    <tr>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/pikachu_product_nice/',sql:urlpart,'/',sql:locale,'/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
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
  <!-- -->
  <xsl:template match="/root/sql:rowset[@name = 'catalogs']/sql:row">
    <tr>
      <td>
        <a>
          <xsl:value-of select="sql:ctn"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="sql:country"/>
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
        <xsl:choose>
          <xsl:when test="me:compDate(sql:sop,fn:current-dateTime())">
            <xsl:attribute name="bgcolor">#FFFF00</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="bgcolor">#CCFFCC</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="sql:sop"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="me:compDate(fn:current-dateTime(), sql:eop)">
            <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="bgcolor">#CCFFCC</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="sql:eop"/>
      </td>
      <td>
        <xsl:value-of select="substring(sql:lastmodified,1,16)"/>
      </td>
      <td>
        <xsl:value-of select="sql:local_going_price"/>
      </td>
      <td>
        <xsl:value-of select="sql:priority"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="sql:deleted = 1">
            <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="bgcolor">#CCFFCC</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="sql:deleted"/>
      </td>
      <td>
        <xsl:if test="sql:dad != ''">
          <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="sql:dad"/>
      </td>
      <td>
        <xsl:value-of select="sql:division"/>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <!--xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template-->
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
