//ESWITCHT    JOB FB3,,REGION=0M,NOTIFY=&SYSUID
//*
//* COBOL CICS COMPILE JOB
//*
//CICSPROG   EXEC DFHZITCL                       IBM CICS COMPILE PROC
//COBOL.SYSIN  DD DISP=SHR,DSN=&SYSUID..CBL(ESWITCHT) MY COBOL PROGRAM
//COBOL.SYSLIB DD DISP=SHR,DSN=DFH620.CICS.SDFHCOB      CICS COPYBOOKS
//             DD DISP=SHR,DSN=&SYSUID..COPYLIB           MY COPYBOOKS
//LKED.SYSLMOD DD DISP=SHR,DSN=&SYSUID..CICS.PROD.DFHLOAD   MY LOADLIB
//LKED.SYSIN   DD *,SYMBOLS=EXECSYS
  NAME ESWITCHT(R)
/*
//
