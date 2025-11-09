*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB103   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         LARL  12,LAB103          Load the address of LAB103 in R12
*        000                      Instruct : X'C0C0 0000 0000'
*        C00                      Length   : 3 Halfwords (6 bytes)
         USING LAB103,12          Use R12 as base register
*---------------------------------------------------------------------*
* Part 1: Code LONG DISPLACEMENT instructions to:
*---------------------------------------------------------------------*
*
*  --->  Load the doubleword labelled DW1 into R2

         LG    2,DW1              Instruct : X'E320 C038 0004'
*        006     038              Length   : 3 Halfwords  (6 bytes)
*        E304                     R2  --->   X'0000 0017 4876 E800'
*
*  --->  Load the fullword labelled F1 into R3 (64-bit)
*
         LGF   3,F1               Instruct : X'E330 C040 0014'
*        00C     040              Length   : 3 Halfwords  (6 bytes)
*        E314                     R3  --->   X'FFFF FFFF FFFF FFFF'
*
*  --->  Load the halfword labelled H1 into R4 (64-bit)
*
         LGH   4,H1               Instruct : X'E340 C044 0015'
*        012     044              Length   : 3 Halfwords  (6 bytes)
*        E315                     R4  --->   X'FFFF FFFF FFFF 8000'
*
*---------------------------------------------------------------------*
* Part 2: Code RELATIVE ADDRESSING instructions to:
*---------------------------------------------------------------------*
*
*  --->  Load the doubleword labelled DW1 into R5 (64-bit)
*
         LGRL  5,DW1              Instruct : X'C458 0000 0010' (Hwds!)
*        018     038              Length   : 3 Halfwords  (6 bytes)
*        C48                      R5  --->   X'0000 0017 4876 E800'
*
*  --->  Load the fullword labelled F1 into R6 (64-bit)
*
         LGFRL 6,F1               Instruct : X'C46C 0000 0011' (Hwds!)
*        01E     040              Length   : 3 Halfwords  (6 bytes)
*        C4C                      R6  --->   X'FFFF FFFF FFFF FFFF'
*
*  --->  Load the halfword labelled H1 into R7 (64-bit)
*
         LGHRL 7,H1               Instruct : X'C474 0000 0010' (Hwds!)
*        024     044              Length   : 3 Halfwords  (6 bytes)
*        C44                      R7  --->   X'FFFF FFFF FFFF 8000'
*
*---------------------------------------------------------------------*
* Part 3: Code IMMEDIATE OPERAND instructions to:
*---------------------------------------------------------------------*
*
*  --->  Load a fullword containing -131072 into R8 (64-bit)
*
         LGFI  8,-131072          Instruct : X'C081 FFFE 0000'
*        02A                      Length   : 3 Halfwords (6 bytes)
*        C01                      R8  --->   X'FFFF FFFF FFFE 0000'
*
*  --->  Load a halfword containing 0 into R9 (64-bit)
*
         LGHI  9,0                Instruct : X'A799 0000'
*        030                      Length   : 2 Halfwords (4 bytes)
*        A79                      R9  --->   X'0000 0000 0000 0000'
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid opcode causes abend S0C1
*        034                      Value    : X'0000'
*                                 Length   : 1 Halfword   (2 bytes)
*---------------------------------------------------------------------*
*
*  --->  Define a doubleword labelled DW1, containing decimal
*        100,000,000,000
*
DW1      DC    FD'100000 000000'  Value    : X'0000 0017 4876 E800'
*        038   (dw/al)            Length   : 1 Doubleword (8 bytes)
*                                 Alignment: Doubleword boundary
*
*  --->  Define a fullword labelled F1, containing decimal -1
*
F1       DC    F'-1'              Value    : X'FFFF FFFF'
*        040                      Length   : 1 Fullword   (4 bytes)
*                                 Alignment: Fullword boundary
*
*  --->  Define a halfword labelled H1, containing decimal -32768
*
H1       DC    H'-32768'          Address  : X'0000 0014'
*        044                      Value    : X'8000'
*                                 Length   : 1 Halfword   (2 bytes)
*                                 Alignment: Halfword boundary
*
*---------------------------------------------------------------------*
         END
