<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">
    
  <xsl:output encoding="UTF-8" indent="yes" media-type="application/json" method="text" />
  
  <!-- If the jsonp parameter has a non-empty value the json output is wrapped in a function call with that name -->
  <xsl:param name="jsonp"/>
  
  <xsl:variable name="quot">"</xsl:variable>
  <xsl:variable name="epoch" select="xs:dateTime('1970-01-01T00:00:00')"/>
  
  <xsl:template match="/">
    <xsl:if test="$jsonp!=''">
      <xsl:value-of select="concat($jsonp,'(')"/>
    </xsl:if>

    <xsl:text>{</xsl:text>
      <xsl:apply-templates/>
    <xsl:text>}</xsl:text>

    <xsl:if test="$jsonp!=''">
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <!--
    Output lists.
    Output: "list", [
              recursive child elements
            ]
  -->
  <xsl:template match="element()" mode="in-list" priority="0">
    <!-- Check if this is the first element in the list.
         (No element with the same name exists before this one.) -->
    <xsl:if test="empty(preceding-sibling::*[local-name() = local-name(current())])">
      <xsl:text>"list":[</xsl:text>
    </xsl:if>

    <xsl:text>{</xsl:text>
    <xsl:next-match/>
    <xsl:text>}</xsl:text>
    
    <xsl:choose>
      <xsl:when test="empty(following-sibling::*[local-name() = local-name(current())])">
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>,</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Output non-list attributes and elements -->
  <xsl:template match="@*|element()" priority="-1">
    <xsl:next-match/>
    <xsl:if test="position() != last()">
      <xsl:text>,</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <!--
    Attributes
    
    Output: "attr-name", "attr-value"
  -->
  <xsl:template match="@*" priority="-3" mode="#all">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>":</xsl:text>
    <xsl:value-of select="my:smart-text(string(.))"/>
  </xsl:template>

  <!-- 
    Empty elements 
    
    Output: "element-name", ""
  -->    
  <xsl:template match="element()[empty(child::element())][empty(@*)][normalize-space(text()) = '']"  mode="#all" priority="-3">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>":""</xsl:text>
  </xsl:template>

  <!-- 
    Elements 
      without child elements
      without attributes
      with non-empty text
    
    Output: "element-name", "element-value"
  -->    
  <xsl:template match="element()[empty(child::element())][empty(@*)][normalize-space(text()) != '']"  mode="#all" priority="-3">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>":</xsl:text>
    <xsl:apply-templates select="text()"/>
  </xsl:template>

  <!-- 
    Elements 
      without child elements
      with attributes
      with or without text
    
    Output: "element-name", {
              "attr-name", "attr-value"
             ,"'value'", "element-value"  // Only if the element has text
            }
   -->
  <xsl:template match="element()[empty(child::element())][exists(@*)]"  mode="#all" priority="-3">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>":{</xsl:text>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="normalize-space(text()) != ''">
      <xsl:if test="exists(@*)">
        <xsl:text>,</xsl:text>
      </xsl:if>
      <xsl:text>"value":</xsl:text>
      <xsl:apply-templates select="text()"/>
    </xsl:if>  
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!--
    Elements 
      with child elements
      with or without attributes
    
    Output: "element-name", {
              "attr-name", "attr-value",
              recursive children
            }
  -->
  <xsl:template match="element()[exists(child::element())]" mode="#all" priority="-3">
    <xsl:choose>
      <xsl:when test="normalize-space(string-join(text(),'')) != ''">
        <xsl:value-of select="error(QName('http://pww.pikachu.philips.com/error','err:mixmode'), 'Mixed mode elements are not supported')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:text>":{</xsl:text>
        <xsl:if test="exists(@*)">
          <xsl:apply-templates select="@*"/>
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="element()"/>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="text()" priority="-3">
    <xsl:value-of select="my:smart-text(.)"/>
  </xsl:template>
  
  <!--
    Conditional text node output.
    Creates output based of recognized types.
  -->
  <xsl:function name="my:smart-text">
    <xsl:param name="text"/>
    
    <xsl:choose>
      <xsl:when test="matches($text,'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})$')">
        <!-- Datetime: new Date(Y,M,D,H,m,s) -->
        <!-- xsl:value-of select="replace($text, '(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})', 'new Date($1,$2,$3,$4,$5,$6)')"/ -->
        <!-- xsl:value-of select="concat('new Date(', my:dateTime2millis(xs:dateTime($text)), ')')"/ -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="concat('\/Date(', my:dateTime2millis(xs:dateTime($text)), ')\/')"/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="matches($text, '^((\d+(\.\d+)?)|(\.\d+))$')">
        <!-- Number -->
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="$text = ('false','true')">
        <!-- Boolean -->
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- String -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="replace(replace($text,$quot,concat('\\',$quot)),'\r?\n|\r','\\n')"/>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
  <xsl:function name="my:dateTime2millis">
    <xsl:param name="date" as="xs:dateTime"/>
    <xsl:variable name="dur" select="xs:dayTimeDuration($date -$epoch)"/>
    <xsl:value-of select="1000 * (86400 * days-from-duration($dur) + 3600 * hours-from-duration($dur) + 60 * minutes-from-duration($dur) + seconds-from-duration($dur))"/>
  </xsl:function>
</xsl:stylesheet>
