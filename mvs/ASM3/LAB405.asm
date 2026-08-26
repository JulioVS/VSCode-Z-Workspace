*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  The lab consists of reviewing the code, you will not be
*        making any changes.
*
*  --->  This program runs in AMODE 31 / RMODE 31.
*        The Binder runs with the option RMODE(SPLIT).
*
*        This means that the resulting program object is in two parts
*        that will be loaded separately when the program runs.
*
*        This program's CSECT will be loaded above the line (RMODE 31)
*        and GET1/PUT1 will be loaded below the line (RMODE 24).
*
*---------------------------------------------------------------------*
LAB405   CSECT
LAB405   AMODE 31
LAB405   RMODE 31
*
R1       EQU   1                  Subroutine arguments
R5       EQU   5                  Employee record
R12      EQU   12                 Base register
R13      EQU   13                 Register save area
R14      EQU   14                 Return address
R15      EQU   15                 Condition code
*
EMPLOYEE DSECT                    Employee record:
EMP_NAME DS    CL20               Name
EMP_NUM  DS    CL6                Number
EMP_DOB  DS    0CL8               Date of birth:
DOB_YYYY DS    CL4                 Year
DOB_MM   DS    CL2                 Month
DOB_DD   DS    CL2                 Day
*---------------------------------------------------------------------*
LAB405   CSECT                    Back to our CSECT
*
         STM   R14,R12,12(R13)    Save caller's registers
         LARL  R12,LAB405         Load the address of LAB405 into R12
         USING LAB405,R12         Use R12 as base register
*
         LA    R15,SAVEAREA       R15 temporarily points to save area
         ST    R15,8(,R13)        Caller's save area points to mine
         ST    R13,SAVEAREA+4     My save area points to caller's
         LR    R13,R15            R13 points to my save area
*
         LA    R5,Input           R5: EMPLOYEE
         USING EMPLOYEE,R5
*---------------------------------------------------------------------*
*
*  --->  Read Employee record from SYSIN.
*
Read     LA    R1,Input           Point R1 to input buffer
         CALL  GET1               Read Employee record from SYSIN
         LTR   R15,R15            End of data?
         BNZ   Return             Yes, return
*
*  --->  Copy Employee fields to print line.
*
         MVC   PRT_NAME,EMP_NAME
         MVC   PRT_NUM,EMP_NUM
         MVC   PRT_YYYY,DOB_YYYY
         MVC   PRT_MM,DOB_MM
         MVC   PRT_DD,DOB_DD
*
*  --->  No need for R5 as base register after here.
*
         DROP  R5
*
         LA    R1,Output          R1: Output record
         CALL  PUT1               Print output record
*
         B     Read               Loop until no more records
*---------------------------------------------------------------------*
Return   L     R13,SAVEAREA+4     Reload 13 (caller's save area)
         LM    R14,R12,12(R13)    Restore caller's registers,
         LHI   R15,0              set return code 0, and
         BR    R14                return
*---------------------------------------------------------------------*
SAVEAREA DS    18F
*---------------------------------------------------------------------*
Input    DS    CL80               Input record
Output   DS    0CL121             Structure for output line
         DC    C' '
Line     DC    CL120' '           Printable line
         ORG   Line
PRT_NAME DS    CL(L'EMP_NAME)
         ORG   Line+30
PRT_NUM  DS    CL(L'EMP_NUM)
         ORG   Line+40
PRT_YYYY DS    CL(L'DOB_YYYY)
         ORG   Line+45
PRT_MM   DS    CL(L'DOB_MM)
         ORG   Line+48
PRT_DD   DS    CL(L'DOB_DD)
         ORG   ,
*---------------------------------------------------------------------*
         END
