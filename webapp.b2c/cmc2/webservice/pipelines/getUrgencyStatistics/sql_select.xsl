<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                >

  <xsl:import href="../em-functions.xsl"/>

  <xsl:param name="userID" select="''"/>
  <xsl:param name="authorizationRestriction" select="''"/>
  <xsl:param name="columnSelection" select="''"/>
  <xsl:param name="ctnRestriction" select="''"/>

  <xsl:template match="/root">
    <root>
         <xsl:variable name="ctns" select="replace($ctnRestriction, 
                                                   ',', 
                                                   concat($apos, ',', $apos)
                                           )"/>
         <xsl:variable name="columns" select="replace($columnSelection, 
                                                   ',', 
                                                   concat($apos, ',', $apos)
                                           )"/>                                           
      <sql:execute-query>
        <sql:query>
        select t1.col, t1.colour,t1.total + nvl(t2.total,0) total 
		from pms_colid_color_total t1
		left outer join 
		     (
		      select col, colour, sum(total) total
		      from
		      ( 
		      select 
		            distinct 
		            a.columnid col, 
		            case when a.rank_group = 0       then 'Green' 
		                 when a.rank_group = 1       then 'Grey'
		                 when a.rank_group = 2       then 'Orange'
		                 when a.rank_group in (3,4)  then 'Red'
		             end colour    ,
		             count(*) over ( partition by a.columnid,a.rank_group ) total
		      from pms_alerts a , vw_pms_products p
		      where a.columnid in ('<xsl:value-of select="$columns"/>')
		        and a.ctn=p.ctn
		        <xsl:if test="$authorizationRestriction = 'I own'">
	            and upper(p.owner) = '<xsl:value-of select="upper-case($userID)"/>'
	            </xsl:if>
	            <xsl:if test="$ctns != ''">
	            and a.ctn in ('<xsl:value-of select="$ctns"/>')
	            </xsl:if>              
		      )
		      group by col,colour 
		    ) t2
		    on ( t1.col = t2.col and t1.colour = t2.colour ) 
        </sql:query>
      </sql:execute-query>	      
    </root>
  </xsl:template>
</xsl:stylesheet>
