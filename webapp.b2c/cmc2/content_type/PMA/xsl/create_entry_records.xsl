<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:a="http://feed.alatest.com" extension-element-prefixes="cmc2-f">

  <xsl:param name="ct" />
  <xsl:param name="l" />
  <xsl:param name="ts" />
  <xsl:param name="dir" />
  <xsl:param name="batchnumber" />
  <xsl:include href="../../../xsl/common/cmc2.function.xsl" />
  
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  
  <xsl:template match="a:reviewsfeed[a:alid]">
    <xsl:variable name="masterLastmodifiedTimestamp" select="concat(@generated-at,'T00:00:00')" />
    <xsl:variable name="contentType" select="$ct" />
    <xsl:variable name="reviewsfeed" select="." />
    
     <!-- get all locales from input files. This has been extended to include bazaarvoiceStatistics -->
    <xsl:for-each-group select="a:alid" group-by="a:bazaarvoiceStatistics/a:NativeReviewStatistics/@locale|a:review/a:locale|a:review/a:locales/a:locale">
      <xsl:sort select="current-grouping-key()" />
      <xsl:variable name="l" select="current-grouping-key()" />

      <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" valid="true">
        <process />	
		<!-- product for locale -->
        <xsl:for-each-group select="current-group()" group-by="a:productid/a:idvalue">
          <xsl:sort select="current-grouping-key()" />
          <xsl:variable name="o" select="current-grouping-key()" />
          
          <xsl:variable name="templ">
	          <xsl:choose>
	            <xsl:when test="not(contains($l,'_')) ">
	              <xsl:text>NONE</xsl:text>
	            </xsl:when>
	            <xsl:otherwise>
	              <xsl:value-of select="substring-after($l,'_')"/>
	            </xsl:otherwise>
	          </xsl:choose>          
          </xsl:variable>
          
          <xsl:variable name="fileName" select="concat(replace($dir,'outbox','temp'),'/list_Of_divisions.xml')"/>
          <xsl:variable name="file" select="document($fileName)" />          
          <xsl:variable name="division" select = "$file/divisions/sql:rowset/sql:row[sql:object_id = $o and sql:localisation =$l]/sql:division" />
          
          <xsl:variable name="productGrouping" select="cmc2-f:productGrouping($o,$division,$templ)" />         
    
          <xsl:for-each select="current-group()">
            <entry o="{$o}" ct="{$ct}" l="{$l}" valid="true">
              <result>OK</result>
              <content>
                <object o="{$o}" l="{$l}">
                  <xsl:if test="current-group()/a:bazaarvoiceStatistics[@groupid=$productGrouping]/a:NativeReviewStatistics[@locale=$l]">
                    <ReviewStatistics>
                      <xsl:for-each select="(current-group()/a:bazaarvoiceStatistics[@groupid=$productGrouping]/a:NativeReviewStatistics[@locale=$l])[1]">
                        <ReviewStatistics source="110117">
                          <AverageOverallRating>
                            <xsl:value-of select="a:averageoverallrating" />
                          </AverageOverallRating>
                          <OverallRatingRange>
                            <xsl:value-of select="a:overallratingrange" />
                          </OverallRatingRange>
                          <TotalReviewCount>
                            <xsl:value-of select="a:totalreviewcount" />
                          </TotalReviewCount>
                          <RatingsOnlyReviewCount>
                            <xsl:value-of select="a:ratingsonlyreviewcount" />
                          </RatingsOnlyReviewCount>
                          <RecommendedCount>
                            <xsl:value-of select="a:recommendedcount" />
                          </RecommendedCount>
                          <AverageRatingValues>
                            <xsl:value-of select="a:averageratingvalues" />
                          </AverageRatingValues>
                          <RatingDistribution>
                            <xsl:for-each select="a:RatingDistribution/a:RatingDistributionItem">
                              <RatingDistributionItem>
                                <RatingValue>
                                  <xsl:value-of select="a:ratingvalue" />
                                </RatingValue>
                                <Count>
                                  <xsl:value-of select="a:count" />
                                </Count>
                              </RatingDistributionItem>
                            </xsl:for-each>
                          </RatingDistribution>
                        </ReviewStatistics>
                      </xsl:for-each>
                    </ReviewStatistics>
                  </xsl:if>

                  <Awards>
                    <!--+
                        | Reviews for product and locale
                        | make sure we add reviews that are not global and all user reviews for the correct locale
                        | Also ensure that when the review is exclusively meant or specific products, it is not included in the result.
                        +-->
                    <xsl:for-each select="current-group()/a:review[a:source[(not(@global='true')) or (../@type =( 'user', 'bv_summary') )]]
                                                                  [a:locale=$l or a:locales/a:locale=$l]
                                                                  [empty(a:moderationstatus) or a:moderationstatus != 'REJECTED']
                                                                  [not(boolean(a:exclusive_productids)) or a:exclusive_productids/a:productid[a:idkind = 'philips_id']/a:idvalue=$o]">
                      <Award>
                        <xsl:choose>
                          <xsl:when test="@type='semantic'">
                            <xsl:attribute name="AwardType" select="'ala_summary'" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="AwardType" select="concat('ala_',@type)" />
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:attribute name="status" select="'Final Published'" />
                        <xsl:attribute name="globalSource" select="'false'" />
                        <xsl:attribute name="awardAlid" select="../@id" />
                        <!--xsl:attribute name="endOfPublication"/--><!-- not mapped -->
                        <AwardCode>
                          <xsl:value-of select="concat('ALA_',upper-case(@id))" />
                        </AwardCode>
                        <AwardName>
                          <xsl:value-of select="if (@type='award') then a:award else a:title"/>
                        </AwardName>
                        <AwardDate>
                          <xsl:value-of select="a:date/@isodate" />
                        </AwardDate>
                        <!--AwardPlace/--><!-- not mapped -->
                        <Title>
                          <xsl:value-of select="a:source/a:name" />
                        </Title>
                        <!--Issue/--><!-- not mapped -->
                        <Rating>
                          <xsl:value-of select="a:rating" />
                        </Rating>
						
						<!-- Update for defect fix for empty trends-->
                        <xsl:if test="../a:trend != '' ">
							<Trend>
							  <xsl:value-of select="../a:trend" />
							</Trend>
                        </xsl:if>
						
						<AwardAuthor>
                          <xsl:value-of select="a:author" />
                        </AwardAuthor>
                        <TestPros>
                          <xsl:value-of select="a:pros" />
                        </TestPros>
                        <TestCons>
                          <xsl:value-of select="a:cons" />
                        </TestCons>
                        <AwardDescription>
                          <xsl:value-of select="if (@type='award') then a:title else ()" />
                        </AwardDescription>
                        <AwardAcknowledgement>
                          <xsl:value-of select="if (a:summary) then a:summary else a:reviewtext" />
                        </AwardAcknowledgement>
                        <AwardVerdict>
                          <xsl:value-of select="a:verdict" />
                        </AwardVerdict>
                        <AwardText>
                          <xsl:value-of select="a:award" />
                        </AwardText>
                        <!--Locales/--><!-- not mapped -->
                        <AwardRank>
                          <xsl:value-of select="a:source/a:rank" />
                        </AwardRank>
                        <AwardSourceCode>
                          <xsl:value-of select="concat('ALS_',upper-case(a:source/@id))" />
                        </AwardSourceCode>
                        <AwardCategory>
                          <xsl:value-of select="../a:category" />
                        </AwardCategory>
                        <AwardSourceLocale>
                          <xsl:value-of select="concat(a:source/a:language,'_',a:source/a:country)" />
                        </AwardSourceLocale>
                      </Award>
                    </xsl:for-each>
                  </Awards>
                </object>
              </content>
              <store-outputs />
              <currentmasterlastmodified_ts>
                <sql:execute-query>
                  <sql:query name="create_entry_records">
                    select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                    from octl where content_type='<xsl:value-of select="$ct" />'
                    and localisation='<xsl:value-of select="$l" />'
                    and object_id='<xsl:value-of select="$o" />'
                  </sql:query>
                </sql:execute-query>
              </currentmasterlastmodified_ts>
              <currentlastmodified_ts />
              <octl-attributes>
                <lastmodified_ts>
                  <xsl:value-of select="$processTimestamp" />
                </lastmodified_ts>
                <masterlastmodified_ts>
                  <xsl:value-of select="$masterLastmodifiedTimestamp" />
                </masterlastmodified_ts>
                <status>Loaded</status>
              </octl-attributes>
            </entry>
          </xsl:for-each>
        </xsl:for-each-group>
        <globalDocs />
      </entries>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>