*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  1. Scroll down and follow the instructions to change this
*           program.
*
*  --->  2. Submit this job.  PROG1 will call CALC1 and show the
*           result in its return code.
*
*---------------------------------------------------------------------*
PROG1    CSECT
*
R0       EQU   0
R1       EQU   1                  Address of fullword integer
R2       EQU   2                  Work
R12      EQU   12                 Base
R13      EQU   13                 Save area
R14      EQU   14                 Return address
R15      EQU   15                 Entry point / return code
*---------------------------------------------------------------------*
*
*  --->  Replace the instruction below with the SAVE macro.
*
         SAVE  (14,12)            Save caller's registers
         LARL  R12,PROG1          Load the address of PROG1 into R12
         USING PROG1,R12          Use R12 as base register
*
         LA    R15,SAVEAREA       R15 temporarily points to save area
         ST    R15,8(,R13)        Caller's save area points to mine
         ST    R13,SAVEAREA+4     My save area points to caller's
         LR    R13,R15            R13 points to my save area
*---------------------------------------------------------------------*
         LA    R1,F1              Point R1 to the fullword
*
*  --->  Replace the two instructions below with the CALL macro.
*
         CALL  CALC1              Call CALC1
*---------------------------------------------------------------------*
         L     R15,F1             Set result as return code
         L     R13,SAVEAREA+4     Reload address of caller's area
*
*  --->  Replace the instructions below with a RETURN macro that
*        passes the return code in R15.
*
         RETURN (14,12),RC=(15)   Return to caller
*---------------------------------------------------------------------*
SAVEAREA DC    18F'0'
F1       DC    F'100'
*
*  --->  Delete this, as it is not needed when we use CALL.
*
*---------------------------------------------------------------------*
         END
