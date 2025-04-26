from __future__ import print_function
import sys
import ibm_db
print('ODBC Test start')

conn = ibm_db.connect('','','')
client = ibm_db.client_info(conn).encode('iso-8859-1').decode('ascii')
print(client)

if client:
    print("DRIVER_NAME: string(%d) \"%s\"" % (len(client.DRIVER_NAME), client.DRIVER_NAME))
    print("DRIVER_VER: string(%d) \"%s\"" % (len(client.DRIVER_VER), client.DRIVER_VER))
    print("DATA_SOURCE_NAME: string(%d) \"%s\"" % (len(client.DATA_SOURCE_NAME), client.DATA_SOURCE_NAME))
    print("DRIVER_ODBC_VER: string(%d) \"%s\"" % (len(client.DRIVER_ODBC_VER), client.DRIVER_ODBC_VER))
    print("ODBC_VER: string(%d) \"%s\"" % (len(client.ODBC_VER), client.ODBC_VER))
    print("ODBC_SQL_CONFORMANCE: string(%d) \"%s\"" % (len(client.ODBC_SQL_CONFORMANCE), client.ODBC_SQL_CONFORMANCE))
    print("APPL_CODEPAGE: int(%s)" % client.APPL_CODEPAGE)
    print("CONN_CODEPAGE: int(%s)" % client.CONN_CODEPAGE)

if conn:
    stmt = ibm_db.exec_immediate(conn,"SELECT CURRENT DATE FROM SYSIBM.SYSDUMMY1")
    if stmt:
        while (ibm_db.fetch_row(stmt)):
            date = ibm_db.result(stmt, 0)
            print("Current date is :",date)
    else:
        print(ibm_db.stmt_errormsg())
    ibm_db.close(conn)
else:
    print("No connection:", ibm_db.conn_errormsg())

print('ODBC Test end')
