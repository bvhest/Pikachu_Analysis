<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                xmlns:cmc2-f="http://www.philips.com/cmc2-f">
  
  <xsl:import href="../service-base.xsl"/>
  <xsl:import href="../../../xsl/common/cmc2.function.xsl"/>
 
  <xsl:param name="objectType" select="'Product'"/>
  <xsl:param name="maxNum" select="0"/>
  <xsl:param name="lastID"/>
  <xsl:param name="locale"/>
  <xsl:param name="contentType"/>
  <xsl:param name="filter" select="''"/>

  <!-- The parameters below are not part of the getObjectListFromProfile interface but other operations use this -->
  <!-- For getObjectListFromPartialID -->
  <xsl:param name="partialID"/>
  <!-- For getObjectListFromCategorization -->
  <xsl:param name="categorizationID"/>
  <xsl:param name="nodeID"/>
  <xsl:param name="nodeType"/>
  <!-- For getObjectListFromCatalog -->  
  <xsl:param name="catalogID"/>
  <xsl:param name="country"/>
  
  <xsl:template match="/root">
  	 <xsl:variable name="l_maxNum" select="500"/>

  	 <!-- for 'I can edit', return objects the user as Update access rights for 
	       for no filter, return all objects the user has View access rights for
	  -->
	  <xsl:variable name="subcats">
	    <xsl:if test="$filter='Edit'">
	      <xsl:sequence select="fn:concat($apos,fn:string-join(svc:allowed-subcats-for-profile($uap, 'Update')/SubcategoryCode/text(),fn:concat($apos,',',$apos)),$apos)"/>
	    </xsl:if>
	    <xsl:if test="$filter=''">
	      <xsl:sequence select="fn:concat($apos,fn:string-join(svc:allowed-subcats-for-profile($uap, 'Read')/SubcategoryCode/text(),fn:concat($apos,',',$apos)),$apos)"/>
	    </xsl:if>
	  </xsl:variable>
  
	  <!-- for 'I own' and 'I can sign', retrieve the CTNs from the portfolio section of the user profile  -->
	  <xsl:variable name="products">
	  	<xsl:if test="$filter = 'Own'">
	  	  <xsl:perform-sort>
	  	    <xsl:sort select="."/>
	  	    <xsl:sequence select="svc:allowed-products-for-profile($uap)/ProductsOwned/CTN"/>
	  	  </xsl:perform-sort>
	  	</xsl:if>
	  	<xsl:if test="$filter = 'Sign'">
	  	  <xsl:perform-sort>
	  	    <xsl:sort select="."/>
	  	    <xsl:sequence select="if ($lastID = '') then svc:allowed-products-for-profile($uap)/ProductsToReview/CTN else svc:allowed-products-for-profile($uap)/ProductsToSign/CTN[string() > $lastID]"/>
	  	  </xsl:perform-sort>
	  	</xsl:if>
	  </xsl:variable>

    <root>
      <xsl:choose>
        <xsl:when test="count($products/CTN) > 0"> 
          <!-- Own filter and Sign filter -->
          <xsl:for-each-group select="if (number($maxNum) = 0) then $products/CTN else $products/CTN[(position() &lt;= number($l_maxNum))]" group-by="(position() - 1) idiv 1000">
	          <xsl:call-template name="do-query">
	            <xsl:with-param name="p_subcats" select="''"/>
	            <xsl:with-param name="p_products" select="fn:concat($apos,fn:string-join(current-group(),fn:concat($apos,',',$apos)),$apos)"/>
	          </xsl:call-template>
          </xsl:for-each-group> 
        </xsl:when>
        <xsl:otherwise>
          <!-- Edit filter -->
          <xsl:if test="$filter = 'Edit'">
	          <xsl:call-template name="do-query">
	            <xsl:with-param name="p_subcats" select="$subcats"/>
	            <xsl:with-param name="p_products" select="''"/>
	          </xsl:call-template>  
          </xsl:if>
          <!-- fetch all PMT Final Published when no filter is applied -->
          <xsl:if test="$filter=''">
            <xsl:call-template name="do-no-filter-query">
            	<xsl:with-param name="p_subcats" select="$subcats"/>
            	<xsl:with-param name="p_maxNum" select="if (number($maxNum) = 0) then $l_maxNum else $maxNum"/>
            </xsl:call-template>	
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>

    </root>
  </xsl:template>
  
  <xsl:template name="do-query">
  	<xsl:param name="p_subcats"/>
  	<xsl:param name="p_products"/>
  	
  	<sql:execute-query>
      <sql:query> 
        <xsl:if test="$filter = 'Edit'">
          select * from (
        </xsl:if>
		  select
		    oc.object_id,
		    to_char(o.lastmodified_ts,'YYYY-MM-DD"T"HH24:MI:SS') lastmodified
		  from octl o
		  inner join object_categorization oc 
           on oc.object_id=o.object_id
		  <xsl:if test="$catalogID != ''">
		  inner join vw_catalog_objects co 
           on co.object_id   = o.object_id
		    and co.customer_id = '<xsl:value-of select="$catalogID"/>'
		    and co.country     = '<xsl:value-of select="$country"/>'
		  </xsl:if>
		  -- Join categorization to get only active subcategories' products
		  inner join categorization c12n 
           on c12n.subcategorycode = oc.subcategory
		    and c12n.catalogcode     = '<xsl:value-of select="if ($categorizationID != '') then $categorizationID else 'CONSUMER'"/>'
		    and c12n.subcategory_status = 'Active'
		    <xsl:choose>
		      <xsl:when test="$nodeType = 'group'">
		      and c12n.groupcode = '<xsl:value-of select="$nodeID"/>'
		      </xsl:when>
		      <xsl:when test="$nodeType = 'category'">
		      and c12n.categorycode = '<xsl:value-of select="$nodeID"/>'
		      </xsl:when>
		      <xsl:when test="$nodeType = 'subcategory'">
		      and c12n.subcategorycode = '<xsl:value-of select="$nodeID"/>'
		      </xsl:when>
		    </xsl:choose>
		  where o.content_type = '<xsl:value-of select="if ($contentType != '') then $contentType else 'PMS'"/>'
		    and o.localisation = '<xsl:value-of select="if ($locale != '') then $locale else 'none'"/>'
		    and o.status != 'Deleted' and status != 'PLACEHOLDER'
		    and oc.catalogcode = '<xsl:value-of select="svc:objectcat-code-for-catalog-code($catalogID)"/>'
		    <xsl:choose>
		      <xsl:when test="$filter = 'Edit' or $categorizationID != ''">
		    	and oc.subcategory in (<xsl:value-of select="$p_subcats"/>)
		      </xsl:when>
		      <xsl:otherwise>
		        and oc.object_id in (<xsl:value-of select="$p_products"/>)
		      </xsl:otherwise>
		    </xsl:choose>
		    <xsl:if test="$partialID != ''">
		    and oc.object_id like '<xsl:value-of select="concat(cmc2-f:escape-sql($partialID, true()), '%')"/>' escape '\'
		    </xsl:if>
		  order by 1
		  <xsl:if test="$filter = 'Edit'">
		    )
			where 1=1
			  <xsl:if test="$lastID != ''">
			  and object_id > '<xsl:value-of select="cmc2-f:escape-sql($lastID, false())"/>'
			  </xsl:if>
			  <xsl:if test="number($maxNum) > 0">
			  and rownum &lt;= <xsl:value-of select="number($maxNum)"/>
			  </xsl:if>
		  </xsl:if>
	  </sql:query>
	</sql:execute-query>
  </xsl:template>
  
  <!-- Fetch all PMT Final Published objects and join with PME_Raw -->
  <xsl:template name="do-no-filter-query">
  	<xsl:param name="p_subcats"/>
  	<xsl:param name="p_maxNum"/>

  	<sql:execute-query>
      <sql:query>
        select * from (
			select object_id, to_char(max(lastmodified_ts),'YYYY-MM-DD"T"HH24:MI:SS') lastmodified
			from (
			    select o.object_id, o.lastmodified_ts 
			    	from octl o
            		inner join mv_co_object_id co on co.object_id = o.object_id 
			    		where o.content_type = 'PMT_Raw'
			    		and o.status         = 'Final Published'
			    		and o.localisation = 'none'
			    		and co.sop &lt;= trunc(sysdate - 2)
              			and co.sos &lt;= trunc(sysdate - 2) 
              			and co.deleted=0   		
			    UNION ALL
			    select o.object_id, o.lastmodified_ts 
			    	from octl o
			    		inner join vw_object_categorization oc 
                     on oc.object_id=o.object_id
						<xsl:if test="$catalogID != ''">
						inner join catalog_objects co 
                     on co.object_id = o.object_id
						  and co.customer_id = '<xsl:value-of select="$catalogID"/>'
						  and co.country = '<xsl:value-of select="$country"/>'
						</xsl:if>
						-- Join categorization to get only active subcategories' products
						inner join categorization c12n 
                     on c12n.subcategorycode = oc.subcategory
						  and c12n.catalogcode = '<xsl:value-of select="if ($categorizationID != '') then $categorizationID else 'CONSUMER'"/>'
						  and c12n.subcategory_status = 'Active'
						  <xsl:choose>
						    <xsl:when test="$nodeType = 'group'">
						    and c12n.groupcode = '<xsl:value-of select="$nodeID"/>'
						    </xsl:when>
						    <xsl:when test="$nodeType = 'category'">
						    and c12n.categorycode = '<xsl:value-of select="$nodeID"/>'
						    </xsl:when>
						    <xsl:when test="$nodeType = 'subcategory'">
						    and c12n.subcategorycode = '<xsl:value-of select="$nodeID"/>'
						    </xsl:when>
						  </xsl:choose>
						  where o.content_type = 'PME_Raw'
						    and o.status != 'Deleted' and status != 'PLACEHOLDER'
						    and oc.catalogcode = '<xsl:value-of select="svc:objectcat-code-for-catalog-code($catalogID)"/>'
					    	and oc.subcategory in (<xsl:value-of select="$p_subcats"/>)
		  )
		  group by object_id
		  order by object_id
	    )
		where 1=1
		<xsl:if test="$partialID != ''">
		and object_id like '<xsl:value-of select="concat(cmc2-f:escape-sql($partialID, true()), '%')"/>' escape '\'
		</xsl:if>
  	    <xsl:if test="$lastID != ''">
	    and object_id > '<xsl:value-of select="cmc2-f:escape-sql($lastID, false())"/>'
	    </xsl:if>  
	    <xsl:if test="number($p_maxNum) > 0">
	    and rownum &lt;= <xsl:value-of select="number($p_maxNum)"/>
	    </xsl:if>
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>
