* ---------------------------------------------------------------------
*  CICS PLURALSIGHT 'FUNDAMENTALS'.
*    - CAR RECORD MAPSET.
* ---------------------------------------------------------------------
* ---------------------------------------------------------------------
*  CAR RECORD MAP.
* ---------------------------------------------------------------------
CARRECS  DFHMSD TYPE=&SYSPARM,                                         X
               STORAGE=AUTO,                                           X
               MODE=INOUT,                                             X
               LANG=COBOL,                                             X
               TIOAPFX=YES
CARRECM  DFHMDI SIZE=(24,80),                                          X
               LINE=1,                                                 X
               COLUMN=1,                                               X
               CTRL=(FREEKB,FRSET),                                    X
               MAPATTS=HILIGHT
         DFHMDF POS=(1,26),                                            X
               LENGTH=10,                                              X
               INITIAL='Car Record'
         DFHMDF POS=(3,1),                                             X
               LENGTH=12,                                              X
               INITIAL='Employee No:'
EMPNO    DFHMDF POS=(3,14),                                            X
               LENGTH=6,                                               X
               HILIGHT=UNDERLINE,                                      X
               ATTRB=(NORM,NUM,IC)
         DFHMDF POS=(3,21),                                            X
               LENGTH=9,                                               X
               INITIAL='  Tag No:'
TAGNO    DFHMDF POS=(3,31),                                            X
               LENGTH=8,                                               X
               HILIGHT=UNDERLINE,                                      X
               ATTRB=UNPROT
         DFHMDF POS=(3,40),                                            X
               LENGTH=8,                                               X
               INITIAL='  State:'
STATE    DFHMDF POS=(3,49),                                            X
               LENGTH=2,                                               X
               HILIGHT=UNDERLINE
         DFHMDF POS=(3,52),                                            X
               LENGTH=0
* ---------------------------------------------------------------------
*  ENDING.
* ---------------------------------------------------------------------
         DFHMSD TYPE=FINAL
         END
