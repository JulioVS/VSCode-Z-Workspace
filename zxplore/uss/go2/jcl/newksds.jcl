//GOKSDS JOB ,MSGLEVEL=(1,1),
// TIME=(0,29),REGION=0M
//STEP1 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSOUT  DD SYSOUT=*
//SYSIN DD *,SYMBOLS=CNVTSYS
  DELETE (&SYSUID..VSAMDS) CLUSTER PURGE ERASE
  SET MAXCC=0
  DEFINE CLUSTER(NAME(&SYSUID..VSAMDS) -
           LOG(NONE)                   -
           UNIQUE)                     -
           DATA(TRACKS(2,1)            -
           RECSZ(67,100)                -
           KEYS(3,0))                 -
           INDEX(TRACKS(1,1))
/*
//SYSOUT   DD SYSOUT=*