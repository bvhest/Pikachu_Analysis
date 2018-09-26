<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="product_generic.xsl"/>
	
	<xsl:template name="headers-product-awardsandreviews">
		<xsl:comment>Product Awards &amp; Reviews headers</xsl:comment>
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/product/product_awardsandreviews.css" />

		<link rel="stylesheet" type="text/css" href="{$website-resources-crsc}styles/global.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-crsc}styles/internet.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-crsc}styles/components.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-assets}css/ce-styles_v1.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-assets}css/pce_gmm.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-assets}css/overrides/overrides_global.css" />

		<!--script type="text/javascript" src="{$icp-host}js/product/product_awardsandreviews.js"></script-->
	</xsl:template>
	
	<xsl:template match="Products" mode="product-awardsandreviews">
		<div id="icp_view_awardsandreviews" class="icp_view">
			<div id="icp_content_website" class="icp_content">
				<xsl:apply-templates select="Product[position() &lt;= $max-items]" mode="l-prd-awdrev"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="Product" mode="l-prd-awdrev">
		<xsl:variable name="ctn" select="CTN"/>
		<xsl:variable name="ctn-norm" select="translate(CTN, '/', '_')"/>
		<div class="icp_container {$locale-lc} {{id:'{$ctn}'}}" id="{$ctn-norm}_container_awardsandreviews">
			<xsl:if test="position() &gt; 1">
				<xsl:attribute name="style">display: none;</xsl:attribute>
			</xsl:if>
			<div id="ipnContainer">
				<div id="p-body-wrapper">
					<div class="p-clearfix" id="p-body-innerwrapper">
						<div id="p-body-content">
              <div class="awdrev_title">Awards and Reviews</div>
              <table class="awdrev_main">
                <tr>
                  <td class="awdrev_awards">
                    <div class="awdrev_awards_title">Awards</div>
                    <xsl:apply-templates select="Award[@AwardType=('global','global_highlight')]" mode="l-prd-awdrev-award">
                      <xsl:with-param name="ctn" select="$ctn"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="Award[@AwardType='ala_award']" mode="l-prd-awdrev-award">
                      <xsl:sort select="AwardRank"/>
                      <xsl:with-param name="ctn" select="$ctn"/>
                    </xsl:apply-templates>
                  </td>
                  <td class="awdrev_reviews">
                    <div class="awdrev_reviews_title">Professional Reviews</div>
                    <table>
                      <xsl:apply-templates select="Award[@AwardType='ala_award']" mode="l-prd-awdrev-review">
                        <xsl:sort select="AwardRank"/>
                        <xsl:with-param name="ctn" select="$ctn"/>
                      </xsl:apply-templates>
                    </table>
                    <table>
                      <xsl:apply-templates select="Award[@AwardType='ala_expert']" mode="l-prd-awdrev-review">
                        <xsl:sort select="AwardRank"/>
                        <xsl:with-param name="ctn" select="$ctn"/>
                      </xsl:apply-templates>
                    </table>
                    <xsl:if test="count(Award[@type='ala_user']) &gt; 0">
                      <div class="awdrev_reviews_title">User Reviews</div>
                      <table>
                        <xsl:apply-templates select="Award[@AwardType='ala_user']" mode="l-prd-awdrev-review">
                          <xsl:sort select="AwardRank"/>
                          <xsl:with-param name="ctn" select="$ctn"/>
                        </xsl:apply-templates>
                      </table>
                    </xsl:if>
                  </td>
                </tr>
              </table>
						</div>
					</div>
					<div id="p-body-bottomwrapper"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="Award" mode="l-prd-awdrev-award">
    <xsl:param name="ctn"/>
    <div class="awdrev_award_logo">
      <xsl:apply-templates select="." mode="awdrev-logo">
        <xsl:with-param name="ctn" select="$ctn"/>
      </xsl:apply-templates>
     </div>
     <div class="awdrev_award_desc">
      <xsl:call-template name="display-text">
        <xsl:with-param name="text-node" select="Title"/>
      </xsl:call-template>
     </div>
	</xsl:template>
  
	<xsl:template match="Award" mode="l-prd-awdrev-review">
    <xsl:param name="ctn"/>
    <tr>
      <td class="awdrev_review_left">
        <xsl:apply-templates select="." mode="awdrev-stars"/>
        <div class="awdrev_review_date">
          <xsl:value-of select="AwardDate"/>
        </div>
      </td>
      <td class="awdrev_review_right">
        <div class="awdrev_review_head">
          <xsl:call-template name="display-text">
            <xsl:with-param name="text-node" select="AwardName"/>
          </xsl:call-template>
        </div>
        <xsl:if test="Title != ''">
          <div class="awdrev_review_title">
            <xsl:call-template name="display-text">
              <xsl:with-param name="text-node" select="Title"/>
            </xsl:call-template>
          </div>
        </xsl:if>
        <!--
        <xsl:if test="TestPros != ''">
          <div class="awdrev_review_pros">
            <b>Pros</b><br/>
            <xsl:call-template name="display-text">
              <xsl:with-param name="text-node" select="TestPros"/>
            </xsl:call-template>
          </div>
        </xsl:if>
        <xsl:if test="TestCons != ''">
          <div class="awdrev_review_cons">
            <b>Cons</b><br/>
            <xsl:call-template name="display-text">
              <xsl:with-param name="text-node" select="TestCons"/>
            </xsl:call-template>
          </div>
        </xsl:if>
        -->
        <div class="awdrev_review_body">
          <xsl:call-template name="display-text">
            <xsl:with-param name="text-node" select="AwardAcknowledgement"/>
          </xsl:call-template>
        </div>
        <!--
        <xsl:if test="AwardDescription != ''">
          <div class="awdrev_review_description">
            <xsl:call-template name="display-text">
              <xsl:with-param name="text-node" select="AwardDescription"/>
            </xsl:call-template>
          </div>
        </xsl:if>
        -->
        <xsl:variable name="readmore-url" select="key('asset-by-code', concat($ctn, AwardCode))[@type='AWU']"/>
        <xsl:if test="$readmore-url != ''">
          <div class="awdrev_review_readmore">
            <a href="{$readmore-url}" target="_blank">Read the entire review &gt;&gt;</a>
          </div>
        </xsl:if>
      </td>
     </tr>
	</xsl:template>
  
  <xsl:template match="Award" mode="awdrev-stars">
    <xsl:choose>
      <xsl:when test="Rating != '' and Rating != '0'">
        <xsl:variable name="rating5" select="floor(number(Rating) div 5) * 5"/>
        <xsl:variable name="stars" select="$rating5 div 20"/>
        <xsl:variable name="img-width" select="floor($stars * 85 div 5)"/>
        <div class="awdrev_rating_stars_blank">
          <div class="awdrev_rating_stars" debug="{Rating}|{$rating5}|{$stars}|{$img-width}">
            <xsl:attribute name="style">
              <xsl:value-of select="concat('width:',$img-width,'px')"/>
            </xsl:attribute>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="awdrev_norating">No rating</div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="Award" mode="awdrev-logo">
    <xsl:param name="ctn"/>
    <xsl:variable name="logo-url" select="key('asset-by-code', concat($ctn, AwardCode))[@type='AWP']"/>
    <xsl:if test="$logo-url != ''">
      <img src="{$logo-url}" alt="{AwardCode}"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
