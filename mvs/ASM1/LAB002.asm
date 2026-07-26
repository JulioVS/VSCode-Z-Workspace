*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB002   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
*
*  --->  Define field labelled HI, containing the characters 'Hello'
*
HI       DC    C'Hello'           Address  : X'0000 0000'
*                                 Value    : X'C8 85 93 93 96'
*                                 Length   : 5 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Same as above, but this time
*        the label is HI2 and the field is 10 bytes long
*
HI2      DC    CL10'Hello'        Address  : X'0000 0005'
*                                 Value    : X'C885939396 4040404040'
*                                 Length   : 10 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Use the Length (L) attribute to define a 4-byte field
*        without label and containing the characters 'XXXYYYZZZ'
*        What happens?
*
         DC    CL4'XXXYYYZZZ'     Address  : X'0000 000F'
*                                 Value    : X'E7 E7 E7 E8' ('XXXY')
*                                 Length   : 4 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Define a field labelled C1 containg the charater '*'
*        repeated 8 times
*
C1       DC    8C'*'              Address  : X'0000 0013'
*                                 Value    : X'5C5C5C5C 5C5C5C5C'
*                                 Length   : 8 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Define a field labelled C2 containg 8 charaters '*'
*
C2       DC    C'********'        Address  : X'0000 001B'
*                                 Value    : X'5C5C5C5C 5C5C5C5C'
*                                 Length   : 8 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Define a 2-byte field without label
*        repeated 3 times and
*        containing one charater '*'
*
         DC    3CL2'*'            Address  : X'0000 0023'
*                                 Value    : X'5C40 5C40 5C40'
*                                 Length   : 6 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Define a field labelled X1, containing hexadecimal A000
*
X1       DC    X'A000'            Address  : X'0000 0029'
*                                 Value    : X'A000'
*                                 Length   : 2 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Define a halfword labelled H1,
*        containing decimal -24576
*
*        Q2. Is it the same as X1?
*
H1       DC    H'-24576'          Address  : X'0000 002C' (aligned)
*                                 Value    : X'A000'
*                                 Length   : 2 bytes
*                                 Alignment: Halfword boundary
*
*                                 Should start on a 'multiple of 2'
*                                 or 'even' memory address!
*                                 (..0,..2,..4,..8,..A,..C,..E)
*
*                                 For that, the assembler may need to
*                                 previouly allocate 1 empty byte
*                                 (ie. X'00') to align the field
*
*  --->  Define a field labelled X2, containing hexadecimal 1A2B
*
X2       DC    X'1A2B'            Address  : X'0000 002E'
*                                 Value    : X'1A2B'
*                                 Length   : 2 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Define a bit string labelled B2, with the same contents as X2
*
B2       DC    B'0001 1010 0010 1011'
*                                 Address  : X'0000 0030'
*                                 Value    : X'1A2B'
*                                 Length   : 2 bytes
*                                 Alignment: None (byte boundary)
*
*  --->  Define a one-byte bit string labelled B3,
*        containing B'1111 0000' and aligned on fullword boundary
*
*        Enter your instruction here (for the fullword alignment)
*
         DC    0F                 Address  : X'0000 0034' (aligned)
*                                 Value    : None!
*                                 Length   : None!
*                                 Alignment: Fullword boundary
*
*                                 Should start on a 'multiple of 4'
*                                 memory address! (..0,..4,..8,..C)
*
*                                 For that, the assembler may need to
*                                 previouly allocate from 1 to 3 empty
*                                 bytes (ie. X'00' to X'000000')
*                                 to align the field
*
*        Enter your instruction here (for the definition)
*
B3       DC    B'1111 0000'       Address  : X'0000 0034' (same)
*                                 Value    : X'F0'
*                                 Length   : 1 bytes
*                                 Alignment: None (byte boundary)
*
*---------------------------------------------------------------------*
         END
