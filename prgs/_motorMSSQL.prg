DEFINE CLASS _motorMSSQL AS CUSTOM
    �����               = 0
    �������             = ""
    �����������������   = ""
    ������������������� = ""
    �������������       = 0
    ������              = ""
    �������             = ""
    ��������            = ""
    * ��� ����� ����� ��� ��������������
    �����               = NULL
    C��������������     = .T.
    ���                 = 0



    PROCEDURE ����������������
        * �������� � ������ � ������� "�������"
        PARAMETERS m.�����
        * ������� �� ������� "�������"
        SELECT �������
        * ������ �� ��� ������
        GO m.�����
        LOCAL m.�������, m.�������, m.�������1, m.���������
        STORE "" TO m.�������, m.�������, m.�������1, m.���������
        * ��������� ��� ���� ������
        m.�������  = �������.���

        * ������� ��� ������ �� ������� "����"
        * ��������� � ������� � ������� "�������"
        * ������� ������ �������� ����
        SELECT ����.* ;
            FROM ����, ������� ;
            WHERE ALLTRIM(����.���_�) == ALLTRIM(�������.���) ;
            AND �������.��� == m.�������  ;
            AND ����.����������� = .F. ;
            INTO CURSOR Temp����

        SELECT Temp����

        SCAN ALL
            ������� =  "m.temp = TRANSFORM(THIS." + ALLTRIM(Temp����.��������) + " )"
            &�������
            DO CASE
                CASE INLIST(ALLTRIM(Temp����.���), "W", "Y", "D", "T", "B", "G", "I", "L", "M")

                CASE INLIST(ALLTRIM(Temp����.���), "C", "Q", "V")
                    m.temp = "'" + ALLTRIM(m.temp) + "'"
                CASE INLIST(ALLTRIM(Temp����.���), "N", "F")

            ENDCASE
            ***��� ������ ���� ������ �������� - ������� �������� �� ���������
            *** IF EMPTY(temp) OR ALLTRIM(temp) == '.  .' OR temp == '0'

            ******** ������� ************
            �������  = �������  + IIF( !EMPTY(�������)  , [, ] , []) + ALLTRIM(Temp����.��������)
            �������1 = �������1 + IIF( !EMPTY(�������1) , [, ] , []) + m.temp
            ******** ����� ������� *******


            ******** ��������� ***********
            ��������� = ��������� + IIF( !EMPTY(���������), [, ] , [ ]) + ALLTRIM(Temp����.��������) + " = " + m.temp
            ******** ����� ��������� *****
        ENDSCAN

        * ������������ ������� ��� �������
        IF !EMPTY(�������) AND !EMPTY(�������1)
            ������� = " INSERT INTO " + IIF(NOT EMPTY(�APP.����mssql),�APP.����mssql+".", "") + ALLTRIM(�������.��������)+" ( " + ������� + " ) VALUES ( " + �������1 +" )"
        ENDIF
        ������� = "O"+ ALLTRIM(�������.��������)+ ".����������������� =  ������� "
        &�������

        * ������������ ������� ��� ���������
        IF !EMPTY(���������)
            ��������� = " UPDATE " + IIF(NOT EMPTY(�APP.����mssql),�APP.����mssql+".", "") + ALLTRIM(�������.��������)+" SET  " + ��������� + ;
                " WHERE "+ALLTRIM(�������.��������)+ ".��� = '" + TRANSFORM(THIS.���) + "'"
        ENDIF
        ������� = "O"+ ALLTRIM(�������.��������)+ ".������������������� =  ��������� "
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
            FROM ����, ������� ;
            WHERE ALLTRIM(����.���_�) == THIS.���������� ;
            INTO CURSOR Temp����

        SELECT Temp����
        IF _TALLY = 0
            USE IN Temp����
        ENDIF
        RETURN IIF(_TALLY > 0, .T. , .F.)
    ENDPROC

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

        ������� = " CREATE TABLE " + ALLTRIM(�������.��������)+ " (" + ������� + ")"
        RETURN IIF( -1 = SQLEXEC(�APP.����������, �������), .F., .T.)
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

    PROCEDURE �������
        THIS.�����()
        IF  .NOT. USED("c"+ALLTRIM(THIS.���������������))
            RETURN THIS.�������()
        ENDIF
    ENDPROC

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
                ������� = "this." +ALLTRIM(Temp����.��������)+ " = C" +ALLTRIM(�������.��������)+"." +ALLTRIM(Temp����.��������)
                &�������
            ENDSCAN
            USE IN Temp����
        ENDIF
        ������� = "SELECT C" + THIS.���������������
        &�������
    ENDPROC
    **
    PROCEDURE ��������
        THIS.�������������()
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
            ������� = "SELECT ��� AS ��� ;
                            where '" + THIS.��� + "' == " +  ALLTRIM(�������.��������) + ".��� ;
                            FROM  "+ALLTRIM(�������.��������)

            =IIF( -1 = SQLEXEC(�APP.����������, �������, temp), .F., .T.)


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
                THIS.�������������()
                *���������� ����� ��� ������
                IF EMPTY(THIS.���)
                    LOCAL m.����������
                    * ���������� ������ ������ � �������� 2 ������� �� �������
                    m.���������� = LEN(THIS.���)-2
                    ������� = "SELECT MAX(VAL(SUBSTR(���,3,?����������))) AS ��� FROM "+ALLTRIM(�������.��������)
                    =IIF( -1 = SQLEXEC(�APP.����������, �������, temp), .F., .T.)


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
                IF EMPTY(THIS.�����������������)
                    THIS.����������������(THIS.�����)
                ENDIF
                m.������� = THIS.�����������������
                = IIF( -1 = SQLEXEC(�APP.����������, �������), .F., .T.)
            ENDIF
        ELSE
            IF THIS.�������������������("��������")
                IF EMPTY(THIS.�������������������)
                    THIS.����������������(THIS.�����)
                ENDIF
                m.������� = THIS.�������������������
                = IIF( -1 = SQLEXEC(�APP.����������, �������), .F., .T.)
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
        m.������� = UPPER(ALLTRIM(�������.��������))

        * ������ ������� �� ������ � ������� ��� ������� �������� ���������� ��� ����
        ������� = "SELECT �������.�������� as ������� , ����.��������    as ���� ;
                       FROM �������, ���� ;
                       where �������.��� == ����.���_� and UPPER(ALLTRIM(����.��������)) ==  m.������� "

        =IIF( -1 = SQLEXEC(�APP.����������, �������, temp), .F., .T.)


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
        ������� = " DELETE FROM " + THIS.��������������� + " WHERE " + THIS.��������������� + ".��� = ?THIS.���"
        = SQLEXEC(�APP.����������, �������), .F., .T.)
        ������� = "SELECT C" + THIS.���������������
        &�������
        RETURN .T.
    endproc
    **
    PROCEDURE �����
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
        = IIF( -1 = SQLEXEC(�APP.����������, �������, "C" + THIS.���������������), .F., .T.)
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
    endproc
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
                    ������� = "DO FORM .\forms\" + THIS.���������������+ ".scx"
                    &�������
                ENDIF
                THIS.������������� = 1
            ENDIF
        ENDIF
    endproc
    **
    PROCEDURE �������������������
        LPARAMETERS m.����������
        PRIVATE m.�������, m.�����
        m.������� = ""
        m.����� = .F.

        THIS.�������������()
        m.������� = UPPER(ALLTRIM(�������.��������))

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

    endproc

    PROCEDURE �����������
        LPARAMETERS ���������
        ������� = "SELECT C" + THIS.���������������
        &�������
        SCAN ALL FOR ��� == ���������
            THIS.�������������()
            RETURN .T.
        ENDSCAN
        RETURN .F.
    endproc

    PROCEDURE ���������������������������������
        * � ��� ���� ������ � ����������� ����������
        * ���������� ������� �������� ������� ������� ��������� �� ������ �������
        THIS.�������������()
        LOCAL m.�������
        m.�������  = �������.���
        SELECT ����.��������, ����.�������� ;
            FROM ����, ������� ;
            WHERE ALLTRIM(����.���_�) == ALLTRIM(�������.���) ;
            AND �������.��� == m.�������  ;
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

ENDDEFINE