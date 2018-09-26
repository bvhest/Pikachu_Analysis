<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="catalog"/>

  <!-- -->
  <xsl:template match="/">
  <root>
    
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="CalculateProductRanking - clean table">
      
        Delete From Catalog_Objects_Rank
      
      </sql:query>
     </sql:execute-query>
    
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="CalculateProductRanking - insert table">
            
      INSERT INTO Catalog_Objects_Rank
			SELECT Cor.Customer_Id,
			  Cor.Object_Id,
			  Cor.Country,
			  TRUNC((Cor.Drank / Cor.Max_Rank * 100) , 6) Rank
			FROM
			  (SELECT customer_id,
			    country,
			    object_id,
			    drank,
			    MAX(drank) over(partition BY country) AS max_rank
			  FROM
			    (SELECT t.*,
			      dense_rank() over(partition BY t.country order by t.grouprank DESC, t.categoryrank DESC, t.subcategoryrank DESC, t.priority, t.object_id) AS drank
			    FROM
			      (SELECT co.country,
			        co.customer_id,
			        co.object_id,
			        max(c.grouprank) as grouprank,
			        max(c.categoryrank) as categoryrank,
			        max(c.subcategoryrank) as subcategoryrank,
			        max(co.priority) as priority 
			      FROM catalog_objects co
			      INNER JOIN vw_object_categorization oc
				      ON oc.object_id   = co.object_id
				      AND oc.catalogcode = co.customer_id
			      INNER JOIN categorization c
				      ON C.Catalogcode     = Co.Customer_Id
				      AND c.subcategorycode= oc.subcategory
			      WHERE co.deleted     = 0				       
				      AND (co.sop - 45) &lt; sysdate 
				      AND co.customer_id = '<xsl:value-of select="$catalog"/>' 
				      AND co.country = '<xsl:value-of select="$country"/>'
			      group by co.country, co.customer_id, co.object_id	      
			      ) T
			    )
			  ) Cor 
      </sql:query>
     </sql:execute-query>    
    
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="CalculateProductRanking - update table">
      				    
				DECLARE
				  CURSOR c1
				  IS
				    SELECT * FROM Catalog_Objects_Rank;
				BEGIN
				  FOR r IN c1
				  LOOP
				    UPDATE Catalog_Objects Catobj
				    SET Catobj.Rank        = r.Rank,
				      Catobj.Lastmodified  = Sysdate
				    WHERE Catobj.Object_Id = r.Object_Id
				    AND Catobj.Customer_Id = r.Customer_Id
				    AND Catobj.Country     = r.Country
				    AND Catobj.rank != r.rank;
				  END LOOP;
				  commit;
				END;
      </sql:query>
     </sql:execute-query>

  </root>
</xsl:template>
</xsl:stylesheet>