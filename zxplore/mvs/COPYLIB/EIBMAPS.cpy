       01  EIBMAPMI.
           02  FILLER PIC X(12).
           02  NEXTL    COMP  PIC  S9(4).
           02  NEXTF    PICTURE X.
           02  FILLER REDEFINES NEXTF.
             03 NEXTA    PICTURE X.
           02  NEXTI  PIC X(16).
           02  EDATEL    COMP  PIC  S9(4).
           02  EDATEF    PICTURE X.
           02  FILLER REDEFINES EDATEF.
             03 EDATEA    PICTURE X.
           02  EDATEI  PIC X(12).
           02  ETIMEL    COMP  PIC  S9(4).
           02  ETIMEF    PICTURE X.
           02  FILLER REDEFINES ETIMEF.
             03 ETIMEA    PICTURE X.
           02  ETIMEI  PIC X(8).
           02  ETRANL    COMP  PIC  S9(4).
           02  ETRANF    PICTURE X.
           02  FILLER REDEFINES ETRANF.
             03 ETRANA    PICTURE X.
           02  ETRANI  PIC X(4).
           02  ETASKL    COMP  PIC  S9(4).
           02  ETASKF    PICTURE X.
           02  FILLER REDEFINES ETASKF.
             03 ETASKA    PICTURE X.
           02  ETASKI  PIC X(7).
           02  ETERML    COMP  PIC  S9(4).
           02  ETERMF    PICTURE X.
           02  FILLER REDEFINES ETERMF.
             03 ETERMA    PICTURE X.
           02  ETERMI  PIC X(4).
       01  EIBMAPMO REDEFINES EIBMAPMI.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  NEXTO  PIC X(16).
           02  FILLER PICTURE X(3).
           02  EDATEO  PIC X(12).
           02  FILLER PICTURE X(3).
           02  ETIMEO  PIC X(8).
           02  FILLER PICTURE X(3).
           02  ETRANO  PIC X(4).
           02  FILLER PICTURE X(3).
           02  ETASKO PIC ZZZZZZ9.
           02  FILLER PICTURE X(3).
           02  ETERMO  PIC X(4).
