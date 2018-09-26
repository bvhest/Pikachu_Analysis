<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>

  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
      select distinct ot.doctimestamp, ot.filename , ot.marketingversion, ot.object_id, ot.localisation
        from octl_translations ot
       where ot.content_type = 'PMT_Translated'
         and ot.workflow     = 'CL_CMC'
         and ot.doctimestamp &lt; add_months(sysdate,-3)
         and (ot.object_id, ot.localisation) 
         IN ( select o.object_id, o.localisation
                from octl o
               inner join catalog_objects co
                  on co.object_id   = o.object_id 
                 AND co.country     = SUBSTR(o.localisation,4,2)
                 AND co.deleted     = 0   -- not deleted
                 AND co.eop         > sop -- not inactivated by setting PublishToWeb=No in LCB
                 and co.customer_id IN ('CONSUMER', 'FLAGSHIPSHOP') 
               where o.content_type = 'PMT'
                 and o.status       = 'Final Published'
--                       and o.object_id    = '56PFL9954H/12' --FOR TESTING PURPOSES > REMOVE!!!
            )
         and ot.import_ts   is null
         and ot.valid       is null
         and exists (select 1
                       from octl_translations ot3
                      where ot3.content_type = 'PMT_Translated'
                        and ot3.workflow     = 'CL_CMC'
                        and ot3.object_id    = ot.object_id
                        and ot3.localisation = ot.localisation
                        and ot3.import_ts   is not null
                        and ot3.valid        = 'true'
                        and ot3.doctimestamp > ot.doctimestamp
                    )
       order by ot.doctimestamp desc
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>