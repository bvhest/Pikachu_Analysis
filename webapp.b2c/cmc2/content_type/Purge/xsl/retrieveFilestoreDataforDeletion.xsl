<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:param name="ts"/>
  
  <xsl:template match="/">
  <root>
    <xsl:copy>
	 <sql:execute-query>
        <sql:query name="update_batch_number">
			update 
			purge_data	
			set batch_number =  null
			where 
				batch_number !=null
        </sql:query>
      </sql:execute-query>
	 <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
		<sql:query isstoredprocedure="true"  name="sql_create_batches: PurgeTemp">
			declare
                  cursor c1
                  is
                    select 
						object_id
						,localisation
						,content_type
						,substr(filelocation,8,length(filelocation))  filelocation						
					from
					purge_data	
					 
						order by object_id						
					;
					i 	PLS_INTEGER := 0 ;
					batchSize	PLS_INTEGER := 5000;
					v_msg            varchar2(4000);
					v_modus varchar2(200) := 'BATCH';
					
					 begin
					  
					  for r in c1 
					  loop
						 i := i + 1 ;
						 update purge_data
							set  batch_number       = ceil(i/batchSize) 
						  where 
							content_type      = r.content_type
							and localisation      = r.localisation
							and object_id = r.object_id
						 ;
					  end loop;
					 
                  end;
				 
		</sql:query>
      </sql:execute-query>
			  
	<!-- Retrieve -->
      <sql:execute-query>
        <sql:query name="seelct-batch-number">
			select 
				distinct batch_number
			from
			purge_data	
			where 
				batch_number >0
				order by batch_number
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
	</root>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
</xsl:stylesheet>
