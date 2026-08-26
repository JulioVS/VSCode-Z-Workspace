*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  1. Submit this job without making any changes, then examine
*           the resulting Assembler error.
*
*  --->  2. Scroll down to Steps 1 and 2 below and follow the
*           instructions to fix the problem.
*           (Note Step 1 is AFTER Step 2 in the code)
*
*---------------------------------------------------------------------*
LAB107   CSECT
*---------------------------------------------------------------------*
         LARL  12,LAB107          Load base register
         USING LAB107,12          Use R12 as base
*---------------------------------------------------------------------*
         LA    4,TAB1             Load address of TAB1 into R4
*
*  --->  Step 2. Change the instruction below to load the CONTENTS of
*                the field you defined in step 1.
*
         L     5,ATAB2            Load address of TAB2 into R5
*---------------------------------------------------------------------*
         L     15,0(,5)           RC=1, loaded from TAB2
         BR    14
*---------------------------------------------------------------------*
*
*  --->  Step 1. Define the address of TAB2:
*
ATAB2    DC    A(TAB2)            Address of TAB2!
*
TAB1     DC    2000F'0'           Array of 2.000 fullwords
TAB2     DC    2000F'1'           Another 2.000 fullwords
*---------------------------------------------------------------------*
         END
