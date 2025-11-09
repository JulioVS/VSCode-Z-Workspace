*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB101   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         LARL  12,LAB101          Load the address of LAB101 in R12
*        000                      Instruct : X'C0C0 0000 0000'
*        C00                      Length   : 3 Halfwords (6 bytes)
         USING LAB101,12          Use R12 as base register
*---------------------------------------------------------------------*
*        Part 1: "Original" instructions
*---------------------------------------------------------------------*
*
         L     2,=F'170'          Instruct : X'5820 C030'
*        006        030           Length   : 2 Halfwords (4 bytes)
*        58                       R2  --->   X'.... .... 0000 00AA'
*
         LH    3,=H'4095'         Instruct : X'4830 C03C'
*        00A        03C           Length   : 2 Halfwords (4 bytes)
*        48                       R3  --->   X'.... .... 0000 0FFF'
*
         LR    4,3                Instruct : X'1843'
*        00E                      Length   : 1 Halfword  (2 bytes)
*        18                       R4  --->   X'.... .... 0000 0FFF'
*
*---------------------------------------------------------------------*
*        Part 2: Using literal second operands (as shown above),
*                code LONG DISPLACEMENT instructions to:
*---------------------------------------------------------------------*
*
*  --->  Load a fullword containing 187 (X'BB') into R5 low half
*
         LY    5,=F'187'          Instruct : X'E350 C034 0058'
*        010        034           Length   : 3 Halfwords (6 bytes)
*        E358                     R5  --->   X'.... .... 0000 00BB'
*
*  --->  Load a halfword containing 2048 (X'800') into R6 low half
*
         LHY   6,=H'2048'         Instruct : X'E360 C03E 0078'
*        016        03E           Length   : 3 Halfwords (6 bytes)
*        E378                     R6  --->   X'.... .... 0000 0800'
*
*---------------------------------------------------------------------*
*        Part 3: Using literal second operands (as shown above),
*                code RELATIVE ADDRESSING instructions to:
*---------------------------------------------------------------------*
*
*  --->  Load a fullword containing 1024000 (X'FA000') into R7 low half
*
         LRL   7,=F'1024000'      Instruct : X'C47D 0000 000E' (Hwds!)
*        01C        038           Length   : 3 Halfwords (6 bytes)
*        C4D                      R7  --->   X'.... .... 000F A000'
*
*  --->  Load a halfword containing 255 (X'FF') into R8 low half
*
         LHRL  8,=H'255'          Instruct : X'C485 0000 000F' (Hwds!)
*        022        040           Length   : 3 Halfwords (6 bytes)
*        C45                      R8  --->   X'.... .... 0000 00FF'
*
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid opcode causes abend S0C1
*        028                      Value    : X'0000'
*                                 Length   : 1 Halfword  (2 bytes)
*---------------------------------------------------------------------*
*  --->  Assembler begins Literal pool here   (Fullword alignment)
*
*        030   First Fullword Literal
*        ...   ...
*        ...   First Halfword Literal
*        ...   ...
*---------------------------------------------------------------------*
         END
