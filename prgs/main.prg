#DEFINE C_FONTNAME  "Arial Cyr"
#DEFINE C_FONTSIZE  10
PARAMETERS c������������������, ���������������������
IF EMPTY(c������������������)
    c������������������ = ""
ENDIF
IF EMPTY(���������������������)
    ��������������������� = ""
ENDIF

SET PROCEDURE TO main.prg, _motorMSSQL.prg

CLOSE ALL
CLEAR MACROS
CLEAR
SET DELETED ON
SET DATE GERMAN
SET EXCLUSIVE OFF
SET SAFETY OFF
SET EXACT OFF
SET STATUS OFF
SET STATUS BAR OFF
SET TALK OFF
*SET RESOURCE OFF
SET POINT TO "."
*SET POINT TO "-"
SET ESCAPE OFF
SET COLLATE TO "MACHINE"
SET PATH TO .\prgs\;.\FORMS\;.\PLUGIN\;.\reports\
SET HOURS TO 24
ON ERROR DO APPERROR WITH  ERROR(),  PROG(), LINENO(), MESSAGE(), MESSAGE(1), SYS(2018)
* ���� ��������� ��� �������� ������������� �� ���
IF FindInstance()
    QUIT
ENDIF
* ���� ������ ? ���� �� ����� :(
*PUBLIC oErr AS Exception


_SCREEN.CLOSABLE=.F.
_SCREEN.CONTROLBOX =.F.

_SCREEN.HEIGHT=SYSMETRIC(2) - 70
_SCREEN.PICTURE = ''
*_Screen.Width = SYSMETRIC(1) - 8

DECLARE INTEGER GetPrivateProfileString IN Win32API AS GetPrivStr STRING, STRING, STRING, STRING @, INTEGER, STRING
DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr STRING, STRING, STRING, STRING

�APP = CREATEOBJECT("_app")
_SCREEN.CAPTION = �APP.GETSTR(SYS(5)+SYS(2003)+"\main.INI", "path", "���������", " ��������� ��� ���������� ���������� �� Visual FoxPro ")

�APP.DBFS = �APP.GETSTR(SYS(5)+SYS(2003)+"\main.INI", "path", "DBFS", "��")
IF �APP.DBFS="��"
    �APP.DBFS = .T.
ELSE
    �APP.DBFS = .F.
ENDIF
IF �APP.DBFS
    �APP.���� = ALLTRIM(�APP.GETSTR(SYS(5)+SYS(2003)+"\main.INI", "path", "����", SYS(5)+SYS(2003)+"\dbfs\"))
ENDIF
�APP.������������� = �APP.GETSTR(SYS(5)+SYS(2003)+"\main.INI", "path", "�������������", "")
�APP.������������ = �APP.GETSTR(SYS(5)+SYS(2003)+"\main.INI", "path", "������������", "����������")
�APP.������ = �APP.GETSTR(SYS(5)+SYS(2003)+"\main.INI", "path", "������", "")
�APP.������� = �APP.GETSTR(SYS(5)+SYS(2003)+"\main.INI", "path", "�������", "00")

IF �APP.DBFS
    IF !FILE(�APP.���� + 'main.dbc') OR !FILE(�APP.���� + '����.dbf') OR !FILE(�APP.���� + '�������.dbf')
        DO APPERROR
    ELSE
        OPEN DATABASE (�APP.���� + 'main.dbc') SHARED
        USE �APP.���� + "����.dbf" IN 0 AGAIN ALIAS ���� SHARED
        USE �APP.���� + "�������.dbf" IN 0 AGAIN ALIAS ������� SHARED
    ENDIF
ENDIF

�APP.����mssql = �APP.GETSTR(SYS(5)+SYS(2003)+"\main.INI", "path", "����mssql", "")


* �������� ��������� �������
* � ��� ��� ������� �������� :)
* ��� ���������� � ������� �� ���� �������� � ���������

SELECT �������
SCAN ALL FOR INLIST(ALLTRIM(�������.����������),"����������","��������","�������")

    ������� = "O" + ALLTRIM(�������.��������) + " = .null."
    &�������
    IF  �APP.DBFS
        ������� = "O" + ALLTRIM(�������.��������)+ [ = CREATEOBJECT('_motorDBF')]
    ELSE
        ������� = "O" + ALLTRIM(�������.��������)+ [ = CREATEOBJECT('_motorMSSQL')]
    ENDIF
    &�������
    * ��� ����� ��������
    ������� = "O" + ALLTRIM(�������.��������)+ ".���������� = '" + ALLTRIM(�������.���) + "'"
    &�������
    ������� = "O" + ALLTRIM(�������.��������)+ ".��������������� = ["+ALLTRIM(�������.��������) +"]"
    &�������




    * � ����� �������� �������������� ����� ������
    SELECT ����
    ������� = ""
    SCAN ALL FOR ALLTRIM(����.���_�) == ALLTRIM(�������.���)
        ������� = ������� + "ADDPROPERTY(O" + ALLTRIM(�������.��������)+ ",'" +ALLTRIM(����.��������)
        DO CASE
            CASE INLIST(ALLTRIM(����.���),"W","C","G","M","V")
                ������� = ������� + "','')"  + CHR(13)
            CASE INLIST(ALLTRIM(����.���),"Y","B","I","N","F","Q")
                ������� = ������� + "',0)" + CHR(13)
            CASE INLIST(ALLTRIM(����.���),"D","T")
                ������� = ������� + "',{})" + CHR(13)
            CASE ALLTRIM(����.���) = "L"
                ������� = ������� + "',.F.)" + CHR(13)
        ENDCASE
    ENDSCAN
    * ������� ������ �������  � ������� ���� �� ���
    ������� = ������� + "O"+ALLTRIM(�������.��������) + ".�������()"
    =EXECSCRIPT(�������)
    SELECT �������
ENDSCAN

* �������� ��������� ������� ������������
SELECT �������
SCAN ALL FOR ALLTRIM(�������.����������) == "������������"
    LOCAL M.�������
    m.�������  = 0
    SELECT ����
    ������� = ""
    SCAN ALL FOR ALLTRIM(����.���_�) == ALLTRIM(�������.���)
        m.�������  = m.�������  + 1
        ������� = "DIMENSION c" +ALLTRIM(�������.��������) + " [" + STR(m.�������)+ ",2]"
        &�������
        ������� = "c" + ALLTRIM(�������.��������) + " [" + ALLTRIM(STR(m.�������))+",1] = '" + ALLTRIM(����.��������) + "'" + CHR(13) +;
            "c" + ALLTRIM(�������.��������) + " [" + ALLTRIM(STR(m.�������))+",2] = "  + STR(m.�������)
        =EXECSCRIPT(�������)
    ENDSCAN
    SELECT �������
    RELEASE m.�������
ENDSCAN

�APP.�������������()
* ������������ �������� ��� �������
* ������������ ����������
m.c������������������ = UPPER(m.c������������������)
m.��������������������� = UPPER(m.���������������������)

* ���������� ��������� ������ � ��������� ������
IF m.c������������������ = "U" AND !EMPTY(m.���������������������)

    * ��������� ����� �����������
    IF �APP.DBFS
        IF !FILE(m.��������������������� + '�������.dbf')
            WAIT WINDOWS "�� ���������� ���� �� ���������� �������" + ALLTRIM(m.���������������������) + '�������.dbf'
            DO ����������������
        ELSE
            USE m.��������������������� + "�������.dbf" IN 0 AGAIN ALIAS �������New SHARED
        ENDIF
    ENDIF
    * ��������� ������ ����������� ������
    SELECT �������New
    SCAN ALL FOR INLIST(ALLTRIM(�������New.����������),"����������","��������")
        ������� = ALLTRIM(�������New.��������)
        IF EMPTY(�������)
            SELECT �������New
            LOOP
        ENDIF
        * ��������� �������
        IF FILE(m.��������������������� + m.������� + ".dbf")
            USE (m.��������������������� + m.������� + ".dbf") ALIAS ( m.�������+"new" ) IN 0 EXCLUSIVE
            SELECT (m.������� +"new")
            * � ������� �� �� ��������� ������
            ZAP
        ELSE
            LOOP
        ENDIF

        * ��������� ���� �� ����� dbf ���� � ������ ��������
        IF FILE(�APP.���� + m.������� + ".dbf")
            * ���� ���� ����� ��������� �� ���� ������
            WAIT WINDOWS NOWAIT "�������� ������ ������� " + ALLTRIM(�������New.��������)
            APPEND FROM (�APP.���� + m.������� + ".dbf")
        ENDIF
        * ��������� ����� �������
        USE IN (m.�������+"new")

        SELECT �������New
    ENDSCAN
    * ��� ���������
    CLOSE DATABASES ALL

    * ������� ��� ����� �� �������� �� ������� �������
    WAIT WINDOWS NOWAIT " ������� ������� "
    ERASE (�APP.���� +  "*.*")

    * �������� ���� ������
    WAIT WINDOWS NOWAIT " �������� ����� ��������� "
    COPY FILE (m.��������������������� + '*.*') TO (�APP.����+'*.*')
    * ������� �� ���������
    DO ����������������
ENDIF

READ EVENTS
DO ����������������

**
FUNCTION APPERROR
    PARAMETER M.ERRNUM, M.PROGRAM, M.LINE, M.MESS, M.MESS1, M.PARAM, M.SYS16
    IF TYPE('M.ERRNUM')!="N"
        WAIT WINDOWS "�� ���������� �������. ��������� ���� � ����� main.ini."
        QUIT
    ENDIF
    DO CASE
            * �������� ���� ������� ��������� � �������
        CASE M.ERRNUM=1531
            RETURN .T.
            * �������� �� ������� ������������ �������
        CASE M.ERRNUM=1871
            RETURN .T.
        CASE M.ERRNUM=1707
            RETRY
        CASE M.ERRNUM=109
            IF MESSAGEBOX("������ �������������. ���������� �������.", WTITLE(""), 0+64+0)=1
                RETRY
            ELSE
                RETURN .F.
            ENDIF
    ENDCASE
    PRIVATE K, I
    SET TEXTMERGE TO ERROR.txt ADDITIVE
    SET TEXTMERGE ON NOSHOW

\   Date :<<Date()>> <<Time()>>
\  Error :<<m.errnum>>
\ Module :<<m.program>>
\At Line :<<m.line>>
\Message :<<m.mess>>
\ Source :<<m.mess1>>
\  Param :<<m.param>>
\Execute :<<m.sys16>>
    IF TYPE("m.�������") = "U"

    ELSE
        IF !EMPTY(m.�������) AND TYPE('m.�������') = "C"
\m.������� = <<m.�������>>
        ENDIF
    ENDIF

\stack
    I = 1
    DO WHILE  .NOT. EMPTY(SYS(16, I))
\<<i>> <<sys(16,i)>>
        I = I+1
    ENDDO
\
    SET TEXTMERGE OFF
    SET TEXTMERGE TO
    K = MESSAGEBOX("���������� ������ # "+LTRIM(STR(M.ERRNUM))+' "'+M.MESS+'"', 0+64+0, "������")
    DO CASE
        CASE K=3
            DO ����������������
        CASE K=4
            RETRY
        CASE K=5
            RETURN .T.
    ENDCASE
    RETURN .T.
ENDFUNC
**
PROCEDURE ����������������
    �APP.DISCONNECTSQL()
    SET SYSMENU TO DEFAULT
    ON ERROR
    SET STATUS BAR ON
    CLOSE ALL
    RELEASE ALL
    SET RESOURCE ON
    RESTORE MACROS
    POP KEY ALL
    *SET STEP ON

    *CLEAR ALL
    CANCEL
ENDPROC
**
DEFINE CLASS _App AS CUSTOM
    * �������� ������ � �������
    ���� = ""
    DBFS = .T.
    * ������� ����� ��� ������
    ������� = ""
    * �������� ���������� ����� ODBC
    ������������� = ""
    ���������� = 0
    * �������� �������� ������������
    ������������ = ""
    ������ = ""
    * �������� ��� ���������� ������
    ������� = ""
    ��������� = ""
    * ���� � ��������� ������� (EXCEL)
    �������� = ""
    * ���� � �������
    ������������������ = ""
    * �������� ���� �� MSSQL �������
    ����mssql = ""

    procedure �������������

        * ��������� �������
        PRIVATE M.NAME, M.OLDERR, M.NERROR, M.PLUGINDIR
        PRIVATE M.PLUGINMODULES, M.PLUGINCOUNT
        m.PLUGINDIR = SYS(5)+SYS(2003)+"\plugin\"
        m.PLUGINMODULES = ADIR(PLGIN, M.PLUGINDIR+'*.*')
        IF M.PLUGINMODULES=0
            *RETURN .F.
        ELSE
            m.OLDERR = ON('ERROR')
            m.NERROR = 0
            ON ERROR STORE ERROR() TO M.NERROR
            FOR M.PLUGINCOUNT = 1 TO M.PLUGINMODULES
                IF  .NOT. ('D'$PLGIN(M.PLUGINCOUNT, 5)) .AND. INLIST(JUSTEXT(PLGIN(M.PLUGINCOUNT, 1)), "PRG", "APP", "EXE")
                    m.NAME = M.PLUGINDIR+PLGIN(M.PLUGINCOUNT, 1)
                    *���� ������� ���� �� ����� ��� ����������
                    DO INIT IN (M.NAME)
                ENDIF
            ENDFOR
        ENDIF
        RELEASE M.NAME, M.OLDERR, M.NERROR, M.PLUGINDIR
        RELEASE M.PLUGINMODULES, M.PLUGINCOUNT
        ON ERROR DO APPERROR WITH    ERROR(),   PROG(), LINENO(), MESSAGE(), MESSAGE(1), SYS(2018)
        * ������ �������� ������ ����
        SET SYSMENU TO DEFAULT
        DO menu_App.mpr
        DEFINE POPUP DATAS MARGIN RELATIVE SHADOW COLOR SCHEME 4

        * ���� ������ ������������
        SELECT ������������
        SCAN ALL FOR ALLTRIM(������������.��������) == ALLTRIM(�APP.������������)
            * ���� ����� ����
            SELECT ����
            SCAN ALL FOR ALLTRIM(����.��������) == ALLTRIM(������������.����)
                * ���� ����� ����
                SELECT ����
                SCAN ALL FOR ����.���_� == ����.���
                    ������� = "�APP.ADDBAR('"+ALLTRIM(����.��������)  +"',"+;
                        "'"+ALLTRIM(����.����������)+"',"+;
                        "'"+ALLTRIM(����.���������) +"'"
                    IF !EMPTY(ALLTRIM(����.����������))
                        ������� = ������� + ",'" + ALLTRIM(����.����������)+ "'"
                    ENDIF
                    IF !EMPTY(ALLTRIM(����.�������))
                        ������� = ������� + ",'" + ALLTRIM(����.�������) + "'"
                    ENDIF
                    ������� = ������� + ")"
                    &�������
                ENDSCAN && ����� ������ ����
                * ���� ������ �� ������ - ������� �� �������� ����
                RETURN .T.
            ENDSCAN && ����� ������ ����
            * ���� ������ �� ������ - ������� �� �������� ����
            RETURN .T.
        ENDSCAN && ����� ������ ������������
        * ���� ������ �� ������ - ������� �� �������� ����
        RETURN .T.

    endproc
    **
    FUNCTION GETSTR
        PARAMETER M.FILE, M.SECTION, M.ITEM, M.DEFAULT
        PRIVATE M.BUFF, M.LEN
        m.BUFF = CHR(0)
        m.LEN = 0
        m.BUFF = REPLICATE(CHR(0), 2048)
        m.LEN = GetPrivStr(M.SECTION, M.ITEM, M.DEFAULT, @M.BUFF, LEN(M.BUFF), M.FILE)
        RETURN IIF(M.LEN !=0, LEFT(M.BUFF, M.LEN), "")
    ENDFUNC
    **
    FUNCTION putstr
        PARAMETER M.FILE, M.SECTION, M.ITEM, M.DEFAULT
        PRIVATE M.LEN
        m.LEN = WritePrivStr(M.SECTION, M.ITEM, M.DEFAULT, M.FILE)
        RETURN M.LEN
    ENDFUNC
    **
    FUNCTION ������������
        SELECT �������
        SCAN ALL FOR INLIST(ALLTRIM(�������.����������),"����������","��������")
            ������� = "O" + ALLTRIM(�������.��������)+ [.�������()]
            &�������
            SET EXCLUSIVE ON
            ������� = "O" + ALLTRIM(�������.��������)+ [.�������()]
            IF  .NOT. EVALUATE(�������)
                DO ����������������
            ENDIF
            ������� = "SELECT " + ALLTRIM(�������.��������)
            &�������
            ������� = "PACK"
            &�������
            ������� = "O" + ALLTRIM(�������.��������)+ [.�������()]
            &�������
            SET EXCLUSIVE OFF
            ������� = "O" + ALLTRIM(�������.��������)+ [.�������()]
            IF  .NOT. EVALUATE(�������)
                DO ����������������
            ENDIF
            SELECT �������
        ENDSCAN
        DO ����������������
    ENDFUNC
    **

    PROCEDURE connectSql
        IF  .NOT. THIS.DBFS
            STORE SQLCONNECT(THIS.�������������, THIS.������, '') TO THIS.����������
            IF THIS.����������<=0
                = MESSAGEBOX('� �������� ����������� �� �������', 16, 'SQL Connect Error')
                DO ����������������
            ENDIF
        ENDIF
    ENDPROC

    PROCEDURE DISCONNECTSQL
        IF  .NOT. THIS.DBFS
            = SQLDISCONNECT(THIS.����������)
        ENDIF
    ENDPROC

    FUNCTION ���������
        IF THIS.DBFS
            m.������� = THIS.�������+THIS.���������
            &�������
        ELSE
            IF EMPTY(THIS.���������)
                RETURN IIF( -1 = SQLEXEC(THIS.����������, �������), .F., .T.)
            ELSE
                RETURN IIF( -1 = SQLEXEC(THIS.����������, �������,THIS.���������), .F., .T.)
            ENDIF
        ENDIF
    ENDFUNC

    PROCEDURE addbar
        PARAMETER M.CPOPUPNAME, CPROMPT, CCOMMAND, KEYNAME, KEYCAPTION
        N = CNTBAR(M.CPOPUPNAME)+1
        KEYNAME = IIF(EMPTY(KEYNAME), "", KEYNAME)
        KEYCAPTION = IIF(EMPTY(KEYCAPTION), "", KEYCAPTION)
        IF  .NOT. EMPTY(KEYNAME)
            DEFINE BAR N OF (CPOPUPNAME) PROMPT CPROMPT KEY &KEYNAME, KEYCAPTION
        ELSE
            DEFINE BAR N OF (CPOPUPNAME) PROMPT CPROMPT
        ENDIF
        IF  .NOT. EMPTY(CCOMMAND)
            ON SELECTION BAR N OF (CPOPUPNAME) &CCOMMAND
        ENDIF
    ENDPROC


ENDDEFINE

DEFINE CLASS _motor AS CUSTOM
    �����               = 0
    �������             = ""
    �����������������   = ""
    ������������������� = ""
    �������������       = 0
    ������              = ""
    �������             = ""
    * ��� ����� ����� ��� ��������������
    �����               = NULL
    C��������������     = .T.
    * ���������� ��� ������ � �������
    ���                 = ""
    * ��� ������ �� ������� "�������"
    ����������          = ""
    * �������� ������� � ������� �������� �� ������� "�������"
    ���������������     = ""



    PROCEDURE ����������������
    ENDPROC

    PROCEDURE �������������
    ENDPROC

    PROCEDURE ���������
    ENDPROC

    PROCEDURE �������
    ENDPROC

    PROCEDURE �����������������
    ENDPROC

    PROCEDURE �������
    ENDPROC

    PROCEDURE �������
    ENDPROC

    PROCEDURE ��������
    ENDPROC

    PROCEDURE �������������
    ENDPROC

    PROCEDURE ��������
    ENDPROC

    PROCEDURE �������
    endproc

    PROCEDURE ����������������
        IF 6=MESSAGEBOX("�� ������������� ������ ������� ������? ", 4+32+256, " ��������! ")
            RETURN THIS.�������()
        ELSE
            RETURN .F.
        ENDIF
    endproc

    PROCEDURE  �����
    ENDPROC

    PROCEDURE ��������
    ENDPROC

    PROCEDURE �������������������
    ENDPROC

    PROCEDURE �����������
    ENDPROC

    PROCEDURE ���������������������������������
    ENDPROC

    PROCEDURE ��������������������������
    ENDPROC
     
    PROCEDURE �������������������������
    ENDPROC

    PROCEDURE ����������������
    ENDPROC

    PROCEDURE �������������
        SELECT �������
        SCAN FOR �������.��� = THIS.����������
            EXIT
        endscan
    ENDPROC


    PROCEDURE ���������GRSM
    ENDPROC

    PROCEDURE ������������
        PARAMETERS ��������
        IF !USED("CACHE")
            CREATE DBF cache.DBF (NUMBER c (10), kommand m)
        ENDIF
        INSERT INTO cache (NUMBER, kommand) VALUES (SYS(2015),��������)
    ENDPROC
    
    PROCEDURE ���������
    ENDPROC

    PROCEDURE ���������
    ENDPROC
    
ENDDEFINE

DEFINE CLASS _motorDBF AS _motor

    PROCEDURE �������
        ������� = ""
        IF THIS.���������()
            SCAN ALL
                ������� = ������� +IIF(EMPTY(�������),""," ,") + ALLTRIM(Temp����.��������)+" "
                DO CASE
                    CASE INLIST(ALLTRIM(Temp����.���), "W", "Y", "D", "T", "B", "G", "I", "L", "M")
                        ������� = ������� + ALLTRIM(Temp����.���)
                    CASE INLIST(ALLTRIM(Temp����.���), "C", "Q", "V")
                        ������� = ������� + ALLTRIM(Temp����.���) + "(" +ALLTRIM(Temp����.������)+")"
                    CASE INLIST(ALLTRIM(Temp����.���), "N", "F")
                        ������� = ������� + ALLTRIM(Temp����.���) + "(" +ALLTRIM(Temp����.������)+","+ALLTRIM(Temp����.��������)+")"
                ENDCASE
            ENDSCAN
            USE IN Temp����
        ENDIF
        * ���� ���� ��� �� �������, ������� �� �������.
        IF EMPTY(�������)
            RETURN .F.
        ENDIF

        ������� = " CREATE TABLE " + �APP.���� + ALLTRIM(�������.��������)+ ".dbf NAME " +ALLTRIM(�������.��������)+ " (" + ������� + ")"
        &�������
        RETURN .T.

    ENDPROC
    
    PROCEDURE �������
        * ���� � ��� DBF ������

        * ���� ������� ��� �������
        IF USED(UPPER(THIS.���������������))
            SELECT (THIS.���������������)
            * ������ �������
            RETURN .T.
        ENDIF
        * ��������� ���� �� ����� dbf ����
        IF FILE(�APP.���� + THIS.��������������� + ".dbf")
            SELECT 0
            * ���������
            USE �APP.���� + THIS.��������������� +".dbf"
        ELSE
            * �������� ��� �������
            RETURN THIS.�������()
        ENDIF
        * ���� �� ����� ��������� ����
        IF  .NOT. FILE(�APP.���� + THIS.��������������� + ".cdx")
            THIS.�������()
            THIS.�����������������()
            * ������� ������� ���� ����
            INDEX ON ��� TAG ��� COLLATE 'MACHINE'
            INDEX ON ���_� TAG ���_� COLLATE 'MACHINE'
            THIS.�������()
            THIS.�������()
        ENDIF
        * � ������� ��� ��� ����
        RETURN .T.
    ENDPROC
    
    **
    PROCEDURE �����������������
        * ��������� ���� �� ����� dbf ����
        IF FILE(�APP.���� + THIS.��������������� + ".dbf")
            SET EXCLUSIVE ON
            SELECT 0
            USE �APP.���� + THIS.��������������� + ".dbf"
            SET EXCLUSIVE OFF
        ENDIF
        RETURN .T.
    ENDPROC

    **
    PROCEDURE �������
        IF USED(THIS.���������������)
            SELECT THIS.���������������
            USE 
        ENDIF
    ENDPROC

    PROCEDURE ����������������
        LOCAL       m.�������, m.�������, m.�������1, m.���������
        STORE "" TO m.�������, m.�������, m.�������1, m.���������

        * ������� ��� ������ �� ������� "����"
        * ��������� � ������� � ������� "�������"
        * ������� ������ �������� ����
        SELECT ����.* ;
            FROM ����;
            WHERE ALLTRIM(����.���_�) == this.���������� ;
            AND ����.����������� = .F. ;
            INTO CURSOR Temp����

        SELECT Temp����

        SCAN all
            ������� =  "m.temp = TRANSFORM(THIS." + ALLTRIM(Temp����.��������) + " )"
            &�������
            DO CASE
                * ������� ���� ��� ���������
                CASE INLIST(ALLTRIM(Temp����.���), "L")            
                
                * ���� - ������� �� �����
                CASE INLIST(ALLTRIM(Temp����.���), "W", "Y", "D", "T", "B", "G", "I", "M")
                    * TODO ���� �� ���� � ����� ��� ���������� �������� ���� �����������
                     m.temp = "'" + ALLTRIM(m.temp) + "'"
                     
                CASE INLIST(ALLTRIM(Temp����.���), "C", "Q", "V")
                    IF EMPTY(m.temp)
                        m.temp = "'" + Temp����.����������� + "'" 
                    ELSE 
                        m.temp = "'" + ALLTRIM(m.temp) + "'"
                    ENDIF 
                CASE INLIST(ALLTRIM(Temp����.���), "N", "F")

            ENDCASE

            ******** ������� ************
            �������  = �������  + IIF( !EMPTY(�������)  , [, ] , []) + ALLTRIM(Temp����.��������)
            �������1 = �������1 + IIF( !EMPTY(�������1) , [, ] , []) + m.temp
            ******** ����� ������� *******


            ******** ��������� ***********
            ** �� ���� �������� ���� � ������� �� �������� ���������� ���������
            IF ALLTRIM(Temp����.��������) != "���"
                ��������� = ��������� + IIF( !EMPTY(���������), [, ] , [ ]) + ALLTRIM(Temp����.��������) + " = " + m.temp
            ENDIF 
            ******** ����� ��������� *****
        ENDSCAN

        * ������������ ������� ��� �������
        IF !EMPTY(�������) AND !EMPTY(�������1)
            m.������� = " INSERT INTO " + THIS.��������������� +" ( " + m.������� + " ) VALUES ( " + �������1 +" )"
        ENDIF
        ������� = "O"+ this.��������������� + ".����������������� =  ������� "
        &�������

        * ������������ ������� ��� ���������
        IF !EMPTY(���������)
            ��������� = " UPDATE " + This.��������������� + ;
                        " SET  " + ��������� + ;
                        " WHERE " + This.��������������� + ;
                        ".��� = '" + TRANSFORM(THIS.���) + "'"
        ENDIF
        ������� = "O"+ This.��������������� + ".������������������� =  ��������� "
        &�������

        IF USED("Temp����")
            USE IN Temp����
        ENDIF
    ENDPROC
    **
    *!*        FUNCTION �������RGSM
    * ��������� ������ �������� ������� ����������

    *!*                IF !USED("RGSM")
    *!*                    this.��������� = ""
    *!*                    IF !this.���������("use RGSM")
    *!*                        WAIT windows NOWAIT ("������ �� ����������")
    *!*                    ENDIF

    *!*                    this.��������� = "temp"
    *!*                    m.������� = 'SELECT       @@Servername             AS Server       ,'
    *!*                    m.������� = m.������� + ' DB_NAME()                AS DBName       ,'
    *!*                    m.������� = m.������� + ' TRIM(isc.Table_Name)     AS TableName    ,'
    *!*                    m.������� = m.������� + ' isc.Table_Schema         AS SchemaName   ,'
    *!*                    m.������� = m.������� + ' Ordinal_Position         AS Ord          ,'
    *!*                    m.������� = m.������� + ' Column_Name              AS Column_Nam   ,'
    *!*                    m.������� = m.������� + ' Data_Type                                ,'
    *!*                    m.������� = m.������� + ' Numeric_Precision        AS  Prec        ,'
    *!*                    m.������� = m.������� + ' Numeric_Scale            AS  Scale       ,'
    *!*                    m.������� = m.������� + ' Character_Maximum_Length AS LEN          ,'
    *!*                    m.������� = m.������� + ' Is_Nullable                              ,'
    *!*                    m.������� = m.������� + ' Column_Default                           ,'
    *!*                    m.������� = m.������� + ' Table_Type                                '
    *!*                    m.������� = m.������� + ' FROM  INFORMATION_SCHEMA.COLUMNS isc      '
    *!*                    m.������� = m.������� + ' INNER JOIN  information_schema.tables ist '
    *!*                    m.������� = m.������� + '       ON isc.table_name = ist.table_name  '
    *!*                    m.������� = m.������� + ' ORDER BY DBName , '
    *!*                    m.������� = m.������� + ' TableName , '
    *!*                    m.������� = m.������� + ' SchemaName , '
    *!*                    m.������� = m.������� + ' Ordinal_position;  '

    *!*                    IF !this.���������(m.�������)
    *!*                        WAIT windows NOWAIT ("������ �� ����������")
    *!*                        *this.����������������()
    *!*                    ENDIF


    *!*                    IF NOT USED("RGSM")
    *!*                        USE RGSM IN 0 EXCLUSIVE
    *!*                        SELECT RGSM
    *!*                        ZAP
    *!*                    ENDIF
    *!*                    SELECT RGSM
    *!*                    SET ORDER TO TableName

    *!*                    SELECT temp
    *!*                    SCAN ALL
    *!*                        SCATTER name oRGSM
    *!*                        INSERT  INTO RGSM from name oRGSM
    *!*                        SELECT temp
    *!*                    ENDSCAN
    *!*                    SELECT RGSM


    *!*                endif
    *!*                SELECT RGSM
    *!*            endfunc


    PROCEDURE ���������

        SELECT ����.* ;
            FROM ���� ;
            WHERE ����.���_� == this.���������� ;
            INTO CURSOR Temp����

        SELECT Temp����
        IF _TALLY = 0
            USE IN Temp����
        ENDIF
        RETURN IIF(_TALLY > 0, .T. , .F.)
    ENDPROC






    **

    PROCEDURE ��������

        IF THIS.���������()
            SELECT Temp����
            * ������� ��������� ������� ����������
            SCAN ALL
                ������� = "this." +ALLTRIM(Temp����.��������)
                DO CASE
                    CASE INLIST(ALLTRIM(Temp����.���),"W", "G", "Q", "V", "M")
                        ������� = ������� + " = []"
                    CASE ALLTRIM(Temp����.���) = "C"
                        ������� = ������� + " = ["+SPACE(VAL(Temp����.������))+"]"
                    CASE INLIST(ALLTRIM(Temp����.���),"Y", "B", "I", "N", "F")
                        ������� = ������� + " = 0"
                    CASE INLIST(ALLTRIM(Temp����.���),"D")
                        ������� = ������� + " = {}"
                    CASE INLIST(ALLTRIM(Temp����.���),"T")
                        ������� = ������� + " = datetime(null,null,null,null,null,null)"
                    CASE ALLTRIM(Temp����.���) = "L"
                        ������� = ������� + " = .f."
                ENDCASE
                &�������
            ENDSCAN
            USE IN Temp����
        ENDIF
        SELECT �������
        * � ����� �� ���������
        IF !EMPTY(�������.��������)
            ������� = "this.���_� = [" + EVALUATE("O" + ALLTRIM(�������.��������)+ ".��� ") +"]"
            &�������
        ENDIF
        ������� = "SELECT C" + THIS.���������������
        &�������
    ENDPROC
    **
    PROCEDURE �������������
        IF THIS.���������()
            SELECT Temp����
            SCAN ALL
                ������� = "this." +ALLTRIM(Temp����.��������)+ " = C" +ALLTRIM(THIS.���������������)+"." +ALLTRIM(Temp����.��������)
                &�������
            ENDSCAN
            USE IN Temp����
        ENDIF
        ������� = "SELECT C" + THIS.���������������
        &�������
    ENDPROC
    **
    PROCEDURE ��������
        IF !EMPTY(�������.��������) AND EMPTY(THIS.���_�)
            RETURN .F.
        ENDIF
        IF NOT THIS.���������������������������������()
            RETURN .F.
        ENDIF

        *********************** �������� ������� ������ � ����� ����� ********
        * ��� ����������, ���� �� ��������� ������ � ������ ������ � �� ����� �������� ���� ����������

        LOCAL m.��������
        m.�������� = .T.
        IF !EMPTY(THIS.���)
            ������� = "SELECT ��� AS ��� where '" + THIS.��� + "' == " +  this.��������������� + ".��� FROM  " + this.���������������

            ������� = �������+" into cursor temp"
            &�������

            IF USED("temp")
                SELECT temp
                IF ISNULL(temp.���) OR EMPTY(temp.���)
                    * ��� ����� ������
                    m.�������� = .T.
                ELSE
                    * ���� ����� ������
                    m.�������� = .F.
                ENDIF
                USE IN temp
            ENDIF
        ENDIF
        **********************************************************************
        IF m.��������
            * �������� ����������
            IF THIS.�������������������("��������")
                *���������� ����� ��� ������
                IF EMPTY(THIS.���)
                    LOCAL m.����������
                    * ���������� ������ ������ � �������� 2 ������� �� �������
                    m.���������� = LEN(THIS.���)-2

                    ������� = "SELECT MAX(VAL(SUBSTR(���,3,m.����������))) AS ��� FROM "+ALLTRIM(�������.��������)+ " into cursor temp"
                    &�������

                    IF USED("temp")
                        SELECT temp
                        IF ISNULL(temp.���)
                            THIS.��� = 1
                        ELSE
                            THIS.��� = temp.���+1
                        ENDIF
                        USE IN temp
                    ELSE
                        THIS.��� = 1
                    ENDIF
                    THIS.��� = �APP.�������+REPLICATE("0", m.����������-LEN(ALLTRIM(STR(THIS.���)))) + ALLTRIM(STR(THIS.���))
                ENDIF
                THIS.����������������� = ""
                THIS.����������������()

                m.������� = THIS.�����������������
                &�������

            ENDIF
        ELSE
            IF THIS.�������������������("��������")
                THIS.������������������� = ""
                THIS.����������������()
                m.������� = THIS.�������������������
                &�������
            ENDIF
        ENDIF
        ������� = "SELECT C" + THIS.���������������
        &�������
        IF m.��������
            RETURN "new"
        ELSE
            RETURN "old"
        ENDIF
    endproc
    **

    **
    PROCEDURE �������
        * ��������� ����������
        IF !THIS.�������������������("�������")
            RETURN .F.
        ENDIF

        * ����� ������ �� ������
        THIS.�������������()
        * ��������� � ����� �������� �������� :)
        THIS.�������������()

        * ��� �� ��������� �� ����� ������� ������ �������
        m.������� = UPPER(THIS.���������������)

        * ������ ������� �� ������ � ������� ��� ������� �������� ���������� ��� ����
        ������� = "SELECT �������.�������� as ������� , ����.��������    as ���� ;
                       FROM �������, ���� ;
                       where �������.��� == ����.���_� and UPPER(ALLTRIM(����.��������)) ==  m.������� "


        ������� = �������+" into cursor temp"
        &�������

        * ���� ������� ����
        IF USED("temp") AND RECCOUNT("temp") > 0
            SELECT temp
            * ���� ��� ������� �������� ����������
            * �������� ���������� ������ �� ����� �� ����� � ������� ������  � ��������� ��������
            SCAN ALL FOR !ISNULL(temp.�������) AND !EMPTY(temp.�������)

                * ������� � ��� ������� � ��������� �������� ������� �������� ����� �� ��� � ���� ���?
                ������� = "SELECT ��� as ��� ;
                                 FROM " + ALLTRIM(temp.�������)+;
                    " where " + ALLTRIM(temp.�������)+"." + ALLTRIM(temp.����)+ " = [" +EVALUATE("O" + m.������� + ".��� ") + "]"+;
                    " into cursor temp1"

                &�������
                IF _TALLY >0
                    WAIT WINDOWS " �� ������� " + ALLTRIM(temp.�������) +" �� ������� ������ ��������� � ����."
                    USE IN temp1
                    USE IN temp
                    ������� = "SELECT C" + THIS.���������������
                    &�������
                    RETURN .F.
                ENDIF
                SELECT temp
            ENDSCAN
        ENDIF
        * ��� ������, �� �� ��� �� ����������
        IF USED("Temp")
            USE IN temp
        ENDIF
        IF USED("Temp1")
            USE IN temp1
        ENDIF

        * ����� ������� ������
        ������� = "SELECT C" + THIS.���������������
        &�������

        ������� = "THIS.��� = C" + THIS.���������������+ ".���"
        &�������

        ������� = "THIS.���_� = C" + THIS.���������������+ ".���_�"
        &�������

        ������� = " DELETE FROM " + THIS.��������������� + " WHERE " + THIS.��������������� + ".��� = THIS.���"
        &�������

        ������� = "SELECT C" + THIS.���������������
        &�������

        RETURN .T.
    endproc
    **
    PROCEDURE  �����
        LPARAMETERS m.���
        IF !THIS.�������������������("�����")
            RETURN .F.
        ENDIF
        THIS.�������������()
        ������� = ""
        IF INLIST(�������.����������,"�������", "����������", "��������")
            IF EMPTY(ALLTRIM(������))
                WAIT WINDOWS " �� ������� ������� ��� ������ ������ "
                RETURN .F.
            ELSE
                ������� = ALLTRIM(�������.������)
            ENDIF
        ENDIF
        IF  !EMPTY(THIS.������)
            ������� = ������� + ' ' + THIS.������
        ENDIF
        IF  !EMPTY(THIS.�������)
            ������� = ������� + ' ' + THIS.�������
        ENDIF

        ������� = ������� + " INTO CURSOR C" +THIS.���������������
        &�������

        ������� = "SELECT C" + THIS.���������������
        &�������

        IF  !EMPTY(m.���)
            ������� = "m.���=C" + THIS.���������������+ ".���"
            LOCATE FOR EVALUATE(�������)
            IF !FOUND()
                GO TOP
            ENDIF
        ENDIF
        RETURN .T.
    ENDPROC
    **
    PROCEDURE ��������
        LPARAMETERS m.���
        * ���� ����������� �� ������������ �� ����� ������ ����� ������
        IF EMPTY(m.���)
            * ������ ������ � ������� ������
            m.��� = THIS.���
        ENDIF
        IF THIS.�������������������("��������")
            THIS.�������������()
            IF (�������.���������� = "����������" OR �������.���������� = "��������" OR �������.���������� = "�������")
                IF THIS.������������� = 0
                    THIS.�����(m.���)
                    ������� = "SELECT C" + THIS.���������������
                    &�������
                    *������� = "DO FORM .\forms\" + THIS.���������������+ ".scx"
                    ������� = "DO FORM .\forms\�������������.scx"
                    &�������
                ENDIF
                THIS.������������� = 1
            ENDIF
        ENDIF
    ENDPROC
    **
    PROCEDURE �������������������
        LPARAMETERS m.����������
        PRIVATE m.�������, m.�����
        m.������� = ""
        m.����� = .F.

        m.������� = UPPER(THIS.���������������)

        SELECT ����������.* ;
            FROM ������������, ����������, ����;
            WHERE UPPER(ALLTRIM(�APP.������������)) == UPPER(ALLTRIM(������������.��������)); && ������� ���� ������ ������������
        AND UPPER(ALLTRIM(����.��������)) == UPPER(ALLTRIM(������������.����)) ; && ����� ���� ����� ����
        AND ����.��� = ����������.���_� ; && ����� �� ���� ���������� ����������
        AND m.������� == UPPER(ALLTRIM(����������.��_�������)); && ��� ����� �� ����� �������
        INTO CURSOR Temp����������

        IF _TALLY > 0
            DO CASE
                CASE m.���������� = "�����"    AND Temp����������.��_�����
                    m.����� = .T.
                CASE m.���������� = "��������" AND Temp����������.��_��������
                    m.����� = .T.
                CASE m.���������� = "��������" AND Temp����������.��_��������
                    m.����� = .T.
                CASE m.���������� = "��������" AND Temp����������.��_��������
                    m.����� = .T.
                CASE m.���������� = "�������" AND Temp����������.��_�������
                    m.����� = .T.
            ENDCASE
        ENDIF
        IF USED("Temp����������")
            USE IN Temp����������
        ENDIF
        IF !m.�����
            WAIT WINDOWS NOWAIT "��� ��������� " + m.���������� + ". �������: " + ALLTRIM(�������.��������)
        ENDIF
        RETURN m.�����

    ENDPROC

    PROCEDURE �����������
        LPARAMETERS ���������
        ������� = "SELECT C" + THIS.���������������
        &�������
        SCAN ALL FOR ��� == ���������
            THIS.�������������()
            RETURN .T.
        ENDSCAN
        RETURN .F.
    ENDPROC

    PROCEDURE ���������������������������������
        * � ��� ���� ������ � ����������� ����������
        * ���������� ������� �������� ������� ������� ��������� �� ������ �������
        
        SELECT ����.��������, ����.�������� ;
            FROM ����;
            WHERE ALLTRIM(����.���_�)  == THIS.����������  ;
            AND ����.����������� = .F. ;
            AND !EMPTY(����.��������) ;
            INTO CURSOR Temp����

        SELECT Temp����
        IF _TALLY = 0
            USE IN Temp����
            RETURN .T.
        ENDIF
        * �������������� ���������� �������
        LOCAL m.��������, m.��������, m.���������
        m.��������� = ""

        SCAN ALL
            m.�������� = Temp����.��������
            m.�������� = Temp����.��������

            * � ��������� ���� �� � ������� �� ������� ��������� ����� ������
            ������� =           " select * from " + ALLTRIM(m.��������)
            ������� = ������� + " into cursor temp "
            ������� = ������� + " where ��� = this." + ALLTRIM(m.��������)
            &�������

            SELECT temp
            IF _TALLY = 0
                m.��������� = m.��������� + CHR(13) + " �� ������� ������ � " + ALLTRIM(m.��������) + " ��� " +ALLTRIM(m.��������)
            ENDIF
        ENDSCAN
        USE IN Temp����
        USE IN temp
        IF !EMPTY(m.���������)
            WAIT WINDOWS m.���������
            RETURN .F.
        ELSE
            RETURN .T.
        ENDIF

    endproc

     PROCEDURE ��������������������������
         IF NOT EMPTY(this.���)         
             SELECT ����
             IF USED('temp')
                 USE IN 'temp'
             endif
             
             ������� = "SELECT ����.���������� FROM ���� WHERE ����.��� = '" + this.��� + "' INTO CURSOR 'temp'"
             &�������

             IF used("temp")
                 SELECT "temp"
                 SCAN all
                     SCATTER MEMVAR memo
                     IF NOT EMPTY(m.����������)
                         try 
                             =EXECSCRIPT(����������)
                         CATCH
                             WAIT windows " �� ������ ��������� ����� ���������� !"
                         ENDTRY
                      ENDIF 
                 endscan
                 USE IN "temp"
             ENDIF 
         ENDIF 
     ENDPROC
     
     PROCEDURE �������������������������
         IF NOT EMPTY(this.���)
             SELECT ����
             IF USED('temp')
                 USE IN 'temp'
             endif
             ������� = "SELECT ����.��������� FROM ���� WHERE ����.��� = '" + this.��� + "' INTO CURSOR 'temp'"
             &�������
             IF used("temp")
                 SELECT "temp"
                 SCAN all
                     SCATTER MEMVAR memo 
                     IF NOT EMPTY(m.���������)
                         try 
                             =EXECSCRIPT(���������)
                         CATCH
                             WAIT windows " �� ������ ��������� ����� ��������� !"
                         ENDTRY
                      ENDIF 
                 endscan
                 USE IN "temp"
             ENDIF 
         ENDIF 
     ENDPROC
     
    PROCEDURE ���������
        SELECT (THIS.���������������)
        RETURN FLOCK()
    ENDPROC
    **
    PROCEDURE ���������
        UNLOCK IN (THIS.���������������)
    ENDPROC     

ENDDEFINE



* ���������� ������������ �������
* ���������������� ������� � ������� ������, ���� :
* Column, Header
***************************************************
DEFINE CLASS MyHeader AS HEADER
    FONTNAME=C_FONTNAME
    FONTSIZE=C_FONTSIZE
    FONTBOLD=.T.
    ALIGNMENT=2
    WORDWRAP=.T.
    ������ = ""
    ������� = ""

    PROCEDURE INIT(m.������, m.�������)
        WITH THIS
            .������ = m.������
            .������� = m.�������
        ENDWITH

    PROCEDURE DBLCLICK
        ������� =  'o' +THIS.������+ '.�������  = " order by '+THIS.������� + '"'
        &�������
        THISFORMSET.��������()
    ENDPROC

ENDDEFINE


DEFINE CLASS MyColumn AS COLUMN
    FONTNAME=C_FONTNAME
    FONTSIZE=C_FONTSIZE
    VISIBLE=.T.
    INDEX=0


    PROCEDURE INIT(m.���, m.������ , m.�������)
        WITH THIS
            .REMOVEOBJECT('Header1')
            .ADDOBJECT("Header","MyHeader", m.������, m.�������)
            .REMOVEOBJECT("Text1")
            DO CASE
                CASE m.��� = "CheckBox"
                    .ADDOBJECT("CheckBox","MyGridCheckBox")
                    .CURRENTCONTROL="CheckBox"
                    .CHECKBOX.VISIBLE = .T.
                    .SPARSE = .F.
                OTHERWISE
                    .ADDOBJECT("Text","MyGridText")
                    .CURRENTCONTROL="Text"
                    .TEXT.VISIBLE=.T.

            ENDCASE
        ENDWITH
   ENDPROC 
        
ENDDEFINE

DEFINE CLASS MyGridText AS TEXTBOX
    FONTNAME=C_FONTNAME
    FONTSIZE=C_FONTSIZE

    MARGIN=0
    SPECIALEFFECT=1
    SELECTONENTRY=.T.
    BORDERSTYLE=0
    VISIBLE=.T.

    PROCEDURE KEYPRESS(nKeyCode, nShiftAltCtrl )
         DO CASE
        CASE  nKeyCode = -2
            THISFORMSET.f3()
        CASE  nKeyCode = -3
            THISFORMSET.f4()
        CASE  nKeyCode = 7
            THISFORMSET.delete()
        CASE  nKeyCode = 13
            THISFORMSET.enter()
        OTHERWISE

        ENDCASE
    ENDPROC

    PROCEDURE RIGHTCLICK
        THISFORMSET.�����()
    ENDPROC

    PROCEDURE DBLCLICK
        THISFORMSET.F4()
    ENDPROC


ENDDEFINE

DEFINE CLASS MyGridCheckBox AS CHECKBOX

    FONTNAME=C_FONTNAME
    FONTSIZE=C_FONTSIZE

    VISIBLE=.T.
    CAPTION = ""
    ALIGNMENT = 2

    PROCEDURE KEYPRESS(nKeyCode, nShiftAltCtrl )
        DO CASE
        CASE  nKeyCode = -2
            THISFORMSET.f3()
        CASE  nKeyCode = -3
            THISFORMSET.f4()
        CASE  nKeyCode = 7
            THISFORMSET.delete()
        CASE  nKeyCode = 13
            THISFORMSET.enter()
        OTHERWISE

        ENDCASE

    ENDPROC

    PROCEDURE RIGHTCLICK
        THISFORMSET.f4()
    ENDPROC

    PROCEDURE DBLCLICK
        THISFORMSET.f4()
    ENDPROC

ENDDEFINE

PROCEDURE NtoC
    PARAMETER m.nValue, m.Decimals
    PRIVATE ALL
    *
    * m.nValue      - (N) ����� ��� �������������
    * m.Decimals    - (L) �������� � ��������� ?
    *
    * �������� �����
    IF EMPTY(m.nValue)
        RETURN '���� ������'+IIF(!EMPTY(m.Decimals),' 00 ������','')+'.'
        * �������� ��� �������� �����
    ELSE
        IF TYPE('m.nValue') # 'N'
            RETURN ''
        ENDIF
    ENDIF

    STORE '' TO ret
    STORE 0  TO tmp, tv, I

    DECLARE names[6,3], numbers[19], tens[10], hound[10]

    names[1,1]='�������'
    names[1,2]='�������'
    names[1,3]='������'

    names[2,1]='�����'
    names[2,2]='�����'
    names[2,3]='������'

    names[3,1]='������'
    names[3,2]='������'
    names[3,3]='�����'

    names[4,1]='�������'
    names[4,2]='��������'
    names[4,3]='���������'

    names[5,1]='��������'
    names[5,2]='���������'
    names[5,3]='����������'

    names[6,1]='��������'
    names[6,2]='���������'
    names[6,3]='����������'

    *�������
    numbers[ 1]='����'
    numbers[ 2]='���'
    numbers[ 3]='���'
    numbers[ 4]='������'
    numbers[ 5]='����'
    numbers[ 6]='�����'
    numbers[ 7]='����'
    numbers[ 8]='������'
    numbers[ 9]='������'
    numbers[10]='������'
    numbers[11]='�����������'
    numbers[12]='����������'
    numbers[13]='����������'
    numbers[14]='������������'
    numbers[15]='����������'
    numbers[16]='�����������'
    numbers[17]='����������'
    numbers[18]='������������'
    numbers[19]='������������'

    * �������
    tens[ 1]='�����'
    tens[ 2]='��������'
    tens[ 3]='��������'
    tens[ 4]='�����'
    tens[ 5]='���������'
    tens[ 6]='����������'
    tens[ 7]='���������'
    tens[ 8]='�����������'
    tens[ 9]='���������'

    *�����
    hound[ 1]='���'
    hound[ 2]='������'
    hound[ 3]='������'
    hound[ 4]='���������'
    hound[ 5]='�������'
    hound[ 6]='��������'
    hound[ 7]='�������'
    hound[ 8]='���������'
    hound[ 9]='���������'

    *------------------------------------------------------------------------

    IF !EMPTY(m.Decimals)
        tmp=ROUND(MOD( nValue * 100, 100),0)
        ret=' '+TRAN(tmp,'@L 99')+' '+x_end(tmp,1)+'.'
    ELSE
        ret='.'
    ENDIF

    I=2
    tmp=INT(nValue)                       && ������� �������
    ret=x_end(MOD(tmp,100),2,.T.)+ret

    DO WHILE tmp > 0
        tv=MOD(tmp,1000)                   && �������� ��������� ������
        IF tmp=0 AND I=2                   && �������� 0
            ret='���� ������'+ret          && ������� �������
            EXIT
        ELSE
            ret=IIF(tv>0,x_str(tv)+' '+x_end(MOD(tv,100),I)+IIF(ret='.','',' ')+ret, ret)
        ENDIF
        tmp=INT(tmp/1000)
        I=I+1
    ENDDO
    ret=ALLTRIM( ret)
    DO WHILE('  ' $ ret)
        ret=STRTRAN(ret,'  ',' ')
    ENDDO
    RETURN UPPER(LEFT(ret,1))+SUBSTR(ret,2)

PROCEDURE x_str
    PARAMETER nx
    PRIVATE nx, nh, s
    s=''
    IF nx > 99
        nh=INT(nx/100)
        s=hound[nh]
        nx=MOD(nx,100)
    ENDIF
    IF nx > 19
        nh=INT(nx/10)
        s=s+' '+tens[nh]
        nx=MOD(nx,10)
    ENDIF
    IF nx > 0
        IF I=3 AND BETWEEN(nx,1,2)
            DO CASE
                CASE nx=1
                    s=s+' '+'����'
                CASE nx=2
                    s=s+' '+'���'
            ENDCASE
        ELSE
            s=s+' '+numbers[nx]
        ENDIF
    ENDIF
    RETURN ALLTRIM(s)

PROCEDURE x_end
    PARAMETER nx, ni, nz
    PRIVATE tmp, nx, ni, nz

    IF nx < 20
        RETURN x_end_x(nx)
    ELSE
        RETURN x_end_x(INT(MOD( nx, 10)))
    ENDIF

PROCEDURE x_end_x
    PARAMETER ny
    IF ni=2 AND !nz
        RETURN ''
    ENDIF
    DO CASE
        CASE ny = 0 AND ni=1
            RETURN names[ni,3]
        CASE ny = 1
            RETURN names[ni,1]
        CASE BETWEEN(ny, 2, 4)
            RETURN names[ni,2]
        OTHER
            RETURN names[ni,3]
    ENDCASE

PROCEDURE FindInstance
    IF _VFP.STARTMODE=0
        RETURN .F.
    ENDIF

    *
    * ����� ����� ���������, � ���� ��� �������� �� ������������� �� ���
    *
    #DEFINE GWL_USERDATA            (-21)
    #DEFINE ERROR_ALREADY_EXISTS    183

    DECLARE INTEGER CreateMutex         IN Win32Api INTEGER, INTEGER, STRING
    DECLARE INTEGER ReleaseMutex         IN Win32Api INTEGER
    DECLARE INTEGER CloseHandle         IN Win32Api INTEGER

    DECLARE LONG     GetWindowLong         IN Win32Api INTEGER, INTEGER
    DECLARE LONG     SetWindowLong         IN Win32Api INTEGER, INTEGER, LONG
    DECLARE INTEGER GetLastError         IN Win32Api

    DECLARE INTEGER GetTopWindow         IN Win32Api INTEGER
    DECLARE INTEGER GetWindow             IN Win32Api INTEGER, INTEGER
    DECLARE INTEGER SetForegroundWindow IN Win32Api INTEGER
    DECLARE INTEGER SHOWWINDOW IN Win32Api INTEGER, INTEGER

    LOCAL m.Mutex, m.Magic, hMutex, HWND, m.ret

    m.ret=.F.                    && ������������ ��������
    m.Mutex="My.Mutex.0001"        && ��������� �����
    m.Magic=0x12345678            && ���������� ����� (����� ����� ����� !)

    hMutex=CreateMutex(0,0,m.Mutex)
    * ���� Mutex ��� ������
    IF GetLastError()=ERROR_ALREADY_EXISTS
        CloseHandle(hMutex)                && ����� �����

        HWND=GetTopWindow(0)            && ��������� ����
        DO WHILE HWND # 0
            HWND=GetWindow(HWND,2)        && ��������� ����
            IF HWND # 0                    && ���� hWnd
                IF GetWindowLong(HWND,GWL_USERDATA)=m.Magic  && � � ��� ���� ��������� �����
                    * ������� ���������� ������ � ����� ������������������
                    * ����� ������� ���� ����� �������� "�������"
                    SetForegroundWindow(HWND)    && ���������� ��� ��� ����� �����
                    SHOWWINDOW(HWND,3)            && � �������� ������
                    m.ret=.T.
                    EXIT
                ENDIF
            ENDIF
        ENDDO

    ELSE
        SetWindowLong(_VFP.HWND,GWL_USERDATA,m.Magic)    && ����� � ���� ��������� �����
        ReleaseMutex(hMutex)            && Mutex ��� ������ �� ����� - �� ����� ������� � ���������
    ENDIF
    RETURN m.ret
    
    
    
    
    
