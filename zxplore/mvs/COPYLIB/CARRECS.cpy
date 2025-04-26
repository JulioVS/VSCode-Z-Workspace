       01  CARRECMI.
           02  FILLER PIC X(12).
           02  EMPNOL    COMP  PIC  S9(4).
           02  EMPNOF    PICTURE X.
           02  FILLER REDEFINES EMPNOF.
             03 EMPNOA    PICTURE X.
           02  EMPNOI  PIC X(6).
           02  TAGNOL    COMP  PIC  S9(4).
           02  TAGNOF    PICTURE X.
           02  FILLER REDEFINES TAGNOF.
             03 TAGNOA    PICTURE X.
           02  TAGNOI  PIC X(8).
           02  STATEL    COMP  PIC  S9(4).
           02  STATEF    PICTURE X.
           02  FILLER REDEFINES STATEF.
             03 STATEA    PICTURE X.
           02  STATEI  PIC X(2).
       01  CARRECMO REDEFINES CARRECMI.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  EMPNOO  PIC X(6).
           02  FILLER PICTURE X(3).
           02  TAGNOO  PIC X(8).
           02  FILLER PICTURE X(3).
           02  STATEO  PIC X(2).
