      ******************************************************************
      *   MY USER DEFINED FUNCTION (UDF).-
      ******************************************************************
       IDENTIFICATION DIVISION.
       FUNCTION-ID. ADDTWOF.

       DATA DIVISION.
       LINKAGE SECTION.
       01 LK-A            PIC S9(9) COMP-5.
       01 LK-B            PIC S9(9) COMP-5.
       01 LK-RESULT       PIC S9(9) COMP-5.

       PROCEDURE DIVISION USING BY VALUE LK-A LK-B
           RETURNING LK-RESULT.
           COMPUTE LK-RESULT = LK-A + LK-B
           GOBACK.
       END FUNCTION ADDTWOF.

      ******************************************************************
      *   SIMPLE CICS PROGRAM THAT USES MY FUNCTION.-
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CICSUDF.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-MESSAGE      PIC X(50) VALUE SPACES.
       01 WS-RESULT       PIC S9(9) COMP-5.
       01 WS-RESULT-DISP  PIC 9(9).

       PROCEDURE DIVISION.

           COMPUTE WS-RESULT =
              FUNCTION ADDTWOF(DFHEIBLK DFHCOMMAREA 10 25).

           MOVE WS-RESULT TO WS-RESULT-DISP.
           STRING 'RESULT = ' WS-RESULT-DISP DELIMITED BY SIZE
              INTO WS-MESSAGE.

           EXEC CICS SEND TEXT
                FROM (WS-MESSAGE)
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.

       END PROGRAM CICSUDF.
