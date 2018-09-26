<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="l"/>
  <!-- -->
  <xsl:template match="/">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}">
      <entry includeinreport='no'>
        <sql:execute-query>
          <sql:query isstoredprocedure="true">
            BEGIN
               -- MV_CAT_OBJ
               DBMS_SNAPSHOT.REFRESH(LIST => 'MV_CAT_OBJ'
                                    ,METHOD => 'C'
                                    ,PUSH_DEFERRED_RPC => TRUE
                                    ,REFRESH_AFTER_ERRORS => FALSE
                                    ,PURGE_OPTION => 1
                                    ,PARALLELISM => 0
                                    ,ATOMIC_REFRESH => TRUE);
               -- MV_CAT_OBJ_COUNTRY
               DBMS_SNAPSHOT.REFRESH(LIST => 'MV_CAT_OBJ_COUNTRY'
                                    ,METHOD => 'C'
                                    ,PUSH_DEFERRED_RPC => TRUE
                                    ,REFRESH_AFTER_ERRORS => FALSE
                                    ,PURGE_OPTION => 1
                                    ,PARALLELISM => 0
                                    ,ATOMIC_REFRESH => TRUE);
               -- MV_OCTL_T_CTL
               DBMS_SNAPSHOT.REFRESH(LIST => 'MV_OCTL_T_CTL'
                                    ,METHOD => 'C'
                                    ,PUSH_DEFERRED_RPC => TRUE
                                    ,REFRESH_AFTER_ERRORS => FALSE
                                    ,PURGE_OPTION => 1
                                    ,PARALLELISM => 0
                                    ,ATOMIC_REFRESH => TRUE);
               -- MV_CO_OBJECT_ID
               DBMS_SNAPSHOT.REFRESH(LIST => 'MV_CO_OBJECT_ID'
                                    ,METHOD => 'C'
                                    ,PUSH_DEFERRED_RPC => TRUE
                                    ,REFRESH_AFTER_ERRORS => FALSE
                                    ,PURGE_OPTION => 1
                                    ,PARALLELISM => 0
                                    ,ATOMIC_REFRESH => TRUE);
               -- MV_CO_OBJECT_ID_COUNTRY
               DBMS_SNAPSHOT.REFRESH(LIST => 'MV_CO_OBJECT_ID_COUNTRY'
                                    ,METHOD => 'C'
                                    ,PUSH_DEFERRED_RPC => TRUE
                                    ,REFRESH_AFTER_ERRORS => FALSE
                                    ,PURGE_OPTION => 1
                                    ,PARALLELISM => 0
                                    ,ATOMIC_REFRESH => TRUE);
            END;
          </sql:query>
        </sql:execute-query>
      </entry>
    </entries>
  </xsl:template>
</xsl:stylesheet>