      *------------------------
       IDENTIFICATION DIVISION.
      *------------------------
       PROGRAM-ID. CICSCOB.
      *---------------------
       ENVIRONMENT DIVISION.
      *---------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 MSGTXT  PIC X(12) VALUE "HELLO WORLD!".
      *  01 MSGLEN  PIC 9(3).
       01 MSGLEN  PIC S9(4) USAGE IS BINARY.

      ******************************************************************
      *  'AEIV' ABEND FIX
      *  ----------------
      *
      *  THE LENGTH PARAMETER HAS TO BE SPECIFIED ON A HALF-WORD BINARY
      *  FIELD. THE LENGTH OF THE STRING IS NOT AUTOMATICALLY CALCULATED
      *  BY CICS.
      *
      *  HALF-WORD = 2 INTERNAL BYTES (A.K.A. 64 KB ADDRESSING)
      *  BINARY    = USAGE IS BINARY / COMP / COMP-4 / COMPUTATIONAL
      *
      *  SOURCE:
      *    https://www.ibm.com/docs/en/cics-ts/6.x?
      *       topic=summary-send-zos-communications-server-default
      *
      ******************************************************************

      *-------------------
       PROCEDURE DIVISION.
      *-------------------
           MOVE LENGTH OF MSGTXT TO MSGLEN.

           EXEC CICS SEND
                FROM(MSGTXT) LENGTH(MSGLEN)
                ERASE
           END-EXEC.

           EXEC CICS RETURN
           END-EXEC.
      *
