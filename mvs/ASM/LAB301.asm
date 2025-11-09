*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB301   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         LARL  12,LAB301          Load the address of LAB301 in R12
         USING LAB301,12          Use R12 as base register
*---------------------------------------------------------------------*
*
*  --->  Compare R2 with the fullword at F55
*        then branch to Step2 if R2 > F55
*
Step1    L     2,F100
*
         C     2,F55
         BH    Step2
*
         LHI   15,1
         B     Return
*
*  --->  Compare R3 with the halfword at H1000
*        then branch to Step3 if R3 < H1000
*
Step2    LHI   3,0
*
         CH    3,H1000
         BL    Step3
*
         LHI   15,2
         B     Return
*
*  --->  Compare R4 with R5
*        then branch to Step4 if R4 = R5
*
Step3    L     4,F55
         LH    5,H55
*
         CR    4,5
         BE    Step4
*
         LHI   15,3
         B     Return
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
