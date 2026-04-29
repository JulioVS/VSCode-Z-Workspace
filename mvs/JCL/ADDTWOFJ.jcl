//ADDTWOFJ JOB 1,NOTIFY=&SYSUID
//***************************************************
//* Build FUNCTION-ID module ADDTWOF
//***************************************************
//BUILD    EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(ADDTWOF),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(ADDTWOF),DISP=SHR
