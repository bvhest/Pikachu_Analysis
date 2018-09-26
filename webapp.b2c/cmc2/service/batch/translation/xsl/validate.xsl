<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"  xmlns:my="http://www.philips.com/nvrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" extension-element-prefixes="my">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="ct"/>
  <!-- -->
  <xsl:variable name="wf" select="/entries[1]/originalentriesattributes/workflow"/>
  <!-- -->
  <xsl:template match="root">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->
  <xsl:template match="entries">
    <entries>
      <xsl:copy-of copy-namespaces="no" select="@*"/>
      <xsl:apply-templates select="*[not(local-name()='entry')]"/>
      <xsl:choose>
        <xsl:when test="$ct='PText_Translated'">
          <xsl:apply-templates select="entry" mode="PText_Translated"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="entry" mode="standard"/>
        </xsl:otherwise>
      </xsl:choose>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry" mode="standard">
    <entry>
      <xsl:variable name="workflow" select="../originalentriesattributes/workflow"/>
      <xsl:variable name="counterpartworkflow" select="if($workflow = 'CL_CMC') then 'CL_QUERY' else if($workflow = 'CL_QUERY') then 'CL_CMC' else ''"/>
      <xsl:variable name="counterpartresult" select="octl-attributes/counterpartstatus[workflow=$counterpartworkflow]/result"/>
      <xsl:variable name="counterpartvalid"  select="octl-attributes/counterpartstatus[workflow=$counterpartworkflow]/valid"/>
      <xsl:variable name="pmt_localised_mlm" select="octl-attributes/currentpmtlocalisedmasterlastmodified_ts"/>
      <xsl:copy-of copy-namespaces="no" select="@*" />
      <xsl:choose>
        <!-- Check that sibling request has not already been received and stored -->
        <xsl:when test="$counterpartresult = 'OK' and $counterpartvalid = 'true'">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>Duplicate: Valid <xsl:value-of select="$counterpartworkflow"/> already received</result>
          <content>
            <xsl:apply-templates select="content" mode="incompletetranslation"/>
          </content>
        </xsl:when>
        <!-- Check that OCTL exists -->
        <xsl:when test="not (currentlastmodified_ts) or string-length(currentlastmodified_ts) = 0">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>No Placeholder</result>
          <content>
            <xsl:apply-templates select="content" mode="incompletetranslation"/>
          </content>
        </xsl:when>
        <!-- Check that current OCTL content does not have the same timestamps -->
        <xsl:when test="currentlastmodified_ts eq octl-attributes/lastmodified_ts and currentmasterlastmodified_ts eq octl-attributes/masterlastmodified_ts">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>Identical modification dates</result>
          <content>
            <xsl:apply-templates select="content" mode="incompletetranslation"/>
          </content>
        </xsl:when>
        <!-- Check that validated translations are not missing -->
        <xsl:when test="$workflow = 'CL_QUERY' and descendant::*[@translated='no' and @validate='yes']">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>Validated translations missing</result>
          <content>
            <xsl:apply-templates select="content" mode="incompletetranslation"/>
          </content>
          <xsl:call-template name="octl-attributes">
            <xsl:with-param name="workflow" select="$workflow"/>
            <xsl:with-param name="pmt_localised_mlm" select="$pmt_localised_mlm"/>
            <xsl:with-param name="presult" select="'Validated translations missing'"/>
          </xsl:call-template>          
        </xsl:when>
        <!-- Check that non-validated translations are not missing -->
        <xsl:when test="$workflow = 'CL_QUERY' and descendant::*[@translated='no' and @validate='no']">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>Non-validated translations missing</result>
          <content>
            <xsl:apply-templates select="content" mode="incompletetranslation"/>
          </content>
          <xsl:call-template name="octl-attributes">
            <xsl:with-param name="workflow" select="$workflow"/>
            <xsl:with-param name="pmt_localised_mlm" select="$pmt_localised_mlm"/>
            <xsl:with-param name="presult" select="'Non-validated translations missing'"/>
          </xsl:call-template>
        </xsl:when>
        <!-- Validate content -->
        <xsl:otherwise>
          <xsl:variable name="result" select="my:validateContent(content)"/>
          <xsl:choose>
            <xsl:when test="$result//error">
              <xsl:attribute name="valid">false</xsl:attribute>
              <result>
                <xsl:copy-of select="$result//error" />
              </result>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="valid">true</xsl:attribute>
              <xsl:variable name="presult">
                <xsl:choose>
                  <xsl:when test="not(octl-attributes/masterlastmodified_ts ge currentmasterlastmodified_ts and octl-attributes/lastmodified_ts &gt; currentlastmodified_ts)">out-of-date</xsl:when>
                  <xsl:otherwise>OK</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <result><xsl:value-of select="$presult"/></result>
              <content>
                <xsl:copy-of select="$result" />
              </content>
              <xsl:call-template name="octl-attributes">
                <xsl:with-param name="workflow" select="$workflow"/>
                <xsl:with-param name="pmt_localised_mlm" select="$pmt_localised_mlm"/>
                <xsl:with-param name="presult" select="$presult"/>
              </xsl:call-template>
              <xsl:copy-of copy-namespaces="no" select="process" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </entry>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry" mode="PText_Translated">
    <entry>
      <xsl:variable name="workflow" select="../originalentriesattributes/workflow"/>
      <xsl:variable name="counterpartworkflow" select="if($workflow = 'CL_CMC') then 'CL_QUERY' else if($workflow = 'CL_QUERY') then 'CL_CMC' else ''"/>
      <xsl:variable name="counterpartresult" select="octl-attributes/counterpartstatus[workflow=$counterpartworkflow]/result"/>
      <xsl:variable name="counterpartvalid"  select="octl-attributes/counterpartstatus[workflow=$counterpartworkflow]/valid"/>
      <xsl:copy-of copy-namespaces="no" select="@*" />
      <xsl:choose>
        <!-- Check that sibling request has not already been received and stored -->
        <xsl:when test="$counterpartresult = 'OK' and $counterpartvalid = 'true'">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>Duplicate: Valid <xsl:value-of select="$counterpartworkflow"/> already received</result>
          <content>
            <xsl:apply-templates select="content" mode="incompletetranslation"/>
          </content>
        </xsl:when>
        <!-- Check that OCTL exists -->
        <xsl:when test="not (currentlastmodified_ts) or string-length(currentlastmodified_ts) = 0">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>No Placeholder</result>
          <content>
            <xsl:apply-templates select="content" mode="incompletetranslation"/>
          </content>
        </xsl:when>
        <!-- No need to check that current OCTL content does not have the same timestamps, because packaging can have updated content as long as the sibling has not already been received/stored as valid/OK -->
        <!-- Check that there is at least some translated content -->
        <xsl:when test="$workflow = 'CL_QUERY' and descendant::*[@translate][@translated] and not(descendant::*[@translate][@translated='yes'])">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>No translated content</result>
          <content>
            <xsl:apply-templates select="content" mode="incompletetranslation"/>
          </content>
        </xsl:when>
        <!-- Validate content -->
        <xsl:otherwise>
          <xsl:variable name="result" select="my:validateContent(content)"/>
          <xsl:choose>
            <xsl:when test="$result//error">
              <xsl:attribute name="valid">false</xsl:attribute>
              <result>
                <xsl:copy-of select="$result//error" />
              </result>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="valid">true</xsl:attribute>
              <xsl:variable name="israbbit" select="exists(content/descendant::*[@translate][@translated])"/>
              <xsl:variable name="presult">
                <xsl:choose>
                  <!-- conventional out-of-date now only applies to non-Rabbit Packaging translations -->
                  <xsl:when test="not($israbbit) and not(octl-attributes/masterlastmodified_ts ge currentmasterlastmodified_ts and octl-attributes/lastmodified_ts &gt; currentlastmodified_ts)">out-of-date</xsl:when>
                  <!-- however if MLM is lt current MLM then I guess that also applies as out-of-date -->
                  <xsl:when test="$israbbit and octl-attributes/masterlastmodified_ts lt currentmasterlastmodified_ts">out-of-date</xsl:when>
                  <xsl:when test="$workflow = 'CL_QUERY' and $result/descendant::*[@translate][@translated='no']">Translations missing</xsl:when>
                  <xsl:otherwise>OK</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <result><xsl:value-of select="$presult"/></result>
              <content>
                <xsl:copy-of select="$result" />
              </content>
              <octl-attributes>
                <xsl:apply-templates select="octl-attributes/*"/>
                <updatedata><xsl:value-of select="if($israbbit and $presult=('Translations missing','OK') and $counterpartvalid = 'true' and not($counterpartresult = 'OK')) then 'yes' else ''"/></updatedata>
              </octl-attributes>
              <xsl:copy-of copy-namespaces="no" select="process" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </entry>
  </xsl:template>
  <!-- -->
  <xsl:function name="my:validateContent">
    <xsl:param name="content"/>
    <xsl:apply-templates select="$content/node()|$content/@*"/>
  </xsl:function>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:choose>
      <!-- Get rid of translation export specific attributes if applicable -->
      <xsl:when test="@translate">
        <!-- Copy the element, but do not process the attributes -->
        <xsl:variable name="elementtext" select="normalize-space(.)"/>
        <xsl:variable name="maxLen" select="xs:integer(@maxlength)"/>
        <xsl:variable name="len" select="string-length($elementtext)"/>
        <xsl:choose>
          <xsl:when test="($wf != 'CL_QUERY' or ($wf = 'CL_QUERY' and @translated='yes')) and $len gt $maxLen">
            <!-- CL_CMC files (or to be more accurate non-CL_QUERY files) should never have $len gt $maxlen
                 CL_QUERY files may have, but this is only ok if @translated has not been set to yes -->
            <error maxLength="{$maxLen}" actualLength="{$len}">
              <xsl:copy copy-namespaces="no">
                  <xsl:apply-templates select="node()"/>
              </xsl:copy>
            </error>
          </xsl:when>
          <xsl:when test="$len = 0 and ends-with(local-name(),'Name')">
            <!--  -->
            <error error="zerolength" maxLength="{$maxLen}" actualLength="{$len}">
              <xsl:copy copy-namespaces="no">
                  <xsl:apply-templates select="node()"/>
              </xsl:copy>
            </error>
          </xsl:when>          
          <xsl:otherwise>
            <xsl:copy copy-namespaces="no">
              <xsl:choose>
                <xsl:when test="$wf = 'CL_QUERY' and $ct = 'PText_Translated' and @translated = 'no'">
                  <!-- If this is a Packaging Rabbit file, mark the element as untranslated by copying the attribute 'translated'"/-->
                  <xsl:apply-templates select="node()|attribute::translate|attribute::translated"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- Otherwise copy as normal -->
                  <xsl:copy-of select="@localized"/>
                  <xsl:apply-templates select="node()"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Copy the element and also process possible attributes -->
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="content" mode="incompletetranslation">
    <!-- create a skeleton Product/Range/RichText etc.; just enough information to allow MERGE into OCTL_TRANSLATIONS table -->
    <xsl:element name="{child::*[1]/local-name()}">
      <xsl:apply-templates select="node()/@*"/>
      <xsl:apply-templates select="node()/MarketingVersion"/>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="octl-attributes/*[local-name()=('needsprocessing_flag','currentpmtlocalisedmasterlastmodified_ts','counterpartstatus')]"/>
  <!-- -->
  <xsl:template name="octl-attributes">
    <xsl:param name="workflow"/>
    <xsl:param name="pmt_localised_mlm"/>
    <xsl:param name="presult"/>
    <octl-attributes>
      <xsl:apply-templates select="octl-attributes/*"/>
      <needsprocessing_flag><xsl:value-of select="     if($presult = 'OK' and $workflow = 'CL_QUERY' and octl-attributes/masterlastmodified_ts = $pmt_localised_mlm) then '0'
                                                  else if($presult = 'Non-validated translations missing' and $workflow = 'CL_QUERY' and octl-attributes/masterlastmodified_ts = $pmt_localised_mlm) then '3'
                                                  else if($presult = 'Validated translations missing' and $workflow = 'CL_QUERY' and octl-attributes/masterlastmodified_ts = $pmt_localised_mlm) then '4'
												  else if($presult = 'OK' and $workflow = 'CL_CMC' and octl-attributes/masterlastmodified_ts = $pmt_localised_mlm) then '0'
                                                  else octl-attributes/needsprocessing_flag"/></needsprocessing_flag>
      <xsl:if test="$workflow = 'CL_QUERY'">
        <querystatus><xsl:value-of select="concat($workflow,' received: ',$presult)"/></querystatus>
      </xsl:if>
    </octl-attributes>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
