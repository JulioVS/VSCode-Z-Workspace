//CBLJSONJ   JOB ,MSGLEVEL=(2,0)
//***************************************************/
//* Compile (IGYWCL command) COBOL source file CBLJSON.cbl
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN   DD DSN=&SYSUID..CBL(CBLJSON),DISP=SHR
//LKED.SYSLMOD  DD DSN=&SYSUID..LOAD(CBLJSON),DISP=SHR
//LKED.SYSPRINT DD DUMMY
//***************************************************/
// IF RC = 0 THEN
//***************************************************/
//* Run COBOL program CBLJSON, with a parameter
//* RUNPROG   EXEC PGM=CBLJSON,PARM=('TEXT')
//*         JE: Changed input parameter to "HTML"
//RUNPROG   EXEC PGM=CBLJSON,PARM=('HTML')
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//* Basic syntax of a JCL DD statement:
//* DD-NAME DD PARAMETERS
//* Define data file for our flyer output, DD-NAME=FLYRFILE
//* The COBOL program refers to this name to write to this file
//FLYRFILE  DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//* JSON input via SYSIN. Do not write anything in column 73 and beyond.
//* Expiry dates are in YYYMMDD format
//SYSIN     DD *
{"inv-data":
   {"inv-record":[
      {
        "prod-name":"Chicken soup",
        "prod-img":"https://ibmzxplore-static.s3.eu-gb.cloud-object-stor
age.appdomain.cloud/unknown.png",
        "expiry":"20210922",
        "quantity":38,
        "salesperday":13,
        "price":0.99
      },
      {
        "prod-name":"Tomato sauce",
        "prod-img":"https://ibmzxplore-static.s3.eu-gb.cloud-object-stor
age.appdomain.cloud/unknown.png",
        "expiry":"20210923",
        "quantity":47,
        "salesperday":12,
        "price":1.49
      },
      {
        "prod-name":"Canned Tuna",
        "prod-img":"https://ibmzxplore-static.s3.eu-gb.cloud-object-stor
age.appdomain.cloud/AdobeStock_65310327.jpeg",
        "expiry":"20210926",
        "quantity":101,
        "salesperday":10,
        "price":0.89
      },
      {
        "prod-name":"Green Beans",
        "prod-img":"https://ibmzxplore-static.s3.eu-gb.cloud-object-stor
age.appdomain.cloud/AdobeStock_62625977.jpeg",
        "expiry":"20210924",
        "quantity":73,
        "salesperday":5,
        "price":0.49
      },
      {
        "prod-name":"Raisins",
        "prod-img":"https://ibmzxplore-static.s3.eu-gb.cloud-object-stor
age.appdomain.cloud/unknown.png",
        "expiry":"20210924",
        "quantity":5,
        "salesperday":2,
        "price":2.99
      },
      {
        "prod-name":"Pinto beans",
        "prod-img":"https://ibmzxplore-static.s3.eu-gb.cloud-object-stor
age.appdomain.cloud/unknown.png",
        "expiry":"20210929",
        "quantity":27,
        "salesperday":9,
        "price":0.69
      },
      {
        "prod-name":"Peanut butter",
        "prod-img":"https://ibmzxplore-static.s3.eu-gb.cloud-object-stor
age.appdomain.cloud/AdobeStock_282479225.jpeg",
        "expiry":"20210928",
        "quantity":89,
        "salesperday":8,
        "price":3.99
      }
   ]}
}
***
/*
//***************************************************/
// ELSE
// ENDIF
