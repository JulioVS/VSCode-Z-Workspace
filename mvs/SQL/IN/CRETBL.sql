--DROP TABLESPACE Z45864.Z45864S;
--COMMIT;

SET CURRENT SCHEMA Z45864;

CREATE TABLESPACE Z45864S IN Z45864
  USING STOGROUP ZXPUSER PRIQTY 20 SECQTY 20 ERASE NO
  LOCKSIZE PAGE LOCKMAX SYSTEM
  BUFFERPOOL BP0 CLOSE NO COMPRESS YES;

COMMIT;

CREATE TABLE Z45864T
              (
                ACCTNO    CHAR(8)        NOT NULL,
                LIMIT     DECIMAL(9,2)           ,
                BALANCE   DECIMAL(9,2)           ,
                SURNAME   CHAR(20)       NOT NULL,
                FIRSTN    CHAR(15)       NOT NULL,
                ADDRESS1  CHAR(25)               ,
                ADDRESS2  CHAR(20)               ,
                ADDRESS3  CHAR(15)               ,
                RESERVED  CHAR(7)                ,
                COMMENTS  CHAR(50)               ,
                PRIMARY KEY(ACCTNO)
              )
        IN Z45864.Z45864S;

COMMIT;

CREATE UNIQUE INDEX Z45864I
                  ON Z45864T (ACCTNO ASC)
                  USING STOGROUP ZXPUSER PRIQTY 12 ERASE NO
                  BUFFERPOOL BP0 CLOSE NO;

COMMIT;
