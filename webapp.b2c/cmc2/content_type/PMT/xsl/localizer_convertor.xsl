<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">
   
<!-- 
  File Name : localizer_convertor.xsl
  Description : Localizer converter used to merge the localized content from localizer tool with PMT_Translated data
  XSD : xUCDM_product_localized_marketing_1_0_0.xsd              
  
  Version       Author      Date              Remark
   ____________________________________________________
  0.1           CJ          12-DEC-2012       Base Version
  0.2           CJ          23-JAN-2013       Updated for modification in xUCDM_product_localized_marketing_1_0_0 
  0.3           CJ          11-FEB-2013       Added new VersionElement4 for Product Differentiation project
  -->   
    
  <xsl:template match="@*|node()" mode="#all">
   <xsl:copy copy-namespaces="no">
     <xsl:apply-templates select="@*|node()" mode="#current"/>
   </xsl:copy>
  </xsl:template>
  
  <!-- Do not copy the operation attribute on localizer elements -->
  <!--<xsl:template match="sql:row[sql:content_type='PMT_LocContent']/sql:data/Product//@operation"/>-->
  
  <!-- Product Name-->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /ProductName">    
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/ProductName"/>  
 
    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>        
        <xsl:next-match />        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
 <!-- NamingString/Descriptor -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /NamingString/Descriptor">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/NamingString/Descriptor"/>
 
    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
   <!-- NamingString/Family/FamilyName -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /NamingString/Family/FamilyName">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/NamingString/Family/FamilyName"/>
 
	<xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>     

      
  
  <!-- NamingString/VersionElement1 -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /NamingString/VersionElement1">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/NamingString/VersionElement1"/>

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- NamingString/VersionElement2 -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /NamingString/VersionElement2">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/NamingString/VersionElement2"/>
 
    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- NamingString/VersionElement3 -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /NamingString/VersionElement3">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/NamingString/VersionElement3"/>
 
    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 
  
  <!-- NamingString/VersionElement4 -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /NamingString/VersionElement4">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/NamingString/VersionElement4"/>

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- NamingString/VersionString -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /NamingString/VersionString">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/NamingString/VersionString"/>

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>   
   
  <!-- NamingString/DescriptorBrandedFeatureString -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /NamingString/DescriptorBrandedFeatureString">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/NamingString/DescriptorBrandedFeatureString"/>

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>    

  <!-- WOW -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /WOW">    
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/WOW"/>  

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- SubWOW -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /SubWOW">    
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/SubWOW"/>  

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
    
  <!-- MarketingTextHeader -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /MarketingTextHeader">    
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/MarketingTextHeader"/>  

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent" />
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  
   
  <!-- KeyBenefitArea Delete --> 
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /KeyBenefitArea">
                                                                                 
     <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/KeyBenefitArea[KeyBenefitAreaCode = current()/KeyBenefitAreaCode]"/>    

     <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>        
           <xsl:next-match />     
      </xsl:otherwise>
     </xsl:choose>
  </xsl:template>
   
  <!-- KeyBenefitArea Update -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /KeyBenefitArea[KeyBenefitAreaCode =  
                        ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/KeyBenefitArea/KeyBenefitAreaCode]
                      /KeyBenefitAreaName">
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/KeyBenefitArea[KeyBenefitAreaCode = current()/../KeyBenefitAreaCode]/KeyBenefitAreaName"/>
    <xsl:variable name="KeyBenefitArea" select="$tmpLocContent/.."/>
  
    <xsl:choose>
      <xsl:when test="$KeyBenefitArea[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent"/>
      </xsl:when>        
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  <!-- Feature -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /KeyBenefitArea/Feature[FeatureCode =  
                         ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/Feature/FeatureCode]">  
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/Feature[FeatureCode = current()/FeatureCode]"/>  

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">          
          <Feature>
            <xsl:apply-templates select="$tmpLocContent/FeatureCode"/>            
            <xsl:apply-templates select="if($tmpLocContent/FeatureReferenceName != '') then  $tmpLocContent/FeatureReferenceName else current()/FeatureReferenceName"/>
            <xsl:apply-templates select="if($tmpLocContent/FeatureName != '') then $tmpLocContent/FeatureName else current()/FeatureName"/>
            <xsl:apply-templates select="if($tmpLocContent/FeatureLongDescription != '') then $tmpLocContent/FeatureLongDescription else current()/FeatureLongDescription "/>
            <xsl:apply-templates select="if($tmpLocContent/FeatureGlossary != '') then $tmpLocContent/FeatureGlossary else current()/FeatureGlossary"/>            
            <xsl:apply-templates select="current()/FeatureRank"/>
            <xsl:apply-templates select="current()/FeatureTopRank"/>
          </Feature>                   
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/> 
      <xsl:otherwise>        
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:template>   
     
             
  <!-- FeatureImage -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /FeatureImage[FeatureCode =  
                        ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/FeatureImage/FeatureCode]">  
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/FeatureImage[FeatureCode = current()/FeatureCode]"/>  

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
        <FeatureImage>
          <xsl:apply-templates select="$tmpLocContent/FeatureCode" />
          <xsl:apply-templates select="$tmpLocContent/FeatureReferenceName" />
          <xsl:apply-templates select="current()/FeatureImageRank" />
        </FeatureImage>
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>    
  
  <!-- CSChapter - Delete -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /CSChapter[CSChapterCode =  
                        ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSChapter/CSChapterCode]"> 
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSChapter[CSChapterCode = current()/CSChapterCode]"/>

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>             
  </xsl:template>
  
  <!-- CSChapter - Update -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /CSChapter[CSChapterCode =  
                        ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSChapter/CSChapterCode]
                      /CSChapterName">  
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSChapter[CSChapterCode = current()/../CSChapterCode]/CSChapterName"/>  
    <xsl:variable name="CSChapter" select="$tmpLocContent/.."/>
       
    <xsl:choose>
      <xsl:when test="$CSChapter[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent"/>
      </xsl:when>            
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>             
  </xsl:template>

  <!-- CSItem - Delete -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /CSChapter/CSItem[CSItemCode =  
                        ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSItem/CSItemCode]"> 
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSItem[CSItemCode = current()/CSItemCode]"/>  

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
          
  <!-- CSItem - Update -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /CSChapter/CSItem[CSItemCode =  
                        ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSItem/CSItemCode]
                      /CSItemName"> 
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSItem[CSItemCode = current()/../CSItemCode]/CSItemName"/>
    <xsl:variable name="CSItem" select="$tmpLocContent/.."/> 

    <xsl:choose>
      <xsl:when test="$CSItem[@operation ='update']">
         <xsl:apply-templates select="$tmpLocContent"/>
      </xsl:when>       
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  <!-- CSValue -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /CSChapter/CSItem/CSValue[CSValueCode =  
                        ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSValue/CSValueCode]"> 
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CSValue[CSValueCode = current()/CSValueCode]"/>  

    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">
        <CSValue> 
          <xsl:apply-templates select="$tmpLocContent/CSValueCode" />
          <xsl:apply-templates select="$tmpLocContent/CSValueName" />
          <xsl:apply-templates select="current()/CSValueRank" />
        </CSValue>
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template> 
      
  <!-- Disclaimers -->
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product
                        [CTN = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                      /Disclaimers/Disclaimer[@code = 
                      ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/Disclaimers/Disclaimer/@code]">
                      
    <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/Disclaimers/Disclaimer[@code=current()/@code]"/>
                           
    <xsl:choose>
      <xsl:when test="$tmpLocContent[@operation ='update']">      
         <Disclaimer code="{current()/@code}" rank="{current()/@rank}" referenceName="{current()/@referenceName}">
             <xsl:apply-templates select="$tmpLocContent/DisclaimerText"/>
		         <xsl:apply-templates select="current()/DisclaimElements"/>
         </Disclaimer>         
      </xsl:when>
      <xsl:when test="$tmpLocContent[@operation ='delete']"/>         
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>