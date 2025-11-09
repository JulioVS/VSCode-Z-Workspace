*---------------------------------------------------------------------*
*           GENERALIZED SYSPRINT SUBROUTINE FOR STUDENT LABS
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
PUT1     CSECT
*---------------------------------------------------------------------*
R1       EQU   1
R2       EQU   2
R3       EQU   3
R4       EQU   4
R5       EQU   5
R6       EQU   6
*---------------------------------------------------------------------*
*
         DS    0H                 Ensure location counter
         SAVE  (14,12),,*         Enter
         LR    12,15              Set up addressing
         USING PUT1,12
*
         LA    R2,SAVEAREA        Chain save areas
         ST    R2,8(,13)
         ST    13,4(,R2)
         LR    13,R2
         LR    R6,R1              Save before open
*
         CLI   0(R6),X'F1'        Check for ASA CTL Chan 1
         BE    NOASAFIX
         CLI   0(R6),X'40'        Check for ASA CTL Space 1
         BE    NOASAFIX
         CLI   0(R6),X'F0'        Check for ASA CTL Space 2
         BE    NOASAFIX
         CLI   0(R6),C'+'         Check for ASA CTL NoSpace
         BE    NOASAFIX
         CLI   0(R6),C'-'         Check for ASA CTL Space 3
         BE    NOASAFIX
*
         MVI   0(R6),X'40'        Force Space 1
*
*---------------------------------------------------------------------*
NOASAFIX DS    0H
         TM    SYSPRINT+48,X'10'  Is it already open?
         BO    NOOPEN
         OPEN  (SYSPRINT,OUTPUT)
NOOPEN   DS    0H
         PUT   SYSPRINT,(R6)      And print it
*---------------------------------------------------------------------*
RETURN   DS    0H
         L     13,4(,13)          Get old save area
         RETURN (14,12),RC=0
*---------------------------------------------------------------------*
WORKAREA DC    CL121' '
         DC    C'PRINT ROUTINES - COURSE K3600'
         EJECT
*---------------------------------------------------------------------*
SAVEAREA DS    18F'0'
SYSPRINT DCB   DSORG=PS,MACRF=PM,DDNAME=SYSPRINT,LRECL=121,RECFM=FBA
         LTORG
*---------------------------------------------------------------------*
         END
