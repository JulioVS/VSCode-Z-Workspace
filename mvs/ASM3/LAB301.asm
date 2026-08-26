*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  1. Submit this JCL unchanged and check the results.
*
*
*  --->  2. The program doesn't use JAS/BAS to call DOUBLE.
*           Scroll down and follow the instructions to change the code
*           to use JAS/BAS.
*
*
*  --->  3. Submit the job and check that the results are the same.
*
*---------------------------------------------------------------------*
LAB301   CSECT
*
R1       EQU   1                  Subroutine arguments
R4       EQU   4                  SALARY before doubling
R5       EQU   5                  SALARY after doubling
R6       EQU   6                  TAX before doubling
R7       EQU   7                  TAX after doubling
R10      EQU   10                 Subroutine return
R12      EQU   12                 Base register
R14      EQU   14                 Program return
*---------------------------------------------------------------------*
         LARL  R12,LAB301         Load the address of LAB301 into R12
         USING LAB301,R12         Use R12 as base register
*---------------------------------------------------------------------*
         L     R4,SALARY          R4: SALARY before doubling
         L     R1,SALARY          R1: SALARY (1024, X'400')
*
*  --->  Change the code below so that it uses JAS or BAS to call
*        DOUBLE. Remove any code that is no longer necessary.
*
         JAS   R10,DOUBLE         Call soubroutine
         ST    R1,SALARY          Update SALARY (2048, X'800')
*
         L     R5,SALARY          R5: SALARY after doubling
*
         L     R6,TAX             R6: TAX before doubling
         L     R1,TAX             R1: TAX (64, X'40')
*
*  --->  Change the code below so that it uses JAS or BAS to call
*        DOUBLE. Remove any code that is no longer necessary.
*
         BAS   R10,DOUBLE         Call subroutine
         ST    R1,TAX             Update TAX (128, X'80')
*
         L     R7,TAX             R7: TAX after doubling
*---------------------------------------------------------------------*
         DC    H'0'               Invalid Opcode - Abend S0C1
*---------------------------------------------------------------------*
*
*  --->  Subroutine: DOUBLE
*
*        - Input:                 Fullword Integer in R1
*        - Process:               Double the value in R1
*        - Output:                Fullword Integer in R1
*        - Return address:        R10
*
DOUBLE   AR    R1,R1              Add R1 to itself
         BR    R10                Return to caller
*---------------------------------------------------------------------*
         DS    0D                 Align to doubleword
SALARY   DC    F'1024'            (X'400')
TAX      DC    F'64'              (X'40')
*---------------------------------------------------------------------*
         END
