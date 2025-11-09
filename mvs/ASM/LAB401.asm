*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB401   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         STM   14,12,12(13)       Save caller's registers
*
         LARL  12,LAB401          Load the address of LAB401 in R12
         USING LAB401,12          Use R12 as base register
*
         LA    15,SAVEAREA        R15 temporarily points to my sv area
         ST    15,8(,13)          Caller's save area points to mine
         ST    13,SAVEAREA+4      My save area points to caller's
         LR    13,15              R13 points to my save area
*---------------------------------------------------------------------*
*
*        Copy Employee fields to Line for printing
*
*  --->  Copy Employee name to the corresponding print line field:
*
         MVC   Out_name,Emp_name
*
*  --->  Copy Employee number to the corresponding print line field:
*
         MVC   Out_num,Emp_num
*
*  --->  ...and the same for Employee date of birth:
*
         MVC   Out_DOB,Emp_DOB
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
Employee DC    0CL34              Employee:
Emp_name DC    CL20'Joan Smith'    Name
Emp_num  DC    CL6'007777'         Number
Emp_DOB  DC    0CL8                Date of Birth:
DOB_yyyy DC    C'2001'              Year
DOB_mm   DC    C'11'                Month
DOB_dd   DC    C'25'                Day
*
Output   DS    0CL121             Print record
Space    DC    C' '               Print control (ignore for now)
Line     DS    0CL120             Print line
         DC    CL10' '
Out_name DS    CL20               Employee name
         DC    CL10' '
Out_num  DS    CL6                Employee number
         DC    CL10' '
Out_DOB  DS    CL8                Employee date of birth
         DC    CL56' '
*
*---------------------------------------------------------------------*
SAVEAREA DS    18F                Standard register save area
*---------------------------------------------------------------------*
         END
