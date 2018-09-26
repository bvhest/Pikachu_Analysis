<?xml version="1.0" encoding="UTF-8"?>
<!-- version 1.1  nly92174  27.03.2007  taking into account optional trans tags in the translated text  -->
<!-- version 1.3  nly90671  12.04.2007    added length overflow block  -->
<!-- version 1.3  nly90671  12.04.2007    made it possible to combine both previews in one XSLT  -->
<!-- version 1.4  nly92174  07.06.2007    make a parameter of image link  -->
<!-- version 1.5  nly92174  07.06.2007    fixed Productname issue  -->
<!-- version 1.5  nly90671  26.06.2007    corrected popup  -->
<!-- version 1.6  nly90671  19.11.2007    added brandstuff  -->
<!-- version 1.7  nly90671  28.02.2007    added support for images, added support for xUCDM 1.,1, added support for packaging -->
<!-- version 1.7  nly90671  28.02.2007    finxed BrandString2 -->
<!-- version 1.8  nly92453  21.05.2008    added content for Range to products (RangeName, Filters) -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sql="http://apache.org/cocoon/SQL/2.0" version="2.0">
  <!-- -->
  <xsl:param name="img_link">http://pww.p3c.philips.com/cgi-bin/newmpr/get.pl</xsl:param>
  <!-- -->
  <xsl:template match="/Products">
    <html>
      <xsl:call-template name="head"/>
      <body contentID="content">
        <div class="philips-body">
          <xsl:apply-templates/>
        </div>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template name="head">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <xsl:call-template name="head_style"/>
    </head>
  </xsl:template>
  <!-- -->
  <xsl:template name="head_style">
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

    .philips-img {
      border:0px;
      padding:0px;
      margin:0px;
      vertical-align:bottom;
    }

    img.p-sectionArrow{
      padding-bottom:1px;
      vertical-align:middle;
    }

    /* Workaround for image bug in NS6 */
    /*
    img {vertical-align: bottom; line-height: 1%; padding: 0px; border: 0px}
    */
    img {border: 0px}

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

    h5{
      margin:0px;
      font-size:110%;
    }

    h6 {
      font-size:90%;
      color:#000077;
       display: inline;
    }
    
    .p-product-general{
      border-collapse:collapse;
      border-spacing:0px;
      width:560px;
      margin-bottom:10px;
    }

    .p-product-general .p-image{
      width:180px;
      padding-bottom:10px;
    }

    .p-product-general .p-content{
      width:370px;
      padding:10px;
      padding-top:0px;
      font-size:90%;
    }
    
    .featureImages {
      float: right;
      margin-top: 15px;
    }
    .featureImages img {
      float: none;
      margin-bottom: 7px;
      margin-left: 20px;
    }
    .featureImages div {
      text-align: center;
    }
    </style>
    </xsl:template>
    <!-- -->
    <xsl:template match="//Product|//object">
        <!-- CTNImage,  ProductName, WOW, SubWOW, MarketingTextHeader -->
        <table cellspacing="0" class="p-product-general">
            <tr>
                <td>
                    <table>
                        <tr>
                            <td class="p-image">
                                <img class="philips-img" width="200" alt="{CTN}" src="{$img_link}?alt=1&amp;defaultimg=1&amp;doctype=RTB&amp;id={CTN}"/>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <a target="_blank">
                                    <xsl:attribute name="href"><xsl:value-of select="concat($img_link,'?id=',CTN,'&amp;doctype=PSS&amp;laco=AEN')"/></xsl:attribute>Master Leaflet</a>
                            </td>
                        </tr>
                    </table>
                </td>
                <!-- -->
                <td valign="top">
                    <h2 style="margin:6px 0px">
                        <xsl:call-template name="show">
                            <xsl:with-param name="node" select="CTN"/>
                        </xsl:call-template>
                    </h2>
                    <br/>
                    <!-- -->
                    <h6>[ProductName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="ProductName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[MasterBrandName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/MasterBrand/BrandName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[PartnerBrandName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/Partner/PartnerBrand/BrandName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[PartnerBrandType]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/Partner/PartnerBrandType"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[PartnerProductName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/Partner/PartnerProductName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[PartnerProductIdentifier]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/Partner/PartnerProductIdentifier"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[BrandString2]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/BrandString2"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[ConceptName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/Concept/ConceptName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[FamilyName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/Family/FamilyName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[RangeName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/Range/RangeName"/>
                    </xsl:call-template>
                    <br/>                    
                    <h6>[DescriptorName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/Descriptor/DescriptorName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[VersionElementName1]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/VersionElement1/VersionElementName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[VersionElementName2]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/VersionElement2/VersionElementName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[VersionElementName3]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/VersionElement3/VersionElementName"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[VersionElementName4]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/VersionElement4/VersionElementName"/>
                    </xsl:call-template>
                    <br/>                    
                    <h6>[VersionString]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/VersionString"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[BrandedFeatureString]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/BrandedFeatureString"/>
                    </xsl:call-template>
                    <br/>
                    <h6>[DescriptorBrandedFeatureString]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="NamingString/DescriptorBrandedFeatureString"/>
                    </xsl:call-template>
                    <br/>
                    <!-- -->
                    <h6>[SupraFeatureName]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="SupraFeature/SupraFeatureName"/>
                    </xsl:call-template>
                    <br/>
                    <!-- -->
                    <h6>[ShortDescription]</h6>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="ShortDescription"/>
                    </xsl:call-template>
                    <br/>
                    <!-- -->
                    <h6>[WOW]</h6>
                    <p style="margin:6px 0px">
                        <xsl:call-template name="show">
                            <xsl:with-param name="node" select="WOW"/>
                        </xsl:call-template>
                    </p>
                    <!-- -->
                    <h6>[SubWOW]</h6>
                    <p style="font-size:100%;margin:6px 0px">
                        <xsl:call-template name="show">
                            <xsl:with-param name="node" select="SubWOW"/>
                        </xsl:call-template>
                    </p>
                    <!-- -->
                    <h6>[MarketingTextHeader]</h6>
                    <p style="font-size:100%;margin:6px 0px">
                        <xsl:call-template name="show">
                            <xsl:with-param name="node" select="MarketingTextHeader"/>
                        </xsl:call-template>
                    </p>
                </td>
            </tr>
        </table>
        <!-- -->
        <p style="margin:5px">&#160;</p>
        <!-- KeyBenefitArea -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">Features</h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <xsl:apply-templates select="KeyBenefitArea">
                    <xsl:sort data-type="number" select="KeyBenefitAreaRank"/>
                </xsl:apply-templates>
            </tbody>
        </table>
        <!-- FeatureCompareGroups -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">FeatureCompareGroups</h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <tr>
                    <td>
                        <ul>
                            <xsl:apply-templates select="FeatureCompareGroups" mode="Product"/>
                        </ul>
                    </td>
                </tr>
            </tbody>
        </table>
        <!-- -->
        <p style="margin:10px">&#160;</p>
        <!-- CSChapter -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">Specifications</h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <xsl:variable name="specifications">
                    <xsl:apply-templates select="CSChapter">
                        <xsl:sort data-type="number" select="CSChapterRank"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$specifications != ''">
                        <xsl:copy-of select="$specifications"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td>
                                <i>None specified</i>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <br/>
        <!-- RichText -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">RichTexts - </h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <xsl:variable name="RichTexts">
                    <xsl:apply-templates select="RichTexts" mode="Product"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$RichTexts != ''">
                        <tr>
                            <td>
                                <ul>
                                    <xsl:copy-of select="$RichTexts"/>
                                </ul>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td>
                                <i>None specified</i>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <br/>            
        <!-- Filters  -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">Filters</h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <xsl:variable name="Filters">
                    <xsl:apply-templates select="Filters" mode="Product"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$Filters != ''">
                        <tr>
                            <td>
                                <ul>
                                    <xsl:copy-of select="$Filters"/>
                                </ul>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td>
                                <i>None specified</i>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <br/>        
        <!-- ABPs -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">AccessoryByPacked</h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <xsl:variable name="abp">
                    <xsl:apply-templates select="AccessoryByPacked">
                        <xsl:sort data-type="number" select="AccessoryByPackedRank"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$abp != ''">
                        <tr>
                            <td>
                                <ul>
                                    <xsl:copy-of select="$abp"/>
                                </ul>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td>
                                <i>None specified</i>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <br/>        
        <!-- Navigation -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">Enrichments</h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <xsl:variable name="navigations">
                    <xsl:apply-templates select="NavigationGroup">
                        <xsl:sort data-type="number" select="NavigationGroupRank"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$navigations != ''">
                        <xsl:copy-of select="$navigations"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td>
                                <i>None specified</i>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <br/>
        <!-- Awards -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">Awards</h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <xsl:variable name="Awards">
                    <xsl:apply-templates select="Award">
                        <xsl:sort data-type="number" select="AwardRank"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$Awards != ''">
                        <tr>
                            <td>
                                <ul>
                                    <xsl:copy-of select="$Awards"/>
                                </ul>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td>
                                <i>None specified</i>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <br/>
   <!-- Assets -->
    <table cellspacing="0" class="p-product-general">
      <thead>
        <tr>
          <td>
            <h5 style="border-bottom: 1px solid #ccc">Assets</h5>
          </td>
        </tr>
      </thead>
      <!-- -->
      <tbody>
        <xsl:variable name="Assets">
          <xsl:apply-templates select="AssetList/Asset">
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$Assets != ''">
            <tr>
              <td>
                <ul>
                  <xsl:copy-of select="$Assets"/>
                </ul>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td>
                <i>None specified</i>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </tbody>
    </table>
    <br/>
  <!-- Accessories -->
    <table cellspacing="0" class="p-product-general">
      <thead>
        <tr>
          <td>
            <h5 style="border-bottom: 1px solid #ccc">Accessories</h5>
          </td>
        </tr>
      </thead>
      <!-- -->
      <tbody>
        <xsl:variable name="Accessories">
          <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType='Accessory']"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$Accessories != ''">
            <tr>
              <td>
                <ul>
                  <xsl:copy-of select="$Accessories"/>
                </ul>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td>
                <i>None specified</i>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </tbody>
    </table>
    <br/>
 <!-- Performers -->
    <table cellspacing="0" class="p-product-general">
      <thead>
        <tr>
          <td>
            <h5 style="border-bottom: 1px solid #ccc">Performers</h5>
          </td>
        </tr>
      </thead>
      <!-- -->
      <tbody>
        <xsl:variable name="Performers">
          <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType='Performer']"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$Performers != ''">
            <tr>
              <td>
                <ul>
                  <xsl:copy-of select="$Performers"/>
                </ul>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td>
                <i>None specified</i>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </tbody>
    </table>
    <br/>
        <!-- Disclaimers -->
        <table cellspacing="0" class="p-product-general">
            <thead>
                <tr>
                    <td>
                        <h5 style="border-bottom: 1px solid #ccc">Disclaimers</h5>
                    </td>
                </tr>
            </thead>
            <!-- -->
            <tbody>
                <tr>
                    <td>
                        <ul>
                            <xsl:apply-templates select="Disclaimer" mode="prod_107"/>
                            <xsl:apply-templates select="Disclaimers" mode="prod_110"/>
                        </ul>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
    <!-- -->
    <xsl:template match="KeyBenefitArea">
        <tr>
            <td>
                <b>
                    <xsl:call-template name="show">
                        <xsl:with-param name="node" select="KeyBenefitAreaName"/>
                    </xsl:call-template>
                </b>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td>
                <ul>
                    <xsl:apply-templates select="Feature">
                        <xsl:sort data-type="number" select="FeatureRank"/>
                    </xsl:apply-templates>
                </ul>
            </td>
        </tr>
    </xsl:template>
    <!-- -->
    <xsl:template match="Feature">
        <li>
            <b>
                <xsl:call-template name="show">
                    <xsl:with-param name="node" select="FeatureLongDescription"/>
                </xsl:call-template>
            </b>
            <xsl:if test="(../../FeatureLogo/FeatureCode = FeatureCode) or (../../FeatureImage/FeatureCode = FeatureCode)">
                <div class="featureImages">
                    <xsl:if test="../../FeatureLogo/FeatureCode = FeatureCode">
                        <div>
                            <img src="{$img_link}?alt=1&amp;defaultimg=1&amp;doctype=FLW&amp;id={FeatureCode}" alt="{FeatureName}" title="{FeatureLongDescription}"/>
                        </div>
                    </xsl:if>
                    <xsl:if test="../../FeatureImage/FeatureCode = FeatureCode">
                        <div>
                            <img src="{$img_link}?alt=1&amp;defaultimg=1&amp;doctype=FIW&amp;id={FeatureCode}" alt="{FeatureName}" title="{FeatureLongDescription}"/>
                        </div>
                    </xsl:if>
                </div>
            </xsl:if>
            <br/>
            <h6>[FeatureName]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="FeatureName"/>
            </xsl:call-template>
            <br/>
            <h6>[FeatureShortDescription]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="FeatureShortDescription"/>
            </xsl:call-template>
            <br/>
            <h6>[FeatureGlossary]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="FeatureGlossary"/>
            </xsl:call-template>
            <br/>
            <h6>[FeatureWhy]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="FeatureWhy"/>
            </xsl:call-template>
            <br/>
            <h6>[FeatureWhat]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="FeatureWhat"/>
            </xsl:call-template>
            <br/>
            <h6>[FeatureHow]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="FeatureHow"/>
            </xsl:call-template>
            <br/>
        </li>
    </xsl:template>
    <!-- -->
    <xsl:template match="CSChapter">
        <tr>
            <td>
                <div class="leftnavactivesection">
                    <b>
                        <xsl:call-template name="show">
                            <xsl:with-param name="node" select="CSChapterName"/>
                        </xsl:call-template>
                    </b>
                </div>
            </td>
        </tr>
        <!-- -->
        <xsl:apply-templates select="CSItem">
            <xsl:sort data-type="number" select="CSItemRank"/>
        </xsl:apply-templates>
    </xsl:template>
    <!-- -->
    <xsl:template match="CSItem">
        <tr>
            <td>
                <xsl:call-template name="show">
                    <xsl:with-param name="node" select="CSItemName"/>
                </xsl:call-template>:&#160; 

                <xsl:apply-templates select="CSValue">
          <xsl:sort data-type="number" select="CSValueRank"/>
        </xsl:apply-templates>&#160;
        <xsl:call-template name="show">
          <xsl:with-param name="node" select="UnitOfMeasure/UnitOfMeasureSymbol"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template match="CSValue">
    <xsl:call-template name="show">
      <xsl:with-param name="node" select="CSValueName"/>
    </xsl:call-template>
    <xsl:if test="position() != last()">,&#160;</xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="Filters" mode="Product">
    <xsl:apply-templates select="Purpose" mode="Product"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="Purpose" mode="Product">
    <tr>
      <td>
        <div class="leftnavactivesection">
          <b>
            <xsl:choose>
              <xsl:when test="@type = 'Detail'">Detail Product Features and Specifications</xsl:when>
              <xsl:when test="@type = 'Comparison'">Comparison Product Features and Specifications</xsl:when>
              <xsl:when test="@type = 'Discriminators'">Differentiating Features and Specifications</xsl:when>
              <xsl:otherwise>
                <xsl:text>FilterType=</xsl:text>
                <xsl:value-of select="@type"/>
              </xsl:otherwise>
            </xsl:choose>
          </b>
        </div>
      </td>
    </tr>
    <!-- -->
    <tr>
      <td>
        <xsl:for-each select="Features/Feature">
          <xsl:sort data-type="number" select="@rank"/>
          <xsl:variable name="c" select="@code"/>
          <xsl:call-template name="show">
            <xsl:with-param name="node" select="../../../../KeyBenefitArea/Feature[FeatureCode=$c]/FeatureLongDescription"/>
          </xsl:call-template>
          <br/>
        </xsl:for-each>
        <xsl:for-each select="CSItems/CSItem">
          <xsl:sort data-type="number" select="@rank"/>
          <xsl:variable name="c" select="@code"/>
          <xsl:variable name="item" select="../../../../CSChapter/CSItem[CSItemCode=$c]"/>
          <xsl:call-template name="show">
            <xsl:with-param name="node" select="$item/CSItemName"/>
          </xsl:call-template>
          <xsl:text>:&#160;</xsl:text>
          <xsl:apply-templates select="$item/CSValue">
            <xsl:sort data-type="number" select="CSValueRank"/>
          </xsl:apply-templates>
          <xsl:text>&#160;</xsl:text>
          <xsl:call-template name="show">
            <xsl:with-param name="node" select="$item/UnitOfMeasure/UnitOfMeasureSymbol"/>
          </xsl:call-template>
          <br/>
        </xsl:for-each>
        <br/>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template match="RichTexts" mode="Product">
    <xsl:apply-templates select="RichText" mode="Product"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="RichText" mode="Product">
    <tr>
      <td>
        <div class="leftnavactivesection">
          <b>
                        RichText - <xsl:value-of select="@type"/>
          </b>
        </div>
        <br/>
      </td>
    </tr>
    <!-- -->
    <tr>
      <td>
        <xsl:apply-templates select="Item" mode="Product_RichText">
          <xsl:sort data-type="number" select="@rank"/>
        </xsl:apply-templates>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
  <xsl:template match="Item" mode="Product_RichText">
    <h6>[Head]&#160;</h6>
    <xsl:call-template name="show">
      <xsl:with-param name="node" select="Head"/>
    </xsl:call-template>
    <br/>
    <h6>[Body]&#160;</h6>
    <xsl:call-template name="show">
      <xsl:with-param name="node" select="Body"/>
    </xsl:call-template>
    <xsl:apply-templates select="BulletList" mode="Product_RichText"/>
    <br/>
    <br/>
  </xsl:template>
  <xsl:template match="BulletList" mode="Product_RichText">
    <ul>
      <xsl:apply-templates select="BulletItem" mode="Product_RichText">
        <xsl:sort data-type="number" select="@rank"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>
  <xsl:template match="BulletItem" mode="Product_RichText">
    <li>
      <xsl:call-template name="show">
        <xsl:with-param name="node" select="Text"/>
      </xsl:call-template>
    </li>
  </xsl:template>
  <!-- -->
  <xsl:template match="NavigationGroup">
    <tr>
      <td>
        <div class="leftnavactivesection">
          <b>
            <xsl:call-template name="show">
              <xsl:with-param name="node" select="NavigationGroupName"/>
            </xsl:call-template>
          </b>
        </div>
      </td>
    </tr>
    <!-- -->
    <xsl:apply-templates select="NavigationAttribute">
      <xsl:sort data-type="number" select="NavigationAttributeRank"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- -->
  <xsl:template match="NavigationAttribute">
    <tr>
      <td>
        <xsl:call-template name="show">
          <xsl:with-param name="node" select="NavigationAttributeName"/>
        </xsl:call-template>:&#160; 
        <xsl:apply-templates select="NavigationValue">
          <xsl:sort data-type="number" select="NavigationValueRank"/>
        </xsl:apply-templates>
       </td>
      </tr>
    </xsl:template>
    <!-- -->
    <xsl:template match="NavigationValue">
        <xsl:call-template name="show">
            <xsl:with-param name="node" select="NavigationValueName"/>
        </xsl:call-template>
        <xsl:if test="position() != last()">,&#160;</xsl:if>
    </xsl:template>
    <!-- -->
    <xsl:template match="Award">
        <li>
            <b>
                <xsl:call-template name="show">
                    <xsl:with-param name="node" select="AwardName"/>
                </xsl:call-template>
            </b>
            <br/>
            <h6>[AwardDate]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="AwardDate"/>
            </xsl:call-template>
            <br/>
            <h6>[AwardPlace]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="AwardPlace"/>
            </xsl:call-template>
            <br/>
            <h6>[AwardDescription]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="AwardDescription"/>
            </xsl:call-template>
            <br/>
            <h6>[AwardAcknowledgement]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="AwardAcknowledgement"/>
            </xsl:call-template>
            <br/>
        </li>
    </xsl:template>
    <!-- -->
    <xsl:template match="Asset">
   <li>
      <b>
        <xsl:call-template name="show">
          <xsl:with-param name="node" select="ResourceType"/>
        </xsl:call-template>
      </b>
      <br/>
      <h6>[Language]</h6>
      <xsl:call-template name="show">
        <xsl:with-param name="node" select="Language"/>
      </xsl:call-template>
      <br/>
      <h6>[License]</h6>
      <xsl:call-template name="show">
        <xsl:with-param name="node" select="License"/>
      </xsl:call-template>
      <br/>
      <h6>[AccessRights]</h6>
      <xsl:call-template name="show">
        <xsl:with-param name="node" select="AccessRights"/>
      </xsl:call-template>
      <br/>
      <h6>[Modified]</h6>
      <xsl:call-template name="show">
        <xsl:with-param name="node" select="Modified"/>
      </xsl:call-template>
      <br/>
    </li>
  </xsl:template>

   <!-- -->
    <xsl:template match="ProductReference">
   <li>
      <b>
        <xsl:call-template name="show">
          <xsl:with-param name="node" select="CTN"/>
        </xsl:call-template>
      </b>
      <h6>[Rank]</h6>
      <xsl:call-template name="show">
        <xsl:with-param name="node" select="ProductReferenceRank"/>
      </xsl:call-template>
      <br/>
    </li>
  </xsl:template>  
   <!-- -->  
   <xsl:template match="ProductRefs/ProductReference">
    <xsl:for-each select="CTN">
     <li>
        <b>
          <xsl:call-template name="show">
            <xsl:with-param name="node" select="."/>
          </xsl:call-template>
        </b>
        <xsl:if test="@rank">
          <h6>[Rank]</h6>
          <xsl:call-template name="show">
            <xsl:with-param name="node" select="@rank"/>
          </xsl:call-template>
        </xsl:if>
        <br/>
      </li>
    </xsl:for-each>
  </xsl:template>    
 
    <xsl:template match="AccessoryByPacked">
        <li>
            <b>
                <xsl:call-template name="show">
                    <xsl:with-param name="node" select="AccessoryByPackedName"/>
                </xsl:call-template>
            </b>
            <br/>
            <h6>[AccessoryByPackedName]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="AccessoryByPackedName"/>
            </xsl:call-template>
            <br/>
            <h6>[AccessoryByPackedReference]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="AccessoryByPackedReference"/>
            </xsl:call-template>
            <br/>
        </li>
    </xsl:template>
    <!-- -->
    <xsl:template match="FeatureCompareGroup" mode="Product">
        <li>
            <b>
                <h6>[DisplayName]</h6>
                <xsl:call-template name="show">
                    <xsl:with-param name="node" select="DisplayName"/>
                </xsl:call-template>
            </b>
            <br/>
            <h6>[Glossary]</h6>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="Glossary"/>
            </xsl:call-template>
            <br/>
            <h6>[Features]</h6>
            <xsl:for-each select="Features/Feature">
                <ul>
                    <li>
                        <xsl:variable name="code" select="@code"/>
                        <xsl:value-of select="../../../../KeyBenefitArea/Feature[FeatureCode = $code]/FeatureName"/>
                    </li>
                </ul>
            </xsl:for-each>
        </li>
    </xsl:template>
    <!-- Display for old style (before 1.07) disclaimer -->
    <xsl:template match="Disclaimer" mode="prod_107">
        <li>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="DisclaimerName"/>
            </xsl:call-template>
        </li>
    </xsl:template>
    <!-- Display for new style (after 1.10) disclaimer -->
    <xsl:template match="Disclaimers" mode="prod_110">
        <xsl:apply-templates select="Disclaimer" mode="prod_110">
            <xsl:sort data-type="number" select="@rank"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="Disclaimer" mode="prod_110">
        <li>
            <xsl:call-template name="show">
                <xsl:with-param name="node" select="DisclaimerText"/>
            </xsl:call-template>
        </li>
    </xsl:template>
    <!-- -->
    <xsl:template match="*|@*">
        <!-- catch all: do nothing -->
    </xsl:template>
    <!-- -->
    <xsl:template name="show">
        <xsl:param name="node"/>
        <xsl:value-of select="$node"/>
    </xsl:template>
    <!-- -->
</xsl:stylesheet>