*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
LAB202   CSECT ,             COMMA REQUIRED IF COMMENT ON THIS STMT
*---------------------------------------------------------------------*
         LARL  12,LAB202          Load the address of LAB202 in R12
         USING LAB202,12          Use R12 as base register
*---------------------------------------------------------------------*
* Part 1: Causing a overflow exception
*---------------------------------------------------------------------*
*
*  --->  First, we set the PSW program mask to cause an exception
*        if there is an overflow
*
         LHI   0,-1               Set R0 to X'FFFFFFFF'
         SPM   0                  Set PSW program mask
*
*  --->  Load 1,000,000,000 into R2 low half
*
*        LFI   2,1000000000       1,000,000,000   X'3B9A CA00'
*
*  --->  Add R2 low half to itself 4 times
*
*        AR    2,2                2,000,000,000 X'0 7735 9400'
*        AR    2,2                4,000,000,000 X'0 EE6B 2800'
*        AR    2,2                8,000,000,000 X'1 DCD6 5000' ovflw!
*        AR    2,2               16,000,000,000 X'3 B9AC A000' ovflw!
*
*---------------------------------------------------------------------*
* Part 2: Fix the problem
*---------------------------------------------------------------------*
*
*  --->  Go back to Part 1 and replace the LFI and AR
*        instructions by their 64-bit variants
*
*
*  --->  Load 1,000,000,000 into R2 full size
*
         LGFI  2,1000000000       1,000,000,000   X'3B9A CA00'
*
*  --->  Add R2 full size to itself 4 times
*
         AGR   2,2                2,000,000,000 X'0 7735 9400'
         AGR   2,2                4,000,000,000 X'0 EE6B 2800'
         AGR   2,2                8,000,000,000 X'1 DCD6 5000' good :)
         AGR   2,2               16,000,000,000 X'3 B9AC A000' good :)
*
*---------------------------------------------------------------------*
         DC    H'0'               Invalid opcode causes abend S0C1
*---------------------------------------------------------------------*
         END
