*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  Review the code below, then submit this job without making any
*        changes.
*
*---------------------------------------------------------------------*
LAB102   CSECT
*
*  --->  Replace the comment line below by the Assembler instruction
*        that sets the AMODE to 64:
*
LAB102   AMODE 64
*
*  --->  Replace the comment line below by the Assembler instruction
*        that sets the RMODE to 31:
*
LAB102   RMODE 31
*---------------------------------------------------------------------*
         LARL  12,LAB102          Load base register
         USING LAB102,12          Use R12 as base
*---------------------------------------------------------------------*
         LA    4,FW100            Address of FW100 in R4
         LAY   5,FW100            Address of FW100 in R5
         LARL  6,FW100            Address of FW100 in R6
         L     7,FW100            Load FW100 into R7
*---------------------------------------------------------------------*
         DC    H'0'               Invalid Opcode - Abend S0C1
*---------------------------------------------------------------------*
FW100    DC    F'100'
*---------------------------------------------------------------------*
         END
