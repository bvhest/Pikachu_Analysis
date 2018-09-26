<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>

  <xsl:template match="/root">
    <html>
      <body>
    		<h2>Reload a translation request</h2>
         <p>With this page, a translation request that has already been loaded, can be reloaded a second time.
         <br/><br/>
         <em>Be carefull with this functionality as it is only needed in exceptional situations!</em>
         <br/><br/>
         An example is when an erroneous text needs to be replaced with a corrected version.
         <br/>
         When the 'submit' button is pressed, all entries in the Pikachu database tables will be reset so that 
         the file with the translation request can be imported into Pikachu a second time.
         <br/>
         After this process has finished, the file with the translation request must be uploaded into the 
         inbox of the PMT_Translated content type.
         <br/><br/>
         The following <strong>preconditions</strong> must be met:
         <ul>
           <li>only possible for PMT real translations.</li>
           <li>the translation request has been returned by SDL and imported by Pikachu.</li>
           <li>the filename of the translation request is known.</li>
         </ul>
         </p>
    		<form method="post">
            <xsl:attribute name="action" select="concat($gui_url,$section_url,'translation_cancelation_post')"/>
            <p>
            <table>
               <tr>
                  <td><b>filename translation request</b></td><td> : </td><td><input name="file_name" size="50" type="text"/> (nb. in the proper case)</td>
               </tr>
            </table>
            </p>
            <hr /><br/><br/>
            <input style="width: 137px" type="submit" value="Submit"/>
    		</form>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
