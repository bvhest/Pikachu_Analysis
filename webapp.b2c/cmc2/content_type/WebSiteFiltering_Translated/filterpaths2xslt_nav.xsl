<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:pikaf="http://www.philips.com/pikachu/functions/1.0" exclude-result-prefixes="fn pikaf xs">
	<!--
     | Create an XSLT stylesheet that will enrich products with
     | website navigation data (NavigationGroup/NavigationAttribute/NavigationValue).
     |
     | IN:  FilterGroup/-Key/-Value file (i.e. the navigation rules file)
     | OUT: XSLT Stylesheet file
     |
     | The resulting stylesheet will have an xsl template matcher for every
     | XPath found in the navigation rules file.
     | Every template is given a different priority to allow multiple matches
     | using <xsl:next-match/> which is called from every template matcher.
     |
     | When a template matches the product the navigation data for the
     | corresponding XPath is merged with previously added navigation data
     | by calling the template named merge-groups.
     |
     | The last template that matches all products using a priority of -99999
     | returns the gathered navigation data.
     -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="quot">"</xsl:variable>
	<xsl:variable name="apos">'</xsl:variable>
	<xsl:variable name="lt">&lt;</xsl:variable>
	<xsl:template match="/">
		<xsl:apply-templates select="//Filters"/>
	</xsl:template>
	<xsl:template match="Filters">
		<xsl:element name="xsl:stylesheet">
			<xsl:attribute name="version">2.0</xsl:attribute>
			<xsl:attribute name="fn:use" namespace="http://www.w3.org/2005/xpath-functions">true</xsl:attribute>
			<xsl:attribute name="exclude-result-prefixes">fn</xsl:attribute>
			<xsl:element name="xsl:output">
				<xsl:attribute name="method">xml</xsl:attribute>
				<xsl:attribute name="version">1.0</xsl:attribute>
				<xsl:attribute name="encoding">UTF-8</xsl:attribute>
				<xsl:attribute name="indent">yes</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:strip-space">
				<xsl:attribute name="elements">*</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:template">
				<xsl:attribute name="match"><xsl:text>@*|node()[local-name()!='Product']</xsl:text></xsl:attribute>
				<xsl:element name="xsl:copy">
					<xsl:attribute name="copy-namespaces">no</xsl:attribute>
					<xsl:element name="xsl:apply-templates">
						<xsl:attribute name="select"><xsl:text>@*|node()</xsl:text></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="xsl:template">
				<xsl:attribute name="match">globalDocs</xsl:attribute>
				<xsl:element name="xsl:copy">
					<xsl:attribute name="copy-namespaces">no</xsl:attribute>
				</xsl:element>
			</xsl:element>
			<!--
        This template will be the first one that matches Product
        because is has the highest priority
      -->
			<xsl:element name="xsl:template">
				<xsl:attribute name="match">Product</xsl:attribute>
				<xsl:attribute name="priority">1</xsl:attribute>
				<xsl:element name="xsl:copy">
					<xsl:attribute name="copy-namespaces">no</xsl:attribute>
					<!-- Copy the CTN -->
					<xsl:element name="xsl:apply-templates">
						<xsl:attribute name="select">CTN</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:variable">
						<xsl:attribute name="name">result</xsl:attribute>
						<!--
              Go to the next match.
              The filters parameter is passed to every next-match to pass
              the navigation data gathered by previous matches.
              It is of course empty in the first call.
            -->
						<xsl:element name="xsl:next-match">
							<xsl:element name="xsl:with-param">
								<xsl:attribute name="name">filters</xsl:attribute>
								<xsl:element name="filters"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<!--
            If there were any matching XPaths and hence any navigation data
            was gathered, output the results.
          -->
					<xsl:element name="xsl:if">
						<xsl:attribute name="test"><xsl:text>$result/*</xsl:text></xsl:attribute>
						<NavigationGroup>
							<NavigationGroupCode>navigation</NavigationGroupCode>
							<NavigationGroupName>Navigation</NavigationGroupName>
							<NavigationGroupRank>1</NavigationGroupRank>
							<xsl:element name="xsl:copy-of">
								<xsl:attribute name="copy-namespaces">no</xsl:attribute>
								<xsl:attribute name="select"><xsl:text>$result</xsl:text></xsl:attribute>
							</xsl:element>
						</NavigationGroup>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<!-- Every FilterGroup match will create an xsl:template -->
			<xsl:apply-templates select="FilterGroup"/>
			<!--
        This template will be the final match on every Product
        and will return the gathered navigation data.
      -->
			<xsl:element name="xsl:template">
				<xsl:attribute name="match">Product</xsl:attribute>
				<xsl:attribute name="priority">-99999</xsl:attribute>
				<xsl:element name="xsl:param">
					<xsl:attribute name="name">filters</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:copy-of">
					<xsl:attribute name="copy-namespaces">no</xsl:attribute>
					<xsl:attribute name="select"><xsl:text>$filters/filters/NavigationAttribute</xsl:text></xsl:attribute>
				</xsl:element>
			</xsl:element>
			<!--
        The convert-group template converts a FilterGroup to
        NavigationAttribute.
      -->
			<xsl:element name="xsl:template">
				<xsl:attribute name="name">convert-group</xsl:attribute>
				<xsl:element name="xsl:param">
					<xsl:attribute name="name">group</xsl:attribute>
				</xsl:element>
				<NavigationAttribute>
					<NavigationAttributeCode>
						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select"><xsl:text>$group/FilterGroup/@code</xsl:text></xsl:attribute>
						</xsl:element>
					</NavigationAttributeCode>
					<NavigationAttributeName>
						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select"><xsl:text>$group/FilterGroup/DisplayName</xsl:text></xsl:attribute>
						</xsl:element>
					</NavigationAttributeName>
					<NavigationAttributeRank>1</NavigationAttributeRank>
					<xsl:element name="xsl:call-template">
						<xsl:attribute name="name">convert-keys</xsl:attribute>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">keys</xsl:attribute>
							<xsl:attribute name="select"><xsl:text>$group/FilterGroup/FilterKeys/FilterKey</xsl:text></xsl:attribute>
						</xsl:element>
					</xsl:element>
				</NavigationAttribute>
			</xsl:element>
			<!--
        The merge-groups template merges one FilterGroup with existing,
        previously gathered, NavigationAttribute-s.
      -->
			<xsl:element name="xsl:template">
				<xsl:attribute name="name">merge-groups</xsl:attribute>
				<xsl:element name="xsl:param">
					<xsl:attribute name="name">assigned-groups</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:param">
					<xsl:attribute name="name">group</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name">existing-group</xsl:attribute>
					<xsl:attribute name="select"><xsl:text>$assigned-groups/filters/NavigationAttribute[NavigationAttributeCode/text()=$group/FilterGroup/@code]</xsl:text></xsl:attribute>
				</xsl:element>
				<filters>
					<xsl:element name="xsl:copy-of">
						<xsl:attribute name="copy-namespaces">no</xsl:attribute>
						<xsl:attribute name="select"><xsl:text>$assigned-groups/filters/NavigationAttribute[NavigationAttributeCode/text()!=$group/FilterGroup/@code]</xsl:text></xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:choose">
						<xsl:element name="xsl:when">
							<xsl:attribute name="test"><xsl:text>fn:exists($existing-group)</xsl:text></xsl:attribute>
							<NavigationAttribute>
								<xsl:element name="xsl:copy-of">
									<xsl:attribute name="copy-namespaces">no</xsl:attribute>
									<xsl:attribute name="select"><xsl:text>$existing-group/NavigationAttributeCode|$existing-group/NavigationAttributeName|$existing-group/NavigationAttributeRank</xsl:text></xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:call-template">
									<xsl:attribute name="name">merge-keys</xsl:attribute>
									<xsl:element name="xsl:with-param">
										<xsl:attribute name="name">assigned-keys</xsl:attribute>
										<xsl:attribute name="select"><xsl:text>$existing-group/NavigationValue</xsl:text></xsl:attribute>
									</xsl:element>
									<xsl:element name="xsl:with-param">
										<xsl:attribute name="name">key</xsl:attribute>
										<xsl:attribute name="select"><xsl:text>$group/FilterGroup/FilterKeys/FilterKey</xsl:text></xsl:attribute>
									</xsl:element>
								</xsl:element>
							</NavigationAttribute>
						</xsl:element>
						<xsl:element name="xsl:otherwise">
							<xsl:element name="xsl:call-template">
								<xsl:attribute name="name">convert-group</xsl:attribute>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">group</xsl:attribute>
									<xsl:attribute name="select"><xsl:text>$group</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</filters>
			</xsl:element>
			<!--
        The convert-keys template converts FilterKey-s to
        NavigationValue-s.
      -->
			<xsl:element name="xsl:template">
				<xsl:attribute name="name">convert-keys</xsl:attribute>
				<xsl:element name="xsl:param">
					<xsl:attribute name="name">keys</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:for-each">
					<xsl:attribute name="select"><xsl:text>$keys</xsl:text></xsl:attribute>
					<NavigationValue>
						<NavigationValueCode>
							<xsl:element name="xsl:value-of">
								<xsl:attribute name="select"><xsl:text>@code</xsl:text></xsl:attribute>
							</xsl:element>
						</NavigationValueCode>
						<NavigationValueName>
							<xsl:element name="xsl:value-of">
								<xsl:attribute name="select"><xsl:text>DisplayName</xsl:text></xsl:attribute>
							</xsl:element>
						</NavigationValueName>						
						<NavigationValueRank>1</NavigationValueRank>
				<!--Add element DisplayValue to store DisplayValue (DV) for this FG-FK. Note that this is a localized value. This value must be set for all FG-FK’s that are derived from the specifications (Chapter – Item – Value) -->
				<DisplayValue>
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select"><xsl:text>XPath_DV</xsl:text></xsl:attribute>
					</xsl:element>
				</DisplayValue>
				<!--Add element FilterValue to store the FV (to be set when MustHaveValue=True in the rules file)-->
				<xsl:element name="xsl:choose">
					<xsl:element name="xsl:when"><xsl:attribute name="test"><xsl:text>MustHaveValue='true' and UseFixedFV='true'</xsl:text></xsl:attribute>
					   <xsl:element name="FilterValue"><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:text>FixedFV</xsl:text></xsl:attribute></xsl:element></xsl:element></xsl:element>
					<xsl:element name="xsl:when"><xsl:attribute name="test"><xsl:text>MustHaveValue='true' and UseFixedFV='false'</xsl:text></xsl:attribute>
					   <xsl:element name="FilterValue"><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:text>XPath_DV</xsl:text></xsl:attribute></xsl:element></xsl:element> </xsl:element>
				</xsl:element>
				<!--debug><xsl:element name="xsl:copy-of">
					<xsl:attribute name="select"><xsl:text>XPath</xsl:text></xsl:attribute>
					</xsl:element></debug-->
					</NavigationValue>
				</xsl:element>
			</xsl:element>
			<!--
        The merge-keys template merges one FilterKey with existing,
        previously gathered, NavigationValue-s.
      -->
			<xsl:element name="xsl:template">
				<xsl:attribute name="name">merge-keys</xsl:attribute>
				<xsl:element name="xsl:param">
					<xsl:attribute name="name">assigned-keys</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:param">
					<xsl:attribute name="name">key</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name">existing-key</xsl:attribute>
					<xsl:attribute name="select"><xsl:text>$assigned-keys[NavigationValueCode/text()=$key/@code]</xsl:text></xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:copy-of">
					<xsl:attribute name="copy-namespaces">no</xsl:attribute>
					<xsl:attribute name="select"><xsl:text>$assigned-keys[NavigationValueCode/text()!=$key/@code]</xsl:text></xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:choose">
					<xsl:element name="xsl:when">
						<xsl:attribute name="test"><xsl:text>fn:exists($existing-key)</xsl:text></xsl:attribute>
						<NavigationValue>
							<xsl:element name="xsl:copy-of">
								<xsl:attribute name="copy-namespaces">no</xsl:attribute>
								<xsl:attribute name="select"><xsl:text>$existing-key/NavigationValueCode|$existing-key/NavigationValueName|$existing-key/NavigationValueRank</xsl:text></xsl:attribute>
							</xsl:element>
						</NavigationValue>
					</xsl:element>
					<xsl:element name="xsl:otherwise">
						<xsl:element name="xsl:call-template">
							<xsl:attribute name="name">convert-keys</xsl:attribute>
							<xsl:element name="xsl:with-param">
								<xsl:attribute name="name">keys</xsl:attribute>
								<xsl:attribute name="select"><xsl:text>$key</xsl:text></xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<!-- end of xsl:stylesheet -->
	</xsl:template>
	<!--
    Apply templates to all FilterKey-s passing the group position for generating
    a priority.
  -->
	<xsl:template match="FilterGroup">
		<xsl:apply-templates select="FilterKeys/FilterKey">
			<xsl:with-param name="group-pos" select="position()-1" as="xs:decimal"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
    A FilterKey can either contain an XPath or FilterValues, but not both
  -->
	<xsl:template match="FilterKey">
		<xsl:param name="group-pos" as="xs:decimal"/>
		<xsl:choose>
			<xsl:when test="XPath">
				<xsl:apply-templates select="XPath">
					<xsl:with-param name="group-pos" select="$group-pos" as="xs:decimal"/>
					<xsl:with-param name="key-pos" select="position()-1" as="xs:decimal"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="FilterValues/FilterValue">
					<xsl:with-param name="group-pos" select="$group-pos" as="xs:decimal"/>
					<xsl:with-param name="key-pos" select="position()-1" as="xs:decimal"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
    An XPath inside a FilterKey creates an xsl:template matching the XPath.
    The 'content' of the xsl:template consists of the FilterGroup and FilterKey
    the XPath is contained by.
    e.g. [pseudo]
      FilterGroup
        FilterKey
          XPath
      
      leads to
      
      xsl:template match="XPath"
        FilterGroup
          FilterKey   
  -->
	<xsl:template match="FilterKey/XPath">
		<xsl:param name="group-pos" as="xs:decimal"/>
		<xsl:param name="key-pos" as="xs:decimal"/>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match" select="fn:concat('Product[',.,']')"/>
			<!--
        Create a unique priority. There can be a total of 100 XPath expressions
        in one FilterGroup, either in FilterKey or FilterValue descendants of the group 
      -->
			<xsl:attribute name="priority" select="-($group-pos * 100 + $key-pos)"/>
			<!--
        The filters param contains the navigation data gathered in previous matches
      -->
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">filters</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:variable">
				<xsl:attribute name="name">updated-filters</xsl:attribute>
				<!--
          Call the merge-groups template to merge the previously gathered navigation data
          with the current FilterGroup and FilterKey
        -->
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name">merge-groups</xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">assigned-groups</xsl:attribute>
						<xsl:attribute name="select"><xsl:text>$filters</xsl:text></xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">group</xsl:attribute>
						<!--
              Copy the current FilterGroup and FilterKey to pass them
              to the merge-groups template
            -->
						<xsl:apply-templates select="ancestor::FilterGroup" mode="copy">
							<xsl:with-param name="key-code" select="../@code"/>
							<xsl:with-param name="key" select=".."/>
						</xsl:apply-templates>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<!-- Go to the next match -->
			<xsl:element name="xsl:next-match">
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">filters</xsl:attribute>
					<xsl:attribute name="select"><xsl:text>$updated-filters</xsl:text></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="FilterValue">
		<xsl:param name="group-pos" as="xs:decimal"/>
		<xsl:param name="key-pos" as="xs:decimal"/>
		<xsl:apply-templates select="XPath">
			<xsl:with-param name="group-pos" select="$group-pos" as="xs:decimal"/>
			<xsl:with-param name="key-pos" select="$key-pos" as="xs:decimal"/>
			<xsl:with-param name="value-pos" select="position()-1" as="xs:decimal"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
    An XPath inside a FilterValue creates an xsl:template matching the XPath.
    The 'content' of the xsl:template consists of the FilterGroup, FilterKey and FilterValue
    the XPath is contained by.
    e.g. [pseudo]
      FilterGroup
        FilterKey
          FilterValue
            XPath
      
      leads to
      
      xsl:template match="XPath"
        FilterGroup
          FilterKey
            FilterValue  
  -->
	<xsl:template match="FilterValue/XPath">
		<xsl:param name="group-pos" as="xs:decimal"/>
		<xsl:param name="key-pos" as="xs:decimal"/>
		<xsl:param name="value-pos" as="xs:decimal"/>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match" select="fn:concat('Product[',.,']')"/>
			<!--
        Create a unique priority. There can be a total of 100 XPath expressions
        in one FilterGroup, either in FilterKey or FilterValue descendants of the group 
      -->
			<xsl:attribute name="priority" select="-($group-pos * 100 + $key-pos + $value-pos)"/>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">filters</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:variable">
				<xsl:attribute name="name">updated-filters</xsl:attribute>
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name">merge-groups</xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">assigned-groups</xsl:attribute>
						<xsl:attribute name="select"><xsl:text>$filters</xsl:text></xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">group</xsl:attribute>
						
						<xsl:apply-templates select="ancestor::FilterGroup" mode="copy">
							<xsl:with-param name="key-code" select="../@code"/>
							<xsl:with-param name="key" select=".."/>
						</xsl:apply-templates>
						
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="xsl:next-match">
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">filters</xsl:attribute>
					<xsl:attribute name="select"><xsl:text>$updated-filters</xsl:text></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!--
     | Copy FilterGroup/FilterKey/FilterValue branch
     |
     | mode: copy
     -->
	<xsl:template match="FilterGroup" mode="copy">
		<xsl:param name="key-code"/>
		<xsl:param name="key"/>
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of copy-namespaces="no" select="@*|DisplayName|Glossary"/>
			<FilterKeys>
				<xsl:apply-templates select="$key" mode="copy">
					<xsl:with-param name="value-code" select="$key-code"/>
				</xsl:apply-templates>
			</FilterKeys>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="FilterKey" mode="copy">
		<xsl:param name="value-code"/>
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of copy-namespaces="no" select="@*|DisplayName|Glossary|MustHaveValue|UnitOfSortValue|UseFixedFV|FixedFV"/>
			<XPath_DV><xsl:element name="xsl:value-of">
								<xsl:attribute name="select"><xsl:value-of select="XPath_DV"/></xsl:attribute>
							</xsl:element></XPath_DV>
			<xsl:if test="$value-code != ''">
				<FilterValues>
					<xsl:apply-templates select="FilterValues/FilterValue[@code=$value-code]" mode="copy"/>
				</FilterValues>
				<xsl:copy-of copy-namespaces="no" select="XPath"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="FilterValue" mode="copy">
		<xsl:param name="value-code"/>
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of copy-namespaces="no" select="@*|DisplayName|Glossary"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
