PROMPT Creating Function 'PIVOT'
CREATE OR REPLACE FUNCTION PIVOT
 (ISQL IN VARCHAR2
 )
 RETURN CLOB
 IS


lvar   varchar2(2000);
tmpVar varchar2(32000);

/******************************************************************************
   NAME:       pivot
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/02/2007          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     pivot1
      Sysdate:         13/02/2007
      Date and Time:   13/02/2007, 13:32:23, and 13/02/2007 13:32:23
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/

TYPE EmpCurTyp IS REF CURSOR;
emp_cv EmpCurTyp;
BEGIN

OPEN emp_cv FOR ISQL;
LOOP
FETCH emp_cv INTO lvar;
EXIT WHEN emp_cv%NOTFOUND;
if (tmpVar IS NOT NULL) then
   tmpVar := tmpVar ||','||lvar;
else
   tmpVar := lvar;
end if;
END LOOP;
CLOSE emp_cv;
    RETURN tmpVar;
   --EXCEPTION WHEN OTHERS THEN
               -- RETURN p1||' '||LENGTH(tmpVar);

END pivot;
/
SHOW ERROR

