//ASMJCL    JOB FB3,,REGION=0M,NOTIFY=&SYSUID
//*
//*   MY ASSEMBLY COMPILE & LINK JOB
//*
// EXPORT SYMLIST=(*)
// SET MYPRG='LAB503'   z/Architecture Assembler Language, Part 2 Labs
//*
//CL       EXEC ASMACL,
//             PARM.L=(MAP,LET,LIST),
//             MBR=&MYPRG
//*
//C.SYSIN    DD DISP=SHR,DSN=&SYSUID..ASM1(&MYPRG)
//L.SYSLIB   DD DISP=SHR,DSN=&SYSUID..LOAD
//
