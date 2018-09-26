<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>\
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="batchsize"/>
  <xsl:param name="filestem"/>
  <xsl:param name="timestamp"/><!-- file timestamp -->
  <xsl:param name="ts"/><!-- run timestamp -->
  <xsl:param name="dir"/>
  <!-- -->
  <xsl:function name="my:reformatDate">
  <!--+
      |  Reformat date string:
      |         20070919164110
      |       IN: yyyymmddHH24miss
      |      OUT: yyyy-mm-ddTHH:mm:ss
      +-->
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="$date=''">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T',substring($date,9,2),':',substring($date,11,2),':',substring($date,13,2))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->  
  <xsl:template match="sql:rowset">
    <root>    
      <xsl:for-each-group select="sql:row" group-by="sql:catalog_id">      
        <xsl:call-template name="RecursiveGrouping">
          <xsl:with-param name="list" select="current-group()"/>
          <xsl:with-param name="catalog" select="replace(current-grouping-key(),' ','_')"/>
          <xsl:with-param name="group" select="1"/>
        </xsl:call-template>     
      </xsl:for-each-group>      
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template name="RecursiveGrouping">
    <xsl:param name="list"/>
    <xsl:param name="catalog"/>
    <xsl:param name="group"/>
    <xsl:if test="count($list)>0">
      <xsl:call-template name="DoIt">
        <xsl:with-param name="list" select="$list[position() &lt;= number($batchsize)]"/>
        <xsl:with-param name="catalog" select="$catalog"/>
        <xsl:with-param name="group" select="$group"/>
      </xsl:call-template>
      <!-- If there are other groups left, call itself -->
      <xsl:call-template name="RecursiveGrouping">
        <xsl:with-param name="list" select="$list[position() > number($batchsize)]"/>
        <xsl:with-param name="catalog" select="$catalog"/>
        <xsl:with-param name="group" select="$group+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template name="DoIt">
    <xsl:param name="list"/>
    <xsl:param name="catalog"/>
    <xsl:param name="group"/>
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source><xsl:value-of select="concat($dir,'/',$filestem,$ts,'.',$l,'.',$catalog,'.batch_',$group,'.xml')"/></source:source>
      <source:fragment>
        <entries>
        <xsl:attribute name="batchnumber" select="concat($catalog,'.batch_',$group)"/>
        <xsl:attribute name="ct" select="$ct"/>
        <xsl:attribute name="dir" select="$dir"/>
        <xsl:attribute name="l" select="$l"/>
        <xsl:attribute name="ts" select="$ts"/>
        <process/>
        <globalDocs/>
          <entry includeinreport="yes">
            <xsl:attribute name="ct" select="$ct"/>
            <xsl:attribute name="l" select="$l"/>
            <xsl:attribute name="o" select="$catalog"/>
            <xsl:attribute name="ts" select="$ts"/>          
            <xsl:attribute name="valid" select="'true'"/>          
            <result>OK</result>
            <currentmasterlastmodified_ts>1900-01-01T00:00:00</currentmasterlastmodified_ts>
            <currentlastmodified_ts/>
            <process/>
            <octl-attributes>
              <lastmodified_ts><xsl:value-of select="my:reformatDate($ts)"/></lastmodified_ts>
              <masterlastmodified_ts><xsl:value-of select="$timestamp"/></masterlastmodified_ts>
              <status>Loaded</status>
            </octl-attributes>            
            <content>
              <catalog-definition DocTimeStamp="{my:reformatDate($ts)}" ct="{$ct}" l="{$l}" o="{$catalog}">
                <xsl:apply-templates select="$list"/>                
              </catalog-definition>
            </content>
          </entry>
        </entries>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:row">
    <object o="{sql:object_id}">
      <xsl:apply-templates select="sql:*"/>
    </object>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:catalog_id|sql:object_id"/>
  <!-- -->
  <xsl:template match="sql:*">
    <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
  </xsl:template>                    
</xsl:stylesheet>