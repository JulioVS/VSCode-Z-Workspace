       IDENTIFICATION DIVISION.
       PROGRAM-ID. ESONP.
      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYEE APP'
      *      - 'SIGN ON' PROGRAM
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   INCLUDE COPYBOOKS FOR:
      *      - APPLICATION CONSTANTS.
      *      - SIGN-ON MAP.
      *      - REGISTERED USERS.
      *      - IBM'S AID KEYS.
      ******************************************************************
       COPY ECONST.
       COPY ESONMAP.
       COPY EREGUSR.
       COPY EMONCTR.
       COPY DFHAID.
      ******************************************************************
      *   DEFINE MY SESSION STATE DATA FOR PASSING INTO COMM-AREA.
      ******************************************************************
       01 WS-SESSION-STATE.
          05 WS-USER-ID           PIC X(8).
          05 WS-USER-PASSWORD     PIC X(8).
      ******************************************************************
      *   DEFINE MY WORKING VARIABLES.
      ******************************************************************
       01 WS-WORKING-VARS.
          05 WS-CICS-RESPONSE     PIC S9(8) USAGE IS BINARY.
          05 WS-CURRENT-DATE      PIC X(14).
      *
          05 WS-USER-LOOKUP       PIC X(1)  VALUE SPACE.
             88 WS-USER-FOUND               VALUE 'Y'.
          05 WS-LOGIN-OUTCOME     PIC X(1)  VALUE SPACE.
             88 WS-LOGIN-SUCCESS            VALUE 'Y'.
      *
          05 WS-DEBUG-MODE        PIC X(1)  VALUE 'Y'.
             88 I-AM-DEBUGGING              VALUE 'Y'.
             88 NOT-DEBUGGING               VALUE 'N'.
      ******************************************************************
      *   EXPLICITLY DEFINE THE COMM-AREA FOR THE TRASACTION.
      ******************************************************************
       LINKAGE SECTION.
       01 DFHCOMMAREA             PIC X(16).

       PROCEDURE DIVISION.
      *-----------------------------------------------------------------
       MAIN-LOGIC SECTION.
      *-----------------------------------------------------------------

           IF EIBCALEN IS EQUAL TO ZERO THEN
              PERFORM 1000-FIRST-INTERACTION
           ELSE
              PERFORM 2000-PROCESS-USER-INPUT
           END-IF.

      *-----------------------------------------------------------------
       START-UP SECTION.
      *-----------------------------------------------------------------

       1000-FIRST-INTERACTION.
      *    THIS IS THE START OF THE (PSEUDO) CONVERSATION,
      *    MEANING THE FIRST INTERACTION OF THE PROCESS,
      *    HENCE THE EMPTY COMM-AREA.-
           PERFORM 1100-INITIALIZE.
           PERFORM 9200-SEND-MAP-AND-RETURN.

       1100-INITIALIZE.
      *    INITIALIZE SESSION STATE, MAP OUPUT, WORK VARS AND CONTAINER
           INITIALIZE WS-SESSION-STATE.
           INITIALIZE WS-WORKING-VARS.
           INITIALIZE ESONMO.
           INITIALIZE ACTIVITY-MONITOR-CONTAINER.

      *    FOR THE FIRST INTERACTION, IT SENDS THE EMPY MAP WITH
      *    JUST THE TRANSACTION ID ON IT (AN ECHO OF A KNOWN VALUE)
           MOVE EIBTRNID TO TRANIDO.

      *-----------------------------------------------------------------
       USE-CASE SECTION.
      *-----------------------------------------------------------------

       2000-PROCESS-USER-INPUT.
      *    THIS IS THE CONTINUATION OF THE CONVERSATION,
      *    MEANING THE SECOND INTERACTION OF THE PROCESS,
      *    HENCE THE COMM-AREA IS NOT EMPTY.

      *    RESTORE SESSION DATA INTO WORKING STORAGE
           MOVE DFHCOMMAREA TO WS-SESSION-STATE.

      *    GET NEW INPUT FROM THE USER
           EXEC CICS RECEIVE
                MAP(AC-SIGNON-MAP-NAME)
                MAPSET(AC-SIGNON-MAPSET-NAME)
                INTO (ESONMI)
                END-EXEC.

      *    AND CHECK PRESSED KEY
           EVALUATE EIBAID
           WHEN DFHPF3
           WHEN DFHPF12
                PERFORM 2100-CANCEL-SIGN-ON
           WHEN DFHENTER
                PERFORM 3000-SIGN-ON-USER
           WHEN OTHER
                MOVE "Invalid Key!" TO MESSO
           END-EVALUATE.

           PERFORM 9200-SEND-MAP-AND-RETURN.

       2100-CANCEL-SIGN-ON.
      *    CLEAR USER SCREEN AND END CONVERSATION
           EXEC CICS SEND CONTROL
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.

       3000-SIGN-ON-USER.
           PERFORM 3100-UPDATE-STATE.
           PERFORM 3200-LOOKUP-USER-ID.

           IF WS-USER-FOUND THEN
              PERFORM 3300-CHECK-USER-STATUS
              PERFORM 3400-CHECK-USER-CREDENTIALS
           ELSE
              EXIT
           END-IF.

           IF WS-LOGIN-SUCCESS THEN
              PERFORM 3500-NOTIFY-ACTIVITY-MONITOR
              PERFORM 9100-TRANSFER-TO-LANDING-PAGE
           END-IF.

       3100-UPDATE-STATE.
      *    IF NEW DATA WAS RECEIVED, UPDATE STATE
           IF USERIDI IS NOT EQUAL TO LOW-VALUES AND
              USERIDI IS NOT EQUAL TO SPACES THEN
              MOVE USERIDI TO WS-USER-ID
           END-IF.
           IF PASSWDI IS NOT EQUAL TO LOW-VALUES AND
              PASSWDI IS NOT EQUAL TO SPACES THEN
              MOVE PASSWDI TO WS-USER-PASSWORD
           END-IF.

       3200-LOOKUP-USER-ID.
      *    LOOKUP THE USER ID IN VSAM FILE
           EXEC CICS READ
                FILE(AC-REG-USER-FILE-NAME)
                INTO (REGISTERED-USER-RECORD)
                RIDFLD(WS-USER-ID)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                SET WS-USER-FOUND TO TRUE
                MOVE "User Found!" TO MESSO
           WHEN DFHRESP(NOTFND)
                MOVE "User Not Found!" TO MESSO
           WHEN OTHER
                MOVE "Error Reading Users File!" TO MESSO
           END-EVALUATE.

       3300-CHECK-USER-STATUS.
      *    CALL ACTIVITY MONITOR PROGRAM WITH "SIGN-ON" ACTION.
           SET MON-AC-SIGN-ON TO TRUE.
           PERFORM 3310-CALL-ACTIVITY-MONITOR.
           PERFORM 3320-EVALUATE-RESPONSE.

       3310-CALL-ACTIVITY-MONITOR.
      *    PUT CONTAINER AND LINK TO ACTIVITY MONITOR PROGRAM
           MOVE AC-SIGNON-PROGRAM-NAME TO MON-LINKING-PROGRAM.
           MOVE WS-USER-ID TO MON-USER-ID.

           PERFORM 3315-PUT-CONTAINER.

      *    'LINK' CALLS THE PROGRAM AND *RETURNS* AFTER ITS EXECUTION.
           EXEC CICS LINK
                PROGRAM(AC-ACTMON-PROGRAM-NAME)
                CHANNEL(AC-ACTMON-CHANNEL-NAME)
                TRANSID(EIBTRNID)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                MOVE "Error Linking To Activity Monitor!" TO MESSO
           END-EVALUATE.

       3315-PUT-CONTAINER.
           EXEC CICS PUT
                CONTAINER(AC-ACTMON-CONTAINER-NAME)
                CHANNEL(AC-ACTMON-CHANNEL-NAME)
                FROM (ACTIVITY-MONITOR-CONTAINER)
                FLENGTH(LENGTH OF ACTIVITY-MONITOR-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                MOVE "Error Writing Activity Monitor!" TO MESSO
           END-EVALUATE.

       3320-EVALUATE-RESPONSE.
      *    GET THE RESPONSE FROM THE ACTIVITY MONITOR PROGRAM
           EXEC CICS GET
                CONTAINER(AC-ACTMON-CONTAINER-NAME)
                CHANNEL(AC-ACTMON-CHANNEL-NAME)
                INTO (ACTIVITY-MONITOR-CONTAINER)
                FLENGTH(LENGTH OF ACTIVITY-MONITOR-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                MOVE "Error Reading Activity Monitor!" TO MESSO
                EXIT
           END-EVALUATE.

      *    RELAY ACTIVITY MONITOR RESPONSE MESSAGE TO USER TERMINAL
           MOVE MON-MESSAGE TO MESSO.

      *    >>> DEBUGGING ONLY <<<
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    SEE IF IT RESULTED IN SUCCESS, FAIL, NEUTRAL OR ERROR.
           EVALUATE TRUE
           WHEN MON-PROCESSING-ERROR
           WHEN MON-ST-LOCKED-OUT
      *         ON LOCKOUT OR ERROR, SEND BACK TO THE START
                PERFORM 9200-SEND-MAP-AND-RETURN
           WHEN MON-ST-SIGNED-ON
      *         ON SUCCESSFUL SIGN-ON, SEND TO INITIAL APP SCREEN
                PERFORM 9100-TRANSFER-TO-LANDING-PAGE
           WHEN MON-ST-IN-PROCESS
           WHEN MON-ST-NOT-SET
      *         ON NEUTRAL, CONTINUE TO CHECK USER CREDENTIALS
                CONTINUE
           WHEN OTHER
                MOVE "Unknown Response From Activity Monitor!" TO MESSO
           END-EVALUATE.

       3400-CHECK-USER-CREDENTIALS.
           MOVE FUNCTION CURRENT-DATE(1:14) TO WS-CURRENT-DATE.

      *    CHECK IF THE USER ID AND PASSWORD MATCH.
           IF WS-USER-PASSWORD IS EQUAL TO RU-USER-PASSWORD THEN
      *       CHECK IF THE USER ID IS ACTIVE.
              IF RU-ST-ACTIVE THEN
      *          CHECK IF THE USER ID VALIDITY PERIOD HAS STARTED.
                 IF WS-CURRENT-DATE >= RU-LAST-EFFECTIVE-DATE THEN
      *             ALL CONDITIONS MET
      *             SUCCESFUL SIGN ON!
                    SET WS-LOGIN-SUCCESS TO TRUE
                    MOVE "User Is Active!" TO MESSO
                 ELSE
                    MOVE "User Is Not Yet Active!" TO MESSO
                 END-IF
              ELSE
                 MOVE "User Is Inactive!" TO MESSO
              END-IF
           ELSE
              MOVE "Invalid Password!" TO MESSO
           END-IF.

       3500-NOTIFY-ACTIVITY-MONITOR.
      *    NOTIFY ACTIVITY MONITOR OF A SUCCESSFUL SIGN-ON!
      *    (ONE-WAY OPERATION, NO RESPONSE EXPECTED)
           SET MON-AC-NOTIFY TO TRUE.
           PERFORM 3310-CALL-ACTIVITY-MONITOR.

      *-----------------------------------------------------------------
       EXIT-ROUTE SECTION.
      *-----------------------------------------------------------------

       9100-TRANSFER-TO-LANDING-PAGE.
      *    PUT CONTAINER AND TRANSFER CONTROL TO INITIAL PROGRAM
      *    OF THE EMPLOYEE APP!
           PERFORM 3315-PUT-CONTAINER.

      *    'XCTL' CALLS THE PROGRAM BUT DOES *NOT* RETURN AFTERWARDS!
           EXEC CICS XCTL
                PROGRAM(AC-LANDING-PROGRAM-NAME)
                CHANNEL(AC-ACTMON-CHANNEL-NAME)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                MOVE "Error Linking To Landing Page!" TO MESSO
                PERFORM 9200-SEND-MAP-AND-RETURN
           END-EVALUATE.

       9200-SEND-MAP-AND-RETURN.
      *    PRESENT INITIAL SIGN-ON SCREEN TO THE USER.
           EXEC CICS SEND
                MAP(AC-SIGNON-MAP-NAME)
                MAPSET(AC-SIGNON-MAPSET-NAME)
                FROM (ESONMO)
                ERASE
                END-EXEC.

      *    THEN IT RETURNS SAVING THE INITIAL STATE
      *    AND ENDING THIS STEP OF THE CONVERSATION.
           EXEC CICS RETURN
                COMMAREA(WS-SESSION-STATE)
                TRANSID(EIBTRNID)
                END-EXEC.

       9300-DEBUG-AID.
      *    >>> DEBUGGING ONLY <<<
           IF I-AM-DEBUGGING THEN
              EXEC CICS SEND TEXT
                   FROM (ACTIVITY-MONITOR-CONTAINER)
                   END-EXEC
              EXEC CICS RECEIVE
                   LENGTH(LENGTH OF EIBAID)
                   END-EXEC
              MOVE MON-MESSAGE(32:48) TO MESSO
           END-IF.
      *    >>> -------------- <<<
