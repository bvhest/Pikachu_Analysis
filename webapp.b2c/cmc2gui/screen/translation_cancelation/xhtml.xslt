<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
                
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>

  <xsl:template match="/root">
    <html>
      <body>
    		<h2>Cancel a translation request</h2>
         <p>With this page, pending translation requests can be cancelled.
         <br/><br/>
         The following <strong>preconditions</strong> must be met:
         <ul>
           <li>the translation request has not yet been returned by SDL.</li>
           <li>the filename of the translation request is known.</li>
         </ul>
         </p>
    		<form method="post">
            <xsl:attribute name="action" select="concat($gui_url,$section_url,'translation_cancelation_post')"/>
            <p>
            <table>
              <tr>
                <td style="width: 160px"><b>Content Type</b></td>
                <td style="width: 15px"> : </td>
                <td style="width: 205px">
                  <select name="ct">
                    <option value="" selected="selected">Select from the following</option>
                    <xsl:apply-templates select="sql:rowset[@name='ct']/sql:row"/>
                  </select>
                </td>
              </tr>        
               <tr>
                  <td><b>filename translation request</b></td><td> : </td><td><input name="file_name" size="100" type="text"/> (nb. in the proper case)</td>
               </tr>
               <tr>
                  <td><b>reason for cancellation</b></td><td> : </td><td><input name="reason" size="100" type="text"/></td>
               </tr>
            </table>
            </p>
            <hr /><br/><br/>
            <input style="width: 137px" type="submit" value="Submit"/>
    		</form>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset[@name='ct']/sql:row">
    <option>
      <xsl:attribute name="value" select="sql:content_type"/>
      <xsl:value-of select="sql:content_type"/>
    </option>
  </xsl:template> 
  <!-- -->
</xsl:stylesheet>
