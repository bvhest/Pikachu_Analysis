<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
  <!--
   | TableBaseWithCSS:
   | Basic Stylesheet to format any ROWSET of ROWS into a table
   | with column headings in a generic way. Leverages Table.css
   | CSS stylesheet to control font/color information for the page.
   +-->
   <xsl:template match="/reports">
     <html>
       <head>
          <meta http-equiv="Content-Type" content="text/html; charset=UTF8"/>
       </head>
       <body>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
          <xsl:for-each select="HTML/BODY">
             <tr><td>
               <xsl:apply-templates select="*"/>
               <tr><td>&#160;</td></tr>
             </td></tr>
          </xsl:for-each>
          </table>
       </body>
     </html>
   </xsl:template>
  	<!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->  
</xsl:stylesheet>
