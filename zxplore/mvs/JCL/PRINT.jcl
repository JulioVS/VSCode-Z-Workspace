//PRINT1   JOB  PRINTJCL
//IDCAMS   EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=A
//SYSIN    DD   *,SYMBOLS=EXECSYS
     PRINT -
           INDATASET(&SYSUID..VSAMDS) -
           CHARACTER
/*
