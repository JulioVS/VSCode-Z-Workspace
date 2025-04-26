//SELTBL  JOB 1,NOTIFY=&SYSUID                                          00010000
//SQLEXEC EXEC DB2JCL                                                   00020000
//SYSIN    DD *,SYMBOLS=CNVTSYS                                         00021000
--******* SQL FOLLOWS                                                   00030000
  SET CURRENT SCHEMA &SYSUID.;                                          00031000
  SELECT * FROM &SYSUID.T;                                              00040000
/*                                                                      00050000
