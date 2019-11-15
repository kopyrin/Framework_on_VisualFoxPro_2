DEFINE CLASS _motorMSSQL AS CUSTOM
    место               = 0
    таблица             = ""
    КомандаДляВставки   = ""
    КомандаДляИзменения = ""
    ЭкраннаяФорма       = 0
    Фильтр              = ""
    Порядок             = ""
    Название            = ""
    * тут будет форма для редактирования
    Форма               = NULL
    CохранитьДанные     = .T.
    код                 = 0



    PROCEDURE ЗаполнитьКоманды
        * передали № записи в таблице "Таблицы"
        PARAMETERS m.место
        * перешли на таблицу "Таблицы"
        SELECT Таблицы
        * встали на эту запись
        GO m.место
        LOCAL m.таблица, m.вставка, m.вставка1, m.изменение
        STORE "" TO m.таблица, m.вставка, m.вставка1, m.изменение
        * запомнили код этой записи
        m.таблица  = Таблицы.код

        * выбрали все записи из таблицы "Поля"
        * связанные с записью в таблице "Таблицы"
        * выбрали только реальные поля
        SELECT Поля.* ;
            FROM Поля, Таблицы ;
            WHERE ALLTRIM(Поля.код_г) == ALLTRIM(Таблицы.код) ;
            AND Таблицы.код == m.таблица  ;
            AND Поля.виртуальное = .F. ;
            INTO CURSOR TempПоля

        SELECT TempПоля

        SCAN ALL
            команда =  "m.temp = TRANSFORM(THIS." + ALLTRIM(TempПоля.Название) + " )"
            &команда
            DO CASE
                CASE INLIST(ALLTRIM(TempПоля.Тип), "W", "Y", "D", "T", "B", "G", "I", "L", "M")

                CASE INLIST(ALLTRIM(TempПоля.Тип), "C", "Q", "V")
                    m.temp = "'" + ALLTRIM(m.temp) + "'"
                CASE INLIST(ALLTRIM(TempПоля.Тип), "N", "F")

            ENDCASE
            ***что делать если пустые значения - ставить значения по умолчанию
            *** IF EMPTY(temp) OR ALLTRIM(temp) == '.  .' OR temp == '0'

            ******** ВСТАВКА ************
            вставка  = вставка  + IIF( !EMPTY(вставка)  , [, ] , []) + ALLTRIM(TempПоля.Название)
            вставка1 = вставка1 + IIF( !EMPTY(вставка1) , [, ] , []) + m.temp
            ******** конец ВСТАВКИ *******


            ******** ИЗМЕНЕНИЕ ***********
            изменение = изменение + IIF( !EMPTY(изменение), [, ] , [ ]) + ALLTRIM(TempПоля.Название) + " = " + m.temp
            ******** конец изменения *****
        ENDSCAN

        * обрабатываем команду для вставки
        IF !EMPTY(вставка) AND !EMPTY(вставка1)
            вставка = " INSERT INTO " + IIF(NOT EMPTY(ОAPP.базаmssql),ОAPP.базаmssql+".", "") + ALLTRIM(Таблицы.Название)+" ( " + вставка + " ) VALUES ( " + вставка1 +" )"
        ENDIF
        команда = "O"+ ALLTRIM(Таблицы.Название)+ ".КомандаДляВставки =  вставка "
        &команда

        * обрабатываем команду для изменения
        IF !EMPTY(изменение)
            изменение = " UPDATE " + IIF(NOT EMPTY(ОAPP.базаmssql),ОAPP.базаmssql+".", "") + ALLTRIM(Таблицы.Название)+" SET  " + изменение + ;
                " WHERE "+ALLTRIM(Таблицы.Название)+ ".код = '" + TRANSFORM(THIS.код) + "'"
        ENDIF
        команда = "O"+ ALLTRIM(Таблицы.Название)+ ".КомандаДляИзменения =  изменение "
        &команда

        IF USED("TempПоля")
            USE IN TempПоля
        ENDIF
    ENDPROC
    **
    *!*        FUNCTION СоздатьRGSM
    * серверная версия создания таблицы метаданных

    *!*                IF !USED("RGSM")
    *!*                    this.результат = ""
    *!*                    IF !this.выполнить("use RGSM")
    *!*                        WAIT windows NOWAIT ("Ничего не получилось")
    *!*                    ENDIF

    *!*                    this.результат = "temp"
    *!*                    m.команда = 'SELECT       @@Servername             AS Server       ,'
    *!*                    m.команда = m.команда + ' DB_NAME()                AS DBName       ,'
    *!*                    m.команда = m.команда + ' TRIM(isc.Table_Name)     AS TableName    ,'
    *!*                    m.команда = m.команда + ' isc.Table_Schema         AS SchemaName   ,'
    *!*                    m.команда = m.команда + ' Ordinal_Position         AS Ord          ,'
    *!*                    m.команда = m.команда + ' Column_Name              AS Column_Nam   ,'
    *!*                    m.команда = m.команда + ' Data_Type                                ,'
    *!*                    m.команда = m.команда + ' Numeric_Precision        AS  Prec        ,'
    *!*                    m.команда = m.команда + ' Numeric_Scale            AS  Scale       ,'
    *!*                    m.команда = m.команда + ' Character_Maximum_Length AS LEN          ,'
    *!*                    m.команда = m.команда + ' Is_Nullable                              ,'
    *!*                    m.команда = m.команда + ' Column_Default                           ,'
    *!*                    m.команда = m.команда + ' Table_Type                                '
    *!*                    m.команда = m.команда + ' FROM  INFORMATION_SCHEMA.COLUMNS isc      '
    *!*                    m.команда = m.команда + ' INNER JOIN  information_schema.tables ist '
    *!*                    m.команда = m.команда + '       ON isc.table_name = ist.table_name  '
    *!*                    m.команда = m.команда + ' ORDER BY DBName , '
    *!*                    m.команда = m.команда + ' TableName , '
    *!*                    m.команда = m.команда + ' SchemaName , '
    *!*                    m.команда = m.команда + ' Ordinal_position;  '

    *!*                    IF !this.выполнить(m.команда)
    *!*                        WAIT windows NOWAIT ("Ничего не получилось")
    *!*                        *this.ВыходИзПрограммы()
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


    PROCEDURE ВзятьПоля

        SELECT Поля.* ;
            FROM Поля, Таблицы ;
            WHERE ALLTRIM(Поля.код_г) == THIS.ТаблицыКод ;
            INTO CURSOR TempПоля

        SELECT TempПоля
        IF _TALLY = 0
            USE IN TempПоля
        ENDIF
        RETURN IIF(_TALLY > 0, .T. , .F.)
    ENDPROC

    PROCEDURE Создать
        команда = ""
        IF THIS.ВзятьПоля()
            SCAN ALL
                команда = команда +IIF(EMPTY(команда),""," ,") + ALLTRIM(TempПоля.Название)+" "
                DO CASE
                    CASE INLIST(ALLTRIM(TempПоля.Тип), "W", "Y", "D", "T", "B", "G", "I", "L", "M")
                        команда = команда + ALLTRIM(TempПоля.Тип)
                    CASE INLIST(ALLTRIM(TempПоля.Тип), "C", "Q", "V")
                        команда = команда + ALLTRIM(TempПоля.Тип) + "(" +ALLTRIM(TempПоля.Размер)+")"
                    CASE INLIST(ALLTRIM(TempПоля.Тип), "N", "F")
                        команда = команда + ALLTRIM(TempПоля.Тип) + "(" +ALLTRIM(TempПоля.Размер)+","+ALLTRIM(TempПоля.Точность)+")"
                ENDCASE
            ENDSCAN
            USE IN TempПоля
        ENDIF
        * Если поля еще не описаны, таблицу не создаем.
        IF EMPTY(команда)
            RETURN .F.
        ENDIF

        команда = " CREATE TABLE " + ALLTRIM(Таблицы.Название)+ " (" + команда + ")"
        RETURN IIF( -1 = SQLEXEC(ОAPP.СОЕДИНЕНИЕ, команда), .F., .T.)
    ENDPROC
    **
    PROCEDURE ОткрытьЭкслюзивно
        * проверяем есть ли такой dbf файл
        IF FILE(ОAPP.ПУТЬ + THIS.ТаблицыНазвание + ".dbf")
            SET EXCLUSIVE ON
            SELECT 0
            USE ОAPP.ПУТЬ + THIS.ТаблицыНазвание + ".dbf"
            SET EXCLUSIVE OFF
        ENDIF
        RETURN .T.
    ENDPROC

    PROCEDURE Открыть
        THIS.Взять()
        IF  .NOT. USED("c"+ALLTRIM(THIS.ТаблицыНазвание))
            RETURN THIS.Создать()
        ENDIF
    ENDPROC

    PROCEDURE Добавить

        IF THIS.ВзятьПоля()
            SELECT TempПоля
            * сначала заполняем пустыми значениями
            SCAN ALL
                команда = "this." +ALLTRIM(TempПоля.Название)
                DO CASE
                    CASE INLIST(ALLTRIM(TempПоля.Тип),"W", "G", "Q", "V", "M")
                        команда = команда + " = []"
                    CASE ALLTRIM(TempПоля.Тип) = "C"
                        команда = команда + " = ["+SPACE(VAL(TempПоля.Размер))+"]"
                    CASE INLIST(ALLTRIM(TempПоля.Тип),"Y", "B", "I", "N", "F")
                        команда = команда + " = 0"
                    CASE INLIST(ALLTRIM(TempПоля.Тип),"D")
                        команда = команда + " = {}"
                    CASE INLIST(ALLTRIM(TempПоля.Тип),"T")
                        команда = команда + " = datetime(null,null,null,null,null,null)"
                    CASE ALLTRIM(TempПоля.Тип) = "L"
                        команда = команда + " = .f."
                ENDCASE
                &команда
            ENDSCAN
            USE IN TempПоля
        ENDIF
        SELECT Таблицы
        * а затем по умолчанию
        IF !EMPTY(Таблицы.Родитель)
            команда = "this.КОД_Г = [" + EVALUATE("O" + ALLTRIM(Таблицы.Родитель)+ ".код ") +"]"
            &команда
        ENDIF
        команда = "SELECT C" + THIS.ТаблицыНазвание
        &команда
    ENDPROC
    **
    PROCEDURE Редактировать
        IF THIS.ВзятьПоля()
            SELECT TempПоля
            SCAN ALL
                команда = "this." +ALLTRIM(TempПоля.Название)+ " = C" +ALLTRIM(Таблицы.Название)+"." +ALLTRIM(TempПоля.Название)
                &команда
            ENDSCAN
            USE IN TempПоля
        ENDIF
        команда = "SELECT C" + THIS.ТаблицыНазвание
        &команда
    ENDPROC
    **
    PROCEDURE Записать
        THIS.ВстатьНаМесто()
        IF !EMPTY(Таблицы.Родитель) AND EMPTY(THIS.код_г)
            RETURN .F.
        ENDIF
        IF NOT THIS.ПроверитьНаличиеЗаписейВИсточнике()
            RETURN .F.
        ENDIF

        *********************** проверка наличия записи с таким кодом ********
        * это необходимо, если мы переносим данные с другой машины и не хотим получить кучу дубликатов

        LOCAL m.вставить
        m.вставить = .T.
        IF !EMPTY(THIS.код)
            команда = "SELECT код AS код ;
                            where '" + THIS.код + "' == " +  ALLTRIM(Таблицы.Название) + ".код ;
                            FROM  "+ALLTRIM(Таблицы.Название)

            =IIF( -1 = SQLEXEC(ОAPP.СОЕДИНЕНИЕ, команда, temp), .F., .T.)


            IF USED("temp")
                SELECT temp
                IF ISNULL(temp.код) OR EMPTY(temp.код)
                    * нет такой записи
                    m.вставить = .T.
                ELSE
                    * есть такая запись
                    m.вставить = .F.
                ENDIF
                USE IN temp
            ENDIF
        ENDIF
        **********************************************************************
        IF m.вставить
            * проверка привилегий
            IF THIS.ПроверитьПривилегии("вставить")
                THIS.ВстатьНаМесто()
                *генерируем новый код записи
                IF EMPTY(THIS.код)
                    LOCAL m.ДлиннаКода
                    * определяем длинну строки и отнимаем 2 символа на префикс
                    m.ДлиннаКода = LEN(THIS.код)-2
                    команда = "SELECT MAX(VAL(SUBSTR(код,3,?ДлиннаКода))) AS код FROM "+ALLTRIM(Таблицы.Название)
                    =IIF( -1 = SQLEXEC(ОAPP.СОЕДИНЕНИЕ, команда, temp), .F., .T.)


                    IF USED("temp")
                        SELECT temp
                        IF ISNULL(temp.код)
                            THIS.код = 1
                        ELSE
                            THIS.код = temp.код+1
                        ENDIF
                        USE IN temp
                    ELSE
                        THIS.код = 1
                    ENDIF
                    THIS.код = ОAPP.ПРЕФИКС+REPLICATE("0", m.ДлиннаКода-LEN(ALLTRIM(STR(THIS.код)))) + ALLTRIM(STR(THIS.код))
                ENDIF
                IF EMPTY(THIS.КомандаДляВставки)
                    THIS.ЗаполнитьКоманды(THIS.место)
                ENDIF
                m.команда = THIS.КомандаДляВставки
                = IIF( -1 = SQLEXEC(ОAPP.СОЕДИНЕНИЕ, команда), .F., .T.)
            ENDIF
        ELSE
            IF THIS.ПроверитьПривилегии("изменить")
                IF EMPTY(THIS.КомандаДляИзменения)
                    THIS.ЗаполнитьКоманды(THIS.место)
                ENDIF
                m.команда = THIS.КомандаДляИзменения
                = IIF( -1 = SQLEXEC(ОAPP.СОЕДИНЕНИЕ, команда), .F., .T.)
            ENDIF
        ENDIF
        команда = "SELECT C" + THIS.ТаблицыНазвание
        &команда
        IF m.вставить
            RETURN "new"
        ELSE
            RETURN "old"
        ENDIF
    endproc


    PROCEDURE Удалить
        * проверили привилегии
        IF !THIS.ПроверитьПривилегии("удалить")
            RETURN .F.
        ENDIF

        * взяли данные из записи
        THIS.Редактировать()
        * запомнили с какой таблицей работаем :)
        THIS.ВстатьНаМесто()

        * это мы запомнили из какой таблицы запись удаляем
        m.таблица = UPPER(ALLTRIM(Таблицы.Название))

        * делаем выборку из таблиц у которых эта таблица является источником для поля
        команда = "SELECT таблицы.название as таблица , поля.название    as поле ;
                       FROM таблицы, поля ;
                       where таблицы.код == поля.код_г and UPPER(ALLTRIM(поля.источник)) ==  m.таблица "

        =IIF( -1 = SQLEXEC(ОAPP.СОЕДИНЕНИЕ, команда, temp), .F., .T.)


        * если выборка есть
        IF USED("temp") AND RECCOUNT("temp") > 0
            SELECT temp
            * если эта таблица является источником
            * начинаем перебирать записи по одной по одной и считать записи  в связанных таблицах
            SCAN ALL FOR !ISNULL(temp.таблица) AND !EMPTY(temp.таблица)

                * сколько у нас записей в связанных таблицах которые содержат такой же код в поле код?
                команда = "SELECT код as код ;
                                 FROM " + ALLTRIM(temp.таблица)+;
                    " where " + ALLTRIM(temp.таблица)+"." + ALLTRIM(temp.поле)+ " = [" +EVALUATE("O" + m.таблица + ".код ") + "]"+;
                    " into cursor temp1"

                &команда
                IF _TALLY >0
                    WAIT WINDOWS " Из таблицы " + ALLTRIM(temp.таблица) +" не удалены записи связанные с этой."
                    USE IN temp1
                    USE IN temp
                    команда = "SELECT C" + THIS.ТаблицыНазвание
                    &команда
                    RETURN .F.
                ENDIF
                SELECT temp
            ENDSCAN
        ENDIF
        * ВСЕ ПРОШЛИ, НЕ НА ЧЕМ НЕ ЗАЦЕПИЛИСЬ
        IF USED("Temp")
            USE IN temp
        ENDIF
        IF USED("Temp1")
            USE IN temp1
        ENDIF

        * ТОГДА УДАЛЯЕМ ЗАПИСЬ
        команда = "SELECT C" + THIS.ТаблицыНазвание
        &команда
        команда = "THIS.КОД = C" + THIS.ТаблицыНазвание+ ".КОД"
        &команда
        команда = "THIS.КОД_Г = C" + THIS.ТаблицыНазвание+ ".КОД_Г"
        &команда
        команда = " DELETE FROM " + THIS.ТаблицыНазвание + " WHERE " + THIS.ТаблицыНазвание + ".КОД = ?THIS.код"
        = SQLEXEC(ОAPP.СОЕДИНЕНИЕ, команда), .F., .T.)
        команда = "SELECT C" + THIS.ТаблицыНазвание
        &команда
        RETURN .T.
    endproc
    **
    PROCEDURE Взять
        LPARAMETERS m.код
        IF !THIS.ПроверитьПривилегии("взять")
            RETURN .F.
        ENDIF
        THIS.ВстатьНаМесто()
        команда = ""
        IF INLIST(Таблицы.виддокумен,"Система", "Справочник", "Документ")
            IF EMPTY(ALLTRIM(запрос))
                WAIT WINDOWS " Не указана команда для показа данных "
                RETURN .F.
            ELSE
                команда = ALLTRIM(Таблицы.запрос)
            ENDIF
        ENDIF
        IF  !EMPTY(THIS.Фильтр)
            команда = команда + ' ' + THIS.Фильтр
        ENDIF
        IF  !EMPTY(THIS.Порядок)
            команда = команда + ' ' + THIS.Порядок
        ENDIF
        = IIF( -1 = SQLEXEC(ОAPP.СОЕДИНЕНИЕ, команда, "C" + THIS.ТаблицыНазвание), .F., .T.)
        команда = "SELECT C" + THIS.ТаблицыНазвание
        &команда
        IF  !EMPTY(m.код)
            команда = "m.КОД=C" + THIS.ТаблицыНазвание+ ".КОД"
            LOCATE FOR EVALUATE(команда)
            IF !FOUND()
                GO TOP
            ENDIF
        ENDIF
        RETURN .T.
    endproc
    **
    PROCEDURE Показать
        LPARAMETERS m.код
        * если программист не предусмотрел на какую запись нужно встать
        IF EMPTY(m.код)
            * возмем данные о текущей записи
            m.код = THIS.код
        ENDIF
        IF THIS.ПроверитьПривилегии("показать")
            THIS.ВстатьНаМесто()
            IF (Таблицы.виддокумен = "Справочник" OR Таблицы.виддокумен = "Документ" OR Таблицы.виддокумен = "Система")
                IF THIS.ЭкраннаяФорма = 0
                    THIS.Взять(m.код)
                    команда = "SELECT C" + THIS.ТаблицыНазвание
                    &команда
                    команда = "DO FORM .\forms\" + THIS.ТаблицыНазвание+ ".scx"
                    &команда
                ENDIF
                THIS.ЭкраннаяФорма = 1
            ENDIF
        ENDIF
    endproc
    **
    PROCEDURE ПроверитьПривилегии
        LPARAMETERS m.привилегия
        PRIVATE m.таблица, m.можно
        m.таблица = ""
        m.можно = .F.

        THIS.ВстатьНаМесто()
        m.таблица = UPPER(ALLTRIM(Таблицы.Название))

        SELECT Привилегии.* ;
            FROM пользователи, Привилегии, роли;
            WHERE UPPER(ALLTRIM(ОAPP.ПОЛЬЗОВАТЕЛЬ)) == UPPER(ALLTRIM(пользователи.Название)); && сначала ищем такого пользователя
        AND UPPER(ALLTRIM(роли.Название)) == UPPER(ALLTRIM(пользователи.роль)) ; && затем ищем такую роль
        AND роли.код = Привилегии.код_г ; && затем по роли определяем привилегии
        AND m.таблица == UPPER(ALLTRIM(Привилегии.пр_таблица)); && для какой то одной таблицы
        INTO CURSOR TempПривилегии

        IF _TALLY > 0
            DO CASE
                CASE m.привилегия = "взять"    AND TempПривилегии.пр_взять
                    m.можно = .T.
                CASE m.привилегия = "показать" AND TempПривилегии.пр_показать
                    m.можно = .T.
                CASE m.привилегия = "вставить" AND TempПривилегии.пр_вставить
                    m.можно = .T.
                CASE m.привилегия = "изменить" AND TempПривилегии.пр_изменить
                    m.можно = .T.
                CASE m.привилегия = "удалить" AND TempПривилегии.пр_удалить
                    m.можно = .T.
            ENDCASE
        ENDIF
        IF USED("TempПривилегии")
            USE IN TempПривилегии
        ENDIF
        IF !m.можно
            WAIT WINDOWS NOWAIT "Вам запрещено " + m.привилегия + ". Таблица: " + ALLTRIM(Таблицы.Название)
        ENDIF
        RETURN m.можно

    endproc

    PROCEDURE НайтиПоКоду
        LPARAMETERS НужныйКод
        команда = "SELECT C" + THIS.ТаблицыНазвание
        &команда
        SCAN ALL FOR код == НужныйКод
            THIS.Редактировать()
            RETURN .T.
        ENDSCAN
        RETURN .F.
    endproc

    PROCEDURE ПроверитьНаличиеЗаписейВИсточнике
        * у нас есть объект с заполнеными свойствами
        * необходимо выбрать свойства объекта которые ссылаются на другую таблицу
        THIS.ВстатьНаМесто()
        LOCAL m.таблица
        m.таблица  = Таблицы.код
        SELECT Поля.Название, Поля.источник ;
            FROM Поля, Таблицы ;
            WHERE ALLTRIM(Поля.код_г) == ALLTRIM(Таблицы.код) ;
            AND Таблицы.код == m.таблица  ;
            AND Поля.виртуальное = .F. ;
            AND !EMPTY(Поля.источник) ;
            INTO CURSOR TempПоля

        SELECT TempПоля
        IF _TALLY = 0
            USE IN TempПоля
            RETURN .T.
        ENDIF
        * просканировать полученную таблицу
        LOCAL m.Название, m.источник, m.РЕЗУЛЬТАТ
        m.РЕЗУЛЬТАТ = ""

        SCAN ALL
            m.Название = TempПоля.Название
            m.источник = TempПоля.источник

            * и проверить есть ли в таблице на которую ссылаются такие записи
            команда =           " select * from " + ALLTRIM(m.источник)
            команда = команда + " into cursor temp "
            команда = команда + " where код = this." + ALLTRIM(m.Название)
            &команда

            SELECT temp
            IF _TALLY = 0
                m.РЕЗУЛЬТАТ = m.РЕЗУЛЬТАТ + CHR(13) + " Не найдена запись в " + ALLTRIM(m.источник) + " для " +ALLTRIM(m.Название)
            ENDIF
        ENDSCAN
        USE IN TempПоля
        USE IN temp
        IF !EMPTY(m.РЕЗУЛЬТАТ)
            WAIT WINDOWS m.РЕЗУЛЬТАТ
            RETURN .F.
        ELSE
            RETURN .T.
        ENDIF

    endproc

ENDDEFINE