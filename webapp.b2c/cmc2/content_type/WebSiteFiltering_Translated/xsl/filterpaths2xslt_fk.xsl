<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:pikaf="http://www.philips.com/pikachu/functions/1.0"
  exclude-result-prefixes="fn pikaf xs">
  
  <!--
     | Create an XSLT stylesheet that will enrich products with
     | website navigation data (FilterGroup/-Key/-Value).
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
     | The last template that matches all products with a priority of -99999
     | returns the gathered navigation data.
     |
     | See also filterpaths2xslt_nav.xslt which basically does the same thing, except
     | that the resulting XSLT will output a different navigation data format.  
     -->
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:variable name="quot">"</xsl:variable>
  <xsl:variable name="apos">'</xsl:variable>
  <xsl:variable name="lt">&lt;</xsl:variable>
  
  <!-- Escape any XML critical characters -->
  <xsl:function name="pikaf:escape-xml">
    <xsl:param name="s"/>
    <xsl:value-of select="fn:replace(fn:replace($s,$quot,'&quot;'),$lt,'&lt;')"/>
  </xsl:function>
  
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
      
      <xsl:element name="xsl:template">
        <xsl:attribute name="match">Product</xsl:attribute>
        <xsl:attribute name="priority">1</xsl:attribute>

        <xsl:element name="xsl:copy">
          <xsl:attribute name="copy-namespaces">no</xsl:attribute>

          <xsl:element name="xsl:apply-templates">
            <xsl:attribute name="select">CTN</xsl:attribute>
          </xsl:element>
          
          <xsl:element name="xsl:variable">
            <xsl:attribute name="name">result</xsl:attribute>
            
            <xsl:element name="xsl:next-match">
              <xsl:element name="xsl:with-param">
                <xsl:attribute name="name">filters</xsl:attribute>
                <xsl:element name="filters"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          
          <xsl:element name="xsl:if">
            <xsl:attribute name="test"><xsl:text>$result/*</xsl:text></xsl:attribute>
            
            <Filters>
              <xsl:element name="xsl:copy-of">
                <xsl:attribute name="copy-namespaces">no</xsl:attribute>
                <xsl:attribute name="select"><xsl:text>$result</xsl:text></xsl:attribute>
              </xsl:element>
            </Filters>
          </xsl:element>
        </xsl:element>
      </xsl:element>

      <xsl:apply-templates select="FilterGroup"/>
    
      <xsl:element name="xsl:template">
        <xsl:attribute name="match">Product</xsl:attribute>
        <xsl:attribute name="priority">-99999</xsl:attribute>
        
        <xsl:element name="xsl:param">
          <xsl:attribute name="name">filters</xsl:attribute>
        </xsl:element>
        
        <xsl:element name="xsl:copy-of">
          <xsl:attribute name="copy-namespaces">no</xsl:attribute>
          <xsl:attribute name="select"><xsl:text>$filters/filters/FilterGroup</xsl:text></xsl:attribute>
        </xsl:element>
      </xsl:element>
          
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
          <xsl:attribute name="select"><xsl:text>$assigned-groups/filters/FilterGroup[@code=$group/FilterGroup/@code]</xsl:text></xsl:attribute>
        </xsl:element>
        
        <filters>
          <xsl:element name="xsl:copy-of">
            <xsl:attribute name="copy-namespaces">no</xsl:attribute>
            <xsl:attribute name="select"><xsl:text>$assigned-groups/filters/FilterGroup[@code!=$group/FilterGroup/@code]</xsl:text></xsl:attribute>
          </xsl:element>
          <xsl:element name="xsl:choose">
            <xsl:element name="xsl:when">
              <xsl:attribute name="test"><xsl:text>fn:exists($existing-group)</xsl:text></xsl:attribute>
              
              <FilterGroup>
                <xsl:element name="xsl:copy-of">
                  <xsl:attribute name="copy-namespaces">no</xsl:attribute>
                  <xsl:attribute name="select"><xsl:text>$existing-group/@*</xsl:text></xsl:attribute>
                </xsl:element>
                <xsl:element name="xsl:copy-of">
                  <xsl:attribute name="copy-namespaces">no</xsl:attribute>
                  <xsl:attribute name="select"><xsl:text>$existing-group/*[local-name()!='FilterKeys']</xsl:text></xsl:attribute>
                </xsl:element>
                
                <FilterKeys>
                  <xsl:element name="xsl:call-template">
                    <xsl:attribute name="name">merge-keys</xsl:attribute>
                    <xsl:element name="xsl:with-param">
                      <xsl:attribute name="name">assigned-keys</xsl:attribute>
                      <xsl:attribute name="select"><xsl:text>$existing-group/FilterKeys/FilterKey</xsl:text></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xsl:with-param">
                      <xsl:attribute name="name">key</xsl:attribute>
                      <xsl:attribute name="select"><xsl:text>$group/FilterGroup/FilterKeys/FilterKey</xsl:text></xsl:attribute>
                    </xsl:element>
                  </xsl:element>
                </FilterKeys>
              </FilterGroup>
            </xsl:element>
            <xsl:element name="xsl:otherwise">
              <xsl:element name="xsl:copy-of">
                <xsl:attribute name="copy-namespaces">no</xsl:attribute>
                <xsl:attribute name="select"><xsl:text>$group</xsl:text></xsl:attribute>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </filters>
      </xsl:element>
            
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
          <xsl:attribute name="select"><xsl:text>$assigned-keys[@code=$key/@code]</xsl:text></xsl:attribute>
        </xsl:element>
        
        <xsl:element name="xsl:copy-of">
          <xsl:attribute name="copy-namespaces">no</xsl:attribute>
          <xsl:attribute name="select"><xsl:text>$assigned-keys[@code!=$key/@code]</xsl:text></xsl:attribute>
        </xsl:element>
        
        <xsl:element name="xsl:choose">
          <xsl:element name="xsl:when">
            <xsl:attribute name="test"><xsl:text>fn:exists($existing-key)</xsl:text></xsl:attribute>
            <FilterKey>
              <xsl:element name="xsl:copy-of">
                <xsl:attribute name="copy-namespaces">no</xsl:attribute>
                <xsl:attribute name="select"><xsl:text>$existing-key/@*</xsl:text></xsl:attribute>
              </xsl:element>
              <xsl:element name="xsl:copy-of">
                <xsl:attribute name="copy-namespaces">no</xsl:attribute>
                <xsl:attribute name="select"><xsl:text>$existing-key/*[local-name()!='FilterValues']</xsl:text></xsl:attribute>
              </xsl:element>
              <xsl:element name="xsl:if">
                <xsl:attribute name="test"><xsl:text>$existing-key/FilterValues or $key/FilterValues</xsl:text></xsl:attribute>
                
                <FilterValues>
                  <xsl:element name="xsl:copy-of">
                    <xsl:attribute name="copy-namespaces">no</xsl:attribute>
                    <xsl:attribute name="select"><xsl:text>$existing-key/FilterValues/FilterValue</xsl:text></xsl:attribute>
                  </xsl:element>
                  <xsl:element name="xsl:copy-of">
                    <xsl:attribute name="copy-namespaces">no</xsl:attribute>
                    <xsl:attribute name="select"><xsl:text>$key/FilterValues/FilterValue</xsl:text></xsl:attribute>
                  </xsl:element>
                </FilterValues>
              </xsl:element>
            </FilterKey>
          </xsl:element>
          <xsl:element name="xsl:otherwise">
            <xsl:element name="xsl:copy-of">
              <xsl:attribute name="copy-namespaces">no</xsl:attribute>
              <xsl:attribute name="select"><xsl:text>$key</xsl:text></xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>

    </xsl:element> <!-- end of xsl:stylesheet -->
  </xsl:template>


  <xsl:template match="FilterGroup">
    <xsl:apply-templates select="FilterKeys/FilterKey">
      <xsl:with-param name="group-pos" select="position()-1" as="xs:decimal"/>
    </xsl:apply-templates>
  </xsl:template>
  
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
  
  <xsl:template match="FilterKey/XPath">
    <xsl:param name="group-pos" as="xs:decimal"/>
    <xsl:param name="key-pos" as="xs:decimal"/>
    
    <xsl:element name="xsl:template">
      <xsl:attribute name="match" select="fn:concat('Product[',.,']')"/>
      <xsl:attribute name="priority" select="-($group-pos * 100 + $key-pos)"/>
      
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
  
  <xsl:template match="FilterValue">
    <xsl:param name="group-pos" as="xs:decimal"/>
    <xsl:param name="key-pos" as="xs:decimal"/>
    <xsl:apply-templates select="XPath">
      <xsl:with-param name="group-pos" select="$group-pos" as="xs:decimal"/>
      <xsl:with-param name="key-pos" select="$key-pos" as="xs:decimal"/>
      <xsl:with-param name="value-pos" select="position()-1" as="xs:decimal"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="FilterValue/XPath">
    <xsl:param name="group-pos" as="xs:decimal"/>
    <xsl:param name="key-pos" as="xs:decimal"/>
    <xsl:param name="value-pos" as="xs:decimal"/>

    <xsl:element name="xsl:template">
      <xsl:attribute name="match" select="fn:concat('Product[',.,']')"/>
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
              <xsl:with-param name="key-code" select="ancestor::FilterKey/@code"/>
              <xsl:with-param name="value-code" select="../@code"/>
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
    <xsl:param name="value-code"/>
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of copy-namespaces="no" select="@*|DisplayName|Glossary"/>
      <FilterKeys>
        <xsl:apply-templates select="FilterKeys/FilterKey[@code=$key-code]" mode="copy">
          <xsl:with-param name="value-code" select="$value-code"/>
        </xsl:apply-templates>
      </FilterKeys>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FilterKey" mode="copy">
    <xsl:param name="value-code"/>
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of copy-namespaces="no" select="@*|DisplayName|Glossary"/>
      <xsl:if test="$value-code != ''">
        <FilterValues>
          <xsl:apply-templates select="FilterValues/FilterValue[@code=$value-code]" mode="copy"/>
        </FilterValues>
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
