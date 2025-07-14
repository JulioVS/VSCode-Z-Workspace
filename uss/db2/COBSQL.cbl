      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBSQL.
       AUTHOR. Julio Errecart.
      *****************************************************************
       ENVIRONMENT DIVISION.
      *****************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *
       EXEC SQL INCLUDE SQLCA END-EXEC.
      *
       01 RESULT PIC S99999 COMP-3.
      *****************************************************************
       PROCEDURE DIVISION.
       MAIN-PARA.
           CALL 'ZXPDSN'.

           EXEC SQL
              SELECT COUNT(*) INTO :RESULT
              FROM SYSIBM.SYSTABLES
           END-EXEC.
           
           DISPLAY RESULT.
           STOP RUN.
