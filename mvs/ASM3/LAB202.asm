*---------------------------------------------------------------------*
*                                                                     *
*---+----1----+----2----+----3----+----4----+----5----+----6----+----7*
*
*  --->  This is just an assembly, there is no "GO" step needed.
*
*---------------------------------------------------------------------*
LAB202   CSECT
*
*  --->  Code an EQU instruction labeled KILO with value 1024.
*
KILO     EQU   1024
*
*  --->  Code an EQU instruction labeled MEGA with value that
*        is the product of KILO * KILO.
*
MEGA     EQU   KILO*KILO
*
*  --->  Code an EQU instruction labeled GIGA with value that
*        is the product of KILO * MEGA.
*
GIGA     EQU   KILO*MEGA
*
*  --->  Define an address labeled K1 with the value KILO.
*
K1       DC    A(KILO)
*
*  --->  Define an address labeled M1 with the value MEGA.
*
M1       DC    A(MEGA)
*
*  --->  Define an address labeled G1 with the value GIGA.
*
G1       DC    A(GIGA)
*
*---------------------------------------------------------------------*
         END
