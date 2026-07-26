*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB203   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         LARL  12,LAB203          Load the address of LAB203 in R12
         USING LAB203,12          Use R12 as base register
*---------------------------------------------------------------------*
* Part 1: Multiplication
*---------------------------------------------------------------------*
*
*        Use instructions that operate on the LOW HALVES OF REGISTERS
*        Set the multiplicand (100) in the R2-R3 register pair
*
*  --->  Load 100 into the multiplicand register
*        (use an IMMEDIATE OPERAND instruction)
*
         LFI   3,100
*
*  --->  Multiply the R2-R3 pair by 3
*        (use a literal for the 3 multiplier)
*
         M     2,=F'3'
*
*---------------------------------------------------------------------*
* Part 2: Division
*---------------------------------------------------------------------*
*
*  --->  Divide the R2-R3 pair by 4 (use a literal for the 4 divisor)
*
         D     2,=F'4'
*
*---------------------------------------------------------------------*
* Part 3: 64-bit multiplication and division
*---------------------------------------------------------------------*
*
*        In this part, we will calculate
*        100,000,000,000 * 3/4 = 75,000,000,000
*
*        Set the multiplicand (100,000,000,000) in R5
*
*  --->  Load 100,000,000,000 into the multiplicand register
*        (use a literal for the second operand)
*
         LG    5,=FD'100 000 000 000'
*
*  --->  Multiply R5 by 3

*        Use MULTIPLY SINGLE to place the result in R5 only
*        (use an IMMEDIATE value for the 3 multiplier)
*
         MSGFI 5,3
*
*  --->  Divide the R4-R5 pair by 4

*        Use DIVIDE SINGLE
*        (use a literal for the 4 divisor)
*
         DSG   4,=FD'4'
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid opcode causes abend S0C1
*---------------------------------------------------------------------*
         END
