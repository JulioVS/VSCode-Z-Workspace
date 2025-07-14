//GIMSAMPU JOB 1,REGION=0M,NOTIFY=&SYSUID
//*
//* Allocate and prime SMP/E CSI and operational data sets.
//*
//*
//* This JCL sample can be used to allocate SMP/E CSI data sets, as
//* well as other SMP/E operational data sets.  This sample can also
//* be used to prime the CSI data sets with basic SMP/E zone
//* definitions, OPTIONS entries, and DDDEF entries.
//*
//* The space values for all data sets are approximate and may need
//* to be adjusted based on your specific needs.
//*
//* CAUTION: This is neither a JCL procedure nor a complete JCL job.
//* It is a sample.  Before using this sample, you will have to make
//* the following modifications:
//*
//* 1) Usually you need to update the job statement to
//*    meet your system requirements.
//*    We have done this for you.
//*
//* 2) Change all occurrences of &HLQ& to the appropriate high-level    vel
//*    qualifier for the CSI and operational data sets.  Use the change
//*    command:
//*
//*    CHANGE &HLQ& 'your-HLQ-value' ALL
//*
//* 3) If you require a specific volume then change all occurrences of
//*    &VOLUME& to the appropriate volume serial identifier for CSI and
//*    operational data sets.  Use the change command:
//*
//*    CHANGE &VOLUME& 'your-VOLUME-identifier' ALL
//*
//*    If you do not require a specific volume, then remove all
//*    occurrences of &VOLUME& and the related keywords throughout the
//*    sample.
//*
//* 4) If you require a specific device then change all occurrences of
//*    &UNIT& to the appropriate device unit identifier for CSI and
//*    operational data sets.  Use the change command:
//*
//*    CHANGE &UNIT& 'your-UNIT-identifier' ALL
//*
//*    If you do not require a specific device, then remove all
//*    occurrences of &UNIT& and the related keywords throughout the
//*    sample.
//*
//********************************************************************
//*
//* Delete data sets from any previous job run
//*  then proceed with allocation of new data sets
//*
//********************************************************************
//DELVSAM  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *,SYMBOLS=CNVTSYS
  DELETE &SYSUID..SMP.GLOBAL.CSI CLUSTER
  DELETE &SYSUID..SMP.TARGET.CSI CLUSTER
  DELETE &SYSUID..SMP.DLIB.CSI CLUSTER
  SET MAXCC=0
//DELPRIM  EXEC PGM=IEFBR14
//D01      DD DSN=&SYSUID..SMP.SMPPTS,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D02      DD DSN=&SYSUID..SMP.TARGET.SMPMTS,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D03      DD DSN=&SYSUID..SMP.TARGET.SMPSTS,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D04      DD DSN=&SYSUID..SMP.TARGET.SMPSCDS,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D05      DD DSN=&SYSUID..SMP.GLOBAL.SMPLOG,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D06      DD DSN=&SYSUID..SMP.GLOBAL.SMPLOGA,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D07      DD DSN=&SYSUID..SMP.TARGET.SMPLOG,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D08      DD DSN=&SYSUID..SMP.TARGET.SMPLOGA,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D09      DD DSN=&SYSUID..SMP.DLIB.SMPLOG,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//D10      DD DSN=&SYSUID..SMP.DLIB.SMPLOGA,DISP=(MOD,DELETE),
// SPACE=(TRK,0)
//********************************************************************
//*
//* Allocate VSAM data sets to contain SMP/E CSIs, and initialize
//* them by copying the GIMZPOOL seed record.
//*
//********************************************************************
//*
//DEFZONES EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//GIMZPOOL DD DSN=SYS1.MACLIB(GIMZPOOL),DISP=SHR
//SYSIN    DD *,SYMBOLS=CNVTSYS
  DEFINE CLUSTER(                            +
           NAME(&SYSUID..SMP.GLOBAL.CSI)     +
           VOLUMES(VPWRKA)                   +
           TRACKS(2 1)                       +
           FREESPACE(10 5)                   +
           KEYS(24 0)                        +
           RECORDSIZE(24 143)                +
           SHAREOPTIONS(2 3)                 +
               )                             +
      DATA (                                 +
           NAME(&SYSUID..SMP.GLOBAL.CSI.DATA) +
           CONTROLINTERVALSIZE(8192)         +
           )                                 +
     INDEX (NAME(&SYSUID..SMP.GLOBAL.CSI.INDEX) +
           CONTROLINTERVALSIZE(4096)         +
           )
  REPRO INFILE(GIMZPOOL)                     +
           OUTDATASET(&SYSUID..SMP.GLOBAL.CSI)
  DEFINE CLUSTER(                            +
           NAME(&SYSUID..SMP.TARGET.CSI)     +
           VOLUMES(VPWRKA)                   +
           TRACKS(2 1)                       +
           FREESPACE(10 5)                   +
           KEYS(24 0)                        +
           RECORDSIZE(24 143)                +
           SHAREOPTIONS(2 3)                 +
               )                             +
      DATA (                                 +
           NAME(&SYSUID..SMP.TARGET.CSI.DATA) +
           CONTROLINTERVALSIZE(8192)         +
           )                                 +
     INDEX (NAME(&SYSUID..SMP.TARGET.CSI.INDEX) +
           CONTROLINTERVALSIZE(4096)         +
           )
  REPRO INFILE(GIMZPOOL)                     +
           OUTDATASET(&SYSUID..SMP.TARGET.CSI)
  DEFINE CLUSTER(                            +
           NAME(&SYSUID..SMP.DLIB.CSI)       +
           VOLUMES(VPWRKA)                   +
           TRACKS(2 1)                       +
           FREESPACE(10 5)                   +
           KEYS(24 0)                        +
           RECORDSIZE(24 143)                +
           SHAREOPTIONS(2 3)                 +
               )                             +
      DATA (                                 +
           NAME(&SYSUID..SMP.DLIB.CSI.DATA)  +
           CONTROLINTERVALSIZE(8192)         +
           )                                 +
     INDEX (NAME(&SYSUID..SMP.DLIB.CSI.INDEX) +
           CONTROLINTERVALSIZE(4096)         +
           )
  REPRO INFILE(GIMZPOOL)                     +
           OUTDATASET(&SYSUID..SMP.DLIB.CSI)
/*
//*
//********************************************************************
//*
//* Allocate SMP/E operational data sets:
//*
//* - SMPPTS data set.
//* - SMPMTS, SMPSTS, and SMPSCDS data sets.  Each target zone     @P2C
//*   must have their own.
//* - SMPLOG and SMPLOGA data sets.  Each zone (global, target, and
//*   dlib) should have their own.
//*
//********************************************************************
//*
//ALLOCDS  EXEC  PGM=IEFBR14,COND=(0,LT)
//*
//*  Recommend SMPPTS be a PDSE (DSNTYPE=LIBRARY)
//*
//SMPPTS   DD DSN=&SYSUID..SMP.SMPPTS,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=0,DSORG=PO),
//         DSNTYPE=LIBRARY,
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1,1))
//*
//* Target zone must have its own SMPMTS, SMPSTS and SMPSCDS.
//*
//SMPMTS   DD DSN=&SYSUID..SMP.TARGET.SMPMTS,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=0,DSORG=PO),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1,1))
//SMPSTS   DD DSN=&SYSUID..SMP.TARGET.SMPSTS,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=0,DSORG=PO),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1,1))                                    7@P2D
//SMPSCDS  DD DSN=&SYSUID..SMP.TARGET.SMPSCDS,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=0,DSORG=PO),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1,1))
//*
//* SMPLOG and SMPLOGA data sets.  Each zone (global, target, and
//* dlib) should have their own.
//*
//GLOG     DD DSN=&SYSUID..SMP.GLOBAL.SMPLOG,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=VB,LRECL=510,BLKSIZE=3200),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1))
//GLOGA    DD DSN=&SYSUID..SMP.GLOBAL.SMPLOGA,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=VB,LRECL=510,BLKSIZE=3200),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1))
//TLOG     DD DSN=&SYSUID..SMP.TARGET.SMPLOG,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=VB,LRECL=510,BLKSIZE=3200),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1))
//TLOGA    DD DSN=&SYSUID..SMP.TARGET.SMPLOGA,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=VB,LRECL=510,BLKSIZE=3200),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1))
//DLOG     DD DSN=&SYSUID..SMP.DLIB.SMPLOG,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=VB,LRECL=510,BLKSIZE=3200),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1))
//DLOGA    DD DSN=&SYSUID..SMP.DLIB.SMPLOGA,
//         DISP=(NEW,CATLG),
//         DCB=(RECFM=VB,LRECL=510,BLKSIZE=3200),
//         UNIT=3390,
//         VOL=SER=VPWRKA,
//         SPACE=(TRK,(1,1))
//*
//********************************************************************
//*
//* Prime the CSI data sets with:
//* - zone definitions for a global, target, and dlib zone
//* - basic OPTIONS entry
//* - DDDEF entries for operational and temporary data sets
//*
//********************************************************************
//*
//UPDZONES EXEC PGM=GIMSMP,COND=(0,LT)
//SMPCSI   DD DSN=&SYSUID..SMP.GLOBAL.CSI,DISP=SHR
//SMPLOG   DD SYSOUT=*
//SMPOUT   DD SYSOUT=*
//SMPRPT   DD SYSOUT=*
//SMPLIST  DD SYSOUT=*
//SMPPTS   DD DSN=&SYSUID..SMP.SMPPTS,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SMPCNTL  DD *,SYMBOLS=CNVTSYS
  SET BOUNDARY(GLOBAL).
  UCLIN.
    ADD OPTIONS(GOPT)
          DSPREFIX(&SYSUID..SMP.SMPTLIB)
          DSSPACE(20,20,100)
          MSGFILTER(YES)
          MSGWIDTH(80)
          RECZGRP(ALLZONES)
          RETRYDDN(ALL).
    ADD GLOBALZONE
          OPTIONS(GOPT)
          SREL(Z038)
          ZONEINDEX(
                    (TARGET,&SYSUID..SMP.TARGET.CSI,TARGET)
                    (DLIB,&SYSUID..SMP.DLIB.CSI,DLIB)
                   ).
    ADD DDDEF(SMPDEBUG) SYSOUT(*).
    ADD DDDEF(SMPLIST)  SYSOUT(*).
    ADD DDDEF(SMPRPT)   SYSOUT(*).
    ADD DDDEF(SMPSNAP)  SYSOUT(*).
    ADD DDDEF(SYSPRINT) SYSOUT(*).
    ADD DDDEF(SMPLOG)   DA(&SYSUID..SMP.GLOBAL.SMPLOG) MOD.
    ADD DDDEF(SMPLOGA)  DA(&SYSUID..SMP.GLOBAL.SMPLOGA) MOD.
    ADD DDDEF(SMPOUT)   SYSOUT(*).
    ADD DDDEF(SMPPTS)   DA(&SYSUID..SMP.SMPPTS) SHR.
    ADD DDDEF(SYSUT1)   UNIT(SYSALLDA) CYLINDERS SPACE(25,25).
    ADD DDDEF(SYSUT2)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SYSUT3)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SYSUT4)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SMPWRK1)  UNIT(SYSALLDA) CYLINDERS SPACE(10,10)
                        DIR(100).
    ADD DDDEF(SMPWRK2)  UNIT(SYSALLDA) CYLINDERS SPACE(10,10)
                        DIR(100).
    ADD DDDEF(SMPWRK3)  UNIT(SYSALLDA) CYLINDERS SPACE(150,50)
                        DIR(1000).
    ADD DDDEF(SMPWRK4)  UNIT(SYSALLDA) CYLINDERS SPACE(5,5)
                        DIR(50).
    ADD DDDEF(SMPWRK6)  UNIT(SYSALLDA) CYLINDERS SPACE(150,50)
                        DIR(1000).
  ENDUCL.
  SET BOUNDARY(TARGET).
  UCLIN.
    ADD TARGETZONE(TARGET)
          OPTIONS(GOPT)
          SREL(Z038)
          RELATED(DLIB).
    ADD DDDEF(SMPDEBUG) SYSOUT(*).
    ADD DDDEF(SMPLIST)  SYSOUT(*).
    ADD DDDEF(SMPLOG)   DA(&SYSUID..SMP.TARGET.SMPLOG) MOD.
    ADD DDDEF(SMPLOGA)  DA(&SYSUID..SMP.TARGET.SMPLOGA) MOD.
    ADD DDDEF(SMPOUT)   SYSOUT(*).
    ADD DDDEF(SMPRPT)   SYSOUT(*).
    ADD DDDEF(SMPSNAP)  SYSOUT(*).
    ADD DDDEF(SYSPRINT) SYSOUT(*).
    ADD DDDEF(SMPPTS)   DA(&SYSUID..SMP.SMPPTS) SHR.
    ADD DDDEF(SMPSTS)   DA(&SYSUID..SMP.TARGET.SMPSTS) OLD.
    ADD DDDEF(SMPMTS)   DA(&SYSUID..SMP.TARGET.SMPMTS) OLD.
    ADD DDDEF(SMPLTS)   UNIT(SYSALLDA) CYLINDERS SPACE(10,10)
                        DIR(1) DSNTYPE(LIBRARY) /*              @P2C*/.
    ADD DDDEF(SMPSCDS)  DA(&SYSUID..SMP.TARGET.SMPSCDS) OLD.
    ADD DDDEF(SYSLIB)   CONCAT(SMPMTS).
    ADD DDDEF(SYSUT1)   UNIT(SYSALLDA) CYLINDERS SPACE(25,25).
    ADD DDDEF(SYSUT2)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SYSUT3)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SYSUT4)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SMPWRK1)  UNIT(SYSALLDA) CYLINDERS SPACE(10,10)
                        DIR(100).
    ADD DDDEF(SMPWRK2)  UNIT(SYSALLDA) CYLINDERS SPACE(10,10)
                        DIR(100).
    ADD DDDEF(SMPWRK3)  UNIT(SYSALLDA) CYLINDERS SPACE(150,50)
                        DIR(1000).
    ADD DDDEF(SMPWRK4)  UNIT(SYSALLDA) CYLINDERS SPACE(5,5)
                        DIR(50).
    ADD DDDEF(SMPWRK6)  UNIT(SYSALLDA) CYLINDERS SPACE(150,50)
                        DIR(1000).
  ENDUCL.
  SET BOUNDARY(DLIB).
  UCLIN.
    ADD DLIBZONE(DLIB)
          OPTIONS(GOPT)
          SREL(Z038)
          ACCJCLIN
          RELATED(TARGET).
    ADD DDDEF(SMPDEBUG) SYSOUT(*).
    ADD DDDEF(SMPLIST)  SYSOUT(*).
    ADD DDDEF(SMPLOG)   DA(&SYSUID..SMP.DLIB.SMPLOG) MOD.
    ADD DDDEF(SMPLOGA)  DA(&SYSUID..SMP.DLIB.SMPLOGA) MOD.
    ADD DDDEF(SMPOUT)   SYSOUT(*).
    ADD DDDEF(SMPRPT)   SYSOUT(*).
    ADD DDDEF(SMPSNAP)  SYSOUT(*).
    ADD DDDEF(SYSPRINT) SYSOUT(*).
    ADD DDDEF(SMPPTS)   DA(&SYSUID..SMP.SMPPTS) SHR.
    ADD DDDEF(SMPSTS)   DA(&SYSUID..SMP.TARGET.SMPSTS) OLD.
    ADD DDDEF(SMPMTS)   DA(&SYSUID..SMP.TARGET.SMPMTS) OLD.
    ADD DDDEF(SMPLTS)   UNIT(SYSALLDA) CYLINDERS SPACE(10,10)
                        DIR(1) DSNTYPE(LIBRARY) /*              @P2C*/.
    ADD DDDEF(SMPSCDS)  DA(&SYSUID..SMP.TARGET.SMPSCDS) OLD.
    ADD DDDEF(SYSLIB)   CONCAT(SMPMTS).
    ADD DDDEF(SYSUT1)   UNIT(SYSALLDA) CYLINDERS SPACE(25,25).
    ADD DDDEF(SYSUT2)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SYSUT3)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SYSUT4)   UNIT(SYSALLDA) CYLINDERS SPACE(5,5).
    ADD DDDEF(SMPWRK1)  UNIT(SYSALLDA) CYLINDERS SPACE(10,10)
                        DIR(100).
    ADD DDDEF(SMPWRK2)  UNIT(SYSALLDA) CYLINDERS SPACE(10,10)
                        DIR(100).
    ADD DDDEF(SMPWRK3)  UNIT(SYSALLDA) CYLINDERS SPACE(150,50)
                        DIR(1000).
    ADD DDDEF(SMPWRK4)  UNIT(SYSALLDA) CYLINDERS SPACE(5,5)
                        DIR(50).
    ADD DDDEF(SMPWRK6)  UNIT(SYSALLDA) CYLINDERS SPACE(150,50)
                        DIR(1000).
  ENDUCL.
/*
