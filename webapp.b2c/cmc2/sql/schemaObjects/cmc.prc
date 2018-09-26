PROMPT Creating Procedure 'purge_octl_store' 
CREATE OR REPLACE PROCEDURE CMC2_PROD1_SCHEMA.purge_octl_store (p_max_history_versions IN number)
IS
   cv_max_history   PLS_INTEGER                 := p_max_history_versions;

   CURSOR c_ctl IS
      SELECT content_type, localisation
      FROM ctl;

   TYPE ctl_table_type IS TABLE OF c_ctl%ROWTYPE INDEX BY BINARY_INTEGER;

   ctl_table        ctl_table_type;

   CURSOR c_octl (p_content_type IN VARCHAR2, p_localisation IN VARCHAR2)  IS
      SELECT   os.object_id, os.ROWID octl_store_rowid
      FROM octl_store os left outer join octl o
      ON os.content_type = o.content_type
      AND os.localisation = o.localisation
      AND os.object_id = o.object_id
      AND os.masterlastmodified_ts = o.masterlastmodified_ts
      AND os.lastmodified_ts = o.lastmodified_ts      
      WHERE os.content_type = p_content_type
      AND os.localisation = p_localisation
      AND o.content_type IS NULL
      ORDER BY os.object_id, os.masterlastmodified_ts DESC, os.lastmodified_ts DESC;

   TYPE octl_table_type IS TABLE OF c_octl%ROWTYPE
      INDEX BY BINARY_INTEGER;

   octl_table       octl_table_type;

   CURSOR c_lock_ (p_rowid IN ROWID) IS
      SELECT        1
      FROM octl_store os
      WHERE os.ROWID = p_rowid
      FOR UPDATE OF os.content_type NOWAIT;

   r                PLS_INTEGER;
   o                octl_store.object_id%TYPE;
   v_dummy          NUMBER;
   e_locked         EXCEPTION;
   PRAGMA EXCEPTION_INIT (e_locked, -54);
   
BEGIN

   OPEN c_ctl;
   FETCH c_ctl BULK COLLECT INTO ctl_table;
   CLOSE c_ctl;

   FOR i IN 1 .. ctl_table.COUNT
   LOOP
      DBMS_OUTPUT.put_line (ctl_table (i).content_type || ',' || ctl_table (i).localisation);

      OPEN c_octl (ctl_table (i).content_type, ctl_table (i).localisation);
      FETCH c_octl
      BULK COLLECT INTO octl_table;
      CLOSE c_octl;

      r := 0;

      FOR j IN 1 .. octl_table.COUNT
      LOOP
         IF o != octl_table (j).object_id OR o IS NULL THEN
            o := octl_table (j).object_id;
            r := 0;
         END IF;

         r := r + 1;

         IF r > cv_max_history THEN
            BEGIN
            
               OPEN c_lock_ (octl_table (j).octl_store_rowid);
               FETCH c_lock_ INTO v_dummy;
               IF c_lock_%FOUND THEN
                 dbms_output.put_line('Deleting from octl_store: ' || octl_table (j).object_id || '-' || octl_table(j).octl_store_rowid);
                 DELETE FROM octl_store WHERE CURRENT OF c_lock_;
               END IF;
               CLOSE c_lock_;
               
            EXCEPTION
               WHEN e_locked THEN
                  DBMS_OUTPUT.put_line ('Skipping due to lock');
                  IF c_lock_%ISOPEN THEN
                     CLOSE c_lock_;
                  END IF;
               WHEN OTHERS THEN
                  RAISE;
            END;
         END IF;
         
      END LOOP;
      COMMIT;
   END LOOP;
END purge_octl_store;
/
SHOW ERROR

PROMPT Creating Procedure 'SET_OUTPUT_NEEDSPROCESSING' 
CREATE OR REPLACE PROCEDURE SET_OUTPUT_NEEDSPROCESSING
 (P_CT IN VARCHAR2
 ,P_L IN VARCHAR2
 ,P_O IN VARCHAR2
 )
 IS

   --CURSOR DECLARATIONS
   CURSOR c_output_octls (
      p_content_type   IN   VARCHAR2,
      p_localisation   IN   VARCHAR2,
      p_object_id      IN   VARCHAR2
   )
   IS
      SELECT o.ROWID o_rowid
        FROM octl o, octl_relations r, content_types ct
       WHERE o.content_type = r.output_content_type
         AND o.localisation = r.output_localisation
         AND o.object_id = r.output_object_id
         AND r.input_content_type = p_content_type
         AND r.input_localisation = p_localisation
         AND r.input_object_id = p_object_id
         AND ct.content_type = r.output_content_type;
BEGIN
   FOR r IN c_output_octls (p_ct, p_l, p_o)
   LOOP
      UPDATE octl
         SET needsprocessing_flag = 1,
             needsprocessing_ts = SYSDATE
       WHERE ROWID = r.o_rowid;
   END LOOP;
END set_output_needsprocessing;
/
SHOW ERROR

PROMPT Creating Procedure 'CREATE_CATALOG_PLACEHOLDERS' 
CREATE OR REPLACE PROCEDURE create_catalog_placeholders (p_ctg_id IN VARCHAR2, p_delta IN NUMBER)
IS
   /******************************************************************************
      NAME:       create_catalog_placeholders
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        09/05/2007          1. Created this procedure.

      NOTES:

      Automatically available Auto Replace Keywords:
         Object Name:     create_catalog_placeholders
         Sysdate:         09/05/2007
         Date and Time:   09/05/2007, 16:18:06, and 09/05/2007 16:18:06
         Username:         (set in TOAD Options, Procedure Editor)
         Table Name:       (set in the "New PL/SQL Object" dialog)

   ******************************************************************************/

   --DECLARE
   --   p_ctg_id                      VARCHAR2 (100) := 'CONSUMER_NL_Catalog';
   --   p_delta                       NUMBER (1) := 1;

   --CURSOR DECLARATIONS
   CURSOR c_catalog_objects
   IS
      SELECT c.content_type, c.localisation, o.object_id, o.sop, o.eop, o.ROWID ctgobjects_rowid, c.ROWID ctgctl_rowid
           , o.country, o.catalog_id, o.needsprocessing_flag
        FROM catalog_ctl c, catalog_objects o, ctl
       WHERE c.catalog_id = o.catalog_id
         AND c.catalog_id = p_ctg_id
         AND ctl.content_type = c.content_type
         AND ctl.localisation = c.localisation;

   /* c_agg_ctg_dates_by_objectid retrieves minSOP/maxEOP across all countries for the same objectid */
   CURSOR c_agg_ctg_dates_by_objectid (
      p_object_id                IN       VARCHAR2
    , p_catalog_id               IN       VARCHAR2
    , p_date_min                 IN       DATE
    , p_date_max                 IN       DATE
   )
   IS
      SELECT MIN (sop) sop, MAX (eop) eop
        FROM catalog_objects
       WHERE object_id = p_object_id
         AND sop IS NOT NULL
         AND sop != p_date_min
         AND eop IS NOT NULL
         AND eop != p_date_max
         AND catalog_id != p_catalog_id;

   r_agg_ctg_dates_by_objectid   c_agg_ctg_dates_by_objectid%ROWTYPE;

   CURSOR c_primary_relations (p_content_type IN VARCHAR2, p_localisation IN VARCHAR2)
   IS
      SELECT     cr.input_content_type, cr.input_localisation, cr.output_content_type, cr.output_localisation
               , cr.issecondary, cr.global_id
            FROM ctl_relations cr
           WHERE cr.issecondary = 0
      START WITH cr.output_content_type = p_content_type
             AND cr.output_localisation = p_localisation
      CONNECT BY PRIOR cr.input_content_type = cr.output_content_type
             AND PRIOR cr.input_localisation = cr.output_localisation;

   CURSOR c_octl (p_content_type IN VARCHAR2, p_localisation IN VARCHAR2, p_object_id IN VARCHAR2)
   IS
      SELECT o.ROWID octl_rowid, startofprocessing, endofprocessing, status, o.object_id, o.active_flag
           , o.needsprocessing_flag, o.localisation, o.content_type
        FROM octl o
       WHERE o.content_type = p_content_type
         AND o.localisation = p_localisation
         AND o.object_id = p_object_id;

   r_output_octl                 c_octl%ROWTYPE;
   r_octl                        c_octl%ROWTYPE;

   CURSOR c_outputs_deleted (p_content_type IN VARCHAR2, p_localisation IN VARCHAR2, p_object_id IN VARCHAR2)
   IS
      SELECT 1
        FROM octl_relations ocr, octl o
       WHERE ocr.input_content_type = p_content_type
         AND ocr.input_localisation = p_localisation
         AND ocr.input_object_id = p_object_id
         AND ocr.issecondary = 0
         AND ocr.output_content_type = o.content_type
         AND ocr.output_localisation = o.localisation
         AND ocr.output_object_id = o.object_id
         AND o.status != 'Deleted';

   -- c_agg_all_dates aggregates dates over catalog_objects and output octl for the same object_id and localisation/country
   CURSOR c_agg_all_dates (
      p_content_type             IN       VARCHAR2
    , p_localisation             IN       VARCHAR2
    , p_object_id                IN       VARCHAR2
    , p_date_min                 IN       DATE
    , p_date_max                 IN       DATE
   )
   IS
      SELECT NVL (MIN (sop), p_date_min) startofprocessing, NVL (MAX (eop), p_date_max) endofprocessing
        FROM (SELECT co.sop - NVL (ctl.offset_days, 0) sop, co.eop
                FROM catalog_ctl cc INNER JOIN ctl ctl
                     ON cc.content_type = ctl.content_type
                   AND cc.localisation = ctl.localisation
                     INNER JOIN catalog_objects co ON co.catalog_id = cc.catalog_id
               WHERE co.object_id = p_object_id
                 AND cc.localisation = p_localisation
                 AND cc.content_type = p_content_type
              UNION
              SELECT o.startofprocessing, o.endofprocessing
                FROM ctl_relations cr INNER JOIN octl o
                     ON cr.output_content_type = o.content_type
                   AND cr.output_localisation = o.localisation
               WHERE cr.input_content_type = p_content_type
                 AND cr.input_localisation = p_localisation
                 AND cr.issecondary = 0
                 AND o.object_id = p_object_id
                 AND o.startofprocessing != TO_DATE ('1900-01-01', 'YYYY-MM-DD')
                 AND o.endofprocessing != TO_DATE ('2299-01-01', 'YYYY-MM-DD'));

   r_agg_all_dates               c_agg_all_dates%ROWTYPE;

   CURSOR c_ctl_offset (p_content_type IN VARCHAR2, p_localisation IN VARCHAR2)
   IS
      SELECT NVL (cl.offset_days, 0)
        FROM ctl cl
       WHERE cl.content_type = p_content_type
         AND cl.localisation = p_localisation;

   -- Retrieve the status of the primary input OCTL for a given OCTL
   CURSOR c_primary_input_status (p_content_type IN VARCHAR2, p_localisation IN VARCHAR2, p_object_id IN VARCHAR2)
   IS
      SELECT NVL (o.status, '') status
        FROM octl_relations ocr, octl o
       WHERE ocr.output_content_type = p_content_type
         AND ocr.output_localisation = p_localisation
         AND ocr.output_object_id = p_object_id
         AND ocr.issecondary = 0
         AND ocr.input_content_type = o.content_type
         AND ocr.input_localisation = o.localisation
         AND ocr.input_object_id = o.object_id;

   r_primary_input_status        VARCHAR (2000);
   --CONSTANT DECLARATIONS
   cv_date_min          CONSTANT DATE := TO_DATE ('01/01/1900', 'dd/mm/yyyy');
   cv_date_max          CONSTANT DATE := TO_DATE ('01/01/2299', 'dd/mm/yyyy');
   cv_needsprocessing_flag CONSTANT octl.needsprocessing_flag%TYPE := 0;
   cv_derivesecondary_flag CONSTANT octl.derivesecondary_flag%TYPE := 0;
   cv_intransaction_flag CONSTANT octl.intransaction_flag%TYPE := 0;
   cv_active_flag       CONSTANT octl.active_flag%TYPE := 1;
   cv_placeholder       CONSTANT octl.status%TYPE := 'PLACEHOLDER';
   cv_deleted           CONSTANT octl.status%TYPE := 'Deleted';
   cv_awaitingtranslationimport CONSTANT octl.status%TYPE := 'AwaitingTranslationImport';
   cv_batch_number      CONSTANT octl.batch_number%TYPE := NULL;
   cv_remark            CONSTANT octl.remark%TYPE := NULL;
   cv_islocalized       CONSTANT octl.islocalized%TYPE := 0;
   --LOCAL VARIABLE DECLARATIONS
   v_output_octl_exists          BOOLEAN;
   v_output_dates_exist          BOOLEAN;
   v_octl_exists                 BOOLEAN;
   v_octl_relation_exists        BOOLEAN;
   v_has_input                   BOOLEAN;
   v_all_deleted                 BOOLEAN;
   v_set_npflag_on_ctg_objects   BOOLEAN;
   v_dummy                       NUMBER;
   v_startofprocessing           DATE;
   v_endofprocessing             DATE;
   v_t1                          DATE;
   v_t2                          DATE;
   v_status                      octl.status%TYPE;
   v_offset                      ctl.offset_days%TYPE;
   v_needsprocessing_flag        octl.needsprocessing_flag%TYPE;
   /** note: the columns in the select clause must be identical to c_catalog_objects cursor select clause **/
   v_sql                         VARCHAR (2000)
      :=    'SELECT c.content_type, c.localisation, o.object_id, o.sop, o.eop, o.rowid ctgobjects_rowid, c.rowid ctgctl_rowid, o.country, o.catalog_id, o.needsprocessing_flag
                             FROM catalog_ctl c, catalog_objects o, ctl
                            WHERE c.catalog_id = o.catalog_id
                              AND ctl.CONTENT_TYPE = c.CONTENT_TYPE
                              AND ctl.LOCALISATION = c.LOCALISATION
                              AND c.catalog_id = '
         || CHR (39)
         || p_ctg_id
         || CHR (39);

   TYPE ref_cursor IS REF CURSOR;

   c_ref_cursor                  ref_cursor;
   catalog                       c_catalog_objects%ROWTYPE;
   b_debug                       BOOLEAN := FALSE;

   PROCEDURE DEBUG (msg IN VARCHAR2)
   IS
   BEGIN
      IF b_debug
      THEN
         DBMS_OUTPUT.put_line (msg);
      END IF;
   END DEBUG;
BEGIN
   IF p_delta = 1
   THEN
      v_sql := v_sql || ' AND (o.NEEDSPROCESSING_FLAG IN (1,2) OR c.NEEDSPROCESSING_FLAG = 1)';
   END IF;

   DEBUG ('000:' || v_sql);

   OPEN c_ref_cursor FOR v_sql;

   LOOP
      FETCH c_ref_cursor
       INTO catalog;

      EXIT WHEN c_ref_cursor%NOTFOUND;
      v_set_npflag_on_ctg_objects := FALSE;
      DEBUG ('005:' || catalog.object_id || ' ' || catalog.localisation || ' ' || catalog.content_type);

      -- get the offset
      OPEN c_ctl_offset (catalog.content_type, catalog.localisation);

      FETCH c_ctl_offset
       INTO v_offset;

      CLOSE c_ctl_offset;

      -- get the catalog octl
      OPEN c_octl (catalog.content_type
                 , catalog.localisation
                 , catalog.object_id
                  );

      FETCH c_octl
       INTO r_output_octl;

      v_output_octl_exists := c_octl%FOUND;

      CLOSE c_octl;

      -- Start by setting v_startofprocessing/v_endofprocessing to own catalog dates
      v_startofprocessing := NVL (catalog.sop, cv_date_min);
      v_endofprocessing := NVL (catalog.eop, cv_date_max);
      DEBUG ('010:' || 'v_startofprocessing from catalog is ' || v_startofprocessing);
      DEBUG ('010:' || 'v_endofprocessing from catalog is ' || v_endofprocessing);

      -- for PMT2SPOT, compare own sop/eop to minSOP/maxEOP for same objectid in all catalogs
      IF catalog.content_type = 'PMT2SPOT'
      THEN
         OPEN c_agg_ctg_dates_by_objectid (catalog.object_id
                                         , catalog.catalog_id
                                         , cv_date_min
                                         , cv_date_max
                                          );

         FETCH c_agg_ctg_dates_by_objectid
          INTO r_agg_ctg_dates_by_objectid;

         CLOSE c_agg_ctg_dates_by_objectid;

         IF r_agg_ctg_dates_by_objectid.sop < catalog.sop
         -- another assignment exists with an earlier sop, so set v_startofprocessing to that sop
         THEN
            v_startofprocessing := r_agg_ctg_dates_by_objectid.sop;
         ELSIF     catalog.sop < r_agg_ctg_dates_by_objectid.sop
               AND catalog.needsprocessing_flag = 1
         THEN
            -- this assignment has the earliest SOP of all countries, and this assignment is being processed because of a change, so flag all other countries for reprocessing
            v_set_npflag_on_ctg_objects := TRUE;
         END IF;

         IF r_agg_ctg_dates_by_objectid.eop > catalog.eop
         -- another assignment exists with later eop so set v_endofprocessing to that eop
         THEN
            v_endofprocessing := r_agg_ctg_dates_by_objectid.eop;
         ELSIF     catalog.eop > r_agg_ctg_dates_by_objectid.eop
               AND catalog.needsprocessing_flag = 1
         THEN
            -- this assignment has the latest EOP of all countries, and this assignment is being processed because of a change, so flag all other countries for reprocessing
            v_set_npflag_on_ctg_objects := TRUE;
         END IF;

         IF v_set_npflag_on_ctg_objects
         THEN
            DEBUG ('015:' || 'flag 1 true');
         ELSE
            DEBUG ('015:' || 'flag 1 false');
         END IF;
      END IF;

      v_startofprocessing := v_startofprocessing - v_offset;
      DEBUG ('020:' || '1. v_startofprocessing is now ' || v_startofprocessing);
      DEBUG ('020:' || '1. v_endofprocessing is now ' || v_endofprocessing);

      IF NOT v_output_octl_exists
      THEN
         DEBUG ('025:' || 'inserting new octl');

         -- insert the catalog octl
         INSERT INTO octl
                     (content_type, localisation, object_id, needsprocessing_flag, derivesecondary_flag
                    , needsprocessing_ts, intransaction_flag, masterlastmodified_ts, lastmodified_ts
                    , startofprocessing, endofprocessing, active_flag, status, batch_number, remark, islocalized)
            SELECT catalog.content_type, catalog.localisation, catalog.object_id, cv_needsprocessing_flag
                 , cv_derivesecondary_flag, cv_date_min, cv_intransaction_flag, cv_date_min, cv_date_min
                 , v_startofprocessing, v_endofprocessing, cv_active_flag, cv_placeholder, cv_batch_number, cv_remark
                 , cv_islocalized
              FROM DUAL;
      ELSE
         -- if no output dates exist then leave dates as catalog dates otherwise take max/min dates
         OPEN c_agg_all_dates (catalog.content_type
                             , catalog.localisation
                             , catalog.object_id
                             , cv_date_min
                             , cv_date_max
                              );

         FETCH c_agg_all_dates
          INTO r_agg_all_dates;

         CLOSE c_agg_all_dates;

         v_needsprocessing_flag := r_output_octl.needsprocessing_flag;
         DEBUG ('030:' || 'v_needsprocessing_flag: ' || v_needsprocessing_flag);
         DEBUG ('030:' || v_startofprocessing || ',' || v_endofprocessing || ',' || r_output_octl.status);

         -- If the SOP or EOP have changed on the existing OCTL for this catalog object/octl then set the needsprocessing_flag
         IF     (   r_output_octl.startofprocessing != v_startofprocessing
                 OR r_output_octl.endofprocessing != v_endofprocessing
                )
            AND r_output_octl.status != cv_placeholder
         THEN
            v_needsprocessing_flag := 1;
            DEBUG ('035:');
         END IF;

         DEBUG ('040:' || 'v_needsprocessing_flag: ' || v_needsprocessing_flag);
         DEBUG ('045:' || 'Setting SOP/EOP to ' || v_startofprocessing || ',' || v_endofprocessing);

         UPDATE octl
            SET startofprocessing = v_startofprocessing
              , endofprocessing = v_endofprocessing
              , needsprocessing_flag = v_needsprocessing_flag
          --,status = v_status
         WHERE  ROWID = r_output_octl.octl_rowid;
      END IF;

      -- reread octl record loaded by catalog insert or update
      OPEN c_octl (catalog.content_type
                 , catalog.localisation
                 , catalog.object_id
                  );

      FETCH c_octl
       INTO r_output_octl;

      v_output_octl_exists := c_octl%FOUND;

      CLOSE c_octl;

      DEBUG ('050:' || '*************Starting primary relations loop**************');

      -- These are the cmc2 generated octls. Starting at the outputs and working backwards.
      FOR r_pr IN c_primary_relations (catalog.content_type, catalog.localisation)
      LOOP
         DEBUG (   '055:'
                || '****************New primary relations iteration for '
                || r_pr.input_content_type
                || ' '
                || r_pr.input_localisation);

         -- note: we have 2 records r_octl and r_output_octl
         -- The output octl is initially set to the end point octl and thento the octl at the end of each loop
         -- v_status, v_startofprocessing and v_endofprocessing are all set up from output octl processing
         OPEN c_octl (r_pr.input_content_type
                    , r_pr.input_localisation
                    , catalog.object_id
                     );

         FETCH c_octl
          INTO r_octl;

         v_octl_exists := c_octl%FOUND;

         CLOSE c_octl;

         -- get the offset days for this octl. It is used to move the start to an earclier date.
         OPEN c_ctl_offset (r_pr.input_content_type, r_pr.input_localisation);

         FETCH c_ctl_offset
          INTO v_offset;

         CLOSE c_ctl_offset;

         v_startofprocessing := v_startofprocessing - v_offset;
         DEBUG ('060:' || ' v_startofprocessing is now ' || v_startofprocessing);
         DEBUG ('060:' || ' v_endofprocessing is now ' || v_endofprocessing);

         IF NOT v_octl_exists
         THEN
            DEBUG (   '065:'
                   || 'Primary relations insert: '
                   || r_pr.input_content_type
                   || r_pr.input_localisation
                   || catalog.object_id
                   || ' Setting SOP/EOP to '
                   || v_startofprocessing
                   || ','
                   || v_endofprocessing);

            INSERT INTO octl
                        (content_type, localisation, object_id, needsprocessing_flag
                       , derivesecondary_flag, needsprocessing_ts, intransaction_flag, masterlastmodified_ts
                       , lastmodified_ts, startofprocessing, endofprocessing, active_flag, status
                       , batch_number, remark, islocalized
                        )
                 VALUES (r_pr.input_content_type, r_pr.input_localisation, catalog.object_id, cv_needsprocessing_flag
                       , cv_derivesecondary_flag, cv_date_min, cv_intransaction_flag, cv_date_min
                       , cv_date_min, v_startofprocessing, v_endofprocessing, cv_active_flag, cv_placeholder
                       , cv_batch_number, cv_remark, cv_islocalized
                        );

            -- reread octl record loaded by catalog insert or update
            OPEN c_octl (r_pr.input_content_type
                       , r_pr.input_localisation
                       , catalog.object_id
                        );

            FETCH c_octl
             INTO r_octl;

            v_octl_exists := c_octl%FOUND;

            CLOSE c_octl;
         ELSE
            --  SET NEEDSPROCESSING_FLAG for first octl in chain with status=PLACEHOLDER whose previous octl has already been processed
            IF     r_octl.status NOT IN (cv_placeholder, cv_awaitingtranslationimport)
               AND r_output_octl.status = cv_placeholder
               AND r_output_octl.endofprocessing >= TRUNC (SYSDATE)
               AND r_output_octl.active_flag = 1
            THEN
               DEBUG (   '070:'
                      || ' Updating needsprocessing_flag on '
                      || r_output_octl.content_type
                      || ','
                      || r_output_octl.localisation
                      || ','
                      || r_output_octl.object_id);

               UPDATE octl oc
                  SET oc.needsprocessing_flag = 1
                    , oc.derivesecondary_flag = (SELECT secondary_derivation
                                                   FROM content_types ct
                                                  WHERE ct.content_type = oc.content_type)
                WHERE ROWID = r_output_octl.octl_rowid;
            ELSE
               DEBUG (   '075:'
                      || ' NOT updating needsprocessing_flag on '
                      || r_output_octl.content_type
                      || ','
                      || r_output_octl.localisation
                      || ','
                      || r_output_octl.object_id);
            END IF;

            -- if no output dates exist then leave dates as is otherwise take max/min dates
            -- note: there will allways be output dates for generated octls
            DEBUG (   '080:'
                   || ' Running c_agg_all_dates for '
                   || r_pr.input_content_type
                   || r_pr.input_localisation
                   || r_octl.object_id);

            OPEN c_agg_all_dates (r_pr.input_content_type
                                , r_pr.input_localisation
                                , r_octl.object_id
                                , cv_date_min
                                , cv_date_max
                                 );

            FETCH c_agg_all_dates
             INTO r_agg_all_dates;

            v_t1 := r_agg_all_dates.startofprocessing;
            v_t2 := r_agg_all_dates.endofprocessing;
            DEBUG ('085:' || ' c_agg_all_dates result: ' || v_t1 || ' ' || v_t2);
            v_output_dates_exist := c_agg_all_dates%FOUND;

            CLOSE c_agg_all_dates;

            IF r_agg_all_dates.startofprocessing < v_startofprocessing
            THEN
               v_startofprocessing := r_agg_all_dates.startofprocessing;
            END IF;

            IF r_agg_all_dates.endofprocessing > v_endofprocessing
            THEN
               v_endofprocessing := r_agg_all_dates.endofprocessing;
            END IF;

            DEBUG ('090:' || ' v_startofprocessing is now ' || v_startofprocessing);
            DEBUG ('090:' || ' v_endofprocessing is now ' || v_endofprocessing);
            v_needsprocessing_flag := r_octl.needsprocessing_flag;

            OPEN c_primary_input_status (r_octl.content_type
                                       , r_octl.localisation
                                       , r_octl.object_id
                                        );

            FETCH c_primary_input_status
             INTO r_primary_input_status;

            CLOSE c_primary_input_status;

            DEBUG ('095:' || ' r_primary_input_status is: ' || r_primary_input_status);
            DEBUG ('095:' || ' v_needsprocessing_flag is now ' || v_needsprocessing_flag);

            -- If the SOP or EOP have changed on the existing OCTL for this catalog object/octl then set the needsprocessing_flag provided the input OCTL does not have status PLACEHOLDER
            IF     (   r_octl.startofprocessing != v_startofprocessing
                    OR r_octl.endofprocessing != v_endofprocessing)
               -- AND r_octl.status != cv_placeholder
               -- don't set np if primary input has status PLACEHOLDER
               AND r_primary_input_status != cv_placeholder
            THEN
               v_needsprocessing_flag := 1;
            END IF;

            DEBUG ('100:' || ' v_needsprocessing_flag is now ' || v_needsprocessing_flag);
            DEBUG (   '100:'
                   || ' Setting SOP/EOP, v_needsprocessing_flag to '
                   || v_startofprocessing
                   || ','
                   || v_endofprocessing
                   || ','
                   || v_needsprocessing_flag);

            UPDATE octl
               SET startofprocessing = v_startofprocessing
                 , endofprocessing = v_endofprocessing
                 , needsprocessing_flag = v_needsprocessing_flag
             --,status = v_status
            WHERE  ROWID = r_octl.octl_rowid;
         END IF;

         DEBUG (   '105:'
                || ' Upserting row into octl_relations: '
                || r_pr.output_content_type
                || r_pr.output_localisation
                || catalog.object_id
                || r_pr.input_content_type
                || r_pr.input_localisation
                || catalog.object_id);

         INSERT INTO octl_relations
                     (output_content_type, output_localisation, output_object_id, input_content_type
                    , input_localisation, input_object_id, issecondary, isderived)
            SELECT r_pr.output_content_type, r_pr.output_localisation, catalog.object_id, r_pr.input_content_type
                 , r_pr.input_localisation, catalog.object_id, 0, 0
              FROM DUAL
             WHERE NOT EXISTS (
                      SELECT 1
                        FROM octl_relations r
                       WHERE r.output_content_type = r_pr.output_content_type
                         AND r.output_localisation = r_pr.output_localisation
                         AND r.output_object_id = catalog.object_id
                         AND r.input_content_type = r_pr.input_content_type
                         AND r.input_localisation = r_pr.input_localisation
                         AND r.input_object_id = catalog.object_id);

         --now add any object static or object global relation.
         INSERT INTO octl
                     (content_type, localisation, object_id, needsprocessing_flag, derivesecondary_flag
                    , needsprocessing_ts, intransaction_flag, masterlastmodified_ts, lastmodified_ts, startofprocessing
                    , endofprocessing, active_flag, status, batch_number, remark, islocalized)
            SELECT cr.input_content_type, cr.input_localisation, NVL (cr.global_id, catalog.object_id)
                 , cv_needsprocessing_flag, cv_derivesecondary_flag, cv_date_min, cv_intransaction_flag, cv_date_min
                 , cv_date_min, cv_date_min, cv_date_max, cv_active_flag, cv_placeholder, cv_batch_number, cv_remark
                 , cv_islocalized
              FROM ctl_relations cr
             WHERE cr.issecondary = 1
               AND cr.output_content_type = r_pr.output_content_type
               AND cr.output_localisation = r_pr.output_localisation
               AND NOT EXISTS (
                      SELECT 1
                        FROM octl oc
                       WHERE oc.content_type = cr.input_content_type
                         AND oc.localisation = cr.input_localisation
                         AND oc.object_id = NVL (cr.global_id, catalog.object_id));

         -- add secondary relation. THIS BIT IS OK
         INSERT INTO octl_relations
                     (output_content_type, output_localisation, output_object_id, input_content_type
                    , input_localisation, input_object_id, issecondary, isderived)
            SELECT cr.output_content_type, cr.output_localisation, catalog.object_id, cr.input_content_type
                 , cr.input_localisation, NVL (cr.global_id, catalog.object_id), 1, 0
              FROM ctl_relations cr
             WHERE cr.issecondary = 1
               AND cr.output_content_type = r_pr.output_content_type
               AND cr.output_localisation = r_pr.output_localisation
               AND NOT EXISTS (
                      SELECT 1
                        FROM octl_relations ocr
                       WHERE ocr.output_content_type = cr.output_content_type
                         AND ocr.output_localisation = cr.output_localisation
                         AND ocr.output_object_id = catalog.object_id
                         AND ocr.input_content_type = cr.input_content_type
                         AND ocr.input_localisation = cr.input_localisation
                         AND ocr.input_object_id = NVL (cr.global_id, catalog.object_id));

         r_output_octl := r_octl;
      END LOOP;

      UPDATE catalog_objects ctg_objects
         SET needsprocessing_flag = -1
       WHERE ctg_objects.ROWID = catalog.ctgobjects_rowid;

      UPDATE catalog_ctl ctg_ctl
         SET needsprocessing_flag = 0
       WHERE ctg_ctl.ROWID = catalog.ctgctl_rowid;

      --if v_set_npflag_on_ctg_objects then debug ('9 true'); else debug ('9 false'); end if;

      -- v_set_npflag_on_ctg_objects will have been set to true if both the following conditions are true:
      --    1. a PMT2SPOT OCTL has had its EOP date set, and
      --    2. that date is the highest EOP date across all countries for the same object_id
      -- If both these conditions are true, set the npflag to -2.  Outside this procedure, the npflag will
      -- be set to 1, and the octl for the catalog_log of the catalogs that refer to this object will also
      -- have their npflag set to 1.
      -- This will retrigger processing of the other PMT2SPOT OCTLs for the same object_id, so that they all
      -- get the same EOP date
      IF v_set_npflag_on_ctg_objects = TRUE
      THEN
         DEBUG ('110:' || ' Updating needsprocessing_flag on other ctgobjects rows to -2');

         UPDATE catalog_objects co
            SET co.needsprocessing_flag = -2
          WHERE co.object_id = catalog.object_id
            AND co.ROWID != catalog.ctgobjects_rowid
            -- Don't set rows that are already flagged for processing as this will cause them not to be processed!
            AND co.needsprocessing_flag != 1
            AND co.sop IS NOT NULL
            AND co.eop IS NOT NULL;
      END IF;
   END LOOP;

   CLOSE c_ref_cursor;
--END;
END create_catalog_placeholders;
/
SHOW ERROR
