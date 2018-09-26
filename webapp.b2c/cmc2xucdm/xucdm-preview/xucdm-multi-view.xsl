<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml tbatch.20061026T1646.fr_CA.SHOQBOX_SU.1.xml?>
<!-- version 1.1	nly92174	27.03.2007	taking into account optional trans tags in the translated text	-->
<!-- version 1.3	nly90671	12.04.2007		added length overflow block	-->
<!-- version 1.3	nly90671	12.04.2007		made it possible to combine both previews in one XSLT	-->
<!-- version 1.4	nly90671	15.05.2007		take into account optional trans tags in the tlength overflow block -->
<!-- version 1.5	nly90671	26.06.2007		corrected productname display	-->
<!-- version 1.5	nly90671	26.06.2007		corrected popup	-->
<!-- version 1.6	nly90671	19.11.2007		added brandstuff	-->
<!-- version 1.7	nly90671	28.02.2007		added support for images, added support for xUCDM 1.,1, added support for packaging -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0">
  <!-- -->
  <xsl:import href="xucdm-generic.xsl"/>
  <!-- -->
  <xsl:template match="/Products">
    <html>
      <xsl:call-template name="head"/>
      <body contentID="content">
        <div class="philips-body">
          <table border="1">
            <thead>
              <xsl:call-template name="ErrorTable"/>
            </thead>
            <tbody>
              <xsl:apply-templates/>
            </tbody>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template name="head">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <xsl:call-template name="head_style"/>
      <style type="text/css">
				table{
				font-size:100%;
				}	

				td{
				background-color:#ffffff;
				line-height:17px;
				padding: 0px;
				margin:0px;
				}
				ul li {
				margin-left: -20px;
				padding-left:0px;
				}
				td p {
				margin-top:0px;
				margin-bottom:0px;
				}

				a.one:link{
				text-decoration:none;
				color:#0E5FD8;
				}
				a.one:visited{
				text-decoration:none;
				color:#0E5FD8;
				}
				a.one:active{
				text-decoration:none;
				color:#0E5FD8;
				}
				a.one:hover{
				text-decoration:underline;
				color:#0E5FD8;
				}
				a.two:link{
				text-decoration:none;
				color:#FF0000;
				}
				a.two:visited{
				text-decoration:none;
				color:#FF0000;
				}
				a.two:active{
				text-decoration:none;
				color:#FF0000;
				}
				a.two:hover{
				text-decoration:none;
				color:#FF0000;
				}
			</style>
    </head>
  </xsl:template>
  <!-- -->
  <xsl:template match="//Product">
    <xsl:variable name="CTN">
      <xsl:value-of select="CTN"/>
    </xsl:variable>
    <tr>
      <td valign="top" align="left" width="150px">
        <b>
          <a class="one">
            <xsl:attribute name="href">#_LengthErrors</xsl:attribute>
						LengthErrors
					</a>
        </b>
        <br/>
        <b>Products</b>
        <br/>
        <xsl:for-each select="//Product/CTN">
          <xsl:choose>
            <xsl:when test="text()=$CTN">
              <b>
                <xsl:value-of select="."/>
              </b>
            </xsl:when>
            <xsl:otherwise>
              <a class="one">
                <xsl:attribute name="href">#_<xsl:value-of select="."/></xsl:attribute>
                <xsl:value-of select="."/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <br/>
        </xsl:for-each>
      </td>
      <td>
        <a class="one">
          <xsl:attribute name="name">_<xsl:value-of select="CTN"/></xsl:attribute>
        </a>
        <xsl:apply-imports/>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template name="show">
    <xsl:param name="node"/>
    <xsl:if test="string-length($node/@translate) = 0">
      <xsl:value-of select="$node"/>
    </xsl:if>
    <xsl:if test="string-length($node/@translate) != 0">
      <xsl:if test="$node/@translate = 'yes'">
        <xsl:variable name="stringLength">
          <xsl:choose>
            <xsl:when test="$node/trans/text()">
              <xsl:value-of select="string-length($node/trans)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="string-length($node)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="lengthOk" select="$stringLength &lt;= $node/@maxlength"/>
        <a class="one">
          <xsl:attribute name="name">_<xsl:value-of select="$node/@key"/></xsl:attribute>
        </a>
        <xsl:if test="$lengthOk = 1">
          <xsl:value-of select="$node"/>
        </xsl:if>
        <xsl:if test="$lengthOk = 0">
          <xsl:variable name="start" select="$node/@maxlength + 1"/>
          <xsl:variable name="error">
            <xsl:text>Textlength is </xsl:text>
            <xsl:value-of select="$stringLength"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>while the maxlength is </xsl:text>
            <xsl:value-of select="$node/@maxlength"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>This part will get lost : </xsl:text>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:choose>
              <xsl:when test="$node/trans/text()">
                <xsl:value-of select="substring($node/trans,$start)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring($node,$start)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <a class="two" href="#">
            <xsl:attribute name="title"><xsl:value-of select="$error"/></xsl:attribute>
            <!--		<xsl:attribute name="onMouseOver">alert(<xsl:value-of select="$error"/>);return true;</xsl:attribute>-->
            <!--		<xsl:attribute name="onMouseOver">alert('test');return true;</xsl:attribute>-->
            <xsl:value-of select="$node"/>
          </a>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template name="ErrorTable">
    <tr>
      <td valign="top" align="left" width="150px">
        <b>
          <a class="one">
            <xsl:attribute name="href">#_LengthErrors</xsl:attribute>
						LengthErrors
					</a>
        </b>
        <br/>
      </td>
      <td>
        <xsl:for-each select="/Products">
          <a class="one">
            <xsl:attribute name="name">_LengthErrors</xsl:attribute>
          </a>
          <xsl:call-template name="ErrorList"/>
        </xsl:for-each>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="ErrorList">
    <table cellspacing="0" class="p-product-general">
      <xsl:for-each select="descendant::*[@translate = 'yes' and ((@maxlength &lt; string-length(.) and not(./trans/text())) or (./trans/text() and @maxlength &lt; string-length(./trans)))]">
        <tr>
          <a class="one">
            <xsl:attribute name="href">#_<xsl:value-of select="./@key"/></xsl:attribute>
            <xsl:value-of select="."/>
          </a>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
</xsl:stylesheet>
