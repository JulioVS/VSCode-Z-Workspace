//IDCAMSD  JOB FB3,NOTIFY=&SYSUID
//*
//* UTILITY JCL FOR IDCAMS  -- DELETE UNWANTED VSAM FILE.-
//*
//STEP1   EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *,SYMBOLS=CNVTSYS
  DELETE &SYSUID..COMPLETE
/*
