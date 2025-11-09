*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB302   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
*        LARL  12,LAB302          Load the address of LAB302 in R12
*        USING LAB302,12          Use R12 as base register
*---------------------------------------------------------------------*
*
*        This is the solution to LAB301, with the instructions that
*        establish the base register commented out.
*
*        If you submit this job as is, you will get an Assembler error,
*        as many instructions below need a base register.
*
*        Fix the problem by replacing the instructions that fail
*        assembly by others that do not need base registers
*
*        Hint: use RELATIVE ADDRESSING variants of LOAD
*              and JUMP instead of BRANCH*
*
*---------------------------------------------------------------------*
*
*  --->  Compare R2 with the fullword at F55
*        then branch to Step2 if R2 > F55
*
Step1    LRL   2,F100
*
         CRL   2,F55
         JH    Step2
*
         LHI   15,1
         J     Return
*
*  --->  Compare R3 with the halfword at H1000
*        then branch to Step3 if R3 < H1000
*
Step2    LHI   3,0
*
         CHRL  3,H1000
         JL    Step3
*
         LHI   15,2
         J     Return
*
*  --->  Compare R4 with R5
*        then branch to Step4 if R4 = R5
*
Step3    LRL   4,F55
         LHRL  5,H55
*
         CR    4,5
         JE    Step4
*
         LHI   15,3
         J     Return
*
*  --->  Final step
*
Step4    LHI   15,0
*
*---------------------------------------------------------------------*
Return   BR    14
*---------------------------------------------------------------------*
*
F100     DC    F'100'
F55      DC    F'55'
H1000    DC    H'1000'
H55      DC    H'55'
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid opcode causes abend S0C1
*---------------------------------------------------------------------*
         END
