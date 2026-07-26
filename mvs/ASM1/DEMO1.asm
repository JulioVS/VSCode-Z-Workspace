*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
DEMO1    CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         LARL  12,DEMO1           Load the address of DEMO1 in R12
         USING DEMO1,12           Use R12 as base register
         LH    3,Int1             Load Int1 into R3
         LR    15,3               Copy R3 to R15 (sets return code)
         BR    14                 End program (return to caller)
*---------------------------------------------------------------------*
*
*  --->  1. Submit this unchanged. You should see this message when the
*           job ends: "DEMO1 ENDED AT ESSMVS1 MAXCC=0010"
*           Note 0010 is the content of R15
*
*  --->  2. Change the number to other small (less than 100)
*           number and resubmit a few times.
*
*        Optional experiments:
*
*  --->  3. What do you see when the number is 4095, 4096, or 4097?
*           Why?
*
*  --->  4. What do you see when the number is -1 or -2? Why?
*
*---------------------------------------------------------------------*
Int1     DC    H'-1'              Try, 95, 4095, 4096, 4097, -1, -2
*---------------------------------------------------------------------*
         END
