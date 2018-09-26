PROMPT Creating Trigger 'STORE_TRG'
CREATE OR REPLACE TRIGGER STORE_TRG
 INSTEAD OF INSERT
 ON STORE_V
DECLARE




   v_found     BOOLEAN      := TRUE;
   v_xmldata   XMLTYPE      := NULL;

   CURSOR c1 (
      p_content_type   IN   VARCHAR2,
      p_localisation   IN   VARCHAR2,
      p_object_id      IN   VARCHAR2
   )
   IS
      SELECT ROWID i_rowid, needsprocessing_flag, needsprocessing_ts,
             intransaction_flag, masterlastmodified_ts, lastmodified_ts,
             startofprocessing, endofprocessing, active_flag, status, remark,
             islocalized
        FROM octl o
       WHERE o.content_type = p_content_type
         AND o.localisation = p_localisation
         AND o.object_id = p_object_id;

   r           c1%ROWTYPE;
   v_status octl.status%TYPE;
   v_needsprocessing_flag octl.needsprocessing_flag%TYPE;
BEGIN
   IF INSERTING
   THEN
--                      formInsert
      BEGIN
         OPEN c1 (:NEW.content_type, :NEW.localisation, :NEW.object_id);

         FETCH c1
          INTO r;

         v_found := c1%FOUND;

         CLOSE c1;

         IF NOT v_found
         THEN
            raise_application_error (-20000,
                                        'Store error: NOT FOUND:'
                                     || :NEW.content_type
                                     || ' '
                                     || :NEW.localisation
                                     || ' '
                                     || :NEW.object_id
                                    );
         END IF;

        -- prohibit overwriting of the deleted status by content_type processing
 /* do not implement yet as not sure how catalog status should interact with marketing_status
        IF r.status = 'Deleted'
        THEN
           v_status := r.status;
        ELSE
           v_status := NVL (:NEW.status, r.status);
        END IF;
*/
        -- prohibit lowering of needsprocessing_flag id needsprocessing_ts > process timestamp
/*
        As 2 content types do not run simutaneously this is not needed!!!!!
        v_needsprocessing_flag := NVL (:NEW.needsprocessing_flag, r.needsprocessing_flag);
        IF r.needsprocessing_ts>:NEW.lastmodified_ts and r.needsprocessing_flag != 0 and v_needsprocessing_flag = 0
        THEN
             v_needsprocessing_flag := r.needsprocessing_flag;
        END IF;
*/

         --
         UPDATE octl
            SET needsprocessing_flag =
                       NVL (:NEW.needsprocessing_flag, r.needsprocessing_flag),
                needsprocessing_ts =
                           NVL (:NEW.needsprocessing_ts, r.needsprocessing_ts),
                intransaction_flag =
                           NVL (:NEW.intransaction_flag, r.intransaction_flag),
                masterlastmodified_ts =
                     NVL (:NEW.masterlastmodified_ts, r.masterlastmodified_ts),
                lastmodified_ts =
                                 NVL (:NEW.lastmodified_ts, r.lastmodified_ts),
                startofprocessing =
                             NVL (:NEW.startofprocessing, r.startofprocessing),
                endofprocessing =
                                 NVL (:NEW.endofprocessing, r.endofprocessing),
                active_flag = NVL (:NEW.active_flag, r.active_flag),
                status =   NVL (:NEW.status, r.status),
                remark = :NEW.remark,
                batch_number = null,
                islocalized = NVL (:NEW.islocalized, r.islocalized)
          WHERE ROWID = r.i_rowid;

         --
         INSERT INTO octl_store
                     (content_type, localisation, object_id,
                      masterlastmodified_ts, lastmodified_ts, status,
                      DATA
                     )
              VALUES (:NEW.content_type, :NEW.localisation, :NEW.object_id,
                      :NEW.masterlastmodified_ts, :NEW.lastmodified_ts, :NEW.status,
                      :NEW.DATA
                     );

         --

         -- process primary to set needs processing flag for octl's that have not been deleted and sysdate < end date
         UPDATE octl oc
            SET needsprocessing_flag = 1,
                derivesecondary_flag = (select secondary_derivation from content_types ct where ct.content_type = oc.content_type),
                needsprocessing_ts = SYSDATE,
                islocalized = NVL (:NEW.islocalized, r.islocalized)
          WHERE (oc.content_type, oc.localisation, oc.object_id) IN (
                   SELECT ocr.output_content_type, ocr.output_localisation,
                          ocr.output_object_id
                     FROM octl_relations ocr
                    WHERE ocr.input_content_type = :NEW.content_type
                      AND ocr.input_localisation = :NEW.localisation
                      AND ocr.input_object_id = :NEW.object_id
                      AND ocr.issecondary = 0)
          AND oc.endofprocessing >= trunc(sysdate)
          AND oc.active_flag = 1;

         -- process secondaries that have primary data
         UPDATE octl oc
            SET needsprocessing_flag = 1,
                derivesecondary_flag = 0,
                needsprocessing_ts = SYSDATE,
                islocalized = NVL (:NEW.islocalized, r.islocalized)
          WHERE (oc.content_type, oc.localisation, oc.object_id) IN (
                   SELECT /*+ index(ocr2 ROL_OCTL_FK1I) */ ocr1.output_content_type, ocr1.output_localisation,
                          ocr1.output_object_id
                     FROM octl_relations ocr1, octl_relations ocr2, octl o
                    WHERE ocr1.input_content_type = :NEW.content_type
                      AND ocr1.input_localisation = :NEW.localisation
                      AND ocr1.input_object_id = :NEW.object_id
                      AND ocr1.issecondary = 1
                      AND ocr2.output_content_type = ocr1.output_content_type
                      AND ocr2.output_localisation = ocr1.output_localisation
                      AND ocr2.output_object_id = ocr1.output_object_id
                      AND ocr2.issecondary = 0
                      AND o.content_type = ocr2.input_content_type
                      AND o.localisation = ocr2.input_localisation
                      AND o.object_id = ocr2.input_object_id
                      AND o.status != 'PLACEHOLDER')
          AND oc.endofprocessing >= trunc(sysdate)
          AND oc.active_flag = 1;
      --
      END;
   END IF;
END;
/
SHOW ERROR






