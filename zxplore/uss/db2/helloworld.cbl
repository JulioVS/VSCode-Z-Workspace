      * Program name: HELLOCOB
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLOCOB.
       AUTHOR. Julio Errecart.
      *****************************************************************
       ENVIRONMENT DIVISION.
      *****************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-HELLO PIC X(12).
      *****************************************************************
       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE "Hello world!" TO WS-HELLO.
           DISPLAY WS-HELLO.
           STOP RUN.
