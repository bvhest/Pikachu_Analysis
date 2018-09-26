<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!--
   | TableBaseWithCSS:
   | Basic Stylesheet to format any ROWSET of ROWS into a table
   | with column headings in a generic way. Leverages Table.css
   | CSS stylesheet to control font/color information for the page.
   +-->

  <xsl:template match="/root">
    <HTML>
      <HEAD/>
      <BODY>
         <center>
            <xsl:apply-templates select="RESULTSET"/>
         </center>
      </BODY>
    </HTML>
  </xsl:template>
  	<!-- -->
  <xsl:template match="RESULTSET ">
    <table width="60%" border="1" cellspacing="0" cellpadding="0" align="left" summary="Family count">
       <caption>
         <h2>Family count</h2>
       </caption>
       <tbody>
       <tr>
          <th width="15%">Catalog</th> 
          <th width="15%">Locale</th> 
          <th width="25%">Family Catalog Count</th> 
          <th width="15%">PMT Count</th> 
          <th width="15%">ATG Count</th> 
          <th width="15%">Prisma Count</th> 
       </tr>
       <!-- Then apply templates to all child nodes normally -->
       <xsl:for-each select="RESULT[@name='PikachuFamilyCount']/ROW">
          <xsl:variable name="v_catalog"      select="catalog"/>
          <xsl:variable name="v_localisation" select="localisation"/>
      <tr>
             <td align="center"><xsl:value-of select="$v_catalog"/></td> 
             <td align="center"><xsl:value-of select="$v_localisation"/></td> 
             <td align="right"><xsl:value-of select="catalog_count"/></td> 
         <td align="right"><xsl:value-of select="pmt_count"/></td> 
             <td align="right"><xsl:value-of select="../../RESULT[@name='atgFamilyCount']/ROW[catalog=$v_catalog and localisation=$v_localisation]/atg_count"/></td> 
             <td align="right"><xsl:value-of select="../../sql:rowset[@name='prismaFamilyCount']/sql:row[sql:catalog=$v_catalog and sql:localisation=$v_localisation]/sql:prisma_count"/></td> 
      </tr>
       </xsl:for-each>
       </tbody>
    </table>
    <br /><br /><br />
   </xsl:template>
  	<!-- -->
</xsl:stylesheet>