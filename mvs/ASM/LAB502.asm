*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB502   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         STM   14,12,12(13)       Save caller's registers
*
         LARL  12,LAB502          Load the address of LAB502 in R12
         USING LAB502,12          Use R12 as base register
*
         LA    15,SAVEAREA        R15 temporarily points to my sv area
         ST    15,8(,13)          Caller's save area points to mine
         ST    13,SAVEAREA+4      My save area points to caller's
         LR    13,15              R13 points to my save area
*---------------------------------------------------------------------*
*
         MVC   Out_name,=C'Num1'
         MVC   Out_val,PattN
         ED    Out_val,Num1

         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
         MVC   Out_name,=C'Num2'
         MVC   Out_val,PattN
         ED    Out_val,Num2

         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
         MVC   Out_name,=C'Num3'
         MVC   Out_val,PattN
         ED    Out_val,Num3

         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
*---------------------------------------------------------------------*
*
*  --->  Copy Num1 to Total
*
         ZAP   Total,Num1         Copy Num1 to Total
*
*  --->  Add Num2 to Total
*
         AP    Total,Num2         Add Num2 to Total
*
*  --->  Add Num3 to Total
*
         AP    Total,Num3         Add Num3 to Total
*
*  --->  Format Total as '**nn.nn' in Out_val using the pattern PattT
*
         MVC   Out_val,PattT
         ED    Out_val,Total
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
Num1     DC    PL3'13.82'
Num2     DC    PL3'47.96'
Num3     DC    PL3'2.40'
Total    DS    PL3                Note no initial content
*
PattN    DC    X'40 202120 4B 2020'    Edit pattern for numbers
PattT    DC    X'5C 202120 4B 2020'    Edit pattern for the total
*
Output   DS    0CL121             Print record
Space    DC    C' '               Print control (ignore for now)
Line     DS    0CL120             Print line
         DC    CL10' '
Out_name DS    CL4                Field name ('Num1','Num2','Num3')
         DC    CL10' '
Out_val  DS    CL7                Num1/Num2/Num3/Total printed here
         DC    CL89' '
*
*---------------------------------------------------------------------*
SAVEAREA DS    18F                Standard register save area
*---------------------------------------------------------------------*
         END
