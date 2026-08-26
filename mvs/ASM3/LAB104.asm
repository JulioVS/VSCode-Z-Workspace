*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  Review the code below, then submit this job without making any
*        changes.
*
*---------------------------------------------------------------------*
LAB104   CSECT
*
*  --->  Enter a LOAD ADDRESS instruction that loads decimal 7
*        into R4.
*
         LA    4,7
*
*  --->  Enter a LOAD ADDRESS instruction that adds decimal 3
*        to R4 and places the result in R5.
*
         LA    5,3(4)
*
*  --->  Enter a LOAD ADDRESS instruction that adds decimal 2
*        to R5 and places the result in R6.
*
         LA    6,2(5)
*
*  --->  Enter a LOAD ADDRESS instruction that subtracts decimal 11
*        from R6 and places the result in R7.
*
         LAY   7,-11(6)
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid Opcode - Abend S0C1
*---------------------------------------------------------------------*
         END
