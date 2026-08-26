*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  The lab consists of reviewing the code, you will not be
*        making any changes.
*
*  --->  Instead of writing a print line, we copy the input record
*        unchanged.
*
*  --->  We also use different DDNAME parameters to show how they
*        relate to DD statements in JCL.
*
*---------------------------------------------------------------------*
LAB404   CSECT
*
R12      EQU   12                 Base register
R13      EQU   13                 Register save area
R14      EQU   14                 Return address
R15      EQU   15                 Condition code
*---------------------------------------------------------------------*
         STM   R14,R12,12(R13)    Save caller's registers
         LARL  R12,LAB404         Load the address of LAB404 into R12
         USING LAB404,R12         Use R12 as base register
*
         LA    R15,SAVEAREA       R15 temporarily points to save area
         ST    R15,8(,R13)        Caller's save area points to mine
         ST    R13,SAVEAREA+4     My save area points to caller's
         LR    R13,R15            R13 points to my save area
*---------------------------------------------------------------------*
         OPEN  (EMP_IN,INPUT)     Open input data set
         OPEN  (EMP_OUT,OUTPUT)   Open output data set
*---------------------------------------------------------------------*
Read     GET   EMP_IN,EMP_REC     Read Employee record into EMP_REC
         PUT   EMP_OUT,EMP_REC    Write Employee record from EMP_REC
         B     Read               Loop until no more records
*---------------------------------------------------------------------*
ENDFILE  CLOSE (EMP_IN)           Close input data set
         CLOSE (EMP_OUT)          Close output data set
*---------------------------------------------------------------------*
Return   L     R13,SAVEAREA+4     Reload 13 (caller's save area)
         LM    R14,R12,12(R13)    Restore caller's registers,
         LHI   R15,0              set return code 0, and
         BR    R14                return
*---------------------------------------------------------------------*
SAVEAREA DS    18F
*---------------------------------------------------------------------*
EMP_IN   DCB   DDNAME=EMPIN,                                           X
               DSORG=PS,MACRF=GM,                                      X
               LRECL=80,EODAD=ENDFILE
EMP_OUT  DCB   DDNAME=EMPOUT,LRECL=80,                                 X
               DSORG=PS,MACRF=PM
EMP_REC  DS    CL80               Employee record
*---------------------------------------------------------------------*
         END
