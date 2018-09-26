<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                >

  <xsl:template match="/root">
    <root>
      <users>    
        <sql:execute-query>
          <sql:query name="users">
			select u.user_account, r.role_code from tbluser u
			left join tbluserrole ur
			on u.user_id = ur.user_id
			left join tblrole r
			on ur.role_id = r.role_id
			and r.role_code in ('projectCreator','projectAdmin')
			where u.user_account not like '%@%'	
			order by u.user_account asc, r.role_code asc          
          </sql:query>
          <sql:execute-query>
            <sql:query name="cat">
              select count(*) logincount, min(timestmp) firstlogin, max(timestmp) lastlogin from logging_event where upper(formatted_message) like 'GETUSERPROFILE USER=<sql:ancestor-value name="user_account" level="1"/>%'
            </sql:query>
          </sql:execute-query>
        </sql:execute-query>        
	  </users>
    </root>
  </xsl:template>
</xsl:stylesheet>
