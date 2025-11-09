*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB102   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
*  --->  DO NOT establish our base register (do not change these)
*        Note the next two instructions are commented out: the program
*        doesn't have a base register. If you submit the program as is,
*        the assembly fails.
*---------------------------------------------------------------------*
*        LARL  12,LAB102          Load the address of LAB102 in R12
*        USING LAB102,12          Use R12 as base register
*---------------------------------------------------------------------*
* Part 1: Relative addressing
*---------------------------------------------------------------------*
*
*  --->  Replace this instruction by its RELATIVE ADDRESSING equivalent
*
         LRL   2,=F'170'          Instruct : X'C42D 0000 0010' (Hwds!)
*        000        020           Length   : 3 Halfwords (6 bytes)
*        C4D                      R2  --->   X'.... .... 0000 00AA'
*
*  --->  Replace this instruction by its RELATIVE ADDRESSING equivalent
*
         LHRL  3,=H'4095'         Instruct : X'C435 0000 000F' (Hwds!)
*        006        024           Length   : 3 Halfwords (6 bytes)
*        C45                      R3  --->   X'.... .... 0000 0FFF'
*
*  --->  This was left to show that RR instructions do not need
*        a base register
*
         LR    4,3                Instruct : X'1843'
*        00C                      Length   : 1 Halfword  (2 bytes)
*        18                       R4  --->   X'.... .... 0000 0FFF'
*
*---------------------------------------------------------------------*
* Part 2: Immediate operands
*---------------------------------------------------------------------*
*
*  --->  Replace this instruction by its IMMEDIATE OPERAND equivalent
*
         LFI   5,187              Instruct : X'C059 0000 00BB'
*        00E                      Length   : 3 Halfwords (6 bytes)
*        C09                      R5  --->   X'.... .... 0000 00BB'
*
*  --->  Replace this instruction by its IMMEDIATE OPERAND equivalent
*
         LHI   6,2048             Instruct : X'A768 0800'
*        014                      Length   : 2 Halfwords (4 bytes)
*        A78                      R6  --->   X'.... .... 0000 0800'
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid opcode causes abend S0C1
*        018                      Value    : X'0000'
*                                 Length   : 1 Halfword  (2 bytes)
*---------------------------------------------------------------------*
*  --->  Assembler begins Literal pool here   (Fullword alignment)
*
*        020   First Fullword Literal
*        ...   ...
*        ...   First Halfword Literal
*        ...   ...
*---------------------------------------------------------------------*
         END
