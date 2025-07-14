       IDENTIFICATION DIVISION.
       PROGRAM-ID. AIDKEY.
      ******************************************************************
      *   CICS RECEIVE TEST PROGRAM (PLURALSIGHT).-
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   IMPORT IBM-PROVIDED SYMBOLIC NAMES COPYBOOK.-
      ******************************************************************
       COPY DFHAID.

       01 WS-MESSAGES.
          05 WS-GREET   PIC X(46)
                VALUE 'HI! PRESS ANY ATTENTION IDENTIFIER KEY PLEASE:'.
          05 WS-KEY     PIC X(05) VALUE SPACES.
          05 WS-REPLY   PIC X(30) VALUE SPACES.

       PROCEDURE DIVISION.
           EXEC CICS SEND TEXT
                FROM (WS-GREET)
                ERASE
                END-EXEC.

           EXEC CICS RECEIVE
                LENGTH(LENGTH OF EIBAID)
                END-EXEC.

           PERFORM 1000-EVAL-KEY.

           STRING 'YOU PRESSED THE <' DELIMITED BY SIZE
                  WS-KEY              DELIMITED BY SPACE
                  '> KEY!'            DELIMITED BY SIZE
                  INTO WS-REPLY.

           EXEC CICS SEND TEXT
                FROM (WS-REPLY)
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.

       1000-EVAL-KEY.
           EVALUATE EIBAID
              WHEN DFHENTER
                 MOVE 'ENTER' TO WS-KEY
              WHEN DFHCLEAR
                 MOVE 'CLEAR' TO WS-KEY
              WHEN DFHPA1
                 MOVE 'PA1'   TO WS-KEY
              WHEN DFHPA2
                 MOVE 'PA2'   TO WS-KEY
              WHEN DFHPA3
                 MOVE 'PA3'   TO WS-KEY
              WHEN DFHPF1 THRU DFHPF9
                 STRING 'PF' EIBAID DELIMITED BY SIZE INTO WS-KEY
              WHEN DFHPF10
                 MOVE 'PF10' TO WS-KEY
              WHEN DFHPF11
                 MOVE 'PF11' TO WS-KEY
              WHEN DFHPF12
                 MOVE 'PF12' TO WS-KEY
              WHEN DFHPF13
                 MOVE 'PF13' TO WS-KEY
              WHEN DFHPF14
                 MOVE 'PF14' TO WS-KEY
              WHEN DFHPF15
                 MOVE 'PF15' TO WS-KEY
              WHEN DFHPF16
                 MOVE 'PF16' TO WS-KEY
              WHEN DFHPF17
                 MOVE 'PF17' TO WS-KEY
              WHEN DFHPF18
                 MOVE 'PF18' TO WS-KEY
              WHEN DFHPF19
                 MOVE 'PF19' TO WS-KEY
              WHEN DFHPF20
                 MOVE 'PF20' TO WS-KEY
              WHEN DFHPF21
                 MOVE 'PF21' TO WS-KEY
              WHEN DFHPF22
                 MOVE 'PF22' TO WS-KEY
              WHEN DFHPF23
                 MOVE 'PF23' TO WS-KEY
              WHEN DFHPF24
                 MOVE 'PF24' TO WS-KEY
           END-EVALUATE.

