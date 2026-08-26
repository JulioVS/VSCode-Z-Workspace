*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  1. Scroll down and follow the instructions to change this
*           program.
*
*  --->  2. Submit this job to assemble and link CALC1.
*
*  --->  3. Submit PROG1. PROG1 will call CALC1 and show the result
*           in its return code.
*
*---------------------------------------------------------------------*
CALC1    CSECT
*
R1       EQU   1                  Address of fullword integer
R2       EQU   2                  Work
R12      EQU   12                 Base
R13      EQU   13                 Save area
R14      EQU   14                 Return address
R15      EQU   15                 Entry point / return code
*
*  --->        Input:             Fullword pointed to by R1.
*              Process:           Double the value in the fullword.
*              Output:            Updated fullword.
*
*---------------------------------------------------------------------*
*
*  --->  Replace the instruction below with the SAVE macro.
*
         SAVE  (14,12)            Save caller's registers
         LARL  R12,CALC1          Load the address of CALC1 into R12
         USING CALC1,R12          Use R12 as base register
*
         LA    R15,SAVEAREA       R15 temporarily points to save area
         ST    R15,8(,R13)        Caller's save area points to mine
         ST    R13,SAVEAREA+4     My save area points to caller's
         LR    R13,R15            R13 points to my save area
*---------------------------------------------------------------------*
         L     R2,0(,R1)          Load the fullword
         AR    R2,R2              Double the value
         ST    R2,0(,R1)          Update the fullword
*---------------------------------------------------------------------*
         L     R13,SAVEAREA+4     Reload address of caller's area
*
*  --->  Replace the two instructions below with the RETURN macro.
*
         RETURN (14,12)           Return to caller
*---------------------------------------------------------------------*
SAVEAREA DC    18F'0'
*---------------------------------------------------------------------*
         END
