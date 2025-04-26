* ---------------------------------------------------------------------
*  CICS PLURALSIGHT 'FUNDAMENTALS'.
*    - EXECUTION INTERFACE BLOCK MAPSET.
* ---------------------------------------------------------------------
* ---------------------------------------------------------------------
*  EXECUTION INTERFACE BLOCK MAP.
* ---------------------------------------------------------------------
EIBMAPS  DFHMSD TYPE=&SYSPARM,                                         X
               CTRL=(FREEKB,FRSET),                                    X
               LANG=COBOL,                                             X
               MAPATTS=HILIGHT,                                        X
               MODE=INOUT,                                             X
               STORAGE=AUTO,                                           X
               TIOAPFX=YES
EIBMAPM  DFHMDI SIZE=(24,80),                                          X
               LINE=1,                                                 X
               COLUMN=1
NEXT     DFHMDF POS=(1,1),                                             X
               LENGTH=16,                                              X
               INITIAL='SHWE',                                         X
               ATTRB=(UNPROT,IC)
         DFHMDF POS=(1,29),                                            X
               LENGTH=21,                                              X
               INITIAL='Selected EIBLK Fields'
         DFHMDF POS=(3,9),                                             X
               LENGTH=16,                                              X
               INITIAL='           Date:'
EDATE    DFHMDF POS=(3,39),                                            X
               LENGTH=12
         DFHMDF POS=(4,9),                                             X
               LENGTH=16,                                              X
               INITIAL='     Time (UTC):'
ETIME    DFHMDF POS=(4,39),                                            X
               LENGTH=8
         DFHMDF POS=(5,9),                                             X
               LENGTH=16,                                              X
               INITIAL=' Transaction ID:'
ETRAN    DFHMDF POS=(5,39),                                            X
               LENGTH=4
         DFHMDF POS=(6,9),                                             X
               LENGTH=16,                                              X
               INITIAL='    Task Number:'
ETASK    DFHMDF POS=(6,39),                                            X
               PICOUT='ZZZZZZ9'
         DFHMDF POS=(7,9),                                             X
               LENGTH=16,                                              X
               INITIAL='    Terminal ID:'
ETERM    DFHMDF POS=(7,39),                                            X
               LENGTH=4
         DFHMDF POS=(14,9),                                            X
               LENGTH=17,                                              X
               INITIAL='Press PF3 to Exit'
* ---------------------------------------------------------------------
*  ENDING.
* ---------------------------------------------------------------------
         DFHMSD TYPE=FINAL
         END
