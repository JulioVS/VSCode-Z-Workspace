//ESONRULJ JOB 1,NOTIFY=&SYSUID
//*
//*   VSAM <RRDS> CREATION AND LOAD JOB FOR SIGN-ON RULES FILE
//*
// EXPORT SYMLIST=(*)
//*
// SET ENTITY='ESONRUL'
// SET TYPE='RRDS'
// SET SEED='DATA'
//*
//DEFINE  EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *,SYMBOLS=CNVTSYS
  DELETE &SYSUID..&TYPE..&ENTITY.
  SET MAXCC=0
  DEFINE CLUSTER ( NAME ( &SYSUID..&TYPE..&ENTITY. ) -
            VOLUME(VPWRKB) TRACKS(1,1) RECORDSIZE(10,10) -
            NUMBERED -
            CONTROLINTERVALSIZE(4096) )
/*
//REPRO   EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//I1        DD DISP=SHR,DSN=&SYSUID..&SEED..&ENTITY.
//O1        DD DISP=SHR,DSN=&SYSUID..&TYPE..&ENTITY.
//SYSIN     DD *,SYMBOLS=CNVTSYS
  REPRO INFILE(I1) OUTFILE(O1)
/*
//LISTPRT EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *,SYMBOLS=CNVTSYS
  LISTCAT ENTRIES( &SYSUID..&TYPE..&ENTITY. )
  PRINT INDATASET( &SYSUID..&TYPE..&ENTITY. ) CHARACTER
/*
