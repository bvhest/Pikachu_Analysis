<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="ct"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="excludeworkflow"/>
  <xsl:param name="includeworkflow"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:variable name="list">
        <list>
          <xsl:apply-templates/>
        </list>
      </xsl:variable>
      <xsl:for-each-group select="$list/list/entry" group-by="@prefix">
        <xsl:for-each select="current-group()">
          <xsl:sort select="@filetimestamp" order="ascending"/>
          <xsl:choose>
            <xsl:when test="$excludeworkflow='' and $includeworkflow=''">
              <!-- both params empty so include all files -->
              <cinclude:include src="cocoon:/createEntryRecords/{$ct}/{$timestamp}/{@name}?prefix={@prefix}&amp;filetimestamp={@filetimestamp}&amp;locale={@locale}&amp;batch={@batch}&amp;subbatch={@subbatch}"/>
            </xsl:when>
            <xsl:when test="$excludeworkflow!=''">
              <!-- include files that don't have excludeworkflow in the filename-->
              <xsl:if test="not(contains(@name,$excludeworkflow))">
                <cinclude:include src="cocoon:/createEntryRecords/{$ct}/{$timestamp}/{@name}?prefix={@prefix}&amp;filetimestamp={@filetimestamp}&amp;locale={@locale}&amp;batch={@batch}&amp;subbatch={@subbatch}"/>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$includeworkflow!=''">
              <!-- include files that have includeworkflow in the filename-->
              <xsl:if test="contains(@name,$includeworkflow)">
                <cinclude:include src="cocoon:/createEntryRecords/{$ct}/{$timestamp}/{@name}?prefix={@prefix}&amp;filetimestamp={@filetimestamp}&amp;locale={@locale}&amp;batch={@batch}&amp;subbatch={@subbatch}"/>
              </xsl:if>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each-group>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:apply-templates select="node()|@*"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[contains(@name,'Online_Products') or contains(@name,'pbatch')]">
  <!--+  E.g.
      |    pbatch.CL_CMC.20081206031341.ja_JP.ACC_MENSGROOMING_CA.1.1.xml
      |    Online_Products_Flat_TV_plasma_LCD_CL_CMC.20090321015724.es_ES.1.2.xml
      |    pbatch.20080322005819.fr_BE.RADIO_CASSETTEPLAYER_RECORDER_CA.4.1.xml
      +-->
      <xsl:variable name="israbbit"      select="if(contains(@name,'CL_CMC') or contains(@name,'CL_QUERY')) then true() else false()"/>
      <xsl:variable name="prefix"        select="if(contains(@name,'pbatch')) then 'pbatch'
                                                 else if(contains(@name,'Online_Products')) then 'Online_Products'
                                                 else tokenize(@name,'\.')[1]"/>
      <xsl:variable name="filetimestamp" select="if($israbbit and $prefix = 'pbatch') then tokenize(@name,'\.')[3] else tokenize(@name,'\.')[2]"/>
      <xsl:variable name="locale"        select="if($israbbit and $prefix = 'pbatch') then tokenize(@name,'\.')[4] else tokenize(@name,'\.')[3]"/>
      <xsl:variable name="batch"         select="if($israbbit and $prefix = 'pbatch') then tokenize(@name,'\.')[6] else if($israbbit) then tokenize(@name,'\.')[4] else tokenize(@name,'\.')[5]"/>
      <xsl:variable name="subbatch"      select="if($israbbit and $prefix = 'pbatch') then tokenize(@name,'\.')[7] else if($israbbit) then tokenize(@name,'\.')[5] else tokenize(@name,'\.')[6]"/>
      <!-- Filter out non-cmc2-generated translation file returns -->
      <xsl:if test="string-length($batch) gt 0">
        <entry>
          <xsl:attribute name="name" select="@name"/>
          <xsl:attribute name="prefix" select="$prefix"/>
          <xsl:attribute name="filetimestamp" select="$filetimestamp"/>
          <xsl:attribute name="locale" select="$locale"/>
          <xsl:attribute name="batch" select="$batch"/>
          <xsl:attribute name="subbatch" select="if($subbatch='xml') then '' else $subbatch"/>
        </entry>
      </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[contains(@name,'Categorization') or contains(@name,'cbatch')]">
  <!--+  E.g.
      |    cbatch.CL_CMC.20090124013917.fr_FR.CONSUMER.1.xml
      |    Categorization_CONSUMER_CL_CMC.20090312161821.it_IT.1.xml
      +-->
      <xsl:variable name="prefix"        select="if(contains(@name,'cbatch')) then 'cbatch'
                                                 else if(contains(@name,'Categorization')) then 'Categorization'
                                                 else tokenize(@name,'\.')[1]"/>
      <xsl:variable name="filetimestamp" select="if($prefix='cbatch') then tokenize(@name,'\.')[3] else tokenize(@name,'\.')[2]"/>
      <xsl:variable name="locale"        select="if($prefix='cbatch') then tokenize(@name,'\.')[4] else tokenize(@name,'\.')[3]"/>
      <xsl:variable name="batch"         select="if($prefix='cbatch') then tokenize(@name,'\.')[6] else tokenize(@name,'\.')[4]"/>
      <xsl:variable name="subbatch"      select="''"/>
      <xsl:variable name="workflow"      select="if(contains(@name,'CL_CMC')) then 'CL_CMC'
                                                 else if(contains(@name,'CL_QUERY')) then 'CL_QUERY'
                                                 else ''"/>
      <!-- Filter out non-cmc2-generated translation file returns -->
      <xsl:if test="string-length($batch) gt 0">
        <entry>
          <xsl:attribute name="name" select="@name"/>
          <xsl:attribute name="israbbit" select="if(contains(@name,'CL_CMC') or contains(@name,'CL_QUERY')) then 'yes' else 'no'"/>
          <xsl:attribute name="prefix" select="$prefix"/>
          <xsl:attribute name="filetimestamp" select="$filetimestamp"/>
          <xsl:attribute name="locale" select="$locale"/>
          <xsl:attribute name="batch" select="$batch"/>
        </entry>
      </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[contains(@name,'Online_Ranges') or contains(@name,'rbatch')]">
  <!--+  E.g.
      |    Online_Ranges_Flat_TV_plasma_LCD_CL_CMC.20090302091635.tr_TR.5.1.xml
      |    rbatch.CL_CMC.20090123142159.en_GB.FLAT_TV_CA.2.1.xml
      +-->

      <xsl:variable name="israbbit"      select="if(contains(@name,'CL_CMC') or contains(@name,'CL_QUERY')) then true() else false()"/>
      <xsl:variable name="prefix"        select="if(contains(@name,'rbatch')) then 'rbatch'
                                                 else if(contains(@name,'Online_Ranges')) then 'Online_Ranges'
                                                 else tokenize(@name,'\.')[1]"/>
      <xsl:variable name="filetimestamp" select="if($israbbit and $prefix = 'rbatch') then tokenize(@name,'\.')[3] else tokenize(@name,'\.')[2]"/>
      <xsl:variable name="locale"        select="if($israbbit and $prefix = 'rbatch') then tokenize(@name,'\.')[4] else tokenize(@name,'\.')[3]"/>
      <xsl:variable name="batch"         select="if($israbbit and $prefix = 'rbatch') then tokenize(@name,'\.')[6] else if($israbbit) then tokenize(@name,'\.')[4] else tokenize(@name,'\.')[5]"/>
      <xsl:variable name="subbatch"      select="if($israbbit and $prefix = 'rbatch') then tokenize(@name,'\.')[7] else if($israbbit) then tokenize(@name,'\.')[5] else tokenize(@name,'\.')[6]"/>
      <!-- Filter out non-cmc2-generated translation file returns -->
      <xsl:if test="string-length($batch) gt 0">
        <entry>
          <xsl:attribute name="name" select="@name"/>
          <xsl:attribute name="prefix" select="$prefix"/>
          <xsl:attribute name="filetimestamp" select="$filetimestamp"/>
          <xsl:attribute name="locale" select="$locale"/>
          <xsl:attribute name="batch" select="$batch"/>
          <xsl:attribute name="subbatch" select="if($subbatch='xml') then '' else $subbatch"/>
        </entry>
      </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[contains(@name,'Packaging') or contains(@name,'bbatch')]">
  <!--+  E.g.
      |    bbatch.CL_CMC.20090211174804.nl_NL.HOP_IRONS_CA.PP_GC9920_05_20090211174657.xml
      |    Packaging_Flat_TV_plasma_LCD_CL_CMC.20090326145805.fr_FR.PP_46PFL9704H_12_20090326145716.xml
      +-->

      <xsl:variable name="israbbit"      select="if(contains(@name,'CL_CMC') or contains(@name,'CL_QUERY')) then true() else false()"/>
      <xsl:variable name="prefix"        select="if(contains(@name,'rbatch')) then 'rbatch'
                                                 else if(contains(@name,'Online_Ranges')) then 'Online_Ranges'
                                                 else tokenize(@name,'\.')[1]"/>
      <xsl:variable name="filetimestamp" select="if($israbbit and $prefix = 'bbatch') then tokenize(@name,'\.')[3] else tokenize(@name,'\.')[2]"/>
      <xsl:variable name="locale"        select="if($israbbit and $prefix = 'bbatch') then tokenize(@name,'\.')[4] else tokenize(@name,'\.')[3]"/>
      <xsl:variable name="batch"         select="if($israbbit and $prefix = 'bbatch') then tokenize(@name,'\.')[6] else if($israbbit) then tokenize(@name,'\.')[4] else tokenize(@name,'\.')[5]"/>
      <xsl:variable name="subbatch"      select="if($israbbit and $prefix = 'bbatch') then tokenize(@name,'\.')[7] else if($israbbit) then tokenize(@name,'\.')[5] else tokenize(@name,'\.')[6]"/>
      <!-- Filter out non-cmc2-generated translation file returns -->
      <xsl:if test="string-length($batch) gt 0">
        <entry>
          <xsl:attribute name="name" select="@name"/>
          <xsl:attribute name="prefix" select="$prefix"/>
          <xsl:attribute name="filetimestamp" select="$filetimestamp"/>
          <xsl:attribute name="locale" select="$locale"/>
          <xsl:attribute name="batch" select="$batch"/>
          <xsl:attribute name="subbatch" select="if($subbatch='xml') then '' else $subbatch"/>
        </entry>
      </xsl:if>
  </xsl:template>
</xsl:stylesheet>