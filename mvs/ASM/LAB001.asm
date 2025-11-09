*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB001   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
*
*  --->  Define a halfword labelled H1, containing decimal 100
*
H1       DC    H'100'             Address  : X'0000 0000'
*                                 Value    : X'0064'
*                                 Length   : 1 Halfword   (2 bytes)
*                                 Alignment: Halfword boundary
*
*  --->  Define a halfword labelled H2, containing decimal -1
*
H2       DC    H'-1'              Address  : X'0000 0002'
*                                 Value    : X'FFFF'
*                                 Length   : 1 Halfword   (2 bytes)
*                                 Alignment: Halfword boundary
*
*  --->  Define a halfword labelled H3, containing decimal 32767
*
H3       DC    H'32767'           Address  : X'0000 0004'
*                                 Value    : X'7FFF'
*                                 Length   : 1 Halfword   (2 bytes)
*                                 Alignment: Halfword boundary
*
*  --->  Define a fullword labelled F1, containing decimal 100
*
F1       DC    F'100'             Address  : X'0000 0008'
*                                 Value    : X'0000 0064'
*                                 Length   : 1 Fullword   (4 bytes)
*                                 Alignment: Fullword boundary
*
*  --->  Define a fullword labelled F2, containing decimal -1
*
F2       DC    F'-1'              Address  : X'0000 000C'
*                                 Value    : X'FFFF FFFF'
*                                 Length   : 1 Fullword   (4 bytes)
*                                 Alignment: Fullword boundary
*
*  --->  Define a fullword labelled F3, containing decimal 32768
*
F3       DC    F'32768'           Address  : X'0000 0010'
*                                 Value    : X'0000 8000'
*                                 Length   : 1 Fullword   (4 bytes)
*                                 Alignment: Fullword boundary
*
*  --->  Define a doubleword labelled D1, containing decimal 100
*
D1       DC    FD'100'            Address  : X'0000 0018'
*                                 Value    : X'0000 0000 0000 0064'
*                                 Length   : 1 Doubleword (8 bytes)
*                                 Alignment: Doubleword boundary
*
*  --->  Define a doubleword labelled D2, containing decimal 0
*
D2       DC    FD'0'              Address  : X'0000 0020'
*                                 Value    : X'0000 0000 0000 0000'
*                                 Length   : 1 Doubleword (8 bytes)
*                                 Alignment: Doubleword boundary
*
*  --->  Define a doubleword labelled D3, containing decimal -4095
*
D3       DC    FD'-4095'          Address  : X'0000 0028'
*                                 Value    : X'FFFF FFFF FFFF F001'
*                                 Length   : 1 Doubleword (8 bytes)
*                                 Alignment: Doubleword boundary
*
*---------------------------------------------------------------------*
         END
