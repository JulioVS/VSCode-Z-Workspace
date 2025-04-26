      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHALL3.
       AUTHOR. Julio Errecart.
      *****************************************************************
       ENVIRONMENT DIVISION.
      *****************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *
       EXEC SQL INCLUDE SQLCA END-EXEC.
      *
       01  RESULT.
           10 SITE     PIC X(25).
           10 VOUCHER  PIC X(25).
      *****************************************************************
       PROCEDURE DIVISION.
       MAIN-PARA.
           CALL 'ZXPDSN'.

           EXEC SQL
              SET ENCRYPTION PASSWORD = "TelumZ"
           END-EXEC.
           
           EXEC SQL
              SELECT SITE, DECRYPT_CHAR(CODE) AS VOUCHER INTO :RESULT   
              FROM IBMUSER.ZECRETS
           END-EXEC.
           
           DISPLAY RESULT.
           STOP RUN.
