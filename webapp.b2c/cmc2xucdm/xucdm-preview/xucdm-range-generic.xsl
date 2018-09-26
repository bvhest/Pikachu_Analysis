<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml xUCDM_Range_Example_R000000004.xml?>
<!-- version 1.0  nly92174  21.03.2007    new   -->
<!-- version 1.1  nly92174  27.03.2007  taking into account optional trans tags in the translated text  -->
<!-- version 1.3  nly90671  12.04.2007    added length overflow block  -->
<!-- version 1.3  nly90671  12.04.2007    made it possible to combine both previews in one XSLT  -->
<!-- version 1.5  nly90671  26.06.2007    corrected productname display  -->
<!-- version 1.5  nly90671  26.06.2007    corrected popup  -->
<!-- version 1.6  nly90671  19.11.2007    added brandstuff  -->
<!-- version 1.7  nly90671  28.02.2007    added support for images, added support for xUCDM 1.,1, added support for packaging -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sql="http://apache.org/cocoon/SQL/2.0" version="2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:variable name="product-counts">
    <xsl:for-each select="//Node">
      <count><xsl:value-of select="count(//Node/ProductReferences/ProductReference/CTN
                                 | //Node/ProductRefs/ProductReference[@ProductReferenceType='assigned']/CTN
                                 | //Node/ProductRefs/ProductReference[@ProductReferenceType='assigned']/Product
                                 )"/></count>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="MaxProductCount" select="max(product-counts/count)"/>
  <!-- -->
  <xsl:template match="/Nodes">
    <html>
      <xsl:call-template name="range_head"/>
      <body contentID="content">
        <div class="philips-body">
          <table>
            <tr>
              <td>xxxxx</td>
            </tr>
          </table>
          <xsl:apply-templates mode="range">
            <xsl:with-param name="pos" select="position()"/>
          </xsl:apply-templates>
        </div>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="Node" mode="range">
    <xsl:param name="pos"/>
    <xsl:variable name="ProductCount" select="count(ProductReferences/ProductReference
                                                  | ProductRefs/ProductReference[@ProductReferenceType='assigned']/CTN
                                                  | ProductRefs/ProductReference[@ProductReferenceType='assigned']/Product)"/>
    <xsl:variable name="position" select="position()"/>
    <table border="1" width="100%" style="border-color: #aaa; border-style: solid; ">
      <tr style="border-style:none">
        <td style="border-style:none">
          <table border="0" width="100%" cellspacing="0">
            <xsl:call-template name="RangeCore">
              <xsl:with-param name="position" select="count(preceding-sibling::*) + 1"/>
              <xsl:with-param name="sibling-count" select="count(preceding-sibling::*) + count(following-sibling::*) + 1"/>
            </xsl:call-template>
          </table>
          <hr/>
          <table border="0">
            <xsl:choose>
              <xsl:when test="/Nodes/@routingCode = '' or not(/Nodes/@routingCode)">
                <!-- Show Filters only if this is a Pika Chu preview -->
                <xsl:apply-templates select="ProductReferences
                                           | ProductRefs/ProductReference[@ProductReferenceType='assigned']
                                           | ProductRefs/ProductReference[@ProductReferenceType='assigned']" mode="rangeNormalPreview">
                  <xsl:with-param name="ProductCount" select="$ProductCount"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="Filters" mode="range">
                  <xsl:with-param name="ProductCount" select="$ProductCount"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="ProductReferences
                                           | ProductRefs/ProductReference[@ProductReferenceType='assigned']
                                           | ProductRefs/ProductReference[@ProductReferenceType='assigned']" mode="rangeTranslationPreview">
                  <xsl:with-param name="ProductCount" select="$ProductCount"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
          </table>
          <hr/>
          <table border="0" width="800px">
            <xsl:apply-templates select="RichTexts" mode="range">
              <xsl:with-param name="ProductCount" select="$ProductCount"/>
            </xsl:apply-templates>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>
  <!-- -->
  <xsl:template name="range_head">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <xsl:call-template name="range_head_style"/>
    </head>
  </xsl:template>
  <!-- -->
  <xsl:template name="range_head_style">
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
    
    b {
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
  <xsl:template name="RangeCore">
    <xsl:param name="position"/>
    <xsl:param name="sibling-count"/>
    <tr style="background-color: #ffa">
      <td valign="center" width="33%">
        <h2 style="margin:6px 0px; margin-top:10px">
          <xsl:value-of select="concat('Range (',$position,' of ',$sibling-count,') : ')"/>
          <xsl:call-template name="range_show">
            <xsl:with-param name="node" select="@code"/>
          </xsl:call-template>
        </h2>
        <br/>
        <h5>Core Range Marketing Data:</h5>
        <br/>
        <!-- -->
        <table border="0">
          <tr>
            <td width="20%">
              <b>RangeName</b>
            </td>
            <td>
              <xsl:call-template name="range_show">
                <xsl:with-param name="node" select="Name"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td width="20%">
              <b>GroupCode/CategoryCode</b>
            </td>
            <td>
              <xsl:variable name="x">
                <xsl:choose>
                  <xsl:when test="../../Nodes/@routingCode != ''">
                    <xsl:value-of select="../../Nodes/@routingCode"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="/Products/categorization/*"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:call-template name="range_show">
                <xsl:with-param name="node" select="$x"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td width="20%">
              <b>MarketingStatus</b>
            </td>
            <td>
              <xsl:call-template name="range_show">
                <xsl:with-param name="node" select="MarketingStatus"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td width="20%">
              <b>MarketingVersion</b>
            </td>
            <td>
              <xsl:call-template name="range_show">
                <xsl:with-param name="node" select="MarketingVersion"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td width="20%">
              <b>Owner</b>
            </td>
            <td>
              <xsl:call-template name="range_show">
                <xsl:with-param name="node" select="Owner"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td width="20%">
              <b>WOW</b>
            </td>
            <td>
              <xsl:call-template name="range_show">
                <xsl:with-param name="node" select="WOW"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td width="20%">
              <b>SubWOW</b>
            </td>
            <td>
              <xsl:call-template name="range_show">
                <xsl:with-param name="node" select="SubWOW"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td width="20%">
              <b>MarketingTextHeader</b>
            </td>
            <td>
              <xsl:call-template name="range_show">
                <xsl:with-param name="node" select="MarketingTextHeader"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td/>
          </tr>
          <tr>
            <td/>
          </tr>
          <tr>
            <td/>
          </tr>
        </table>
        <br/>
      </td>
      <td width="33%"/>
      <td width="34%"/>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template match="ProductReferences|ProductReference" mode="rangeTranslationPreview">
    <xsl:param name="ProductCount"/>
    <tr>
      <td>
        <xsl:attribute name="colspan"><xsl:value-of select="$ProductCount"/></xsl:attribute>
        <h5>Assigned Products <xsl:value-of select="concat(' (',$ProductCount,'):')"/>
        </h5>
        <br/>
      </td>
    </tr>
    <tr>
      <td>
        <xsl:attribute name="colspan"><xsl:value-of select="$ProductCount"/></xsl:attribute>
        <div align="center">
          <table border="0" width="100%">
            <tr>
              <xsl:apply-templates select="ProductReference/CTN|CTN|Product/@ctn" mode="range"/>
            </tr>
          </table>
        </div>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template match="ProductReferences|ProductReference" mode="rangeNormalPreview">
    <xsl:param name="ProductCount"/>
    <tr>
      <td>
        <xsl:attribute name="colspan"><xsl:value-of select="$ProductCount+2"/></xsl:attribute>
        <h5>Assigned Products <xsl:value-of select="concat(' (',$ProductCount,'):')"/>
        </h5>
        <br/>
      </td>
    </tr>
    <tr>
      <td>
        <div style="width: 200px"/>
      </td>
      <td>
        <div style="width: 200px"/>
      </td>
      <td>
        <xsl:attribute name="colspan"><xsl:value-of select="$ProductCount"/></xsl:attribute>
        <div align="center">
          <table border="0" width="100%">
            <tr>
              <xsl:apply-templates select="ProductReference/CTN|CTN|Product/@ctn" mode="range"/>
            </tr>
          </table>
        </div>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template match="ProductReference/CTN|CTN|@ctn" mode="range">
    <td align="center">
      <table border="0">
        <tr align="center">
          <td class="p-image" align="center">
            <img class="philips-img" width="100" alt="{.}" src="{$img_link}?alt=1&amp;defaultimg=1&amp;doctype=RTM&amp;id={.}"/>
          </td>
        </tr>
        <tr>
          <td align="center">
            <a target="_blank">
              <xsl:attribute name="href"><xsl:value-of select="concat($img_link,'?id=',.,'&amp;doctype=PSS&amp;laco=AEN')"/></xsl:attribute>
              <xsl:value-of select="."/> Master Leaflet</a>
          </td>
        </tr>
      </table>
    </td>
  </xsl:template>
  <!-- -->
  <xsl:template match="Filters" mode="range">
    <xsl:param name="ProductCount"/>
    <xsl:apply-templates select="Purpose" mode="range">
      <xsl:with-param name="ProductCount" select="$ProductCount"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- -->
  <xsl:template match="Purpose[@type='Base'] | Purpose[@type='Differentiating']" mode="range">
    <xsl:param name="ProductCount"/>
    <tr>
      <td>
        <xsl:attribute name="colspan"><xsl:value-of select="$ProductCount+2"/></xsl:attribute>
        <br/>
        <h5>
          <xsl:choose>
            <xsl:when test="@type = 'Base'">Base Features and Specifications:</xsl:when>
            <xsl:otherwise>Differentiating Features and Specifications:</xsl:otherwise>
          </xsl:choose>
        </h5>
        <br/>
        <br/>
      </td>
    </tr>
    <xsl:apply-templates select="Features/Feature|CSItems/CSItem" mode="range">
      <xsl:with-param name="ProductCount" select="$ProductCount"/>
      <xsl:sort data-type="number" select="@rank"/>
    </xsl:apply-templates>
    <br/>
    <tr>
      <td>
        <xsl:attribute name="colspan"><xsl:value-of select="$ProductCount+2"/></xsl:attribute>
        <br/>
        <br/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="Features/Feature|CSItems/CSItem" mode="range">
    <xsl:param name="ProductCount"/>
    <tr>
      <td valign="center">
        <b>Type:&#160;</b>
      </td>
      <td>
        <xsl:call-template name="range_show">
          <xsl:with-param name="node" select="local-name()"/>
        </xsl:call-template>
      </td>
      <xsl:variable name="nodetype">
        <xsl:value-of select="local-name()"/>
      </xsl:variable>
      <xsl:variable name="nodecode">
        <xsl:value-of select="@code"/>
      </xsl:variable>
      <xsl:variable name="percent" select="if(number($ProductCount) = number($ProductCount) and number($ProductCount) != 0) then 100 idiv $ProductCount else 100"/>
      <xsl:variable name="referenced-products" select="ancestor::ProductReferences/referencedproducts|ancestor::ProductRefs/referencedproducts"/>
      <!--xsl:variable name="percent" select="100 idiv $MaxProductCount"/-->
      <xsl:for-each select="../../../../ProductReferences/ProductReference/CTN
                          | ../../../../ProductRefs/ProductReference[@ProductReferenceType='assigned']/CTN
                          | ../../../../ProductRefs/ProductReference[@ProductReferenceType='assigned']/Product/@ctn
                          ">
        <td align="center" valign="center">
          <xsl:attribute name="width"><xsl:value-of select="concat($percent,'%')"/></xsl:attribute>
          <!--xsl:attribute name="bgcolor" select="'red'"/-->
          <xsl:choose>
            <xsl:when test="($nodetype='Feature' and $referenced-products/Product[CTN=current()]/Feature[FeatureCode=$nodecode]) 
                            or ($nodetype='CSItem' and $referenced-products/Product[CTN=current()]/CSItem[CSItemCode=$nodecode])">
              <xsl:choose>
                <xsl:when test="$nodetype='CSItem'">
                  <xsl:attribute name="style">font-style:italic</xsl:attribute>
                  <xsl:for-each select="$referenced-products/Product[CTN=current()]/CSItem[CSItemCode=$nodecode]/CSValue/CSValueName">
                    <xsl:value-of select="."/>
                    <BR/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="style">color:#00000</xsl:attribute>
                  <xsl:text>Yes</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">color:#000000</xsl:attribute>
              <xsl:text>No</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </xsl:for-each>
    </tr>
    <tr>
      <td>
        <b>Code:&#160;</b>
      </td>
      <td>
        <xsl:call-template name="range_show">
          <xsl:with-param name="node" select="@code"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td>
        <b>Name:&#160;</b>
      </td>
      <td>
        <xsl:variable name="x">
          <xsl:variable name="code" select="@code"/>
          <xsl:choose>
            <xsl:when test="local-name()='Feature'">
              <xsl:for-each select="$referenced-products/Product[Feature/FeatureCode=current()/@code]">
                <xsl:sort select="@masterLastModified"/>
                <xsl:sort select="@lastModified"/>
                <xsl:if test="position()=1">
                  <xsl:value-of select="Feature[FeatureCode=$code]/FeatureName"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="$referenced-products/Product[CSItem/CSItemCode=current()/@code]">
                <xsl:sort select="@masterLastModified"/>
                <xsl:sort select="@lastModified"/>
                <xsl:if test="position()=1">
                  <xsl:value-of select="CSItem[CSItemCode=$code]/CSItemName"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="normalize-space($x)">
            <xsl:call-template name="range_show">
              <xsl:with-param name="node" select="normalize-space($x)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="style">color:#FF0000</xsl:attribute>
            <xsl:choose>
              <xsl:when test="local-name()='Feature'">
                <xsl:text>Feature is missing in all products</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>CSItem missing in all products</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
    <tr>
      <td>
        <b>Rank:&#160;</b>
      </td>
      <td>
        <xsl:call-template name="range_show">
          <xsl:with-param name="node" select="@rank"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td>
        <br/>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template match="RichTexts" mode="range">
    <xsl:apply-templates select="RichText" mode="range"/>
  </xsl:template>
  <xsl:template match="RichText" mode="range">
    <tr>
      <td colspan="2">
        <!--h5 style="border-bottom: 1px solid #ccc"-->
        <h5>
          <xsl:text>RichText - </xsl:text>
          <xsl:value-of select="@type"/>:
                </h5>
        <br/>
      </td>
    </tr>
    <tr>
      <td>
        <br/>
      </td>
    </tr>
    <!-- -->
    <tr>
      <td colspan="2">
        <xsl:apply-templates select="Item" mode="range">
          <xsl:sort data-type="number" select="@rank"/>
        </xsl:apply-templates>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="Item" mode="range">
    <tr>
      <td colspan="2">
        <b style="border-bottom: 1px solid #000077">
          <xsl:text>Rich text item:&#160;&#160;</xsl:text>
          <xsl:value-of select="@referenceName"/>
        </b>
      </td>
    </tr>
    <tr>
      <td>
        <br/>
      </td>
    </tr>
    <tr>
      <td width="20%">
        <b>Head&#160;</b>
      </td>
      <td>
        <xsl:call-template name="range_show">
          <xsl:with-param name="node" select="Head"/>
        </xsl:call-template>
        <br/>
      </td>
    </tr>
    <tr>
      <td>
        <br/>
      </td>
    </tr>
    <tr>
      <td>
        <b>Body&#160;</b>
      </td>
      <td>
        <xsl:call-template name="range_show">
          <xsl:with-param name="node" select="Body"/>
        </xsl:call-template>
        <br/>
      </td>
    </tr>
    <tr>
      <td/>
    </tr>
    <xsl:apply-templates select="BulletList" mode="range"/>
    <br/>
    <br/>
  </xsl:template>
  <xsl:template match="BulletList" mode="range">
    <tr>
      <td valign="top">
        <br/>
        <b>Bullet&#160;Items</b>
      </td>
      <td>
        <br/>
        <ul>
          <xsl:apply-templates select="BulletItem" mode="range">
            <xsl:sort data-type="number" select="@rank"/>
          </xsl:apply-templates>
        </ul>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="BulletItem" mode="range">
    <li>
      <xsl:call-template name="range_show">
        <xsl:with-param name="node" select="Text"/>
      </xsl:call-template>
    </li>
  </xsl:template>
  <!-- -->
  <!-- -->
  <xsl:template match="*|@*" mode="range">
    <!-- catch all: do nothing -->
  </xsl:template>
  <!-- -->
  <xsl:template name="range_show">
    <xsl:param name="node"/>
    <xsl:value-of select="$node"/>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
