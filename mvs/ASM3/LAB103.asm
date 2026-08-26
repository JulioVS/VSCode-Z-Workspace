*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  Review the code below, then submit this job without making any
*        changes.
*
*---------------------------------------------------------------------*
LAB103   CSECT
*
*  --->  Enter a LOAD ADDRESS instruction that loads decimal 7
*        into R4.
*
         LA    4,7
*
*  --->  Enter a LOAD ADDRESS instruction that loads decimal 4095
*        into R5.
*
         LA    5,4095
*
*  --->  Enter a LOAD ADDRESS instruction that loads decimal 4096
*        into R6.
*
         LAY   6,4096
*
*  --->  Enter a LOAD ADDRESS instruction that loads decimal 65535
*        into R7.
*
         LAY   7,65535
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid Opcode - Abend S0C1
*---------------------------------------------------------------------*
         END
