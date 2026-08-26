*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  1. Submit this job without making any changes.
*           Check the resulting listing in SDSF (scroll to the end).
*
*  --->  2. Change the instructions that refer to Employee fields so
*           that they use length attributes instead of explicit
*           lengths.
*
*  --->  3. Submit again and check that the listing is the same.
*
*---------------------------------------------------------------------*
LAB206   CSECT
*
R1       EQU   1                  Subroutine arguments
R4       EQU   4                  Items in Employee table
R5       EQU   5                  Employee table
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
*
LAB206   CSECT
*
*---------------------------------------------------------------------*
         STM   R14,R12,12(R13)    Save caller's registers
         LARL  R12,LAB206         Load the address of LAB206 into R12
         USING LAB206,R12         Use R12 as base register
*
         LA    R15,SAVEAREA       R15 temporarily points to save area
         ST    R15,8(,R13)        Caller's save area points to mine
         ST    R13,SAVEAREA+4     My save area points to caller's
         LR    R13,R15            R13 points to my save area
*---------------------------------------------------------------------*
         LHI   R4,EMP_items       R4: items in table
         LA    R5,Employees       R5: EMPLOYEE
*
         USING EMPLOYEE,R5
*
*  --->  Copy Employee fields to print line.
*
*        In the statements that follow, change the first operand
*        lengths by the corresponding DSECT field length attributes
*        (L'field_name)
*
Loop     MVC   Line(L'EMP_NAME),EMP_NAME      Employee name
         MVC   Line+30(L'EMP_NUM),EMP_NUM     Employee number
         MVC   Line+40(L'DOB_YYYY),DOB_YYYY   Employee DOB - year
         MVC   Line+45(L'DOB_MM),DOB_MM       Employee DOB - month
         MVC   Line+48(L'DOB_DD),DOB_DD       Employee DOB - day
*
         LA    R1,Output          R1: Output record
         CALL  PUT1               Print output record
*
         LA    R5,L'Employees(,R5)  Next employee
         BCT   R4,Loop            Loop if more items
*---------------------------------------------------------------------*
         L     R13,SAVEAREA+4     Reload 13 (caller's save area)
         LM    R14,R12,12(R13)    Restore caller's registers.
         LHI   R15,0              Set return code 0, and
         BR    R14                return
*---------------------------------------------------------------------*
         DS    0D                 Align to doubleword
         DC    X'88888888'        Dump eyecatcher
*
SAVEAREA DS    18F
*
EMP_items EQU  8
*
Employees DS   (EMP_items)CL34
         ORG   Employees
*
         DC    CL20'JOAN ALLEN'   NAME
         DC    CL6'111111'        NUMBER
         DC    C'2001'            YEAR
         DC    C'01'              MONTH
         DC    C'21'              DAY
*
         DC    CL20'JANE BAKER'   NAME
         DC    CL6'222222'        NUMBER
         DC    C'2002'            YEAR
         DC    C'02'              MONTH
         DC    C'22'              DAY
*
         DC    CL20'JOHN CLARK'   NAME
         DC    CL6'333333'        NUMBER
         DC    C'2003'            YEAR
         DC    C'03'              MONTH
         DC    C'23'              DAY
*
         DC    CL20'JOEL DAVIS'   NAME
         DC    CL6'444444'        NUMBER
         DC    C'2004'            YEAR
         DC    C'04'              MONTH
         DC    C'24'              DAY
*
         DC    CL20'JACK EVANS'   NAME
         DC    CL6'555555'        NUMBER
         DC    C'2005'            YEAR
         DC    C'05'              MONTH
         DC    C'25'              DAY
*
         DC    CL20'JILL FRANK'   NAME
         DC    CL6'666666'        NUMBER
         DC    C'2006'            YEAR
         DC    C'06'              MONTH
         DC    C'26'              DAY
*
         DC    CL20'JAKE GREEN'   NAME
         DC    CL6'777777'        NUMBER
         DC    C'2007'            YEAR
         DC    C'07'              MONTH
         DC    C'27'              DAY
*
         DC    CL20'JOSS HENRY'   NAME
         DC    CL6'888888'        NUMBER
         DC    C'2008'            YEAR
         DC    C'08'              MONTH
         DC    C'28'              DAY
*
Output   DS    0CL121             Structure for output line
         DC    C' '
Line     DC    CL120' '           Printable line
*---------------------------------------------------------------------*
         END
