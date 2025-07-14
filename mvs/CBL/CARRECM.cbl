       IDENTIFICATION DIVISION.
       PROGRAM-ID. CARRECM.
      ******************************************************************
      *   CONVERT DATASTREAM TO BMS MAP.-
      *   (PLURALSIGHT CICS COURSE MODULE 4 LESSONS 7-9)
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   IMPORT SYMBOLIC MAP SET DEFINITION.-
      ******************************************************************
       COPY CARRECS.

       PROCEDURE DIVISION.
           INITIALIZE CARRECMO.

           EXEC CICS SEND
                MAP ('CARRECM')
                MAPSET ('CARRECS')
                FROM (CARRECMO)
                FREEKB
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.
