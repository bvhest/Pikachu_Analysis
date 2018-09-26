<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="dir">
    <xsl:text>myDirPath</xsl:text>
  </xsl:param>
  <xsl:param name="ts">
    <xsl:text>xx</xsl:text>
  </xsl:param>
  <xsl:param name="ct">
    <xsl:text>xx</xsl:text>
  </xsl:param>

  <!-- -->

  <xsl:template match="report">
    <xsl:choose>
      <xsl:when test="entries">
        <xsl:apply-templates select="entries" />
      </xsl:when>
      <xsl:otherwise>
        <source:write>
          <source:source>
            <xsl:value-of select="concat($dir,'/',$ct,'/logs/Report_',$ts,'.xml')" />
          </source:source>
          <source:fragment>
            <report>
              <item>
                <xsl:text>None processed</xsl:text>
              </item>
            </report>
          </source:fragment>
        </source:write>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="entries[1]">
    <xsl:variable name="lct" select="if (string(@ct) != '') then @ct else $ct" />
    <xsl:variable name="lts" select="if (string(@ts) != '') then @ts else $ts" />
    <source:write>
      <source:source>
        <xsl:value-of select="concat($dir,'/',$lct,'/logs/Report_',$lts,'.xml')" />
      </source:source>
      <source:fragment>
        <report>
          <xsl:copy-of select="../entries/filedata" copy-namespaces="no" />
          <xsl:apply-templates select="../entries/entry[not(@includeinreport='yes')]" mode="report" />
          <xsl:copy-of copy-namespaces="no" select="../entries/entry[@includeinreport='yes']" />
        </report>
      </source:fragment>
    </source:write>
  </xsl:template>

  <xsl:template match="entry" mode="report">
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="sourceResult[execution!='success']">
          <xsl:text>WriteSource Failure</xsl:text>
        </xsl:when>
        <xsl:when test="sql:rowset/sql:error|sql-error">
          <xsl:text>SQL Failure</xsl:text>
        </xsl:when>
        <xsl:when test="result='OK'">
          <xsl:text>Success</xsl:text>
        </xsl:when>
        <xsl:when test="result='Identical octl exists'">
          <xsl:text>Info</xsl:text>
        </xsl:when>
        <xsl:when test="result='Store Output Warning'">
          <xsl:text>Info</xsl:text>
        </xsl:when>
        <xsl:when test="result='More recent document exists' and ancestor::entries/@ct=('ProductMasterData','PMT_Raw')">
          <xsl:text>Info</xsl:text>
        </xsl:when>
        <xsl:when test="result='No Placeholder' and ancestor::entries/@ct=('ObjectCategorization')">
          <xsl:text>Info</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Failure</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="comments">
      <xsl:value-of select="result" />
      <xsl:text>*</xsl:text>
      <xsl:value-of select="sql:rowset/sql:error" />
      <xsl:text>*</xsl:text>
      <xsl:value-of select="sql-error" />
    </xsl:variable>
    <item>
      <id>
        <xsl:value-of select="@o" />
      </id>
      <locale>
        <xsl:value-of select="@l" />
      </locale>
      <result>
        <xsl:value-of select="$status" />
      </result>
      <remark>
        <xsl:value-of select="$comments" />
      </remark>
    </item>
  </xsl:template>

  <xsl:template match="entry" />
  <xsl:template match="text()" />
</xsl:stylesheet>