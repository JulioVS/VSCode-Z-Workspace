*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  1. Submit this JCL unchanged and check the contents of R4/R5.
*
*  --->  2. Set AMODE to 31 and RMODE to 31 and submit. Check R4 & R5.
*
*  --->  3. Set AMODE to 64 and RMODE to 31 and submit. Check R4 & R5.
*
*  --->  Are the register contents ofR4/R5 different between runs?
*        Why?
*
*---------------------------------------------------------------------*
LAB105   CSECT
*
*  --->  Enter AMODE/RMODE below
*
LAB105   AMODE 64
LAB105   RMODE 31
*
*---------------------------------------------------------------------*
         LFI   4,X'03000000'      R4 = X'03000000'
         LA    4,1(4)             X'03000000' + X'1' = X'03000001'?
         LAY   5,-1               Load -1 into R5 - X'FFFFFFFF'?
*---------------------------------------------------------------------*
         DC    H'0'               Invalid Opcode - Abend S0C1
*---------------------------------------------------------------------*
         END
