<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel" />
  <xsl:param name="locale" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/">
    <root>
      <!--  Copy the doctype attributes -->
      <xsl:apply-templates select="*" />
      <!-- 
        Select the doctypes that ought to be sent to this channel.
        Records were flagged in CLE during the flagging stage. 
      -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="deleted-products">
          select al.object_id , al.locale, al.doctype, al.format
          from asset_lists al
          
          inner join customer_locale_export cle
             on cle.ctn = al.asset_id
            and cle.locale = al.locale
          
          where al.deleted=1
            and al.locale = '<xsl:value-of select="$locale" />'
            and cle.customer_id = '<xsl:value-of select="$channel" />'
            and cle.flag=1
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
