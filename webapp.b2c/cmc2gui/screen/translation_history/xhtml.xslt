<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="gui_url"/>
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
    <h2>Translation history request - Specify search criteria</h2><hr/>
    <br />
    Use this screen to retrieve translation export and import history information for OCTLs.<br/><br/>
    You may use the wildcard character '*' to specify a partial id or filename, e.g. 42*FL9900*.
    
    <br /><br /><br />
    <form method="POST" id="to_form" name="to_form" enctype="multipart/form-data">
        <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'translation_details_step2')"/></xsl:attribute>    
    <table>
      <tr><td colspan="2"><b>Step 1: Specify criteria:</b></td></tr>
      <tr style="background-color:#ddf"><td colspan="2"><xsl:call-template name="ctl"><xsl:with-param name="ctl" select="sql:rowset[@name='ctl']"/></xsl:call-template></td></tr>
      <tr><td colspan="2" align="center"><b>OR</b></td></tr><tr/>
      <tr style="background-color:#ddf"><td colspan="2"><xsl:call-template name="filename"/></td></tr>
      <tr/><tr/><tr/><tr/><tr/><tr/>
      <tr><td colspan="2"><b>Step 2: Specify filter criteria:</b></td></tr>
      <tr style="background-color:#cff"><td><table cellspacing="0"><tr><td>Retrieve OCTL translation details for:&#160;&#160;&#160;&#160;&#160;&#160;&#160;</td>
        <td><BR/>
          <INPUT TYPE="RADIO" NAME="radiofilesfilter" VALUE="all" checked="true"/>All files<BR/>
          <INPUT TYPE="RADIO" NAME="radiofilesfilter" VALUE="unreturned"/>Only files still awaiting import<BR/>
          <INPUT TYPE="RADIO" NAME="radiofilesfilter" VALUE="returned"/>Only imported files <P/>
        </td></tr></table></td>
      </tr>
      <tr/><tr/><tr/><tr/><tr/><tr/>
      <tr><td colspan="2"><b>Step 3: Submit:</b></td></tr>      
      <tr>
        <td colspan="2" align="center">
          <input id="SendChannelData" style="width: 200px" type="submit" value="Retrieve translation details"/>
        </td>
      </tr>      
    </table>    
        </form>
    </body>
  </html>
    
  </xsl:template>
    
    <xsl:template name="ctl">
     <xsl:param name="ctl"/>
    <table>
      <tr>
        <td style="width: 180px"><b>Specify an object id (partial&#160;or&#160;full):</b></td>
        <td style="width: 205px">
          <input name="id" size="60" type="text"/>
        </td>
      </tr>
      <tr/><tr><td align="left"><b>&#160;&#160;&#160;&#160;and / or</b></td></tr><tr/>
      <tr>
        <td style="width: 180px"><b>Choose a content type &amp; localisation</b></td>
        <td style="width: 205px">
          <select name="ctl">
            <option value="" selected="selected">Select a content type and localisation</option>
            <xsl:apply-templates select="$ctl/sql:row"/>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2"></td>
      </tr>
    </table>
  </xsl:template>

  
   <xsl:template name="filename">
    <table>
      <tr>
        <td style="width: 180px"><b>Specify a filename (partial&#160;or&#160;full):</b></td>
        <td style="width: 205px">
          <input name="partialfilename" size="60" type="text"/>
        </td>
      </tr>      
    </table>
  </xsl:template>
  
  
     <xsl:template match="sql:rowset[@name='routingcode']">
    <table>
    <tr>
        <td style="width: 180px"><b>Specify a routing code (partial&#160;or&#160;full):</b></td>
        <td style="width: 205px">
          <input name="partialroutingcode" size="60" type="text"/>
        </td>
      </tr>      
      <tr/><tr><td align="left"><b>&#160;&#160;&#160;&#160;or</b></td></tr><tr/>      
      <tr>
        <td style="width: 180px"><b>Select a routing code:</b></td>
        <td style="width: 205px">
          <select name="routingcode">
            <option value="" selected="selected">Select a routing code</option>
            <xsl:apply-templates select="sql:row"/>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2"></td>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="sql:rowset[@name='category']">
    <table>
    <tr>
        <td style="width: 180px"><b>Specify a category (partial&#160;or&#160;full):</b></td>
        <td style="width: 205px">
          <input name="partialcategory" size="60" type="text"/>
        </td>
      </tr>      
      <tr/><tr><td align="left"><b>&#160;&#160;&#160;&#160;or</b></td></tr><tr/>      
      <tr>
        <td style="width: 180px"><b>Select a category:</b></td>
        <td style="width: 205px">
          <select name="category">
            <option value="" selected="selected">Select a category</option>
            <xsl:apply-templates select="sql:row"/>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2"></td>
      </tr>
    </table>
  </xsl:template>  
  
  <xsl:template match="sql:rowset[@name='ctl']/sql:row">
    <option><xsl:attribute name="value" select="concat(sql:content_type,',',sql:localisation)"/><xsl:value-of select="concat(sql:content_type,',',sql:localisation)"/></option>
  </xsl:template>
  
  <xsl:template match="sql:rowset[@name='filename']/sql:row">
    <option><xsl:attribute name="value" select="sql:filename"/><xsl:value-of select="sql:filename"/></option>
  </xsl:template>

  <xsl:template match="sql:rowset[@name='routingcode']/sql:row">
    <option><xsl:attribute name="value" select="sql:routing_code"/><xsl:value-of select="sql:routing_code"/></option>
  </xsl:template>
  
  <xsl:template match="sql:rowset[@name='category']/sql:row">
    <option><xsl:attribute name="value" select="sql:category"/><xsl:value-of select="sql:category"/></option>
  </xsl:template>
  
</xsl:stylesheet>
