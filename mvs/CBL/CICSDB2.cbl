      *------------------------
       IDENTIFICATION DIVISION.
      *------------------------
       PROGRAM-ID. CICSDB2.
       AUTHOR. JULIO ERRECART.

      *---------------------
       DATA DIVISION.
      *---------------------
       WORKING-STORAGE SECTION.

       01 WS-MSG  PIC X(75) VALUE 'INITIAL MESSAGE'.

      *----------------------------------------------------
      * SQL INCLUDE FOR SQLCA                             *
      *----------------------------------------------------
           EXEC SQL
              INCLUDE SQLCA
           END-EXEC.
      *----------------------------------------------------
      * SQL DECLARATION FOR IBM'S EMP TABLE               *
      *----------------------------------------------------
           EXEC SQL
              INCLUDE EMP
           END-EXEC.
      *----------------------------------------------------
      * SQL CURSORS                                       *
      *----------------------------------------------------
           EXEC SQL
              DECLARE CUR1 CURSOR FOR
                 SELECT * FROM IBMUSER.EMP
           END-EXEC.

      *-------------------
       PROCEDURE DIVISION.
      *-------------------
      *-------------------
      * DB2 CALLS
      *-------------------

           EXEC SQL
              OPEN CUR1
           END-EXEC.

           EXEC SQL
              FETCH CUR1 INTO :DCLEMP
           END-EXEC.

           EXEC SQL
              CLOSE CUR1
           END-EXEC.

           STRING "FIRST EMPLOYEE'S NAME IS: "
                  FIRSTNME-TEXT(1:FIRSTNME-LEN)
                  " "
                  LASTNAME-TEXT(1:LASTNAME-LEN)
                  "!"
              DELIMITED BY SIZE
              INTO WS-MSG
           END-STRING.

      *-------------------
      * CICS CALLS
      *-------------------

           EXEC CICS SEND TEXT
                FROM (WS-MSG)
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.
