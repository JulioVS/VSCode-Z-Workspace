*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  1. Submit this job without making any changes.
*
*  --->  2. Code EQU statements for registers used in the program,
*           and change the instructions to use the equates.
*
*  --->. 3. Submit the job again and check that the generated code
*           is the same.
*
*---------------------------------------------------------------------*
LAB204   CSECT
*
*  --->  This program uses these registers:
*
*              R12   (Base)
*              R4    (TAB1)
*              R5    (TAB2)
*              R14   (Return Address)
*              R15   (Return Code)
*
*  --->  Code the Rx EQU statements, then change the instructions
*        to use the equates.
*
R12      EQU   12
R4       EQU   4
R5       EQU   5
R14      EQU   14
R15      EQU   15
*
*---------------------------------------------------------------------*
*
*  --->  Change the instructions below to use the R12 equate.
*
         LARL  R12,LAB204         Load base register
         USING LAB204,R12         Use R12 as base
*---------------------------------------------------------------------*
*
*  --->  Change the instructions below to use the R4 and R5 equates.
*
         LA    R4,TAB1            Load address of TAB1 into R4
         LA    R5,TAB2            Load address of TAB2 into R5
*
         MVC   0(4,R5),0(R4)      Copy word 1 from TAB1 to TAB2
         MVC   4(4,R5),4(R4)      Copy word 2 from TAB1 to TAB2
         MVC   8(4,R5),8(R4)      Copy word 3 from TAB1 to TAB2
         MVC   12(4,R5),12(R4)    Copy word 4 from TAB1 to TAB2
*
*---------------------------------------------------------------------*
*
*  --->  Change the instructions below to use the R14 and R15 equates.
*
         SR    R15,R15            RC=0
         BR    R14
*---------------------------------------------------------------------*
TAB1     DC    4F'100'            Array of 4 fullwords
TAB2     DS    4F                 Another 4 fullwords
*---------------------------------------------------------------------*
         END
