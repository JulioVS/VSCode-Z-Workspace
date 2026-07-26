*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB201   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         LARL  12,LAB201          Load the address of LAB201 in R12
*        000                      Instruct : X'C0C0 0000 0000'
*        C00                      Length   : 3 Halfwords (6 bytes)
         USING LAB201,12          Use R12 as base register
*---------------------------------------------------------------------*
* Part 1: "Original" instructions
*---------------------------------------------------------------------*
*
*  --->  Load a fullword containing 40960 (X'A000') into R2 low half
*
         L     2,=F'40960'        Instruct : X'5820 C028'
*        006        028           Length   : 2 Halfwords (4 bytes)
*        58                       R2  --->   X'.... .... 0000 A000'
*
*  --->  Add a fullword containing 2730 (X'AAA') to R2 low half
*              40960+2730=43690 (X'AAAA')
*
         A     2,=F'2730'         Instruct : X'5A20 C02C'
*        00A        02C           Length   : 2 Halfwords (4 bytes)
*        5A                       R2  --->   X'.... .... 0000 AAAA'
*
*  --->  Copy R2 to R3
*
         LR    3,2                Instruct : X'1832'
*        00E                      Length   : 1 Halfwords (2 bytes)
*        18                       R3  --->   X'.... .... 0000 AAAA'
*
*  --->  Subtract a halfword containing 8738 (X'2222') from R3 low half
*              43690-8738=34952 (X'8888')
*
         SH    3,=H'8738'         Instruct : X'4B30 C030'
*        010        030           Length   : 2 Halfwords (4 bytes)
*        4B                       R3  --->   X'.... .... 0000 8888'
*
*---------------------------------------------------------------------*
* Part 2: Same as above, but using IMMEDIATE OPERAND
*---------------------------------------------------------------------*
*
*  --->  Load a fullword containing 40960 (X'A000') into R4 low half
*
         LFI   4,40960            Instruct : X'C049 0000 A000'
*        014                      Length   : 3 Halfwords (6 bytes)
*        C09                      R4  --->   X'.... .... 0000 A000'
*
*  --->  Add a fullword containing 2730 (X'AAA') to R4 low half
*
         AFI   4,2730             Instruct : X'C249 0000 0AAA'
*        01A                      Length   : 3 Halfwords (6 bytes)
*        C29                      R4  --->   X'.... .... 0000 AAAA'
*
*  --->  Copy R4 to R5 (use LR)
*
         LR    5,4                Instruct : X'1854'
*        020                      Length   : 1 Halfwords (2 bytes)
*        18                       R5  --->   X'.... .... 0000 AAAA'
*
*  --->  Subtract a halfword containing 8738 (X'2222') from R5 low half
*
         AHI   5,-8738            Instruct : X'A75A DDDE'
*        022                      Length   : 2 Halfwords (4 bytes)
*        A7A                      R5  --->   X'.... .... 0000 8888'
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid opcode causes abend S0C1
*        026                      Value    : X'0000'
*                                 Length   : 1 Halfword  (2 bytes)
*---------------------------------------------------------------------*
*  --->  Assembler begins Literal pool here   (Fullword alignment)
*
*        028   First Fullword Literal                    (4 bytes)
*        02C   ...
*        030   First Halfword Literal                    (2 bytes)
*        ...   ...
*---------------------------------------------------------------------*
         END
