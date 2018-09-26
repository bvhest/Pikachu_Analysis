<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml CE_CategorizationTree.xml?>
<!-- version 1.0	nly92174	21.03.2007		new 	-->
<!-- version 1.1	nly92174	27.03.2007	taking into account optional trans tags in the translated text	-->
<!-- version 1.3	nly90671	12.04.2007		added length overflow block	-->
<!-- version 1.3	nly90671	12.04.2007		made it possible to combine both previews in one XSLT	-->
<!-- version 1.5	nly90671	26.06.2007		corrected productname display	-->
<!-- version 1.5	nly90671	26.06.2007		corrected popup	-->
<!-- version 1.6	nly90671	19.11.2007		added brandstuff	-->
<!-- version 1.7	nly90671	28.02.2007		added support for images, added support for xUCDM 1.,1, added support for packaging -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sql="http://apache.org/cocoon/SQL/2.0" version="2.0">
  <!-- -->
  <xsl:template match="PackagingText">
    <html>
      <xsl:call-template name="pt_head"/>
      <body contentID="content">
        <div class="philips-body">
          <h2 style="margin:6px 0px">Packaging project - <xsl:value-of select="@code"/>
          </h2>
          <br/>
          <table>
            <xsl:apply-templates mode="pt"/>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template name="pt_head">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <xsl:call-template name="pt_head_style"/>
    </head>
  </xsl:template>
  <!-- -->
  <xsl:template name="pt_head_style">
    <style type="text/css">
		.philips-body {
			font-family:Verdana, Arial, Helvetica, sans-serif;
			font-size:70%;
			color:#252F47;
			background-color:#FFFFFF; 
			line-height:17px;
			margin:0px;
			/*margin-top: 25px;*/
		}

		.p-center{
			text-align:center;
		}

		h1 {
			text-align:left;
			font-size:22px;
			padding:6px 5px 5px 8px;
			font-weight:normal;
			color:#B9BBC7;
			margin:0px;
			margin-left:1px;
			line-height:normal;
		}

		h4{
			margin:0px;
			font-size:120%;
			color:#2554C7;
		}

		h5 {
			margin:15px;
			font-size:110%;
			color:#2B60DE;
			display:inline;
		}
		
		h6 {
			margin:30px;
			font-size:100%;
			color:#000077;
			display:inline;
		}
		
		.p-product-general{
			border-collapse:collapse;
			border-spacing:0px;
			width:560px;
			margin-bottom:10px;
		}

		</style>
  </xsl:template>
  <!-- -->
  <xsl:template match="ProductReferences" mode="pt">
    <!--  -->
    <tr>
      <td valign="top" colspan="2">
      Reference Products:
      <hr/>
      </td>
    </tr>
    <xsl:apply-templates select="ProductReference" mode="pt"/>
    <tr >
      <td colspan="2" valign="top">
      Packaging Text:
      <hr/>
      </td>
    </tr>    
    <!-- -->
  </xsl:template>
  <!-- -->
  <xsl:template match="ProductReference" mode="pt">
    <!--  -->
    <tr>
      <td valign="top">
        <h2 style="margin:6px 0px">
        <xsl:value-of select="@code"/></h2>
      </td>
	  <td>
      <table>
        <tr>
          <td class="p-image">
            <img class="philips-img" width="200" alt="{@code}" src="{$img_link}?alt=1&amp;defaultimg=1&amp;doctype=RTB&amp;id={@code}"/>
          </td>
        </tr>
        <tr>    
          <td align="center">
            <a target="_blank">
              <xsl:attribute name="href"><xsl:value-of select="concat($img_link,'?id=',@code,'&amp;doctype=PSS&amp;laco=AEN')"/></xsl:attribute>Master Leaflet</a>
          </td>      
        </tr>
      </table>
      </td>
    </tr>      
    <!-- -->
  </xsl:template>
  <!-- -->
  <xsl:template match="PackagingTextItem" mode="pt">
    <!--  -->
    <tr>
      <td>
        <xsl:value-of select="@code"/>:&#160;
		</td>
      <td>
        <xsl:call-template name="pt_show">
          <xsl:with-param name="node" select="ItemText"/>
        </xsl:call-template>
      </td>
    </tr>
    <!-- -->
  </xsl:template>
  <!-- -->
  <xsl:template match="*|@*" mode="pt">
    <!-- catch all: do nothing -->
  </xsl:template>
  <!-- -->
  <xsl:template name="pt_show">
    <xsl:param name="node"/>
    <xsl:value-of select="$node"/>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
