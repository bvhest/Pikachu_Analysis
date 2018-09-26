<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
  <xsl:variable name="channel" select="/root/sql:rowset/sql:row/sql:id"/>
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>Add channel</h2>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, 'pikachu_channel_add_post?channel=', $channel)"/></xsl:attribute>
          <table>
            <tr>
              <td style="width: 140px">ID
            </td>
              <td style="width: 205px">
                <input name="ID" size="60" type="text" value="0300"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
            </td>
              <td style="width: 400px">
				This is the unique ID of the channel. Its value determines where in the total execute sequence it is executed. 
				It cannot be changed later-on.
				</td>
            </tr>
            <tr>
              <td style="width: 140px">Name
            </td>
              <td style="width: 205px">
                <input name="Name" size="60" type="text" value="NewPipe"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
            </td>
              <td style="width: 400px">
				This is the unique name of the channel. Its value must be identical to the LCB CatalogType name. 
				</td>
            </tr>
            <tr>
              <td style="width: 140px">Locale
            </td>
              <td style="width: 205px">
                <input name="Locale" size="60" type="text" value="en_US"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
            </td>
              <td style="width: 400px">
				Some channels use this field to select one or more locales to export. 
				</td>
            </tr>
            <tr>
              <td style="width: 140px">Catalog</td>
              <td style="width: 205px">
                <input name="Catalog" size="60" type="text">
                  <xsl:attribute name="value">CONSUMER</xsl:attribute>
                </input>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
				            </td>
              <td style="width: 400px">
								This is the name of the catalog, the channel should use. Default names are 'CONSUMER', 'PROFESSIONAL', 'WALITA' or 'NORELCO'.
								</td>
            </tr>
            <tr>
              <td style="width: 140px">Location
            </td>
              <td style="width: 205px">
                <input name="Location" size="60" type="text" value="NewPipe"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
            </td>
              <td style="width: 400px">
				The directory where the channel stores its data, logfiles, etc. This value cannot contain spaces. 
				</td>
            </tr>
            <tr>
              <td style="width: 140px">Type
            </td>
              <td style="width: 205px">
                <select id="Type" style="width: 392px" name="Type">
                  <option selected="True" value="import">import</option>
                  <option value="export">export</option>
                  <option value="maintenance">maintenance</option>
                </select>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
            </td>
              <td style="width: 400px">
				The channel type. Possible values are import, export. Maintenance is used for cleanup or report channels and is normally not needed. Import channels show up under the 'Import' menu, export channels under the 'Export' menu.
				</td>
            </tr>
            <tr>
              <td style="width: 140px">Pipeline
            </td>
              <td style="width: 400px">
                <input name="Pipeline" size="60" type="text" value="pipes/NewPipe"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
            </td>
              <td style="width: 400px">
				This can be something like '<b>pipes/NewPipe</b>'. This requires however that a developer creates the new channel.
				Another option is the use of '<b>pipes/Zip.NewPipe</b>' or <b>pipes/Xml.NewPipe</b>'. This makes it possible to use the 
				standard ZIP or XML export channel. In this case no programming is needed.
				</td>
            </tr>
            <tr>
              <td style="width: 140px">MachineAffinity
            </td>
              <td style="width: 205px">
                <input name="MachineAffinity" size="60" type="text" value="all"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
            </td>
              <td style="width: 400px">
                <p>This parameter is used by the Main pipeline (pipes/Main/runPipeline) to determine which 
								pipeline must be executed. Possible values are:<br/>
								- <b>all</b>: Execute always<br/>
								- <b>COMPUTERNAME</b>: Execute only when COMPUTERNAME equals the left part of 
								the fully qualified system name. Thus a value of 'nlvu045' makes sure that it runs on
								'nlvu045.gdc1.ce.philips.com'<br/> 
								- <b>all(XX)</b>: Execute when pipes/Main/runPipeline_XX is used. XX can be something like 
								daily, weekly, hourly, etc.<br/>
								- <b>COMPUTERNAME(XX)</b>: Execute only when COMPUTERNAME equals the left part of 
								the fully qualified system name and pipes/Main/runPipeline_XX is used. XX can be something like 
								daily, weekly, hourly, etc.<br/>
                </p>
              </td>
            </tr>
            <tr>
              <td style="width: 140px; height: 13px">
            </td>
              <td style="width: 205px; height: 13px">
            </td>
            </tr>
            <tr>
              <td style="width: 140px">
                <input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
              </td>
              <td style="width: 205px">
            </td>
            </tr>
          </table>
        </form>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sql:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
