*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  You'll make changes to the program data, not the instructions.
*
*  --->  Review the code, then scroll down to Program data and follow
*        the lab instructions to define the translate table.
*
*---------------------------------------------------------------------*
LAB503   CSECT
*
R1       EQU   1                  Print line
R12      EQU   12                 Base
R13      EQU   13                 Save area
R14      EQU   14                 Return to caller
R15      EQU   15                 Entry point / Return code
*---------------------------------------------------------------------*
         STM   R14,R12,12(R13)    Save caller's registers
         LARL  R12,LAB503         Load the address of LAB503 into R12
         USING LAB503,R12         Use R12 as base register
*
         LA    R15,SAVEAREA       R15 temporarily points to save area
         ST    R15,8(,R13)        Caller's save area points to mine
         ST    R13,SAVEAREA+4     My save area points to caller's
         LR    R13,R15            R13 points to my save area
*---------------------------------------------------------------------*
         LA    R1,Output          Print R1 to output record
         CALL  PUT1               Print line with ASCII number

         TR    NUMBER,EBCDIC      Convert ASCII to EBCDIC

         LA    R1,Output          Point R1 to output record
         CALL  PUT1               Print line (now EBCDIC and readable)
*---------------------------------------------------------------------*
RETURN   DS    0H                 Branch to here for normal return
         L     R13,SAVEAREA+4     Point to caller's save area
         RETURN (14,12),RC=0      Restore caller's regs and return
*---------------------------------------------------------------------*
         DS    0D
SAVEAREA DC    18F'0'    Area for callee to save and restore my regs
*
*  --->  Define a 256-byte field labeled EBCDIC with 256 '?' EBCDIC
*        characters.
*
EBCDIC   DC    256C'?'
*
*  --->  Change the location counter to the position of ASCII
*        character '0' in EBCDIC.
*
         ORG   EBCDIC+CA'0'
*
*  --->  Define all the EBCDIC numeric characters from '0' to '9'.
*
         DC    C'0123456789'
*
*  --->  Reset the location counter to the next available position
*        (the byte following the end of EBCDIC).
*
         ORG   ,
*
Output   DS    0CL121             Structure for output line
         DC    C' '               Printer control
Line     DC    CL120' '           Printable line
         ORG   Line
         DC    C'NUMBER: '
NUMBER   DC    CA'3538'           ASCII 3538
         ORG   ,
*---------------------------------------------------------------------*
         END
