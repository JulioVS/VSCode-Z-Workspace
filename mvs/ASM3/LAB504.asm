*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  You'll make changes to the program data, not the instructions.
*
*  --->  Review the code, then scroll down to Program data and follow
*        the lab instructions to define the table for TRANSLATE AND
*        TEST.
*
*---------------------------------------------------------------------*
LAB504   CSECT
*
R1       EQU   1                  Print line
R12      EQU   12                 Base
R13      EQU   13                 Save area
R14      EQU   14                 Return to caller
R15      EQU   15                 Entry point / Return code
*---------------------------------------------------------------------*
         STM   R14,R12,12(R13)    Save caller's registers
         LARL  R12,LAB504         Load the address of LAB504 into R12
         USING LAB504,R12         Use R12 as base register
*
         LA    R15,SAVEAREA       R15 temporarily points to save area
         ST    R15,8(,R13)        Caller's save area points to mine
         ST    R13,SAVEAREA+4     My save area points to caller's
         LR    R13,R15            R13 points to my save area
*---------------------------------------------------------------------*
         TRT   NUMBER,NUMERIC     Is NUMBER valid numeric EBCDIC?
         JZ    PRINT

         MVC   VALID,=C'INVALID: '  NUMBER was invalid

PRINT    LA    R1,Output          Point R1 to output record
         CALL  PUT1               Print line (now EBCDIC and readable)
*---------------------------------------------------------------------*
RETURN   DS    0H                 Branch to here for normal return
         L     R13,SAVEAREA+4     Point to caller's save area
         RETURN (14,12),RC=0      Restore caller's regs and return
*---------------------------------------------------------------------*
         DS    0D
SAVEAREA DC    18F'0'    Area for callee to save and restore my regs
*
*  --->  Define a 256-byte field labeled NUMERIC with any non-zero
*        value.
*
NUMERIC  DC    256C'-'
*
*  --->  Change the location counter to the position of EBCDIC
*        character '0' in NUMERIC.
*
         ORG   NUMERIC+C'0'
*
*  --->  Define 10 bytes with X'0'. for characters '0' to '9'.
*
         DC    10X'00'
*
*  --->  Reset the location counter to the next available position
*        (the byte following the end of NUMERIC).
*
         ORG   ,
*
Output   DS    0CL121             Structure for output line
         DC    C' '               Printer control
Line     DC    CL120' '           Printable line
         ORG   Line
VALID    DC    C'VALID:   '
NUMBER   DC    C'3538'            Valid EBCDIC numeric
         ORG   ,
*---------------------------------------------------------------------*
         END
