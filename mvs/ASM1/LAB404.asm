*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB404   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         STM   14,12,12(13)       Save caller's registers
*
         LARL  12,LAB404          Load the address of LAB404 in R12
         USING LAB404,12          Use R12 as base register
*
         LA    15,SAVEAREA        R15 temporarily points to my sv area
         ST    15,8(,13)          Caller's save area points to mine
         ST    13,SAVEAREA+4      My save area points to caller's
         LR    13,15              R13 points to my save area
*---------------------------------------------------------------------*
*
*        For this lab, you must check if Emp_MGR is 'Y'
*        - If it is, print 'Manager' at Line+70
*        - If not, leave Line+70 blank
*
         MVC   Line+10(L'Emp_name),Emp_name
         MVC   Line+40(L'Emp_num),Emp_num
*
         MVC   Line+50(L'DOB_yyyy),DOB_yyyy
         MVI   Line+54,C'-'
         MVC   Line+55(L'DOB_mm),DOB_mm
         MVI   Line+57,C'-'
         MVC   Line+58(L'DOB_dd),DOB_dd
*
*  --->  Enter your instruction here (compare Emp_MGR with 'Y')
*
         CLI   Emp_MGR,C'Y'
*
*  --->  Enter your instruction here (branch/jump to Return if not)
*
         JNE   Return
*
*  --->  Enter your instruction here (copy 'Manager' to Line+70)
*
         MVC   Line+70(7),=C'Manager'
*
*---------------------------------------------------------------------*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
*---------------------------------------------------------------------*
Return   L     13,SAVEAREA+4      Restore R13 (caller's save area)
         LM    14,12,12(13)       Restore caller's registers
         LHI   15,0               Set return code to 0
         BR    14                 Return to caller
*---------------------------------------------------------------------*
*
Employee DC    0CL35              Employee:
Emp_name DC    CL20'Joan Smith'    Name
Emp_num  DC    CL6'007777'         Number
Emp_DOB  DC    0CL8                Date of Birth:
DOB_yyyy DC    C'2001'              Year
DOB_mm   DC    C'11'                Month
DOB_dd   DC    C'25'                Day
Emp_MGR  DC    C'Y'                Employee is a manager
*
Output   DS    0CL121             Print record
Space    DC    C' '               Print control (ignore for now)
Line     DS    0CL120             Print line
         DC    120C' '            Initial print line contents
*
*---------------------------------------------------------------------*
SAVEAREA DS    18F                Standard register save area
*---------------------------------------------------------------------*
         END
