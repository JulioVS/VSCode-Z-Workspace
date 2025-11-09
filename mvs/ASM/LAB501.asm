*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB501   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         STM   14,12,12(13)       Save caller's registers
*
         LARL  12,LAB501          Load the address of LAB501 in R12
         USING LAB501,12          Use R12 as base register
*
         LA    15,SAVEAREA        R15 temporarily points to my sv area
         ST    15,8(,13)          Caller's save area points to mine
         ST    13,SAVEAREA+4      My save area points to caller's
         LR    13,15              R13 points to my save area
*---------------------------------------------------------------------*
*
*  --->  Copy the characters 'Num1' to Out_name
*        Format Num1 as ' 1382' in Out_val using the pattern PattN
*
         MVC   Out_name,=C'Num1'
         MVC   Out_val,PattN
         ED    Out_val,Num1
*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
*  --->  Copy the characters 'Num2' to Out_name
*        Format Num2 as ' 4796' in Out_val using the pattern PattN
*
         MVC   Out_name,=C'Num2'
         MVC   Out_val,PattN
         ED    Out_val,Num2
*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
*  --->  Copy the characters 'Num3' to Out_name
*        Format Num3 as ' 240' in Out_val using the pattern PattN
*
         MVC   Out_name,=C'Num3'
         MVC   Out_val,PattN
         ED    Out_val,Num3
*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
*
*---------------------------------------------------------------------*
Return   L     13,SAVEAREA+4      Restore R13 (caller's save area)
         LM    14,12,12(13)       Restore caller's registers
         LHI   15,0               Set return code to 0
         BR    14                 Return to caller
*---------------------------------------------------------------------*
*
Num1     DC    PL3'1382'
Num2     DC    PL3'4796'
Num3     DC    PL3'240'
*
PattN    DC    X'40 2020202020'
*
Output   DS    0CL121             Print record
Space    DC    C' '               Print control (ignore for now)
Line     DS    0CL120             Print line
         DC    CL10' '
Out_name DS    CL4                Field name ('Num1','Num2','Num3')
         DC    CL10' '
Out_val  DS    CL6                Num1/Num2/Num3 printed here
         DC    CL90' '
*
*---------------------------------------------------------------------*
SAVEAREA DS    18F                Standard register save area
*---------------------------------------------------------------------*
         END
