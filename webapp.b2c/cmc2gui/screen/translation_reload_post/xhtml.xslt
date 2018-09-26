<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:fn="http://www.w3.org/2005/xpath-functions" 
                xmlns:h="http://apache.org/cocoon/request/2.0">
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

   <xsl:param name="file_name" select="/h:request/h:requestParameters/h:parameter[@name='file_name']/h:value" />

	<xsl:template match="/root">
		<html>
			<body>
            <h2>Results for the translation reset</h2>
            <hr/>
            <br /><br />
            <xsl:apply-templates />
			</body>
		</html>
   </xsl:template>
   
   <xsl:template match="sql:rowset">
      <p>
         <xsl:choose>
            <xsl:when test="sql:error">
               <xsl:variable name="errortext" select="substring(sql:error,11)" />
               <strong><xsl:text>Reset was not succesfull!</xsl:text></strong>
               <br /><br />
               <xsl:choose>
                  <xsl:when test="substring($errortext,2,5)='ERROR'">
                     <xsl:value-of select="$errortext"/>
                     <br /><br />
                     <strong><xsl:text>This is a technical error: </xsl:text></strong>
                     <br />
                     <xsl:text>Please inform Pikachu support!</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="substring-before($errortext,'ORA-')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>Reset of the translation request </xsl:text>
               <xsl:value-of select="$file_name"/>
               <xsl:text>was completed succesfully!</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </p>
   </xsl:template>
   
   <xsl:template match="@*|node()">
     <xsl:copy copy-namespaces="no">
       <xsl:apply-templates select="@*|node()" /> 
     </xsl:copy>
   </xsl:template>

</xsl:stylesheet>
