       IDENTIFICATION DIVISION.
       PROGRAM-ID. EIBDISP.
      ******************************************************************
      *   CICS PROGRAM FOR DISPLAYING RUNTIME INFO ON SCREEN.-
      *      - READS 'EIB' (EXECUTION INTERFACE BLOCK) CICS-PROVIDED
      *        VARIABLES AND SENDS THEIR VALUES ON MAP FOR DISPLAY.
      *      - PLURALSIGHT MODULE 5, LESSON 3.-
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   COPYBOOKS:
      *      - MY SYMBOLIC MAPSET.
      *      - ATTENTION IDENTIFIER ('AID') KEYS NAMED VALUES.
      *      - BASIC MAPPING SUPPORT ('BMS') CODES NAMED VALUES.
      ******************************************************************
       COPY EIBMAPS.
       COPY DFHAID.
       COPY DFHBMSCA.

      ******************************************************************
      *   MY VARS:
      ******************************************************************
       01 WS-MY-VARS.
      *
      *   DATE HANDLING
      *
          05 WS-EIB-DATE    PIC S9(7).
          05 FILLER REDEFINES WS-EIB-DATE.
             07 FILLER      PIC 9.
             07 WS-EIB-C    PIC 9.
             07 WS-EIB-YY   PIC 99.
             07 WS-EIB-DDD  PIC 999.
          05 WS-JUL-YEAR    PIC 9(4).
          05 WS-JUL-DATE    PIC 9(7).
          05 WS-INT-DATE    PIC 9(7).
          05 WS-MAP-DATE    PIC X(10).
      *
      *   TIME HANDLING
      *
          05 WS-EIB-TIME    PIC S9(7).
          05 FILLER REDEFINES WS-EIB-TIME.
             07 FILLER      PIC 9.
             07 WS-EIB-HH   PIC 99.
             07 WS-EIB-MM   PIC 99.
             07 WS-EIB-SS   PIC 99.
          05 WS-MAP-TIME.
             07 WS-MAP-HH   PIC 99.
             07 FILLER      PIC X     VALUE ':'.
             07 WS-MAP-MM   PIC 99.
             07 FILLER      PIC X     VALUE ':'.
             07 WS-MAP-SS   PIC 99.

       PROCEDURE DIVISION.
           PERFORM UNTIL EIBAID IS EQUAL TO DFHPF3
                   PERFORM 1000-FORMAT-DATETIME
                   PERFORM 2000-LOAD-MAP

                   EXEC CICS SEND
                        MAP ('EIBMAPM')
                        MAPSET ('EIBMAPS')
                        FROM (EIBMAPMO)
                        FREEKB
                        ERASE
                        END-EXEC

                   EXEC CICS RECEIVE
                        LENGTH(LENGTH OF EIBAID)
                        END-EXEC
           END-PERFORM.

           EXEC CICS SEND
                CONTROL
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.

       1000-FORMAT-DATETIME.
           INITIALIZE WS-MY-VARS.

      *    GET CICS DATE
           MOVE EIBDATE     TO WS-EIB-DATE.

      *    GET JULIAN DATE
           COMPUTE
              WS-JUL-YEAR = 1900 + (WS-EIB-C * 100) + WS-EIB-YY
           END-COMPUTE.
           COMPUTE
              WS-JUL-DATE = (WS-JUL-YEAR * 1000) + WS-EIB-DDD
           END-COMPUTE.

      *    GET INTEGER DATE
           COMPUTE
              WS-INT-DATE = FUNCTION INTEGER-OF-DAY (WS-JUL-DATE)
           END-COMPUTE.

      *    GET FORMATTED DATE
           MOVE FUNCTION FORMATTED-DATE ('YYYY-MM-DD', WS-INT-DATE)
                TO WS-MAP-DATE.

      *    GET CICS EIB TIME
           MOVE EIBTIME     TO WS-EIB-TIME.

      *    GET FORMATTED TIME
           MOVE WS-EIB-HH   TO WS-MAP-HH.
           MOVE WS-EIB-MM   TO WS-MAP-MM.
           MOVE WS-EIB-SS   TO WS-MAP-SS.

       2000-LOAD-MAP.
           INITIALIZE EIBMAPMO.

      *    LOAD MAP WITH CICS-SUPPLIED 'EIB' VARIABLES
           MOVE WS-MAP-DATE TO EDATEO.
           MOVE WS-MAP-TIME TO ETIMEO.
           MOVE EIBTRNID    TO ETRANO.
           MOVE EIBTASKN    TO ETASKO.
           MOVE EIBTRMID    TO ETERMO.
           MOVE EIBTRNID    TO NEXTO.

      *    SET MODIFIED DATA TAG 'ON' FOR 'NEXT' FIELD'S ATTR BYTE
      *    - THIS AVOIDS POSSIBLE 'MAPFAIL' CONDITION
      *    - WE USE A NAMED VALUE FROM CICS' COPYBOOK
           MOVE DFHBMFSE    TO NEXTA.

