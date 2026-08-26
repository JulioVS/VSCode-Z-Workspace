*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  This is just an assembly, there is no "GO" step needed.
*
*---------------------------------------------------------------------*
LAB203   CSECT
*
*  --->  Code EQU instructions to associate the values 1, 2, 3, ...7
*        to the symbols Monday, Tuesday, Wednesday...
*
Monday         EQU 1
Tuesday        EQU 2
Wednesday      EQU 3
Thursday       EQU 4
Friday         EQU 5
Saturday       EQU 6
Sunday         EQU 7
*
*---------------------------------------------------------------------*
         LARL  12,LAB203
         USING LAB203,12
*---------------------------------------------------------------------*
         MVI   DAY,1
         MVI   DAY,Monday
         MVI   DAY,2
         MVI   DAY,Tuesday
         MVI   DAY,6
         MVI   DAY,Saturday
*---------------------------------------------------------------------*
         SR    15,15
         BR    14
*---------------------------------------------------------------------*
DAY      DC    X'0'
*---------------------------------------------------------------------*
         END
