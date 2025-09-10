//AIRINJCL JOB MSGCLASS=C,MSGLEVEL=(1,1),USER=XXXXXXX,NOTIFY=XXXXXXX    00010000
//********************************************************************  00020000
//*                                                                  *  00030000
//* PROPRIETARY STATEMENT:                                           *  00040000
//*    Licensed Materials - Property of IBM                          *  00050000
//*    5694-A01 Copyright IBM Corp. 2010                             *  00060000
//*                                                                  *  00070000
//*    STATUS=HBB7770                                                *  00080000
//*                                                                  *  00090000
//* DESCRIPTIVE NAME:                                                *  00100000
//*    This job runs PFA AIRSHREP.sh install script in batch.        *  00110000
//*                                                                  *  00120000
//* Note:                                                            *  00130000
//*    If your installation has previously started the PFA on        *  00140000
//*    z/OS V1R10 or z/OS V1R11 and you want to preserve the history *  00150000
//*    data then use the 'migrate' parameter when invoking           *  00160000
//*    AIRSHREP.sh script.                                           *  00170000
//*    /pfa is the home directory of the user ID that owns the PFA   *  00181005
//*    started task.                                                 *  00182005
//*    // PARM='SH cd /pfa; /usr/lpp/bcp/AIRSHREP.sh migrate'        *  00200004
//*                                                                  *  00210000
//*    If your installation is going to start PFA for the first time *  00220000
//*    or you want to start with clean directories then use the      *  00230000
//*    'new' parameter when invoking AIRSHREP.sh script.             *  00240000
//*                                                                  *  00250000
//*    // PARM='SH cd /pfa; /usr/lpp/bcp/AIRSHREP.sh new'            *  00260004
//*                                                                  *  00270000
//*    On PARM= statement '/pfa' needs to be replaced by the         *  00280005
//*    home directory of the user ID that owns the PFA started task. *  00290005
//*                                                                  *  00300000
//*    Change Activity:                                              *  00310000
//*    $L0=SCPFA  hbb7770 090920, ASH: Initial Creation              *  00320000
//*    $L1=SCPFA  hbb7770 100405  ASH: pfa is the home directory     *  00321003
//*                                    of pfauser                   *   00330003
//*                                                                  *  00331003
//********************************************************************  00340000
//PFAINST  EXEC PGM=BPXBATCH,TIME=NOLIMIT,REGION=0M,                    00350000
//*PARM='SH cd /pfa; /usr/lpp/bcp/AIRSHREP.sh migrate'                  00360004
// PARM='SH cd /pfa; /usr/lpp/bcp/AIRSHREP.sh new'                      00370004
//*                                                                     00380000
//STDOUT   DD   PATH='/tmp/pfainst.out',                                00390000
//         PATHOPTS=(OWRONLY,OCREAT,OTRUNC),                            00400000
//         PATHMODE=(SIRWXU)                                            00410000
//STDERR   DD   PATH='/var/pfainst.err',                                00420000
//         PATHOPTS=(OWRONLY,OCREAT,OTRUNC),                            00430000
//         PATHMODE=(SIRWXU)                                            00440000
//SYSPRINT DD SYSOUT=*                                                  00450000
//SYSUDUMP DD SYSOUT=*                                                  00460000
//SYSMDUMP DD SYSOUT=*                                                  00470000
//********************************************************************/ 00480000
//*  STEP 2 - Copy stdout back to joblog                             */ 00490000
//********************************************************************/ 00500000
//STEP2    EXEC PGM=IEBGENER                                            00510000
//SYSPRINT DD SYSOUT=*                                                  00520000
//SYSUT1   DD    PATH='/var/pfainst.out',                               00530000
//          FILEDATA=TEXT,PATHOPTS=ORDONLY,                             00540000
//          LRECL=160,BLKSIZE=640,RECFM=FB                              00550000
//SYSUT2   DD SYSOUT=*,                                                 00560000
//          DCB=(RECFM=FB,LRECL=160,BLKSIZE=640)                        00570000
//SYSIN    DD DUMMY                                                     00580000
//********************************************************************/ 00590000
//*  STEP 3 - Copy stderr back to joblog                             */ 00600000
//********************************************************************/ 00610000
//STEP3    EXEC PGM=IEBGENER                                            00620000
//SYSPRINT DD SYSOUT=*                                                  00630000
//SYSUT1   DD   PATH='/var/pfainst.err',                                00640000
//          FILEDATA=TEXT,PATHOPTS=ORDONLY,                             00650000
//          LRECL=160,BLKSIZE=640,RECFM=FB                              00660000
//SYSUT2   DD SYSOUT=*,                                                 00670000
//          DCB=(RECFM=FB,LRECL=160,BLKSIZE=640)                        00680000
//SYSIN    DD DUMMY                                                     00690000
