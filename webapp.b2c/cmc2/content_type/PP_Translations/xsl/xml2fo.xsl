<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- ROME: Next template can most probably be removed later. -->
  <xsl:template match="entry">
	<xsl:if test="content[PackagingProjectTranslations]">
		<xsl:copy>
		  <xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:if>
  </xsl:template>
  <xsl:template match="content">
	<content>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
		  <!-- page setup -->
		  <!-- size (A4)-->
		  <fo:layout-master-set>
			<fo:simple-page-master master-name="first-page" page-height="29.7cm" page-width="21cm" margin-top="7cm" margin-bottom="2cm" margin-left="2.5cm" margin-right="2.5cm">
			  <fo:region-body margin-top="3cm" margin-bottom="3cm"/>
			  <fo:region-before extent="3cm"/>
			  <fo:region-after extent="1.5cm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="default-page" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="2cm" margin-left="2.5cm" margin-right="2.5cm">
			  <fo:region-body margin-top="3cm" margin-bottom="3cm"/>
			  <fo:region-before extent="3cm"/>
			  <fo:region-after extent="1.5cm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="all">
			  <fo:repeatable-page-master-alternatives>
				<!--fo:conditional-page-master-reference master-reference="first-page" page-position="first"/-->
				<fo:conditional-page-master-reference master-reference="default-page" page-position="any"/>
			  </fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
		  </fo:layout-master-set>
		  <!-- page layout -->
		  <fo:page-sequence master-reference="all">
			<!-- footer-->
			<fo:static-content flow-name="xsl-region-after">
			  <fo:block text-align="right" font-size="10pt" font-family="ArialUnicodeMS" line-height="14pt" font-variant="normal" font-weight="normal">
				<fo:table table-layout="fixed" width="100%" border-spacing="2pt">
				  <fo:table-column column-width="130pt"/>
				  <fo:table-column column-width="proportional-column-width(1)"/>
				  <fo:table-column column-width="130pt"/>
				  <fo:table-body start-indent="0pt">
					<fo:table-row>
					  <fo:table-cell padding="2pt" display-align="center">
						<fo:block text-align="left">
						  <xsl:value-of select="@referenceName"/>
						</fo:block>
					  </fo:table-cell>
					  <fo:table-cell padding="2pt" display-align="center">
						<fo:block text-align="center">
					page <fo:page-number/>
						</fo:block>
					  </fo:table-cell>
					  <fo:table-cell padding="2pt" display-align="center">
						<fo:block text-align="right">
						  <xsl:value-of select="substring(@docTimeStamp,1,19)"/>
						</fo:block>
					  </fo:table-cell>
					</fo:table-row>
				  </fo:table-body>
				</fo:table>
			  </fo:block>
			</fo:static-content>
			<!-- body -->
			<fo:flow flow-name="xsl-region-body">
			  <xsl:apply-templates select="PackagingProjectTranslations"/>
			</fo:flow>
		  </fo:page-sequence>
		</fo:root>
	</content>
  </xsl:template>

  <xsl:template match="PackagingProjectTranslations">
	  <xsl:apply-templates select="Versioning/DocStatus"/>
	  <fo:block font-size="18pt" font-weight="bold" margin="0pt" text-align="left">
		<xsl:text>Package texts translations for project reference:</xsl:text>
	  </fo:block>
	  <fo:block font-size="24pt" font-weight="bold" margin="0pt" text-align="left">
		<xsl:value-of select="@referenceName"/>
	  </fo:block>
	  <fo:block>
		<fo:inline>
		  <xsl:text>&#160;</xsl:text>
		</fo:inline>
	  </fo:block>
	  <xsl:apply-templates select="Versioning"/>
	  <fo:block>
		<fo:inline>
		  <xsl:text>&#160;</xsl:text>
		</fo:inline>
	  </fo:block>
	  <fo:table table-layout="fixed" width="100%" border="solid 1pt gray" border-spacing="2pt">
		<fo:table-column column-width="proportional-column-width(1)"/>
		<fo:table-column column-width="300pt"/>
		<fo:table-body start-indent="0pt">
		  <fo:table-row>
			<fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
			  <fo:block>
				<fo:inline font-weight="bold">
				  <xsl:text>Remarks for Packaging Engineer</xsl:text>
				</fo:inline>
			  </fo:block>
			</fo:table-cell>
			<fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
			  <fo:block>
                    <xsl:value-of select="@remarks4engineer"/>
			  </fo:block>
			</fo:table-cell>
		  </fo:table-row>
		  <fo:table-row>
			<fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
			  <fo:block>
				<fo:inline font-weight="bold">
				  <xsl:text>Remarks for Translation Agency</xsl:text>
				</fo:inline>
			  </fo:block>
			</fo:table-cell>
			<fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
			  <fo:block>
                    <xsl:value-of select="@remarks4translation"/>
			  </fo:block>
			</fo:table-cell>
		  </fo:table-row>
		</fo:table-body>
	  </fo:table>
	  <fo:block>
		<fo:inline>
		  <xsl:text>&#160;</xsl:text>
		</fo:inline>
	  </fo:block>
    <fo:block background-color="#f0f0f0" border-style="solid" padding-left="2px" padding-right="2px" page-break-inside="auto" margin="0pt">
      <fo:block>
        <fo:table table-layout="fixed" width="100%" border-spacing="2pt">
          <!--fo:table-column column-width="130pt"/>
          <fo:table-column column-width="proportional-column-width(1)"/-->
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-column column-width="300pt"/>
          <fo:table-body start-indent="0pt">
            <fo:table-row>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block text-align="left">
                  <xsl:text>Project:</xsl:text>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block>
                  <xsl:value-of select="@code"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <xsl:apply-templates select="Versioning/Input[LanguageCode != 'Configuration' and LanguageCode != 'Source Text']" mode="availability"/>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:block>
    <fo:block>
      <fo:inline>
        <xsl:text>&#160;</xsl:text>
      </fo:inline>
    </fo:block>
	<xsl:apply-templates select="Versioning/Input[LanguageCode != 'Configuration' and LanguageCode != 'Source Text']" mode="PackagingTextItem"/>
	  <!--xsl:apply-templates select="PackagingTextItem" mode="parse"/-->
  </xsl:template>
  <!-- 
  <xsl:template match="node()|@*" mode="parse"/>-->
  <!---->

  <xsl:template match="Input" mode="availability">
	<xsl:variable name="languageCode" select="LanguageCode"/>
	<fo:table-row>
	  <fo:table-cell padding="2pt" display-align="center">
		<fo:block text-align="left">
		  <xsl:value-of select="$languageCode"/>
		</fo:block>
	  </fo:table-cell>
	  <fo:table-cell padding="2pt" display-align="center">
		<fo:block>
		  <xsl:choose>
			<xsl:when test="ancestor::PackagingProjectTranslations/PackagingTextItem/Translation[@languageCode=$languageCode]/ItemTextTranslation[. = 'not yet available']">
				<xsl:text>translations missing</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>translations completed</xsl:text>
			</xsl:otherwise>
		  </xsl:choose>
		</fo:block>
	  </fo:table-cell>
	</fo:table-row>
  </xsl:template>
  
  <xsl:template match="Input" mode="PackagingTextItem">
	<xsl:variable name="languageCode" select="LanguageCode"/>
    <fo:block background-color="#f0f0f0" border-style="solid" padding-left="2px" padding-right="2px" page-break-before="always" page-break-inside="auto" margin="0pt">
      <fo:block>
        <fo:table table-layout="fixed" width="100%" border-spacing="2pt">
          <fo:table-column column-width="130pt"/>
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body start-indent="0pt">
            <fo:table-row>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block text-align="left">
                  <xsl:text>Project:</xsl:text>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block>
                  <xsl:value-of select="../../@code"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block text-align="left">
                  <xsl:text>Language:</xsl:text>
                </fo:block>
              </fo:table-cell>
			  <fo:table-cell padding="2pt" display-align="center">
				<fo:block text-align="left">
				  <xsl:value-of select="$languageCode"/>
				</fo:block>
			  </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
        <fo:block background-color="#ffffe9" border-style="solid" width="100%" margin="0pt" keep-with-previous = "always">
          <fo:block>
            <fo:table table-layout="fixed" width="100%" border="solid 1pt gray" border-spacing="2pt">
               <fo:table-column column-width="130pt"/>
               <fo:table-column column-width="proportional-column-width(1)"/>
               <fo:table-column column-width="proportional-column-width(1)"/>
               <fo:table-body start-indent="0pt">
               <xsl:apply-templates select="ancestor::PackagingProjectTranslations/PackagingTextItem" mode="PackagingTextItem">
                  <xsl:with-param name="languageCode" select="$languageCode"/>
               </xsl:apply-templates>
               </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:block>
      </fo:block>
    </fo:block>
    <fo:block>
      <fo:inline>
        <xsl:text>&#160;</xsl:text>
      </fo:inline>
    </fo:block>
  </xsl:template>

  <xsl:template match="PackagingTextItem" mode="parse">
    <fo:block background-color="#f0f0f0" border-style="solid" padding-left="2px" padding-right="2px" page-break-before="always" page-break-inside="auto" margin="0pt">
      <fo:block>
        <fo:table table-layout="fixed" width="100%" border-spacing="2pt">
          <fo:table-column column-width="130pt"/>
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body start-indent="0pt">
            <fo:table-row>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block text-align="left">
                  <xsl:text>Productreference:</xsl:text>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block>
                  <xsl:value-of select="../@referenceName"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row keep-with-next="always">
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block>
                  <xsl:text>Item: </xsl:text>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block>
                  <xsl:value-of select="@code"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row keep-with-previous="always">
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block>
                  <xsl:text>Item Type:</xsl:text>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block>
                  <xsl:value-of select="@itemTypeDescription"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block text-align="left">
                  <xsl:text>Remarks:</xsl:text>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell padding="2pt" display-align="center">
                <fo:block>
                  <xsl:value-of select="@remarks"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
        <fo:block background-color="#ffffe9" border-style="solid" width="100%" margin="0pt" keep-with-previous = "always">
          <fo:block>
            <xsl:value-of select="ItemText"/>
            <fo:table table-layout="fixed" width="100%" border="solid 1pt gray" border-spacing="2pt">
              <fo:table-column column-width="130pt"/>
              <fo:table-column column-width="proportional-column-width(1)"/>
              <fo:table-column column-width="50pt"/>
              <fo:table-body start-indent="0pt">
                <xsl:apply-templates select="Translation" mode="parse"/>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:block>
      </fo:block>
    </fo:block>
    <fo:block>
      <fo:inline>
        <xsl:text>&#160;</xsl:text>
      </fo:inline>
    </fo:block>
  </xsl:template>
  <!-- -->
  <xsl:template match="PackagingTextItem" mode="PackagingTextItem">
	<xsl:param name="languageCode"/>
    <fo:table-row keep-with-previous="always">
      <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
        <fo:block>
          <xsl:value-of select="@itemDescription"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
        <fo:block font-family="ArialUnicodeMS" font-variant="normal" font-weight="normal">
          <xsl:value-of select="ItemText"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
        <fo:block font-family="ArialUnicodeMS" font-variant="normal" font-weight="normal">
          <xsl:value-of select="Translation[@languageCode=$languageCode]/ItemTextTranslation"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>
  <!-- -->
  <xsl:template match="Input">
    <fo:table-row>
      <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
        <fo:block>
          <xsl:value-of select="LanguageCode"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
        <fo:block>
          <xsl:value-of select="MasterLastModified"/>
          <xsl:if test="empty(MasterLastModified/text())">Not yet available</xsl:if>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
        <fo:block>
          <xsl:value-of select="LastModified"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>
  <!-- -->
  <xsl:template match="Versioning">
    <fo:table table-layout="fixed" width="100%" border="solid 1pt gray" border-spacing="2pt">
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="150pt"/>
      <fo:table-column column-width="150pt"/>
      <fo:table-body start-indent="0pt">
        <fo:table-row>
          <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
            <fo:block font-weight="bold">
              <xsl:value-of select="'Input'"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
            <fo:block font-weight="bold">
              <xsl:value-of select="'Version'"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border="solid 1pt gray" padding="2pt" display-align="center">
            <fo:block font-weight="bold">
              <xsl:value-of select="'Last Loaded'"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <xsl:apply-templates select="Input"/>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <!-- -->
  <xsl:template match="DocStatus">
    <fo:block font-size="36pt" font-weight="bold" margin="0pt" text-align="center">
    <!-- DEBUG BHE: volgende regel misschien weer naar enkelvoud: PackagingProjectTranslation -->
	  <xsl:if test="ancestor::PackagingProjectTranslations[preceding-sibling::PackagingProjectTranslations]"><xsl:attribute name="page-break-before" select="'always'"/></xsl:if>
      <xsl:value-of select="text()" />
      <fo:block font-size="20pt" font-weight="bold" margin="0pt" text-align="center">
        <xsl:value-of select="Remark/c" />
      </fo:block>
      <fo:block font-size="20pt" font-weight="bold" margin="0pt" text-align="center">
        <xsl:value-of select="Remark/m" />
      </fo:block>
      <fo:block font-size="20pt" font-weight="bold" margin="0pt" text-align="center">
        <xsl:value-of select="Remark/p" />
      </fo:block>
    </fo:block>
    <fo:block>
      <fo:inline>
        <xsl:text>&#160;</xsl:text>
      </fo:inline>
    </fo:block>
    <fo:block>
      <fo:inline>
        <xsl:text>&#160;</xsl:text>
      </fo:inline>
    </fo:block>
    <fo:block>
      <fo:inline>
        <xsl:text>&#160;</xsl:text>
      </fo:inline>
    </fo:block>
    <fo:block>
      <fo:inline>
        <xsl:text>&#160;</xsl:text>
      </fo:inline>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>
