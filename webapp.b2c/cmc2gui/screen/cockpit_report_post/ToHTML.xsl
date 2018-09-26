<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
   | TableBaseWithCSS:
   | Basic Stylesheet to format any ROWSET of ROWS into a table
   | with column headings in a generic way. Leverages Table.css
   | CSS stylesheet to control font/color information for the page.
   +-->
  <xsl:template match="/">
    <html>
      <!-- Generated HTML Result will be linked to Table.css CSS Stylesheet -->
      <head></head>
      <body><xsl:apply-templates/></body>
    </html>
  </xsl:template>
  <xsl:template match="ROWSET">
    <table border="1" cellspacing="0">
      <!-- Apply templates in "ColumnHeader" mode to just *first* ROW child -->
      <xsl:apply-templates select="ROW[1]/*" mode="ColumnHeaders"/>
      <!-- Then apply templates to all child nodes normally -->
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xsl:template match="ROW">
    <tr><xsl:apply-templates mode="cell"/></tr>
  </xsl:template>
  <!-- Match any element child of a ROW -->
  <!--xsl:template match="ROW/*">
	   <td><small><xsl:apply-templates/></small></td>
  </xsl:template-->
   <xsl:template match="node()" mode="cell">
	   <td><small><xsl:value-of select="."/></small></td>
   </xsl:template>
 <xsl:template match="Localized-content" mode="cell">
   <td>
	   <xsl:choose>
					<xsl:when test=".='Approved'"> <xsl:attribute name="style">color: #008000;</xsl:attribute></xsl:when>
					<xsl:when test=".='Translation not requested'"> <xsl:attribute name="style">color: #FF0000;</xsl:attribute></xsl:when>
					<xsl:when test=".='Translation request pending'"> <xsl:attribute name="style">color: #FF0000;</xsl:attribute></xsl:when>
					<xsl:when test=".='Approved, newer request pending'"> <xsl:attribute name="style">color: #FF8C00;</xsl:attribute></xsl:when>
		</xsl:choose>
   <small><xsl:value-of select="."/></small></td>
  </xsl:template> 
  
  <xsl:template match="Commercial-ID" mode="cell">
	  <td><small><a  href="{concat('http://pww.findyourproduct.philips.com/ccrprd/f?p=402:7:::NO::P0_CTN:',.)}"><xsl:value-of select="."/></a></small></td>
  </xsl:template>
  
  
  <!-- Match any element child of a ROW when in "ColumnHeaders" Mode-->
  <xsl:template match="ROW/*" mode="ColumnHeaders">
    <th>
      <!-- Put the value of the *name* of the current element -->
      <xsl:value-of select="name(.)"/>
    </th>
  </xsl:template>
</xsl:stylesheet>