*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  This is just an assembly, there is no "GO" step needed.
*
*---------------------------------------------------------------------*
LAB201   CSECT
*
*  --->  Define a fullword labeled TAB1L1 containing the total size
*        of TAB1.
*
TAB1L1   DC    A(8000)
*
*  --->  Define an address labeled TAB1L2 containing the size of TAB1
*        expressed as the number of items times 80 (item length).
*
TAB1L2   DC    A(100*80)
*
*  --->  Define an address labeled TAB1L3 containing the size of TAB1
*        expressed as the number of items times the length attribute
*        of TAB1.
*
TAB1L3   DC    A(100*L'TAB1)
*
*---------------------------------------------------------------------*
TAB1     DS    100CL80            Array of 100 80-byte items
*---------------------------------------------------------------------*
*
*  --->  Define an EQU labeled TAB1END to indicate the location at
*        the end of TAB1.
*
TAB1END  EQU   *
*
*  --->  Define an address labeled TAB1L4 containing the size of TAB1
*        expressed as the difference between the end and the start
*        of TAB1
*
TAB1L4   DC    A(TAB1END-TAB1)
*
*---------------------------------------------------------------------*
         END
