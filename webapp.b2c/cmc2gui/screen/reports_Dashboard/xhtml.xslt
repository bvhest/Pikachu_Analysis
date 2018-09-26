<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>

  <xsl:template match="/root">
    <html>
      <body>
    		<h2>Pikachu Dashboard report</h2>
    		<form method="post">
            <xsl:attribute name="action" select="concat($gui_url,$section_url,'reports_Dashboard_post')"/>
            <p>
            <table>
               <tr>
                  <td>Date</td>
                  <td> : </td>
                  <td><input name="p_date" size="8" type="text">
                         <xsl:attribute name="value" select="format-date(current-date(), '[Y0001][M01][D01]')"/>
                      </input>in format 'YYYYMMDD'.<br />
                  </td>
               </tr>
               <tr>
                  <td>Runmode</td>
                  <td> : </td>
                  <td><select name="p_runmode">
                        <option name="value" select="Daily" value="BATCH" selected="selected">Daily batch</option>
                        <option name="value" value="MANUAL">Manual run</option>
                     </select>
                  </td>
               </tr>
			    <tr>
                  <td>Details</td>
                  <td> : </td>
                  <td><select name="p_details">
                        <option name="value" select="PMT" value="1" selected="selected">PMT</option>						
                        <option name="value" value="0">ALL</option>
                     </select>
                  </td>
               </tr>
			    <tr>
                  <td>Period</td>
                  <td> : </td>
                  <td><select name="p_period">
                        <option name="value" value="30">30</option>
                        <option name="value" value="60" select="60" selected="selected">60</option>						
                        <option name="value" value="90">90</option>
                        <option name="value" value="120">120</option>
                        <option name="value" value="180">180</option>
                     </select> in days.
                  </td>
               </tr>
            </table>
            </p>
    			<hr/>
    			<br/><br/>
    			<input style="width: 137px" type="submit" value="Run report"/>
    		</form>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>