*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB503   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         STM   14,12,12(13)       Save caller's registers
*
         LARL  12,LAB503          Load the address of LAB503 in R12
         USING LAB503,12          Use R12 as base register
*
         LA    15,SAVEAREA        R15 temporarily points to my sv area
         ST    15,8(,13)          Caller's save area points to mine
         ST    13,SAVEAREA+4      My save area points to caller's
         LR    13,15              R13 points to my save area
*---------------------------------------------------------------------*
         MVC   Line,Space         Clear the print line
*---------------------------------------------------------------------*
* Part 1:
*---------------------------------------------------------------------*
*
*  --->  Copy the characters 'Unit_Price' to Out_name
*        Out_name is 11 characters long and 'Unit_Price' is 10
*        Code an instruction that copies 10 characters
*        Format Unit_Price in Out_val using the pattern Patt52
*
         MVC   Out_name(10),=C'Unit_Price'
         MVC   Out_val,Patt52
         ED    Out_val,Unit_Price
*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
*  --->  Print Quantity's name and value:
*        Copy the characters 'Quantity' to Out_name
*        Out_name is 11 characters long and 'Quantity' is 8
*        Code an instruction that copies 8 characters
*        Format Quantity in Out_val using the pattern Patt20
*
         MVC   Out_name(8),=C'Quantity'
         MVC   Out_val,Patt20
         ED    Out_val,Quantity
*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
*  --->  Print Tax_Rate's name and value:
*        Copy the characters 'Tax_Rate' to Out_name
*        Out_name is 11 characters long and 'Tax_Rate' is 8
*        Code an instruction that copies 8 characters
*        Format Tax_Rate in Out_val using the pattern Patt22
*
         MVC   Out_name(8),=C'Tax_Rate'
         MVC   Out_val,Patt22
         ED    Out_val,Tax_Rate
*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
*---------------------------------------------------------------------*
* Part 2:
*---------------------------------------------------------------------*
*
*  --->  Copy Unit_Price to Gross_Price
*        Multiply Gross_Price * Quantity (result in Gross_Price)
*
         ZAP   Gross_Price,Unit_Price
         MP    Gross_Price,Quantity
*
*  --->  Print Gross_Price's name and value:
*        Copy the characters 'Gross_Price' to Out_name
*        Format Gross_Price in Out_val using the pattern Patt52
*
         MVC   Out_name,=C'Gross_Price'
         MVC   Out_val,Patt52
         ED    Out_val,Gross_Price
*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
*---------------------------------------------------------------------*
* Part 3:
*---------------------------------------------------------------------*
*
*  --->  First, copy Gross_Price to Net_Price
*        Multiply Net_Price * Tax_Rate (result in Net_Price)
*
         ZAP   Net_Price,Gross_Price
         MP    Net_Price,Tax_Rate
*
*  --->  After multiplication, Net_Price is 115.0952
*        Round Net_Price to 115.10 (standard rounding)
*
         SRP   Net_Price,64-2,5
*
*  --->  Print Net_Price's name and value:
*        Copy the characters 'Net_Price' to Out_name
*        Out_name is 11 characters long and 'Net_Price' is 9
*        Code an instruction that copies 9 characters
*        Format Net_Price in Out_val using the pattern Patt52
*
         MVC   Out_name(9),=C'Net_Price'
         MVC   Out_val,Patt52
         ED    Out_val,Net_Price
*
         LA    1,Output           R1 points to print record
         CALL  PUT1               Call print routine
         MVC   Line,Space         Clear the print line
*
*---------------------------------------------------------------------*
Return   L     13,SAVEAREA+4      Restore R13 (caller's save area)
         LM    14,12,12(13)       Restore caller's registers
         LHI   15,0               Set return code to 0
         BR    14                 Return to caller
*---------------------------------------------------------------------*
*
Unit_Price     DC PL5'11.89'
Quantity       DC PL2'8'
Tax_Rate       DC PL2'1.21'
Gross_Price    DC PL5'0.00'       Unit_Price  * Quantity
Net_Price      DC PL5'0.00'       Gross_Price * Tax_Rate
*
Patt52   DC    X'40 20 202020 202120 4B 2020'
Patt20   DC    X'40 40 404040 404040 202020'
Patt22   DC    X'40 404040 404040 20 4B 2020'
*
Output   DS    0CL121             Print record
Space    DC    C' '               Print control (ignore for now)
Line     DS    0CL120             Print line
         DC    CL10' '
Out_name DS    CL11               Field name
         DC    CL10' '
Out_val  DS    CL11               Field value (size of pattern)
         DC    CL78' '
*
*---------------------------------------------------------------------*
SAVEAREA DS    18F                Standard register save area
*---------------------------------------------------------------------*
         END
