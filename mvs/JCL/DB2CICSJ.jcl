//DB2CICSJ JOB FB3,,REGION=0M,NOTIFY=&SYSUID
//*
// EXPORT SYMLIST=(*)
// SET MEMBER='DB2CICS'
//*
//********************************************************************
//*  COMPILE AND LINK FOR CICS WITH ADDED 'SQL' OPTION               *
//********************************************************************
//CICSPROG EXEC DFHZITCL,
//            CBLPARM=('NODYNAM,RENT,SQL',          COMPILE OPTIONS
//             'SIZE(4000K),CICS(''COBOL3'')')   TRANSLATOR OPTIONS
//*
//COBOL.SYSIN  DD  DISP=SHR,DSN=&SYSUID..CBL(&MEMBER)
//COBOL.DBRMLIB DD DISP=SHR,DSN=&SYSUID..DBRMLIB(&MEMBER)
//COBOL.SYSLIB DD  DISP=SHR,DSN=DFH620.CICS.SDFHCOB
//             DD  DISP=SHR,DSN=&SYSUID..COPYLIB
//             DD  DISP=SHR,DSN=&SYSUID..DCLGEN
//COBOL.STEPLIB DD DISP=SHR,DSN=DFH620.CICS.SDFHLOAD
//             DD  DISP=SHR,DSN=IGY640.SIGYCOMP
//             DD  DISP=SHR,DSN=DSND10.DBDG.SDSNEXIT
//             DD  DISP=SHR,DSN=DSND10.SDSNLOAD
//             DD  DISP=SHR,DSN=CEE.SCEERUN
//             DD  DISP=SHR,DSN=CEE.SCEERUN2
//*
//LKED.SYSLMOD DD  DISP=SHR,DSN=&SYSUID..CICS.PROD.DFHLOAD
//LKED.SYSIN   DD  *,SYMBOLS=EXECSYS
  NAME &MEMBER.(R)
/*
//********************************************************************
//*  BIND DB2 PLAN                                                   *
//********************************************************************
//         IF RC <= 4 THEN
//*
//BIND     EXEC PGM=IKJEFT01
//STEPLIB    DD DSN=DSND10.SDSNLOAD,DISP=SHR
//DBRMLIB    DD DSN=&SYSUID..DBRMLIB,DISP=SHR
//SYSUDUMP   DD DUMMY
//SYSTSPRT   DD SYSOUT=*
//SYSPRINT   DD SYSOUT=*
//SYSTSIN    DD *,SYMBOLS=EXECSYS
 DSN SYSTEM(DBDG)
 BIND PLAN(&SYSUID) PKLIST(&SYSUID..*) MEMBER(&MEMBER) -
      ACT(REP) ISO(CS) ENCODING(EBCDIC)
/*
//*
//         ENDIF
