<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
                xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
                extension-element-prefixes="asset-f">  

  <xsl:import href="../xUCDM.1.4.convertProducts.xsl" />    
  <xsl:import href="../../../common/xsl/xUCDM-external-assets.xsl"/>  
        
   <xsl:template match="Products">
      <xsl:copy>
        <sql:rowset name="product">
           <xsl:for-each-group select="sql:rowset[@name='product']/sql:row" group-by="sql:id">        
              <xsl:copy-of select="."/>
           </xsl:for-each-group>
         </sql:rowset>
      </xsl:copy>
  </xsl:template>  
  
</xsl:stylesheet>