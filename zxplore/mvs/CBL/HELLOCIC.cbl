       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLOCIC.
      ******************************************************************
      *   SIMPLE 'HELLO WORLD!' FOR CICS.-
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-MESSAGE.
          05 WS-TEXT  PIC X(22) VALUE 'HELLO WORLD FROM CICS!'.

       PROCEDURE DIVISION.
           EXEC CICS SEND TEXT
                FROM (WS-TEXT)
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.
