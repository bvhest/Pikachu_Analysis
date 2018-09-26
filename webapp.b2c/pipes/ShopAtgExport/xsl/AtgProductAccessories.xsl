<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:my="http://www.philips.com/pika" 
    extension-element-prefixes="my">
    
  <xsl:strip-space elements="*"/>
  
  <xsl:function name="my:normalized-id">
    <xsl:param name="id"/>
    <xsl:value-of select="translate($id,'/-. ','___')"/>
  </xsl:function>

  <xsl:function name="my:accessories">
    <xsl:param name="prdNode"/>
    <xsl:param name="locale"/>
    <xsl:variable name="country" select="substring($locale,4)"/>
    <xsl:variable name="accessory-ctns">
      <!-- 
        xUCDM 1.1:
        <ProductReferences ProductReferenceType="Accessory">
          <CTN rank="1">SLV3100/00</CTN> 
        </ProductReference>
  
        xUCDM 1.2 :
        <ProductRefs>
          <ProductReference ProductReferenceType="Accessory">
            <CTN rank="1">30MF200V/17</CTN> 
            <CTN rank="2">30PF9946/12</CTN> 
            <CTN rank="3">30PF9946/37</CTN>       
          </ProductReference>
        </ProductRefs>
      -->        
      <xsl:for-each select="$prdNode/ProductReferences[@ProductReferenceType='Accessory']/CTN 
                          | $prdNode/ProductRefs/ProductReference[@ProductReferenceType='Accessory']/CTN
                          | $prdNode/ProductRefs/ProductReferences[@ProductReferenceType='Accessory']/CTN">
        <xsl:sort order="ascending" data-type="number" select="@rank"/>
        <ctn>
          <xsl:value-of select="concat(my:normalized-id(.),'_',$country)"/>
        </ctn>
      </xsl:for-each>          
    </xsl:variable>
    <xsl:value-of select="string-join($accessory-ctns/ctn,',')"/>
  </xsl:function>
  
  
  <xsl:function name="my:MotherProducts">
    <xsl:param name="prdNode"/>
    <xsl:param name="locale"/>
    <xsl:variable name="country" select="substring($locale,4)"/>
    <xsl:variable name="motherProducts">     
      <xsl:for-each select="$prdNode">
         <ctn>
          <xsl:value-of select="concat(my:normalized-id(.),'_',$country)"/>
        </ctn>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="string-join($motherProducts/ctn,',')"/>
  </xsl:function>
  
  <xsl:template name="product-accessories">
    <xsl:param name="locale"/>
    <xsl:param name="atgCTN"/>
    
    <xsl:variable name="country" select="substring($locale,4)"/>
    <xsl:variable name="accessories" select="my:accessories(.,$locale)"/>
    <xsl:if test="$accessories != ''">
      <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="product-content" id="{concat($atgCTN,'_',$country)}">
        <set-property name="accessories">
          <xsl:value-of select='$accessories'/>
        </set-property>
      </add-item>
    </xsl:if>
  </xsl:template>

  <xsl:template name="compatibleMotherProducts">
    <xsl:param name="locale"/>
    <xsl:param name="atgCTN"/>
	<xsl:variable name="country" select="substring($locale,4)"/>			
	<xsl:variable name="motherProducts" select='my:MotherProducts(ProductRefs/ProductReference[@ProductReferenceType="compatibleMotherProducts"]/CTN,$locale)'/>
			<xsl:if test="$motherProducts != ''">			
				<add-item id="{concat(my:normalized-id($atgCTN),'_',$country)}" item-descriptor = "product-content" 
						  repository="/philips/store/catalog/ProductContentRepository">			
					<set-property name="compatibleMotherProducts">
		                <xsl:value-of select='$motherProducts'/>
					</set-property>						
				</add-item>		
			</xsl:if>	
  </xsl:template>
      
  <xsl:template match="/Products">
    <gsa-template>
      <import-items>
        <xsl:for-each select="Product">
          <xsl:variable name="lastModified" select="@lastModified" as="xsl:dateTime"/>
          <xsl:variable name="lastExportDate" select="@LastExportDate" as="xsl:dateTime"/>
          <xsl:variable name="isDeleted" select="@isDeleted"/>
          <xsl:if test="$lastModified &gt; $lastExportDate">
            <xsl:variable name="atgCTN" select="my:normalized-id(CTN)"/>
            <xsl:call-template name="product-accessories">
              <xsl:with-param name="locale" select="@Locale"/>
              <xsl:with-param name="atgCTN" select="$atgCTN"/>
            </xsl:call-template>
            
            <xsl:call-template name="compatibleMotherProducts">
              <xsl:with-param name="locale" select="@Locale"/>
              <xsl:with-param name="atgCTN" select="$atgCTN"/>
            </xsl:call-template> 
              			
          </xsl:if>
        </xsl:for-each>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
