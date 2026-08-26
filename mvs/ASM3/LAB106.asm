*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  1. Submit the job before making any changes and verify that
*           R2 = R3 = R4 = FFFFFFFF_00FFFFFF.
*
*  --->  2. Scroll down and code SAMxx instructions as directed,
*           then submit the job and check the contents of R2/R3/R4.
*
*---------------------------------------------------------------------*
LAB106   CSECT
*
*  --->  No AMODE/RMODE: we are AMODE 24, RMODE 24.
*
*---------------------------------------------------------------------*
         LGHI  2,-1               R2 = FFFFFFFF_FFFFFFFF
         LHI   2,0                R2 = FFFFFFFF_00000000
         LAY   2,-1               R2 = FFFFFFFF_00FFFFFF
*
*  --->  Code the instruction to switch to AMODE 31
*
         SAM31
*
         LGHI  3,-1               R3 = FFFFFFFF_FFFFFFFF
         LHI   3,0                R3 = FFFFFFFF_00000000
         LAY   3,-1               R3 = FFFFFFFF_7FFFFFFF
*
*  --->  Code the instruction to switch to AMODE 64
*
         SAM64
*
         LGHI  4,-1               R4 = FFFFFFFF_FFFFFFFF
         LHI   4,0                R4 = FFFFFFFF_00000000
         LAY   4,-1               R4 = FFFFFFFF_FFFFFFFF
*
         SAM24                    Back to AMODE 24
*---------------------------------------------------------------------*
         DC    H'0'               Invalid Opcode - Abend S0C1
*---------------------------------------------------------------------*
         END
