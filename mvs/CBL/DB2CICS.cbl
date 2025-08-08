      *------------------------
       IDENTIFICATION DIVISION.
      *------------------------
       PROGRAM-ID. DB2CICS.
       AUTHOR. JULIO ERRECART.

      *---------------------
       DATA DIVISION.
      *---------------------
       WORKING-STORAGE SECTION.

       01 WS-MSG  PIC X(75) VALUE 'HELLO WORLD FROM CICS!'.

      *----------------------------------------------------
      * SQL INCLUDE FOR SQLCA                             *
      *----------------------------------------------------
           EXEC SQL
              INCLUDE SQLCA
           END-EXEC.
      *----------------------------------------------------
      * SQL DECLARATION FOR EMPLOYEE TABLE                *
      *----------------------------------------------------
           EXEC SQL
              INCLUDE EMPLOYEE
           END-EXEC.
      *----------------------------------------------------
      * SQL CURSORS                                       *
      *----------------------------------------------------
           EXEC SQL
              DECLARE CUR1 CURSOR FOR
                 SELECT * FROM Z45864.EMPLOYEE
           END-EXEC.

      *-------------------
       PROCEDURE DIVISION.
      *-------------------
      *-------------------
       DB2-CODE SECTION.
      *-------------------

           EXEC SQL
              OPEN CUR1
           END-EXEC.

           EXEC SQL
              FETCH CUR1 INTO :DCLEMPLOYEE
           END-EXEC.

           EXEC SQL
              CLOSE CUR1
           END-EXEC.

           STRING "FIRST EMPLOYEE'S NAME IS: "
                  FIRST-NAME
                  " "
                  LAST-NAME
                  "."
              DELIMITED BY SIZE
              INTO WS-MSG
           END-STRING.

      *-------------------
       CICS-CODE SECTION.
      *-------------------

           EXEC CICS SEND TEXT
                FROM (WS-MSG)
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.
