*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  Submit this job unchanged, then follow the instruction in the
*        Exercise Guide.
*
*        This is to check the contents of TGT before MVCL.
*
*  --->  Scroll down and follow the instructions to write the code
*        that clears TGT.
*
*  --->  Submit the job again and see the Exercise Gide for how to
*        check the results.
*
*---------------------------------------------------------------------*
LAB502   CSECT
*
R0       EQU   0                  MVCL source address (not used)
R1       EQU   1                  MVCL source length  (zero) + pad byte
R8       EQU   8                  MVCL target address
R9       EQU   9                  MVCL target length
R12      EQU   12                 Base
R13      EQU   13                 Save area
R14      EQU   14                 Return to caller
R15      EQU   15                 Entry point / Return code
*---------------------------------------------------------------------*
         STM   R14,R12,12(R13)    Save caller's registers
         LARL  R12,LAB502         Load the address of LAB502 into R12
         USING LAB502,R12         Use R12 as base register
*
         LA    R15,SAVEAREA       R15 temporarily points to save area
         ST    R15,8(,R13)        Caller's save area points to mine
         ST    R13,SAVEAREA+4     My save area points to caller's
         LR    R13,R15            R13 points to my save area
*---------------------------------------------------------------------*
*
*  --->  Code the instruction to set the source address to zero in R0.
*
         LHI   R0,0
*
*  --->  Code the instruction to set the source length to zero in R1.
*
         LHI   R1,0
*
*  --->  Code the instruction to insert PAD into R1.
*
         ICM   R1,B'1000',PAD
*
*  --->  Code the instruction to load the address of TGT into R8.
*
         LA    R8,TGT
*
*  --->  Code the instruction to load the length of TGT into R9.
*
         LHI   R9,8000
*
*  --->  Code the instruction to copy SRC to TGT.
*
         MVCL  R8,R0
*
*---------------------------------------------------------------------*
         DC    H'0'               Abend S0C1
*---------------------------------------------------------------------*
RETURN   DS    0H                 Branch to here for normal return
         L     R13,SAVEAREA+4     Point to caller's save area
         RETURN (14,12),RC=0      Restore caller's regs and return
*---------------------------------------------------------------------*
         DS    0D
SAVEAREA DC    18F'0'    Area for callee to save and restore my regs
         DC    C'PAD'             Dump eyecatcher
PAD      DC    C' '               Pad byte
         DC    0F,X'44444444'     (Align) Dump eyecatcher
TGT      DC    8000C'-'           Target string
         DC    X'55555555'        Dump eyecatcher
*---------------------------------------------------------------------*
         END
