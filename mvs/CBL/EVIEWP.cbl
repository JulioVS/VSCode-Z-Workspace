       IDENTIFICATION DIVISION.
       PROGRAM-ID. EVIEWP.
      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYEE APP'.
      *      - 'VIEW EMPLOYEE DETAILS' PROGRAM.
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   INCLUDE COPYBOOKS FOR:
      *      - APPLICATION CONSTANTS.
      *      - EMPLOYEE DETAILS MAPSET.
      *      - EMPLOYEE DETAILS CONTAINER.
      *      - EMPLOYEE MASTER RECORD.
      *      - LIST CONTAINER.
      *      - ACTIVITY MONITOR CONTAINER.
      *      - REGISTERED USERS.
      *      - IBM'S AID KEYS.
      *      - IBM'S BMS VALUES.
      ******************************************************************
       COPY ECONST.
       COPY EDETMAP.
       COPY EDETCTR.
       COPY EMPMAST.
       COPY ELSTCTR.
       COPY EMONCTR.
       COPY EREGUSR.
       COPY DFHAID.
       COPY DFHBMSCA.
      ******************************************************************
      *   DEFINE MY WORKING VARIABLES.
      ******************************************************************
       01 WS-WORKING-VARS.
          05 WS-CICS-RESPONSE       PIC S9(8) USAGE IS BINARY.
          05 WS-EMPLOYEE-ID         PIC X(8) JUSTIFIED RIGHT.
          05 WS-INSP-COUNTER        PIC S9(2) USAGE IS BINARY.
          05 WS-DEPT-KEY            PIC X(8).
      *
       01 WS-DISPLAY-MESSAGES.
          05 WS-MESSAGE             PIC X(79) VALUE SPACES.
      *
       01 WS-DATE-FORMATTING.
          05 WS-INPUT-DATE.
             10 WS-YYYY             PIC X(4)  VALUE SPACES.
             10 WS-MM               PIC X(2)  VALUE SPACES.
             10 WS-DD               PIC X(2)  VALUE SPACES.
          05 WS-OUTPUT-DATE.
             10 WS-DD               PIC X(2)  VALUE SPACES.
             10 FILLER              PIC X(1)  VALUE '-'.
             10 WS-MM               PIC X(2)  VALUE SPACES.
             10 FILLER              PIC X(1)  VALUE '-'.
             10 WS-YYYY             PIC X(4)  VALUE SPACES.
      *
       01 WS-FILTER-FLAGS.
          03 WS-FILTERS-CHECK       PIC X(1)  VALUE SPACES.
             88 FILTERS-PASSED                VALUE 'Y'.
             88 FILTERS-FAILED                VALUE 'N'.
          03 WS-KEY-FILTER-CHECK    PIC X(1)  VALUE SPACES.
             88 KEY-FILTER-PASSED             VALUE 'Y'.
          03 WS-DEPT-FILTER-CHECK   PIC X(1)  VALUE SPACES.
             88 DEPT-FILTER-PASSED            VALUE 'Y'.
             88 DEPT-FILTER-FAILED            VALUE 'N'.
          03 WS-DATE-FILTER-CHECK   PIC X(1)  VALUE SPACES.
             88 DATE-FILTER-PASSED            VALUE 'Y'.
      *
       01 WS-DEBUG-AID              PIC X(45) VALUE SPACES.
      *
       01 WS-DEBUG-MESSAGE.
          05 FILLER                 PIC X(5)  VALUE '<MSG:'.
          05 WS-DEBUG-TEXT          PIC X(45) VALUE SPACES.
          05 FILLER                 PIC X(1)  VALUE '>'.
          05 FILLER                 PIC X(5)  VALUE '<EB1='.
          05 WS-DEBUG-EIBRESP       PIC 9(8)  VALUE ZEROES.
          05 FILLER                 PIC X(1)  VALUE '>'.
          05 FILLER                 PIC X(5)  VALUE '<EB2='.
          05 WS-DEBUG-EIBRESP2      PIC 9(8)  VALUE ZEROES.
          05 FILLER                 PIC X(1)  VALUE '>'.
      *
       01 WS-DEBUG-MODE             PIC X(1)  VALUE 'N'.
          88 I-AM-DEBUGGING                   VALUE 'Y'.
          88 NOT-DEBUGGING                    VALUE 'N'.

       PROCEDURE DIVISION.
      *-----------------------------------------------------------------
       MAIN-LOGIC SECTION.
      *-----------------------------------------------------------------

      *    >>> DEBUGGING ONLY <<<
           MOVE 'MAIN-LOGIC' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    PSEUDO-CONVERSATIONAL PROGRAM DESIGN.

      *    START BY GETTING THE 'VIEW' (DETAIL) CONTAINER:
      *
      *    - IF IT DOES NOT YET EXIST -> 1ST STEP IN CONVERSATION
      *    - IF IT DOES ALREADY EXIST -> CONVERSATION IN PROGRESS

           EXEC CICS GET
                CONTAINER(APP-VIEW-CONTAINER-NAME)
                CHANNEL(APP-VIEW-CHANNEL-NAME)
                INTO (EMPLOYEE-DETAILS-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(CHANNELERR)
           WHEN DFHRESP(CONTAINERERR)
      *         1ST INTERACTION -> NO CONTAINER YET (CREATE IT)
                PERFORM 1000-FIRST-INTERACTION
           WHEN DFHRESP(NORMAL)
      *         NEXT INTERACTIONS -> CONTAINER FOUND (CONTINUE)
                IF DET-SAVING-PROGRAM EQUAL TO APP-VIEW-PROGRAM-NAME
                   PERFORM 2000-PROCESS-USER-INPUT
                   EXIT
                END-IF
      *         IF BOUNCING BACK FROM 'UPDATE', RESTART CONVERSATION
                IF DET-SAVING-PROGRAM EQUAL TO APP-UPDATE-PROGRAM-NAME
                   PERFORM 5000-RE-ENTRY-FROM-UPDATE
                END-IF
           WHEN OTHER
                MOVE 'Error Retrieving View Container!' TO WS-MESSAGE
           END-EVALUATE.

           PERFORM 9000-SEND-MAP-AND-RETURN.

      *-----------------------------------------------------------------
       START-UP SECTION.
      *-----------------------------------------------------------------

       1000-FIRST-INTERACTION.
      *    >>> DEBUGGING ONLY <<<
           MOVE '1000-FIRST-INTERACTION' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           PERFORM 1100-INITIALIZE-VARIABLES.
           PERFORM 1200-INITIALIZE-CONTAINER.

      *    >>> CALL ACTIVITY MONITOR <<<
           PERFORM 4000-CHECK-USER-STATUS.
      *    >>> --------------------- <<<

      *    IF WE HAVE A LOGGED-IN USER:
      *      - SAVE HIS DATA ON THE APPLICATION CONTAINER.
      *      - FIND HIS OWN 'EMPLOYEE ID'.
           IF MON-USER-ID IS NOT EQUAL TO SPACES THEN
              MOVE MON-USER-ID TO DET-USER-ID REG-USER-ID
              MOVE MON-USER-CATEGORY TO DET-USER-CATEGORY

              PERFORM 1600-LOOKUP-USER-ID
           END-IF.

      *    CHECK IF WE ARE COMING FROM THE 'LIST EMPLOYEES' VIEW AND
      *    IF SO, RETRIEVE THE SELECTED RECORD FOR DISPLAY.
           IF EIBTRNID IS EQUAL TO APP-LIST-TRANSACTION-ID THEN
              PERFORM 3000-GET-LIST-CONTAINER
              IF DET-EMPLOYEE-RECORD IS NOT EQUAL TO SPACES THEN
                 EXIT PARAGRAPH
              END-IF
           END-IF.

      *    IF NOT, JUST READ THE FIRST EMPLOYEE RECORD.
           PERFORM 1300-READ-EMPLOYEE-BY-KEY.

       1100-INITIALIZE-VARIABLES.
      *    >>> DEBUGGING ONLY <<<
           MOVE '1100-INITIALIZE-VARIABLES' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    CLEAR ALL RECORDS AND VARIABLES.
           INITIALIZE ACTIVITY-MONITOR-CONTAINER.
           INITIALIZE EMPLOYEE-DETAILS-CONTAINER.
           INITIALIZE LIST-EMPLOYEE-CONTAINER.
           INITIALIZE EMPLOYEE-MASTER-RECORD.
           INITIALIZE REGISTERED-USER-RECORD.
           INITIALIZE WS-WORKING-VARS.

       1200-INITIALIZE-CONTAINER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '1200-INITIALIZE-CONTAINER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    SET INITIAL VALUES FOR 'DETAILS' CONTAINER.
           MOVE 'ANONYMUS' TO DET-USER-ID.
           MOVE 'STD' TO DET-USER-CATEGORY.
           MOVE '1' TO DET-SELECT-KEY-TYPE.
           MOVE LOW-VALUE TO DET-SELECT-KEY-VALUE.
           MOVE APP-VIEW-PROGRAM-NAME TO DET-SAVING-PROGRAM.

      *    GET CALLING PROGRAM NAME FROM ITS TRANSACTION ID WHILE IT'S
      *    STILL AVAILABLE IN THE EXECUTION INTERFACE BLOCK.
      *
      *    WE WILL USE THIS TO RETURN TO THE CALLING PROGRAM WHEN
      *    THE USER EXISTS OR CANCELS THE VIEW.
      *
      *    AS OF NOW, IT WILL EITHER BE 'ELISTP' (LIST EMPLOYEES) OR
      *    'EMENUP' (MAIN MENU).-

           EXEC CICS INQUIRE
                TRANSACTION(EIBTRNID)
                PROGRAM(DET-CALLING-PROGRAM)
                END-EXEC.

      *    >>> ---IMPORTANT!--- <<<
      *    THE USE OF 'CICS INQUIRE' REQUIRED ADDING THE 'SP' OPTION
      *    IN THE TRANSLATOR OPTIONS OF THE COMPILING JCL!
      *    >>> ---------------- <<<

       1300-READ-EMPLOYEE-BY-KEY.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '1300-READ-EMPLOYEE-BY-KEY (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '1300-READ-EMPLOYEE-BY-KEY (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    READ EMPLOYEE MASTER FILE RECORD INTO CONTAINER.
           PERFORM 1310-START-BROWSING.

      *    >>> DEBUGGING ONLY <<<
           IF I-AM-DEBUGGING AND DET-SEL-BY-EMPLOYEE-ID AND
              EMP-EMPLOYEE-ID IS GREATER THAN 3 THEN
              SET DET-END-OF-FILE TO TRUE
           END-IF.
           IF I-AM-DEBUGGING AND DET-SEL-BY-EMPLOYEE-NAME AND
              EMP-PRIMARY-NAME(1:1) IS GREATER THAN 'A' THEN
              SET DET-END-OF-FILE TO TRUE
           END-IF.
      *    >>> -------------- <<<

           PERFORM 1320-READ-NEXT-RECORD
              UNTIL FILTERS-PASSED OR DET-END-OF-FILE.

           IF FILTERS-PASSED THEN
              MOVE EMPLOYEE-MASTER-RECORD TO DET-EMPLOYEE-RECORD
           END-IF.

           IF NOT DET-END-OF-FILE THEN
              PERFORM 1330-END-BROWSING
           END-IF.

       1310-START-BROWSING.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '1310-START-BROWSING (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '1310-START-BROWSING (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           IF DET-SEL-BY-EMPLOYEE-ID THEN
              EXEC CICS STARTBR
                   FILE(APP-EMP-MASTER-FILE-NAME)
                   RIDFLD(EMP-EMPLOYEE-ID)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           ELSE
              EXEC CICS STARTBR
                   FILE(APP-EMP-MASTER-PATH-NAME)
                   RIDFLD(EMP-PRIMARY-NAME)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           END-IF.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN DFHRESP(NOTFND)
                MOVE 'No Records Found!' TO WS-MESSAGE
                SET DET-END-OF-FILE TO TRUE
           WHEN DFHRESP(INVREQ)
                MOVE 'Invalid Request (Browse)!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           WHEN DFHRESP(NOTOPEN)
                MOVE 'Employee Master File Not Open!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           WHEN OTHER
                MOVE 'Error Starting Browse!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           END-EVALUATE.

       1320-READ-NEXT-RECORD.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '1320-READ-NEXT-RECORD (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '1320-READ-NEXT-RECORD (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           IF DET-SEL-BY-EMPLOYEE-ID THEN
              EXEC CICS READNEXT
                   FILE(APP-EMP-MASTER-FILE-NAME)
                   RIDFLD(EMP-EMPLOYEE-ID)
                   INTO (EMPLOYEE-MASTER-RECORD)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           ELSE
              EXEC CICS READNEXT
                   FILE(APP-EMP-MASTER-PATH-NAME)
                   RIDFLD(EMP-PRIMARY-NAME)
                   INTO (EMPLOYEE-MASTER-RECORD)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           END-IF.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                PERFORM 3200-APPLY-FILTERS
                PERFORM 3700-CHECK-DELETION
           WHEN DFHRESP(NOTFND)
                MOVE 'No Records Found!' TO WS-MESSAGE
                SET DET-END-OF-FILE TO TRUE
           WHEN DFHRESP(ENDFILE)
                MOVE 'End of Employee Master File' TO WS-MESSAGE
                SET DET-END-OF-FILE TO TRUE
           WHEN OTHER
                MOVE 'Error Reading Employee Record!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           END-EVALUATE.

       1330-END-BROWSING.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '1330-END-BROWSING (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '1330-END-BROWSING (NM)' TO WS-DEBUG-AID
           END-IF
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           IF DET-SEL-BY-EMPLOYEE-ID THEN
              EXEC CICS ENDBR
                   FILE(APP-EMP-MASTER-FILE-NAME)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           ELSE
              EXEC CICS ENDBR
                   FILE(APP-EMP-MASTER-PATH-NAME)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           END-IF.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                MOVE 'Error Ending Browse!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           END-EVALUATE.

       1400-READ-BACKWARDS-BY-KEY.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '1400-READ-BACKWARDS-BY-KEY (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '1400-READ-BACKWARDS-BY-KEY (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           PERFORM 1310-START-BROWSING.

      *    <<< PATCH FOR BACKWARDS BROWSING BY NAME CASE >>>
           IF DET-SEL-BY-EMPLOYEE-NAME THEN
              EXEC CICS READPREV
                   FILE(APP-EMP-MASTER-PATH-NAME)
                   RIDFLD(EMP-PRIMARY-NAME)
                   INTO (EMPLOYEE-MASTER-RECORD)
                   END-EXEC
           END-IF.
      *    <<< ----------------------------------------- >>>

           PERFORM 1410-READ-PREV-RECORD
              UNTIL FILTERS-PASSED OR DET-TOP-OF-FILE.

           IF FILTERS-PASSED THEN
              MOVE EMPLOYEE-MASTER-RECORD TO DET-EMPLOYEE-RECORD
           END-IF.

           IF NOT DET-TOP-OF-FILE THEN
              PERFORM 1330-END-BROWSING
           END-IF.

       1410-READ-PREV-RECORD.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '1410-READ-PREV-RECORD (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '1410-READ-PREV-RECORD (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           IF DET-SEL-BY-EMPLOYEE-ID THEN
              EXEC CICS READPREV
                   FILE(APP-EMP-MASTER-FILE-NAME)
                   RIDFLD(EMP-EMPLOYEE-ID)
                   INTO (EMPLOYEE-MASTER-RECORD)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           ELSE
              EXEC CICS READPREV
                   FILE(APP-EMP-MASTER-PATH-NAME)
                   RIDFLD(EMP-PRIMARY-NAME)
                   INTO (EMPLOYEE-MASTER-RECORD)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           END-IF.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                PERFORM 3200-APPLY-FILTERS
                PERFORM 3700-CHECK-DELETION
           WHEN DFHRESP(NOTFND)
                MOVE 'No Previous Records Found!' TO WS-MESSAGE
                SET DET-TOP-OF-FILE TO TRUE
           WHEN DFHRESP(ENDFILE)
                MOVE 'Start of Employee Master File' TO WS-MESSAGE
                SET DET-TOP-OF-FILE TO TRUE
           WHEN OTHER
                MOVE 'Error Reading Previous Record!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           END-EVALUATE.

       1500-FIND-RECORD-BY-KEY.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '1500-FIND-RECORD-BY-KEY (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '1500-FIND-RECORD-BY-KEY (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           IF DET-SEL-BY-EMPLOYEE-ID THEN
              EXEC CICS READ
                   FILE(APP-EMP-MASTER-FILE-NAME)
                   RIDFLD(EMP-EMPLOYEE-ID)
                   INTO (EMPLOYEE-MASTER-RECORD)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           ELSE
              EXEC CICS READ
                   FILE(APP-EMP-MASTER-PATH-NAME)
                   RIDFLD(EMP-PRIMARY-NAME)
                   INTO (EMPLOYEE-MASTER-RECORD)
                   RESP(WS-CICS-RESPONSE)
                   END-EXEC
           END-IF.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                PERFORM 3200-APPLY-FILTERS
                PERFORM 3700-CHECK-DELETION
           WHEN DFHRESP(NOTFND)
                MOVE 'No Record Found By That Key!' TO WS-MESSAGE
           WHEN DFHRESP(ENDFILE)
                MOVE 'End of Employee Master File' TO WS-MESSAGE
                SET DET-END-OF-FILE TO TRUE
           WHEN OTHER
                MOVE 'Error Reading Employee Record!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           END-EVALUATE.

       1600-LOOKUP-USER-ID.
      *    >>> DEBUGGING ONLY <<<
           MOVE '1600-LOOKUP-USER-ID' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    LOOKUP THE USER ID IN VSAM FILE
           EXEC CICS READ
                FILE(APP-REG-USER-FILE-NAME)
                INTO (REGISTERED-USER-RECORD)
                RIDFLD(REG-USER-ID)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                MOVE REG-EMPLOYEE-ID TO DET-USER-EMP-ID
           WHEN DFHRESP(NOTFND)
                MOVE "User Not Found!" TO WS-MESSAGE
           WHEN OTHER
                MOVE "Error Reading Users File!" TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           END-EVALUATE.

      *-----------------------------------------------------------------
       VIEWING SECTION.
      *-----------------------------------------------------------------

       2000-PROCESS-USER-INPUT.
      *    >>> DEBUGGING ONLY <<<
           MOVE '2000-PROCESS-USER-INPUT' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           MOVE 'So Far, So Good...' TO WS-MESSAGE.

           EXEC CICS RECEIVE
                MAP(APP-VIEW-MAP-NAME)
                MAPSET(APP-VIEW-MAPSET-NAME)
                INTO (EDETMI)
                END-EXEC.

      *    >>> CALL ACTIVITY MONITOR <<<
           PERFORM 4000-CHECK-USER-STATUS.
      *    >>> --------------------- <<<

           EVALUATE EIBAID
           WHEN DFHENTER
                PERFORM 2100-FIND-BY-EMPLOYEE-KEY
           WHEN DFHPF3
           WHEN DFHPF12
                PERFORM 2200-TRANSFER-BACK-TO-CALLER
           WHEN DFHPF5
                PERFORM 2600-TRANSFER-TO-UPDATE-PAGE
           WHEN DFHPF7
                PERFORM 2300-PREV-BY-EMPLOYEE-KEY
           WHEN DFHPF8
                PERFORM 2400-NEXT-BY-EMPLOYEE-KEY
           WHEN DFHPF9
                PERFORM 2700-SWITCH-DISPLAY-ORDER
           WHEN DFHPF10
                PERFORM 2500-SIGN-USER-OFF
           WHEN OTHER
                MOVE 'Invalid Key!' TO WS-MESSAGE
           END-EVALUATE.

       2100-FIND-BY-EMPLOYEE-KEY.
      *    IF EMPLOYEE ID WAS ENTERED, THEN FIND BY ID.
           IF EMPLIDI IS NOT EQUAL TO LOW-VALUES AND
              EMPLIDI IS NOT EQUAL TO SPACES THEN
      *       --- BY ID ---
              SET DET-SEL-BY-EMPLOYEE-ID TO TRUE

      **       MY OWN CODE FOR FORMATTING THE ENTERED ID VALUE.
      *       MOVE FUNCTION TRIM(EMPLIDI) TO WS-EMPLOYEE-ID
      *       INSPECT WS-EMPLOYEE-ID REPLACING LEADING SPACES BY ZEROES
      *       MOVE WS-EMPLOYEE-ID TO EMP-EMPLOYEE-ID

      *       CICS BUILT-IN UTILITY FOR CONVERT INPUT TO NUMERIC VALUE
              EXEC CICS BIF DEEDIT
                   FIELD(EMPLIDI)
                   LENGTH(8)
                   END-EXEC

              MOVE EMPLIDI TO EMP-EMPLOYEE-ID
           END-IF.

      *    IF PRIMARY NAME WAS ENTERED, THEN FIND BY NAME.
           IF PRNAMEI IS NOT EQUAL TO LOW-VALUES AND
              PRNAMEI IS NOT EQUAL TO SPACES THEN
      *       --- BY NAME ---
              SET DET-SEL-BY-EMPLOYEE-NAME TO TRUE

      *       WE COMPENSATE FOR THE CICS TERMINAL CONVERTING ALL MAP
      *       INPUT STRING DATA TO UPPER CASE! (A SYSTEM-WIDE
      *       CONFIGURATION APPARENTLY).
      *
      *       WE TRIM IT AND CONVERT IT TO TITLE-CASE TO BEST MATCH
      *       THE ALTERNATE-KEY FORMAT ON THE EMPLOYEES MASTER FILE.
      *
      *       - NOTE: THIS WILL *NOT* WORK IF THE PRIMARY NAME ON THE
      *               EMPLOYEES MASTER FILE USES MORE UPPER-CASE
      *               LETTERS THAN THE FIRST ONE IN EACH WORD.
      *
              MOVE FUNCTION TRIM(PRNAMEI) TO EMP-PRIMARY-NAME
              PERFORM 2150-CONVERT-TO-TITLE-CASE
           END-IF.

      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '2100-FIND-BY-EMPLOYEE-KEY (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '2100-FIND-BY-EMPLOYEE-KEY (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           PERFORM 1500-FIND-RECORD-BY-KEY.

           IF FILTERS-PASSED THEN
              MOVE EMPLOYEE-MASTER-RECORD TO DET-EMPLOYEE-RECORD
           ELSE
              MOVE 'No Matching Record By That Key!' TO WS-MESSAGE
           END-IF.

       2150-CONVERT-TO-TITLE-CASE.
      *    >>> DEBUGGING ONLY <<<
           MOVE '2150-CONVERT-TO-TITLE-CASE' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    FIRST, CONVERT TO LOWER CASE.
           MOVE FUNCTION LOWER-CASE(EMP-PRIMARY-NAME)
              TO EMP-PRIMARY-NAME.

      *    THEN, CAPITALIZE FIRST LETTER.
           MOVE FUNCTION UPPER-CASE(EMP-PRIMARY-NAME(1:1))
              TO EMP-PRIMARY-NAME(1:1).

      *    FINALLY, CAPITALIZE INITIAL LETTERS OF ALL INNER WORDS.
           INSPECT EMP-PRIMARY-NAME
              REPLACING
              ALL ' a' BY ' A',
              ALL ' b' BY ' B',
              ALL ' c' BY ' C',
              ALL ' d' BY ' D',
              ALL ' e' BY ' E',
              ALL ' f' BY ' F',
              ALL ' g' BY ' G',
              ALL ' h' BY ' H',
              ALL ' i' BY ' I',
              ALL ' j' BY ' J',
              ALL ' k' BY ' K',
              ALL ' l' BY ' L',
              ALL ' m' BY ' M',
              ALL ' n' BY ' N',
              ALL ' o' BY ' O',
              ALL ' p' BY ' P',
              ALL ' q' BY ' Q',
              ALL ' r' BY ' R',
              ALL ' s' BY ' S',
              ALL ' t' BY ' T',
              ALL ' u' BY ' U',
              ALL ' v' BY ' V',
              ALL ' w' BY ' W',
              ALL ' x' BY ' X',
              ALL ' y' BY ' Y',
              ALL ' z' BY ' Z'.

      *    PLUS -> THE *O'CONNOR* CASE!
           INSPECT EMP-PRIMARY-NAME
              REPLACING
              ALL "'a" BY "'A",
              ALL "'b" BY "'B",
              ALL "'c" BY "'C",
              ALL "'d" BY "'D",
              ALL "'e" BY "'E",
              ALL "'f" BY "'F",
              ALL "'g" BY "'G",
              ALL "'h" BY "'H",
              ALL "'i" BY "'I",
              ALL "'j" BY "'J",
              ALL "'k" BY "'K",
              ALL "'l" BY "'L",
              ALL "'m" BY "'M",
              ALL "'n" BY "'N",
              ALL "'o" BY "'O",
              ALL "'p" BY "'P",
              ALL "'q" BY "'Q",
              ALL "'r" BY "'R",
              ALL "'s" BY "'S",
              ALL "'t" BY "'T",
              ALL "'u" BY "'U",
              ALL "'v" BY "'V",
              ALL "'w" BY "'W",
              ALL "'x" BY "'X",
              ALL "'y" BY "'Y",
              ALL "'z" BY "'Z".

      *    AND -> THE 'JAN LEVINSON-GOULD' CASE! :)
           INSPECT EMP-PRIMARY-NAME
              REPLACING
              ALL '-a' BY '-A',
              ALL '-b' BY '-B',
              ALL '-c' BY '-C',
              ALL '-d' BY '-D',
              ALL '-e' BY '-E',
              ALL '-f' BY '-F',
              ALL '-g' BY '-G',
              ALL '-h' BY '-H',
              ALL '-i' BY '-I',
              ALL '-j' BY '-J',
              ALL '-k' BY '-K',
              ALL '-l' BY '-L',
              ALL '-m' BY '-M',
              ALL '-n' BY '-N',
              ALL '-o' BY '-O',
              ALL '-p' BY '-P',
              ALL '-q' BY '-Q',
              ALL '-r' BY '-R',
              ALL '-s' BY '-S',
              ALL '-t' BY '-T',
              ALL '-u' BY '-U',
              ALL '-v' BY '-V',
              ALL '-w' BY '-W',
              ALL '-x' BY '-X',
              ALL '-y' BY '-Y',
              ALL '-z' BY '-Z'.

      *    >>> DEBUGGING ONLY <<<
           MOVE EMP-PRIMARY-NAME TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

       2200-TRANSFER-BACK-TO-CALLER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '2200-TRANSFER-BACK-TO-CALLER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    IF WE ARE COMING FROM 'OURSELVES', I.E. WE INVOKED THE
      *    'EDET' TRANSACTION DIRECTLY, THEN WE JUST RETURN TO CICS.
           IF DET-CALLING-PROGRAM IS EQUAL TO APP-VIEW-PROGRAM-NAME
              PERFORM 9200-RETURN-TO-CICS
           END-IF.

      *    OTHERWISE, WE TRANSFER BACK TO THE CALLING PROGRAM.
      *    I.E. 'ELISTP' (LIST EMPLOYEES) OR 'EMENUP' (MENU).

      *    RESET THIS CONVERSATION BY DELETING CURRENT CONTAINER.
           PERFORM 2250-DELETE-VIEW-CONTAINER.

           EXEC CICS XCTL
                PROGRAM(DET-CALLING-PROGRAM)
                CHANNEL(APP-ACTMON-CHANNEL-NAME)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN DFHRESP(INVREQ)
                MOVE 'Invalid Request!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           WHEN DFHRESP(PGMIDERR)
                MOVE 'Caller Program Not Found!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           WHEN OTHER
                MOVE 'Error Transferring To Caller!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           END-EVALUATE.

       2250-DELETE-VIEW-CONTAINER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '2250-DELETE-VIEW-CONTAINER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           EXEC CICS DELETE
                CONTAINER(APP-VIEW-CONTAINER-NAME)
                CHANNEL(APP-VIEW-CHANNEL-NAME)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN DFHRESP(NOTFND)
                MOVE 'View Container Not Found!' TO WS-MESSAGE
           WHEN OTHER
                MOVE 'Error Deleting View Container!' TO WS-MESSAGE
           END-EVALUATE.

       2300-PREV-BY-EMPLOYEE-KEY.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '2300-PREV-BY-EMPLOYEE-KEY (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '2300-PREV-BY-EMPLOYEE-KEY (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           IF NOT DET-TOP-OF-FILE THEN
              IF DET-SEL-BY-EMPLOYEE-ID THEN
                 SUBTRACT 1 FROM EMP-EMPLOYEE-ID
              ELSE
                 CONTINUE
              END-IF

      *       RESET 'FILE BOUNDARY' FLAG.
              INITIALIZE DET-FILE-FLAG

      *       READ FILE BACKWARDS!
              PERFORM 1400-READ-BACKWARDS-BY-KEY
           ELSE
              MOVE 'No Previous Records To Display!' TO WS-MESSAGE
              MOVE DFHPROTN TO HLPPF7A
           END-IF.

       2400-NEXT-BY-EMPLOYEE-KEY.
      *    >>> DEBUGGING ONLY <<<
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE '2400-NEXT-BY-EMPLOYEE-KEY (ID)' TO WS-DEBUG-AID
           ELSE
              MOVE '2400-NEXT-BY-EMPLOYEE-KEY (NM)' TO WS-DEBUG-AID
           END-IF.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           MOVE DET-EMPLOYEE-RECORD TO EMPLOYEE-MASTER-RECORD.

           IF NOT DET-END-OF-FILE THEN
              IF DET-SEL-BY-EMPLOYEE-ID THEN
                 ADD 1 TO EMP-EMPLOYEE-ID
              ELSE
                 MOVE HIGH-VALUES TO EMP-PRIMARY-NAME(38:)
              END-IF

      *       RESET 'FILE BOUNDARY' FLAG.
              INITIALIZE DET-FILE-FLAG

      *       READ FILE IN NORMAL (FORWARD) WAY.
              PERFORM 1300-READ-EMPLOYEE-BY-KEY
           ELSE
              MOVE 'No More Records To Display!' TO WS-MESSAGE
              MOVE DFHPROTN TO HLPPF8A
           END-IF.

       2500-SIGN-USER-OFF.
      *    >>> DEBUGGING ONLY <<<
           MOVE '2500-SIGN-USER-OFF' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    >>> CALL ACTIVITY MONITOR <<<
           SET MON-AC-SIGN-OFF TO TRUE.
           PERFORM 4200-CALL-ACTIVITY-MONITOR.
      *    >>> --------------------- <<<

           PERFORM 9200-RETURN-TO-CICS.

       2600-TRANSFER-TO-UPDATE-PAGE.
      *    >>> DEBUGGING ONLY <<<
           MOVE '2600-TRANSFER-TO-UPDATE-PAGE' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           PERFORM 9150-PUT-VIEW-CONTAINER.

           EXEC CICS XCTL
                PROGRAM(APP-UPDATE-PROGRAM-NAME)
                CHANNEL(APP-VIEW-CHANNEL-NAME)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN DFHRESP(INVREQ)
                MOVE 'Invalid Request!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           WHEN DFHRESP(PGMIDERR)
                MOVE 'Update Program Not Found!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           WHEN OTHER
                MOVE 'Error Transferring To Update Page!' TO WS-MESSAGE
                PERFORM 9000-SEND-MAP-AND-RETURN
           END-EVALUATE.

       2700-SWITCH-DISPLAY-ORDER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '2700-SWITCH-DISPLAY-ORDER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           IF DET-SEL-BY-EMPLOYEE-ID THEN
              SET DET-SEL-BY-EMPLOYEE-NAME TO TRUE
           ELSE
              SET DET-SEL-BY-EMPLOYEE-ID TO TRUE
           END-IF.

      *    RESET 'FILE BOUNDARY' FLAG.
           INITIALIZE DET-FILE-FLAG.

      *-----------------------------------------------------------------
       LIST-FILTERS SECTION.
      *-----------------------------------------------------------------

       3000-GET-LIST-CONTAINER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '3000-GET-LIST-CONTAINER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           EXEC CICS GET
                CONTAINER(APP-LIST-CONTAINER-NAME)
                CHANNEL(APP-LIST-CHANNEL-NAME)
                INTO (LIST-EMPLOYEE-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(CHANNELERR)
           WHEN DFHRESP(CONTAINERERR)
      *         IF WE DON'T FIND IT, SOMETHING'S WRONG, BU WE JUST
      *         LEAVE THE EMPLOYEE RECORD EMPLY SO THE LOGIC MOVES ON
      *         THROUGH THE DEFAULT PATH (I.E. GET FIRST RECORD).
                MOVE 'No List Container Found!' TO WS-MESSAGE
                INITIALIZE DET-EMPLOYEE-RECORD
           WHEN DFHRESP(NORMAL)
      *         IF SUCCESSFULLY FOUND, WE RETRIEVE THE EMPLOYEE RECORD
      *         FOR THE CURRENTLY SELECTED LINE, AS WELL AS THE CURRENT
      *         DISPLAY ORDER AND FILTER SET FROM THE LIST CONTAINER.
                MOVE LST-CURRENT-RECORD(LST-SELECT-LINE-NUMBER)
                   TO DET-EMPLOYEE-RECORD
                MOVE LST-SELECT-KEY-TYPE TO DET-SELECT-KEY-TYPE
                MOVE LST-FILTERS TO DET-FILTERS

      *         ALSO UPDATE LIST CONTAINER WITH THIS PROGRAM'S NAME.
                MOVE APP-VIEW-PROGRAM-NAME TO LST-SAVING-PROGRAM
                PERFORM 3100-PUT-LIST-CONTAINER
           WHEN OTHER
                MOVE 'Error Retrieving List Container!' TO WS-MESSAGE
           END-EVALUATE.

       3100-PUT-LIST-CONTAINER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '3100-PUT-LIST-CONTAINER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           EXEC CICS PUT
                CONTAINER(APP-LIST-CONTAINER-NAME)
                CHANNEL(APP-LIST-CHANNEL-NAME)
                FROM (LIST-EMPLOYEE-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                MOVE 'Error Putting List Container!' TO WS-MESSAGE
           END-EVALUATE.

       3200-APPLY-FILTERS.
      *    >>> DEBUGGING ONLY <<<
           MOVE '3200-APPLY-FILTERS' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    RESET ALL FILTERS FLAGS.
           INITIALIZE WS-FILTER-FLAGS.

      *    RESTORE FILTERS FROM APP CONTAINER.
           MOVE DET-FILTERS TO LST-FILTERS.

      *    IF NO FILTERS WERE SET, THEN WE JUST 'OK' THE RECORD.
           IF LST-NO-FILTERS-SET THEN
              SET FILTERS-PASSED TO TRUE
              EXIT PARAGRAPH
           END-IF.

      *    IF FILTERS WERE SET, THEN WE CHECK THEM ALL.
           PERFORM 3300-APPLY-KEY-FILTERS.
           PERFORM 3400-APPLY-DEPT-FILTERS.
           PERFORM 3500-APPLY-DATE-FILTERS.

      *    IF *ALL* FILTERS WERE MET, THEN WE SET THE 'PASSED' FLAG.
           IF KEY-FILTER-PASSED AND
              DEPT-FILTER-PASSED AND
              DATE-FILTER-PASSED THEN
              SET FILTERS-PASSED TO TRUE
           END-IF.

       3300-APPLY-KEY-FILTERS.
      *    >>> DEBUGGING ONLY <<<
           MOVE '3300-APPLY-KEY-FILTERS' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    IF 'VALUE' WAS OMITTED, WE IGNORE THE FILTER.
           IF LST-SELECT-KEY-VALUE IS EQUAL TO SPACES THEN
              SET KEY-FILTER-PASSED TO TRUE
              EXIT PARAGRAPH
           END-IF.

      *    OTHERWISE, WE CHECK THE KEY FILTERS.

      *    IF 'KEY' WAS OMITTED BUT WE GOT A 'VALUE', THEN WE GUESS THE
      *    KEY FROM THE VALUE!
           IF LST-SELECT-KEY-TYPE IS EQUAL TO SPACES AND
              LST-SELECT-KEY-VALUE IS NOT EQUAL TO SPACES THEN
              IF FUNCTION TRIM(LST-SELECT-KEY-VALUE) IS NUMERIC THEN
                 MOVE '1' TO LST-SELECT-KEY-TYPE
              ELSE
                 MOVE '2' TO LST-SELECT-KEY-TYPE
              END-IF
           END-IF.

      *    SELECT OPTION '1' -> 'EMPLOYEE ID' FILTER.
           IF LST-SEL-BY-EMPLOYEE-ID THEN
              INITIALIZE WS-INSP-COUNTER

              INSPECT EMP-KEY
                 TALLYING WS-INSP-COUNTER
                 FOR ALL FUNCTION TRIM(LST-SELECT-KEY-VALUE)

              IF WS-INSP-COUNTER IS GREATER THAN ZERO THEN
                 SET KEY-FILTER-PASSED TO TRUE
              END-IF
           END-IF.

      *    SELECT OPTION '2' -> 'EMPLOYEE NAME' FILTER.
           IF LST-SEL-BY-EMPLOYEE-NAME THEN
              INITIALIZE WS-INSP-COUNTER

              INSPECT FUNCTION UPPER-CASE(EMP-PRIMARY-NAME)
                 TALLYING WS-INSP-COUNTER
                 FOR ALL FUNCTION TRIM(LST-SELECT-KEY-VALUE)

              IF WS-INSP-COUNTER IS GREATER THAN ZERO THEN
                 SET KEY-FILTER-PASSED TO TRUE
              END-IF
           END-IF.

       3400-APPLY-DEPT-FILTERS.
      *    >>> DEBUGGING ONLY <<<
           MOVE '3400-APPLY-DEPT-FILTERS' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    IF NO DEPARTMENT FILTERS WERE SET, WE JUST 'OK' IT.
           IF LST-INCLUDE-DEPT-FILTERS IS EQUAL TO SPACES AND
              LST-EXCLUDE-DEPT-FILTERS IS EQUAL TO SPACES THEN
              SET DEPT-FILTER-PASSED TO TRUE
              EXIT PARAGRAPH
           END-IF.

      *    OTHERWISE, WE CHECK THE DEPARTMENT FILTERS.
           MOVE EMP-DEPARTMENT-ID TO WS-DEPT-KEY.

      *    FIRST, THE 'POSITIVE' DEPARTMENT INCLUSION FILTERS.
           IF LST-INCLUDE-DEPT-FILTERS IS EQUAL TO SPACES THEN
      *       NO 'INCLUDE' FILTERS, SO *ALL* DEPARTMENTS ARE FINE.
              SET DEPT-FILTER-PASSED TO TRUE
           ELSE
      *       WE NEED TO MATCH A 'WHITE-LISTED' DEPARTMENT TO PASS.
              PERFORM VARYING LST-IN-DEPT-INDEX
                 FROM 1 BY 1
                 UNTIL LST-IN-DEPT-INDEX IS GREATER THAN 4
                 OR DEPT-FILTER-PASSED
                      IF LST-INCL-DEPT-ID(LST-IN-DEPT-INDEX)
                         IS NOT EQUAL TO SPACES THEN

                         INITIALIZE WS-INSP-COUNTER

                         INSPECT WS-DEPT-KEY
                            TALLYING WS-INSP-COUNTER
                            FOR ALL FUNCTION TRIM
                            (LST-INCL-DEPT-ID(LST-IN-DEPT-INDEX))

                         IF WS-INSP-COUNTER IS GREATER THAN ZERO THEN
      *                     SUCCESS! IT PASSES THE FILTER.
                            SET DEPT-FILTER-PASSED TO TRUE
                         END-IF
                      END-IF
              END-PERFORM
           END-IF.

      *    SECOND, THE 'NEGATIVE' DEPARTMENT EXCLUSION FILTERS.
           IF LST-EXCLUDE-DEPT-FILTERS IS EQUAL TO SPACES THEN
      *       NO 'EXCLUDE' FILTERS, SO *NO* DEPARTMENTS ARE OFF.
      *       WE MANTAIN THE STATUS QUO (AS IN THE 'INCLUDE' OUTCOME)
              CONTINUE
           ELSE
      *       WE NEED TO AVOID ALL 'BLACK-LISTED' DEPARTMENTS TO PASS.
              PERFORM VARYING LST-EX-DEPT-INDEX
                 FROM 1 BY 1
                 UNTIL LST-EX-DEPT-INDEX IS GREATER THAN 4
                 OR DEPT-FILTER-FAILED
                      IF LST-EXCL-DEPT-ID(LST-EX-DEPT-INDEX)
                         IS NOT EQUAL TO SPACES THEN

                         INITIALIZE WS-INSP-COUNTER

                         INSPECT WS-DEPT-KEY
                            TALLYING WS-INSP-COUNTER
                            FOR ALL FUNCTION TRIM
                            (LST-EXCL-DEPT-ID(LST-EX-DEPT-INDEX))

                         IF WS-INSP-COUNTER IS GREATER THAN ZERO THEN
      *                     BLACKLISTED! IT DOESN'T MAKE THE CUT.
                            SET DEPT-FILTER-FAILED TO TRUE
                         END-IF
                      END-IF
              END-PERFORM
           END-IF.

       3500-APPLY-DATE-FILTERS.
      *    >>> DEBUGGING ONLY <<<
           MOVE '3500-APPLY-DATE-FILTERS' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    IF NO DATE FILTERS WERE SET, WE JUST 'OK' IT AND RETURN
           IF LST-EMPLOYMENT-DATE-FILTERS IS EQUAL TO SPACES THEN
              SET DATE-FILTER-PASSED TO TRUE
              EXIT PARAGRAPH
           END-IF.

      *    OTHERWISE, WE CHECK THE DATE FILTERS.

      *    IF BOTH FILTERS WERE SET, WE CHECK THE EMPLOYEE START DATE
      *    AGAINST THE FILTERS.
           IF LST-EMPL-DATE-AFTER IS NOT EQUAL TO SPACES AND
              LST-EMPL-DATE-BEFORE IS NOT EQUAL TO SPACES THEN
              IF EMP-START-DATE IS GREATER THAN LST-EMPL-DATE-AFTER AND
                 EMP-START-DATE IS LESS THAN LST-EMPL-DATE-BEFORE THEN
      *          SUCCESS!
                 SET DATE-FILTER-PASSED TO TRUE
                 EXIT PARAGRAPH
              END-IF
           END-IF.

      *    IF ONLY DATE-BEFORE FILTER WAS SET.
           IF LST-EMPL-DATE-AFTER IS EQUAL TO SPACES THEN
              IF EMP-START-DATE IS LESS THAN LST-EMPL-DATE-BEFORE THEN
      *          SUCCESS!
                 SET DATE-FILTER-PASSED TO TRUE
                 EXIT PARAGRAPH
              END-IF
           END-IF.

      *    IF ONLY DATE-AFTER FILTER WAS SET.
           IF LST-EMPL-DATE-BEFORE IS EQUAL TO SPACES THEN
              IF EMP-START-DATE IS GREATER THAN LST-EMPL-DATE-AFTER THEN
      *          SUCCESS!
                 SET DATE-FILTER-PASSED TO TRUE
                 EXIT PARAGRAPH
              END-IF
           END-IF.

       3700-CHECK-DELETION.
      *    >>> DEBUGGING ONLY <<<
           MOVE '3700-CHECK-DELETION' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    FILTER 'LOGICALLY DELETED' RECORDS FROM STANDARD USERS, BUT
      *    ALLOW MANAGERS AND ADMINISTRATORS TO SEE THEM.

           IF DET-CT-MANAGER OR DET-CT-ADMINISTRATOR THEN
              EXIT PARAGRAPH
           END-IF.

           IF EMP-DELETED THEN
              SET FILTERS-FAILED TO TRUE
           END-IF.

      *-----------------------------------------------------------------
       ACTIVITY-MONITOR SECTION.
      *-----------------------------------------------------------------

       4000-CHECK-USER-STATUS.
      *    >>> DEBUGGING ONLY <<<
           MOVE '4000-CHECK-USER-STATUS' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    CHECK IF THE USER IS ALREADY SIGNED ON TO THE ACTIVITY
           PERFORM 4100-GET-MONITOR-CONTAINER.

      *    IF THE USER IS SIGNED ON, CHECK IF SESSION IS STILL ACTIVE.
           SET MON-AC-APP-FUNCTION TO TRUE.
           PERFORM 4200-CALL-ACTIVITY-MONITOR.


       4100-GET-MONITOR-CONTAINER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '4100-GET-MONITOR-CONTAINER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           EXEC CICS GET
                CONTAINER(APP-ACTMON-CONTAINER-NAME)
                CHANNEL(APP-ACTMON-CHANNEL-NAME)
                INTO (ACTIVITY-MONITOR-CONTAINER)
                FLENGTH(LENGTH OF ACTIVITY-MONITOR-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN DFHRESP(CHANNELERR)
           WHEN DFHRESP(CONTAINERERR)
                MOVE 'No Activity Monitor Data Found!' TO WS-MESSAGE
           WHEN OTHER
                MOVE 'Error Getting Activity Monitor!' TO WS-MESSAGE
           END-EVALUATE.

       4200-CALL-ACTIVITY-MONITOR.
      *    >>> DEBUGGING ONLY <<<
           MOVE '4200-CALL-ACTIVITY-MONITOR' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    PUT CONTAINER AND LINK TO ACTIVITY MONITOR PROGRAM
           MOVE APP-VIEW-PROGRAM-NAME TO MON-LINKING-PROGRAM.
           INITIALIZE MON-RESPONSE.

           PERFORM 4300-PUT-MONITOR-CONTAINER.

           EXEC CICS LINK
                PROGRAM(APP-ACTMON-PROGRAM-NAME)
                CHANNEL(APP-ACTMON-CHANNEL-NAME)
                TRANSID(EIBTRNID)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN DFHRESP(PGMIDERR)
                MOVE 'Activity Monitor Program Not Found!' TO WS-MESSAGE
           WHEN OTHER
                MOVE 'Error Linking to Activity Monitor!' TO WS-MESSAGE
           END-EVALUATE.

       4300-PUT-MONITOR-CONTAINER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '4300-PUT-MONITOR-CONTAINER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           EXEC CICS PUT
                CONTAINER(APP-ACTMON-CONTAINER-NAME)
                CHANNEL(APP-ACTMON-CHANNEL-NAME)
                FROM (ACTIVITY-MONITOR-CONTAINER)
                FLENGTH(LENGTH OF ACTIVITY-MONITOR-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                MOVE 'Error Putting Activity Monitor!' TO WS-MESSAGE
           END-EVALUATE.

      *-----------------------------------------------------------------
       RE-ENTRY SECTION.
      *-----------------------------------------------------------------

       5000-RE-ENTRY-FROM-UPDATE.
      *    >>> DEBUGGING ONLY <<<
           MOVE '5000-RE-ENTRY-FROM-UPDATE' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    RESTORE 'VIEW DETAILS' (THIS!) AS THE ACTIVE PROGRAM TO
      *    PICK UP THE PSEUDO CONVERSATION.
           MOVE APP-VIEW-PROGRAM-NAME TO DET-SAVING-PROGRAM.

      *    EVERYTHING ELSE WAS ALREADY RECEIVED IN THE CONTAINER,
      *    SO WE JUST CHILL!
           CONTINUE.

      *-----------------------------------------------------------------
       EXIT-ROUTE SECTION.
      *-----------------------------------------------------------------

       9000-SEND-MAP-AND-RETURN.
      *    >>> DEBUGGING ONLY <<<
           MOVE '9000-SEND-MAP-AND-RETURN' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    PSEUDO-CONVERSATIONAL RETURN:
      *      - PUT THE CONTAINER BACK TO CICS.
      *      - POPULATE AND SEND MAP TO CICS.
      *      - RETURN TO CICS.

           PERFORM 9100-POPULATE-MAP.
           PERFORM 9150-PUT-VIEW-CONTAINER.

           EXEC CICS SEND
                MAP(APP-VIEW-MAP-NAME)
                MAPSET(APP-VIEW-MAPSET-NAME)
                FROM (EDETMO)
                ERASE
                FREEKB
                END-EXEC.

           EXEC CICS RETURN
                CHANNEL(APP-VIEW-CHANNEL-NAME)
                TRANSID(APP-VIEW-TRANSACTION-ID)
                END-EXEC.

       9100-POPULATE-MAP.
      *    >>> DEBUGGING ONLY <<<
           MOVE '9100-POPULATE-MAP' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           MOVE DET-EMPLOYEE-RECORD TO EMPLOYEE-MASTER-RECORD.

      *    ALL USERS -> DISPLAY TRANSACTION ID.
           MOVE EIBTRNID TO TRANIDO.

      *    ALL USERS -> DISPLAY BROWSING ORDER.
           IF DET-SEL-BY-EMPLOYEE-ID THEN
              MOVE 'By Id  ' TO SELBYO
           ELSE
              MOVE 'By Name' TO SELBYO
           END-IF.

      *    ALL USERS -> DISPLAY CURRENTLY LOGGED-IN USER.
           IF MON-USER-ID IS NOT EQUAL TO SPACES THEN
              MOVE MON-USER-ID TO LOGDINO
           ELSE
              MOVE '<Anonym>' TO LOGDINO
           END-IF.

      *    ALL USERS -> DISPLAY ID AND ALT-KEY FIELDS.
           MOVE EMP-EMPLOYEE-ID TO EMPLIDO.
           MOVE EMP-PRIMARY-NAME TO PRNAMEO.

      *    ALL USERS -> DISPLAY BASIC EMPLOYEE DATA.
           MOVE EMP-HONORIFIC TO HONORO.
           MOVE EMP-SHORT-NAME TO SHNAMEO.
           MOVE EMP-FULL-NAME TO FLNAMEO.

      *    STANDARD & MANAGERS -> DISPLAY FURTHER EMPLOYEE DATA.
           IF DET-CT-STANDARD OR DET-CT-MANAGER THEN
              MOVE EMP-JOB-TITLE TO JBTITLO
              MOVE EMP-DEPARTMENT-ID TO DEPTIDO
              MOVE 'Undefined' TO DEPTNMO

              MOVE EMP-START-DATE TO WS-INPUT-DATE
              MOVE CORRESPONDING WS-INPUT-DATE TO WS-OUTPUT-DATE
              MOVE WS-OUTPUT-DATE TO STDATEO

              MOVE EMP-END-DATE TO WS-INPUT-DATE
              MOVE CORRESPONDING WS-INPUT-DATE TO WS-OUTPUT-DATE
              MOVE WS-OUTPUT-DATE TO ENDATEO
           ELSE
              MOVE '<Hidden>' TO JBTITLO DEPTIDO DEPTNMO
              MOVE '<Hidden>' TO STDATEO ENDATEO
           END-IF.

      *    USER HIMSELF & MANAGERS -> DISPLAY APPRAISAL DATA.
           IF DET-CT-MANAGER OR
              (DET-CT-STANDARD AND
              DET-USER-EMP-ID IS EQUAL TO EMP-EMPLOYEE-ID) THEN

              MOVE EMP-APPRAISAL-DATE TO WS-INPUT-DATE
              MOVE CORRESPONDING WS-INPUT-DATE TO WS-OUTPUT-DATE
              MOVE WS-OUTPUT-DATE TO APPRDTO

              EVALUATE TRUE
              WHEN EMP-EXCEEDS-EXPECTATIONS
                   MOVE 'Exceeds Expectations' TO APPRRSO
              WHEN EMP-MEETS-EXPECTATIONS
                   MOVE 'Meets Expectations' TO APPRRSO
              WHEN EMP-UH-OH
                   MOVE 'You Are Truly Fucked' TO APPRRSO
              WHEN OTHER
                   MOVE 'Undefined' TO APPRRSO
              END-EVALUATE
           ELSE
              MOVE '<Hidden>' TO APPRDTO APPRRSO
           END-IF.

      *    MANAGERS & ADMINS -> DISPLAY LOGICAL RECORD STATUS.
           IF DET-CT-MANAGER OR DET-CT-ADMINISTRATOR THEN
              MOVE EMP-DELETE-FLAG TO DELFLGO

              EVALUATE TRUE
              WHEN EMP-ACTIVE
                   MOVE 'Active' TO DELDSCO
              WHEN EMP-DELETED
                   MOVE 'Deleted' TO DELDSCO
              WHEN OTHER
                   MOVE 'Undefined' TO DELDSCO
              END-EVALUATE

              MOVE EMP-DELETE-DATE TO WS-INPUT-DATE
              MOVE CORRESPONDING WS-INPUT-DATE TO WS-OUTPUT-DATE
              MOVE WS-OUTPUT-DATE TO DELDTO
           ELSE
              MOVE '-' TO DELFLGO
              MOVE '<Hidden>' TO DELDSCO DELDTO
           END-IF.

      *    USER HIMSELF -> SPECIAL GREETING!
           IF DET-USER-EMP-ID IS GREATER THAN ZERO AND
              DET-USER-EMP-ID IS EQUAL TO EMP-EMPLOYEE-ID THEN
              MOVE 'Hey! This Is Actually You!' TO WS-MESSAGE
           END-IF.

      *    ALL USERS -> DISPLAY ALL-IMPORTANT MESSAGE LINE!
           MOVE WS-MESSAGE TO MESSO.
           MOVE DFHTURQ TO MESSC.

      *    ALL USERS -> COLOR MESSAGE ACCORDING TO TYPE/CONTENT.
           EVALUATE TRUE
           WHEN MESSO(1:5) IS EQUAL TO 'Error'
                MOVE DFHRED TO MESSC
           WHEN MESSO(1:3) IS EQUAL TO 'No '
                MOVE DFHYELLO TO MESSC
           WHEN MESSO(1:7) IS EQUAL TO 'Invalid'
           WHEN MESSO(1:4) IS EQUAL TO 'Hey!'
                MOVE DFHPINK TO MESSC
           END-EVALUATE.

      *    HERE, WE SET THE MODIFIED DATA TAG (MDT) OF ONE THE FIELDS
      *    TO 'ON' TO AVOID THE 'AEI9' ABEND THAT HAPPENS DUE TO A
      *    'MAPFAIL' CONDITION WHEN WE LATER RECEIVE THE MAP WITH JUST
      *    AN AID KEY PRESS AND NO MODIFIED DATA ON IT.
           MOVE DFHBMFSE TO EMPLIDA.

      *    ALL USERS -> POPULATE NAVIG   ATION KEY LABELS.
           IF DET-TOP-OF-FILE THEN
              MOVE SPACES TO HLPPF7O
           END-IF.
           IF DET-END-OF-FILE THEN
              MOVE SPACES TO HLPPF8O
           END-IF.

       9150-PUT-VIEW-CONTAINER.
      *    >>> DEBUGGING ONLY <<<
           MOVE '9150-PUT-VIEW-CONTAINER' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

           EXEC CICS PUT
                CONTAINER(APP-VIEW-CONTAINER-NAME)
                CHANNEL(APP-VIEW-CHANNEL-NAME)
                FROM (EMPLOYEE-DETAILS-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                MOVE 'Error Putting View Container!' TO WS-MESSAGE
           END-EVALUATE.

       9200-RETURN-TO-CICS.
      *    >>> DEBUGGING ONLY <<<
           MOVE '9200-RETURN-TO-CICS' TO WS-DEBUG-AID.
           PERFORM 9300-DEBUG-AID.
      *    >>> -------------- <<<

      *    SIGN-OFF OR CANCEL:
      *      - CLEAR TERMINAL SCREEN.
      *      - COLD RETURN TO CICS.
      *      - END OF CONVERSATION.

           EXEC CICS SEND CONTROL
                ERASE
                FREEKB
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.

       9300-DEBUG-AID.
      *    >>> DEBUGGING ONLY <<<
           IF I-AM-DEBUGGING THEN
              INITIALIZE WS-DEBUG-MESSAGE

              MOVE WS-DEBUG-AID TO WS-DEBUG-TEXT
              MOVE EIBRESP TO WS-DEBUG-EIBRESP
              MOVE EIBRESP2 TO WS-DEBUG-EIBRESP2

              EXEC CICS SEND TEXT
                   FROM (WS-DEBUG-MESSAGE)
                   END-EXEC
              EXEC CICS RECEIVE
                   LENGTH(LENGTH OF EIBAID)
                   END-EXEC

              INITIALIZE EIBRESP EIBRESP2
           END-IF.
      *    >>> -------------- <<<
