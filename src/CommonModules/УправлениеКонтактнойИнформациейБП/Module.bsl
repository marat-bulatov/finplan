////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация Бухгалтерии предприятия".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает адрес в виде структуры полей. Если адрес нужного вида не задан, то будет возвращена структура с пустыми полями.
//
// Параметры:
//    Ссылка                  - СправочникСсылка - Ссылка на объект, который содержит контактную информацию.
//    ВидКонтактнойИнформации - СправочникСсылка.ВидыКонтактнойИнформации - Вид контактной информации, структуру которого нужно получить.
//    НаименованиеВключаетСокращение - Булево - признак включение в наименования элемента адреса его сокращенного представления
//
// Возвращаемое значение:
//  Структура - Структура со значениями полей адреса.
//
Функция АдресСтруктурой(Ссылка, ВидКонтактнойИнформации, Период = '00010101', НаименованиеВключаетСокращение = Истина) Экспорт
	
	Адрес = УправлениеКонтактнойИнформациейБП.КонтактнаяИнформацияОбъектовНаДату(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка),
		Перечисления.ТипыКонтактнойИнформации.Адрес, 
		ВидКонтактнойИнформации,
		Период);
	
	Если Адрес.Количество() <> 0 Тогда
		ДополнительныеПараметры = Новый Структура("НаименованиеВключаетСокращение", НаименованиеВключаетСокращение);
		СтруктураАдреса = СтруктураАдреса(Адрес[0].ЗначенияПолей, ДополнительныеПараметры);
		СтруктураАдреса.Представление = Адрес[0].Представление;
		СтруктураАдреса.ЗначенияПолей = Адрес[0].ЗначенияПолей;
	Иначе
		СтруктураАдреса = НовыйСтруктураАдреса();
	КонецЕсли;
	
	Возврат СтруктураАдреса;
	
КонецФункции

// Заполняет контактную информацию объекта.
//
// Параметры:
//    Приемник    - Произвольный - ссылка или объект, в котором нужно заполнить КИ.
//    ВидКИ       - СправочникСсылка.ВидыКонтактнойИнформации - вид контактной информации, заполняемый в приемнике.
//    СтруктураКИ - Структура - заполненная структура контактной информации.
//    КлючСтроки  - Структура  - отбор для поиска строки в табличной части, Ключ - Имя колонки в табличной части,
//                               значение - значение отбора.
//
Процедура ЗаполнитьКонтактнуюИнформациюОбъекта(Приемник, ВидКИ, СтруктураКИ) Экспорт
	
	ЗаполнитьКонтактнуюИнформациюТабличнойЧасти(Приемник, ВидКИ, СтруктураКИ);
	
КонецПроцедуры

// Заполняет дополнительные реквизиты табличной части "Контактная информация" для адреса.
//
// Параметры:
//    СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - заполняемая строка табличной части "Контактная информация".
//    Источник             - ОбъектXDTO  - контактная информация.
//
Процедура ЗаполнитьРеквизитыТабличнойЧастиДляАдреса(СтрокаТабличнойЧасти, Источник) Экспорт
	
	// Умолчания
	СтрокаТабличнойЧасти.Страна = "";
	СтрокаТабличнойЧасти.Регион = "";
	СтрокаТабличнойЧасти.Город  = "";
	
	Адрес = Источник.Состав;
	
	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
	ЭтоАдрес = ТипЗнч(Адрес) = Тип("ОбъектXDTO") И Адрес.Тип() = ФабрикаXDTO.Тип(ПространствоИмен, "Адрес");
	Если ЭтоАдрес И Адрес.Состав <> Неопределено Тогда 
		СтрокаТабличнойЧасти.Страна = Адрес.Страна;
		АдресРФ = Обработки.РасширенныйВводКонтактнойИнформации.НациональныйАдрес(Адрес);
		Если АдресРФ <> Неопределено Тогда
			// Российский адрес
			СтрокаТабличнойЧасти.Регион = АдресРФ.СубъектРФ;
			СтрокаТабличнойЧасти.Город  = АдресРФ.Город;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет дополнительные реквизиты табличной части "Контактная информация" для адреса электронной почты.
//
// Параметры:
//    СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - заполняемая строка табличной части "Контактная информация".
//    Источник             - ОбъектXDTO  - контактная информация.
//
Процедура ЗаполнитьРеквизитыТабличнойЧастиДляАдресаЭлектроннойПочты(СтрокаТабличнойЧасти, Источник) Экспорт
	
	Результат = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(СтрокаТабличнойЧасти.Представление, Ложь);
	
	Если Результат.Количество() > 0 Тогда
		СтрокаТабличнойЧасти.АдресЭП = Результат[0].Адрес;
		
		Поз = СтрНайти(СтрокаТабличнойЧасти.АдресЭП, "@");
		Если Поз <> 0 Тогда
			СтрокаТабличнойЧасти.ДоменноеИмяСервера = Сред(СтрокаТабличнойЧасти.АдресЭП, Поз+1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет дополнительные реквизиты табличной части "Контактная информация" для телефона и факса.
//
// Параметры:
//    СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - заполняемая строка табличной части "Контактная информация".
//    Источник             - ОбъектXDTO  - контактная информация.
//
Процедура ЗаполнитьРеквизитыТабличнойЧастиДляТелефона(СтрокаТабличнойЧасти, Источник) Экспорт
	
	// Умолчания
	СтрокаТабличнойЧасти.НомерТелефонаБезКодов = "";
	СтрокаТабличнойЧасти.НомерТелефона         = "";
	
	Телефон = Источник.Состав;
	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
	Если Телефон <> Неопределено И Телефон.Тип() = ФабрикаXDTO.Тип(ПространствоИмен, "НомерТелефона") Тогда
		КодСтраны     = Телефон.КодСтраны;
		КодГорода     = Телефон.КодГорода;
		НомерТелефона = Телефон.Номер;
		
		Если СтрНачинаетсяС(КодСтраны, "+") Тогда
			КодСтраны = Сред(КодСтраны, 2);
		КонецЕсли;
		
		Поз = СтрНайти(НомерТелефона, ",");
		Если Поз <> 0 Тогда
			НомерТелефона = Лев(НомерТелефона, Поз-1);
		КонецЕсли;
		
		Поз = СтрНайти(НомерТелефона, Символы.ПС);
		Если Поз <> 0 Тогда
			НомерТелефона = Лев(НомерТелефона, Поз-1);
		КонецЕсли;
		
		СтрокаТабличнойЧасти.НомерТелефонаБезКодов = УбратьРазделителиВНомерТелефона(НомерТелефона);
		СтрокаТабличнойЧасти.НомерТелефона         = УбратьРазделителиВНомерТелефона(Строка(КодСтраны) + КодГорода + НомерТелефона);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет дополнительные реквизиты табличной части "Контактная информация" для телефона и факса.
//
// Параметры:
//    СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - заполняемая строка табличной части "Контактная информация".
//    Источник             - ОбъектXDTO  - контактная информация.
//
Процедура ЗаполнитьРеквизитыТабличнойЧастиДляВебСтраницы(СтрокаТабличнойЧасти, Источник) Экспорт
	
	// Умолчания
	СтрокаТабличнойЧасти.ДоменноеИмяСервера = "";
	
	АдресСтраницы = Источник.Состав;
	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
	Если АдресСтраницы <> Неопределено И АдресСтраницы.Тип() = ФабрикаXDTO.Тип(ПространствоИмен, "ВебСайт") Тогда
		АдресСтрокой = АдресСтраницы.Значение;
		
		// Удалим протокол
		АдресСервера = Прав(АдресСтрокой, СтрДлина(АдресСтрокой) - СтрНайти(АдресСтрокой, "://") );
		Поз = СтрНайти(АдресСервера, "/");
		// Удалим путь
		АдресСервера = ?(Поз = 0, АдресСервера, Лев(АдресСервера,  Поз-1));
		
		СтрокаТабличнойЧасти.ДоменноеИмяСервера = АдресСервера;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает код региона по переданному адресу.
//
// Параметры:
//    Адрес - Строка - Значения полей контактной информации в формате XML.
//
// Возвращаемое значение:
//    Число - код региона.
//
Функция КодРегионаПоАдресу(Адрес) Экспорт
	
	Попытка
		Регион = РаботаСАдресами.РегионАдресаКонтактнойИнформации(Адрес);
	Исключение
		Возврат 0;
	КонецПопытки;
	
	Если ЗначениеЗаполнено(Регион) Тогда
		КодРегиона = АдресныйКлассификатор.КодРегионаПоНаименованию(Регион);
		Если ЗначениеЗаполнено(КодРегиона) Тогда
			Возврат КодРегиона;
		КонецЕсли;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

// Определяет, соответствует ли номер региона городу федерального значения.
// Города федерального значения перечислены в статье 65 Конституции РФ
// Также статусом города федерального значения наделен город Байконур 
// (Соглашение между Российской Федерацией и Республикой Казахстан о статусе города Байконур,
// порядке формирования и статусе его органов исполнительной власти (Москва, 23 декабря 1995 г.))
//
// Параметры:
//  КодРегиона	 - Строка - двухсимволный код региона в соответствии с ФИАС
// 
// Возвращаемое значение:
//  Булево - Истина, если код региона соответствует городу федерального значения.
//
Функция ГородФедеральногоЗначения(КодРегиона) Экспорт
	
	Возврат КодРегиона = "77"  // Москва
		Или КодРегиона = "78"  // Санкт-Петербург
		Или КодРегиона = "92"  // Севастополь
		Или КодРегиона = "99"; // Байконур
	
КонецФункции

// Определяет нижний уровень населенного пункта в адресе.
//
// Параметры:
//  ЗначенияПолей - Строка - XML контактной информации или пары ключ-значение.
// 
// Возвращаемое значение:
//  Строка - наименование города или иного населенного пункта.
//
Функция НаселенныйПунктПоАдресу(ЗначенияПолей) Экспорт
	
	ДополнительныеПараметры = Новый Структура("НаименованиеВключаетСокращение", Ложь);
	
	СтруктураПолейАдреса = РаботаСАдресами.СведенияОбАдресе(ЗначенияПолей, ДополнительныеПараметры);
	
	ШаблонНаименованияГорода = НСтр("ru = '%1. %2'");
	
	Если СтруктураПолейАдреса.Свойство("Город") 
		И ЗначениеЗаполнено(СтруктураПолейАдреса.Город) Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименованияГорода,
					СтруктураПолейАдреса.ГородСокращение, СтруктураПолейАдреса.Город);
	
	ИначеЕсли СтруктураПолейАдреса.Свойство("НаселенныйПункт") 
		И ЗначениеЗаполнено(СтруктураПолейАдреса.НаселенныйПункт) Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименованияГорода,
					СтруктураПолейАдреса.НаселенныйПунктСокращение, СтруктураПолейАдреса.НаселенныйПункт);
	
	ИначеЕсли СтруктураПолейАдреса.Свойство("КодРегиона")
		И СтруктураПолейАдреса.Свойство("Регион")
		И ГородФедеральногоЗначения(СтруктураПолейАдреса.КодРегиона) Тогда
		
		// Города федерального значения и приравненные к ним
		Возврат СтруктураПолейАдреса.Регион;
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;

КонецФункции

// Предназначена для получения контактной информации на дату для нескольких объектов.
//
// Параметры:
//    МассивОбъектов - Массив - владельцы контактной информации.
//    ТипыКИ         - Массив - необязательный, используется, если не задан все типы.
//    ВидыКИ         - Массив - необязательный, используется, если не задан все виды.
//    Дата           - Дата   - необязательный, дата с которой действует запись контактной информации,
//                              используется при хранении истории изменения контактной информации.
//                              Если владелец хранит историю изменений, то при несоответствии параметра
//                              дате будет вызвано исключение.
//
// Возвращаемое значение:
//    Таблица значений - результат. Колонки:
//        * Объект        - Ссылка - владелец КИ.
//        * Вид           - СправочникСсылка.ВидыКонтактнойИнформации
//        * Тип           - ПеречислениеСсылка.ТипыКонтактнойИнформации
//        * ЗначенияПолей - Строка - данные значений полей.
//        * Представление - Строка - представление КИ.
//
Функция КонтактнаяИнформацияОбъектовНаДату(МассивОбъектов, ТипыКИ = Неопределено, ВидыКИ = Неопределено, Дата = Неопределено) Экспорт
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		МассивОбъектов,
		ТипыКИ,
		ВидыКИ);
		
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("ДатаСведений", Дата);
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	Запрос.Параметры.Вставить("Виды", ВидыКИ);
	Запрос.Параметры.Вставить("ТаблицаКИ", КонтактнаяИнформация);
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОрганизацииИсторияКонтактнойИнформации.Ссылка КАК Объект,
	|	ОрганизацииИсторияКонтактнойИнформации.Вид КАК Вид,
	|	ОрганизацииИсторияКонтактнойИнформации.Вид.Тип КАК Тип,
	|	ОрганизацииИсторияКонтактнойИнформации.ЗначенияПолей,
	|	ОрганизацииИсторияКонтактнойИнформации.Представление,
	|	ОрганизацииИсторияКонтактнойИнформации.Период
	|ПОМЕСТИТЬ ВТИсторияКонтактныхДанных
	|ИЗ
	|	Справочник.Организации.ИсторияКонтактнойИнформации КАК ОрганизацииИсторияКонтактнойИнформации
	|ГДЕ
	|	ОрганизацииИсторияКонтактнойИнформации.Ссылка В(&МассивОбъектов)
	|	И ОрганизацииИсторияКонтактнойИнформации.Период <= &ДатаСведений
	|	" + ?(ЗначениеЗаполнено(ВидыКИ), "И ОрганизацииИсторияКонтактнойИнформации.Вид В(&Виды)", "");
	
	Если ПравоДоступа("Чтение", Метаданные.Справочники.Контрагенты) Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КонтрагентыИсторияКонтактнойИнформации.Ссылка,
		|	КонтрагентыИсторияКонтактнойИнформации.Вид,
		|	КонтрагентыИсторияКонтактнойИнформации.Вид.Тип,
		|	КонтрагентыИсторияКонтактнойИнформации.ЗначенияПолей,
		|	КонтрагентыИсторияКонтактнойИнформации.Представление,
		|	КонтрагентыИсторияКонтактнойИнформации.Период
		|ИЗ
		|	Справочник.Контрагенты.ИсторияКонтактнойИнформации КАК КонтрагентыИсторияКонтактнойИнформации
		|ГДЕ
		|	КонтрагентыИсторияКонтактнойИнформации.Ссылка В(&МассивОбъектов)
		|	И КонтрагентыИсторияКонтактнойИнформации.Период <= &ДатаСведений
		|	" + ?(ЗначениеЗаполнено(ВидыКИ), "И КонтрагентыИсторияКонтактнойИнформации.Вид В(&Виды)", "");
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Объект,
	|	Вид
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТИсторияКонтактныхДанных.Объект КАК Объект,
	|	ВТИсторияКонтактныхДанных.Вид КАК Вид,
	|	МАКСИМУМ(ВТИсторияКонтактныхДанных.Период) КАК Период
	|ПОМЕСТИТЬ ВТСрезКонтактнойИнформации
	|ИЗ
	|	ВТИсторияКонтактныхДанных КАК ВТИсторияКонтактныхДанных
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТИсторияКонтактныхДанных.Объект,
	|	ВТИсторияКонтактныхДанных.Вид
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Объект,
	|	Вид
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКИ.Объект,
	|	ТаблицаКИ.Тип,
	|	ТаблицаКИ.Вид,
	|	ТаблицаКИ.ЗначенияПолей,
	|	ТаблицаКИ.Представление
	|ПОМЕСТИТЬ ВТКонтактнаяИнформация
	|ИЗ
	|	&ТаблицаКИ КАК ТаблицаКИ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТКонтактнаяИнформация.Объект,
	|	ВТКонтактнаяИнформация.Тип,
	|	ВТКонтактнаяИнформация.Вид,
	|	ВТКонтактнаяИнформация.ЗначенияПолей,
	|	ВТКонтактнаяИнформация.Представление,
	|	ЕСТЬNULL(ВТСрезКонтактнойИнформации.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК Период
	|ПОМЕСТИТЬ ВТКонтактнаяИнформацияПериод
	|ИЗ
	|	ВТКонтактнаяИнформация КАК ВТКонтактнаяИнформация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСрезКонтактнойИнформации КАК ВТСрезКонтактнойИнформации
	|		ПО ВТКонтактнаяИнформация.Объект = ВТСрезКонтактнойИнформации.Объект
	|			И ВТКонтактнаяИнформация.Вид = ВТСрезКонтактнойИнформации.Вид
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТКонтактнаяИнформацияПериод.Объект,
	|	ВТКонтактнаяИнформацияПериод.Тип,
	|	ВТКонтактнаяИнформацияПериод.Вид,
	|	ЕСТЬNULL(ВТИсторияКонтактныхДанных.ЗначенияПолей, ВТКонтактнаяИнформацияПериод.ЗначенияПолей) КАК ЗначенияПолей,
	|	ЕСТЬNULL(ВТИсторияКонтактныхДанных.Представление, ВТКонтактнаяИнформацияПериод.Представление) КАК Представление
	|ИЗ
	|	ВТКонтактнаяИнформацияПериод КАК ВТКонтактнаяИнформацияПериод
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИсторияКонтактныхДанных КАК ВТИсторияКонтактныхДанных
	|		ПО ВТКонтактнаяИнформацияПериод.Объект = ВТИсторияКонтактныхДанных.Объект
	|			И ВТКонтактнаяИнформацияПериод.Вид = ВТИсторияКонтактныхДанных.Вид
	|			И ВТКонтактнаяИнформацияПериод.Период = ВТИсторияКонтактныхДанных.Период";
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает значения полей по виду адреса из ТаблицаКонтактнойИнформации.
// ТаблицаКонтактнойИнформации должна быть предварительно получена с помощью УправлениеКонтактнойИнформациейБП.КонтактнаяИнформацияОбъектовНаДату.
// Если в таблице есть несколько значений для данного вида контактной информации, то будет возвращено первое значение.
//
// Параметры:
//  ТаблицаКонтактнойИнформации - ТаблицаЗначений - Таблица, которую возвращает функция УправлениеКонтактнойИнформациейБП.КонтактнаяИнформацияОбъектовНаДату.
//  ВидКонтактнойИнформации     - СправочникСсылка.ВидыКонтактнойИнформации - вид контактной информации, для которого нужно определить значения полей.
//
// Возвращаемое значение:
//    Строка - XML значения полей.
//
Функция ЗначенияПолейВидаКонтактнойИнформации(ТаблицаКонтактнойИнформации, ВидКонтактнойИнформации) Экспорт
	
	ЗначенияАдреса = ТаблицаКонтактнойИнформации.НайтиСтроки(Новый Структура("Вид", ВидКонтактнойИнформации));
	Если ЗначенияАдреса.Количество() > 0 Тогда
		Возврат ЗначенияАдреса[0].ЗначенияПолей;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Функция - Возвращает массив дат, когда был изменен адрес. Данные берутся из истории адресов.
//
// Параметры:
//  Компания - СправочникСсылка.Организации, СправочникСсылка.Контрагенты - объекты, откуда нужно получить историю.
// 
// Возвращаемое значение:
//  ФиксированныйМассив - массив данных с типом "Дата".
//
Функция ДатыИзмененияАдреса(Компания) Экспорт
	
	Результат = Новый Массив;
	
	Если Не (ЗначениеЗаполнено(Компания) И ОбщегоНазначения.СсылкаСуществует(Компания)) Тогда
		Возврат Новый ФиксированныйМассив(Результат);
	КонецЕсли;
	
	Если ТипЗнч(Компания)<> Тип("СправочникСсылка.Организации")
		И ТипЗнч(Компания)<> Тип("СправочникСсылка.Контрагенты") Тогда
		
		Возврат Новый ФиксированныйМассив(Результат);
	КонецЕсли;
	
	ИсторияАдреса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Компания, "ИсторияКонтактнойИнформации");
	Выборка = ИсторияАдреса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.Период);
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Обновляет историю изменений адреса объекта.
//
// Параметры:
//    СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - заполняемая строка табличной части "Контактная информация".
//    Источник             - ОбъектXDTO  - контактная информация.
//
Процедура ОбновитьИсториюИзмененийАдреса(Объект) Экспорт
	
	ИсторияСрезПоследних = Новый Соответствие;
	Для Каждого ЗаписьИстории Из Объект.ИсторияКонтактнойИнформации Цикл
		КрайняяЗаписьИстории = ИсторияСрезПоследних[ЗаписьИстории.Вид];
		Если КрайняяЗаписьИстории = Неопределено Или КрайняяЗаписьИстории.Период < ЗаписьИстории.Период Тогда
			ИсторияСрезПоследних.Вставить(ЗаписьИстории.Вид, ЗаписьИстории);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИсторияСрезПоследних) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЗаписьИстории Из ИсторияСрезПоследних Цикл
		
		ЗаписиКонтактнойИнформации = Объект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ЗаписьИстории.Ключ));
		КоличествоЗаписей = ЗаписиКонтактнойИнформации.Количество();
		Если КоличествоЗаписей > 0 Тогда
			
			ЗаписьКонтактнойИнформации = ЗаписиКонтактнойИнформации[0];
			Если ЗаписьКонтактнойИнформации.Представление = ЗаписьИстории.Значение.Представление
				И ЗаписьКонтактнойИнформации.ЗначенияПолей = ЗаписьИстории.Значение.ЗначенияПолей Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ЗаписьИстории.Значение, ЗаписьКонтактнойИнформации, "Представление, ЗначенияПолей");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Копирует значения контактной информации объекта одного вида в значения другого.
// Тип контактной информации источника и приемника должен быть одинаков.
//
// Параметры:
//    КонтактнаяИнформация - ТабличнаяЧасть - табличная часть, которая содержит сведения о контактной информации.
//    Источник             - СправочникСсылка.ВидКонтактнойИнформации - вид, значения которого будут выступать источником для копирования.
//    Приемник             - СправочникСсылка.ВидКонтактнойИнформации - вид, значения которого будут выступать приемником для копирования.
//
Процедура СкопироватьКонтактнуюИнформацию(КонтактнаяИнформация, Источник, Приемник) Экспорт
	
	ЗаписиИсточника = ЗаписиКонтактнойИнформации(КонтактнаяИнформация, Источник);
	
	Если Не ЗначениеЗаполнено(ЗаписиИсточника) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписиПриемника = ЗаписиКонтактнойИнформации(КонтактнаяИнформация, Приемник);
	
	Для Каждого Запись Из ЗаписиПриемника Цикл
		КонтактнаяИнформация.Удалить(Запись);
	КонецЦикла;
	
	Для Каждого Запись Из ЗаписиИсточника Цикл
		
		НоваяЗапись = КонтактнаяИнформация.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Запись);
		
		Если ЗначениеЗаполнено(НоваяЗапись.Вид) Тогда
			НоваяЗапись.Вид = Приемник;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НоваяЗапись.ВидДляСписка) Тогда
			НоваяЗапись.ВидДляСписка = Приемник;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Сравнивает адреса.
// Параметры:
//   Адрес1 - Строка, ОбъектXDTO - XDTO объект или строка XML контактной информации.
//   Адрес2 - Строка, ОбъектXDTO - XDTO объект или строка XML контактной информации.
//
// Возвращаемое значение:
//  Булево - Истина, если адреса совпадают, Ложь - если нет
//
Функция СравнитьАдреса(Адрес1, Адрес2) Экспорт
	
	ДополнительныеПараметры =  Новый Структура("НаименованиеВключаетСокращение", Ложь);
	СведенияОбАдресе1 = РаботаСАдресами.СведенияОбАдресе(Адрес1, ДополнительныеПараметры);
	СведенияОбАдресе2 = РаботаСАдресами.СведенияОбАдресе(Адрес2, ДополнительныеПараметры);
	
	Возврат ОбщегоНазначения.ДанныеСовпадают(СведенияОбАдресе1, СведенияОбАдресе2);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает текст ссылки по которой осуществляется переход на карту,
// в виде форматированной строки (с картинкой)
//
Функция СтрокаСсылкиПоказатьНаКарте() Экспорт
	
	СоставСтроки = Новый Массив;
	СоставСтроки.Добавить(БиблиотекаКартинок.Пин);
	СоставСтроки.Добавить(НСтр("ru = 'Показать на карте'"));
	Возврат Новый ФорматированнаяСтрока(СоставСтроки);
	
КонецФункции

// Функция - Проверяет совпадение видов адресов объекта по представлению
//
// Параметры:
//  Компания	 - СправочникСсылка.Организация, СправочникСсылка.Контрагент - организация или контрагент, владелец адреса
//  ВидАдреса1	 - СправочникСсылка.ВидыКонтактнойИнформации - вид контактной информации организации или контрагента
//  ВидАдреса2	 - СправочникСсылка.ВидыКонтактнойИнформации - вид контактной информации организации или контрагента
// 
// Возвращаемое значение:
//  Булево - Истина, если адреса совпадают, Ложь - если нет
//
Функция АдресаСовпадают(Компания, ВидАдреса1, ВидАдреса2) Экспорт
	
	Если Не ЗначениеЗаполнено(Компания) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Компания)<> Тип("СправочникСсылка.Организации")
		И ТипЗнч(Компания)<> Тип("СправочникСсылка.Контрагенты") Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Объекты = Новый Массив;
	Объекты.Добавить(Компания);
	
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(ВидАдреса1);
	ВидыКИ.Добавить(ВидАдреса2);
	
	ТекущиеАдреса = КонтактнаяИнформацияОбъектовНаДату(Объекты,, ВидыКИ);
	Адрес1 = ТекущиеАдреса.Найти(ВидАдреса1, "Вид");
	Адрес2 = ТекущиеАдреса.Найти(ВидАдреса2, "Вид");
	
	// Если фактический и юридический адрес совпадают, то адрес доставки грузополучателя берем из истории юр. адресов.
	Если Адрес1 <> Неопределено И Адрес2 <> Неопределено 
		И СокрЛП(Адрес1.Представление) = СокрЛП(Адрес2.Представление) Тогда
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Процедура - Если фактический и почтовый адреса совпадают с текущим юр. адресом, то заменяет их на юр. адрес из истории
//
// Параметры:
//  Компания			 - СправочникСсылка.Организация, СправочникСсылка.Контрагенты - компания, контактные данные которого проверяем
//  КонтактнаяИнформация - ТаблицаЗначений - таблица значения, полученная с помощью УправлениеКонтактнойИнформациейБП.КонтактнаяИнформацияОбъектовНаДату()
//
Процедура ЗаменитьАдресаНаЮрИзИстории(Компания, КонтактнаяИнформация) Экспорт
	
	Если Не ЗначениеЗаполнено(Компания) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Компания)<> Тип("СправочникСсылка.Организации")
		И ТипЗнч(Компания)<> Тип("СправочникСсылка.Контрагенты") Тогда
		
		Возврат;
	КонецЕсли;
	
	Объекты = Новый Массив;
	Объекты.Добавить(Компания);
	
	Если ТипЗнч(Компания) = Тип("СправочникСсылка.Организации") Тогда
		ВидЮрАдрес		 = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
		ВидФактАдрес	 = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
		ВидПочтовыйАдрес = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации;
	Иначе
		ВидЮрАдрес		 = Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента;
		ВидФактАдрес	 = Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента;
		ВидПочтовыйАдрес = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента;
	КонецЕсли;
	
	ЮрФактАдресаСовпадают = АдресаСовпадают(Компания, ВидЮрАдрес, ВидФактАдрес);
		
	ЮрПочтовыйАдресаСовпадают = АдресаСовпадают(Компания, ВидЮрАдрес, ВидПочтовыйАдрес);
	
	Если ЮрФактАдресаСовпадают Тогда
		
		ЮрАдрес		 = КонтактнаяИнформация.Найти(ВидЮрАдрес,	 "Вид");
		ФактАдрес	 = КонтактнаяИнформация.Найти(ВидФактАдрес,	 "Вид");
		Если ЮрАдрес <> Неопределено И ФактАдрес <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ФактАдрес, ЮрАдрес, "ЗначенияПолей, Представление");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЮрПочтовыйАдресаСовпадают Тогда
		
		ЮрАдрес			 = КонтактнаяИнформация.Найти(ВидЮрАдрес,		 "Вид");
		ПочтовыйАдрес	 = КонтактнаяИнформация.Найти(ВидПочтовыйАдрес,	 "Вид");
		Если ЮрАдрес <> Неопределено И ПочтовыйАдрес <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ПочтовыйАдрес, ЮрАдрес, "ЗначенияПолей, Представление");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Убирает разделители в номере телефона.
//
// Параметры:
//    НомерТелефона - Строка - номер телефона или факса.
//
// Возвращаемое значение:
//     Строка - номер телефона или факса без разделителей.
//
Функция УбратьРазделителиВНомерТелефона(Знач НомерТелефона)
	
	Поз = СтрНайти(НомерТелефона, ",");
	Если Поз <> 0 Тогда
		НомерТелефона = Лев(НомерТелефона, Поз-1);
	КонецЕсли;
	
	НомерТелефона = СтрЗаменить(НомерТелефона, "-", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, " ", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, "+", "");
	
	Возврат НомерТелефона;
	
КонецФункции

// Заполняет контактную информацию в табличной части "Контактная информация" приемника.
//
// Параметры:
//        * Приемник    - Произвольный - Объект, в котором нужно заполнить КИ.
//        * ВидКИ       - СправочникСсылка.ВидыКонтактнойИнформации - вид контактной информации, заполняемый в
//                                                                    приемнике.
//        * СтруктураКИ - СписокЗначений, Строка, Структура - данные значений полей контактной информации.
//        * СтрокаТабличнойЧасти - СтрокаТабличнойЧасти, Неопределено - данные приемника, если контактная информация
//                                 заполняется для строки.
//                                                                      Неопределено, если контактная информация
//                                                                      заполняется для приемника.
//        * Дата         - Дата - Дата с который действует контактная информация. Используется только
//                                если у вида КИ установлен флаг ХранитьИсториюИзменений.
//
Процедура ЗаполнитьКонтактнуюИнформациюТабличнойЧасти(Приемник, ВидКИ, СтруктураКИ, СтрокаТабличнойЧасти = Неопределено, Дата = Неопределено)
	
	ПараметрыОтбора = Новый Структура;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		ДанныеЗаполнения = Приемник;
	Иначе
		ДанныеЗаполнения = СтрокаТабличнойЧасти;
		ПараметрыОтбора.Вставить("ИдентификаторСтрокиТабличнойЧасти", СтрокаТабличнойЧасти.ИдентификаторСтрокиТабличнойЧасти);
	КонецЕсли;
	
	ПараметрыОтбора.Вставить("Вид", ВидКИ);
	НайденныеСтрокиКИ = Приемник.КонтактнаяИнформация.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтрокиКИ.Количество() = 0 Тогда
		СтрокаКИ = Приемник.КонтактнаяИнформация.Добавить();
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			СтрокаКИ.ИдентификаторСтрокиТабличнойЧасти = СтрокаТабличнойЧасти.ИдентификаторСтрокиТабличнойЧасти;
		КонецЕсли;
	Иначе
		СтрокаКИ = НайденныеСтрокиКИ[0];
	КонецЕсли;
	
	Если ТипЗнч(СтруктураКИ) = Тип("Структура") И СтруктураКИ.Свойство("КонтактнаяИнформация") Тогда
		ЗначенияПолей = СтруктураКИ.КонтактнаяИнформация;
	Иначе
		// Из любого понимаемого - в XML.
		ЗначенияПолей = КонтактнаяИнформацияВXML(СтруктураКИ, , ВидКИ);
	КонецЕсли;
	Представление = ПредставлениеКонтактнойИнформации(ЗначенияПолей);
	
	СтрокаКИ.Тип           = ВидКИ.Тип;
	СтрокаКИ.Вид           = ВидКИ;
	СтрокаКИ.Представление = Представление;
	СтрокаКИ.ЗначенияПолей = ЗначенияПолей;
	
	Если ВидКИ.ХранитьИсториюИзменений Тогда
		СтрокаКИ.ДействуетС = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КонецЕсли;
	
	ЗаполнитьДополнительныеРеквизитыКонтактнойИнформации(СтрокаКИ, Представление, ЗначенияПолей);
КонецПроцедуры

// Преобразует все входящие форматы контактной информации в XML.
//
// Параметры:
//    ЗначенияПолей - Строка, Структура, Соответствие, СписокЗначений - описание полей контактной информации.
//    Представление - Строка  - представления. Используется, если невозможно определить представление из параметра.
//                    ЗначенияПолей (отсутствие поля "Представление").
//    ОжидаемыйВид  - СправочникСсылка.ВидыКонтактнойИнформации, ПеречислениеСсылка.ТипыКонтактнойИнформации -
//                    Используется для определения типа, если его невозможно вычислить по полю ЗначенияПолей.
//
// Возвращаемое значение:
//     Строка  - XML данные контактной информации.
//
Функция КонтактнаяИнформацияВXML(Знач ЗначенияПолей, Знач Представление = "", Знач ОжидаемыйВид = Неопределено) Экспорт
	
	Результат = УправлениеКонтактнойИнформациейСлужебный.ПривестиКонтактнуюИнформациюXML(Новый Структура(
		"ЗначенияПолей, Представление, ВидКонтактнойИнформации",
		ЗначенияПолей, Представление, ОжидаемыйВид));
	Возврат Результат.ДанныеXML;
	
КонецФункции

// Заполняет дополнительные реквизиты строки табличной части "Контактная информация".
//
// Параметры:
//    СтрокаКИ      - СтрокаТабличнойЧасти - строка "Контактная информация".
//    Представление - Строка                     - представление значения.
//    ЗначенияПолей - СписокЗначений, ОбъектXTDO - значения полей.
//
Процедура ЗаполнитьДополнительныеРеквизитыКонтактнойИнформации(СтрокаКИ, Представление, ЗначенияПолей)
	
	Если ТипЗнч(ЗначенияПолей) = Тип("ОбъектXDTO") Тогда
		ОбъектКИ = ЗначенияПолей;
	Иначе
		ОбъектКИ = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(ЗначенияПолей, СтрокаКИ.Вид);
	КонецЕсли;
	
	ТипИнформации = СтрокаКИ.Тип;

	Если ТипИнформации = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
		ЗаполнитьРеквизитыТабличнойЧастиДляАдресаЭлектроннойПочты(СтрокаКИ, ОбъектКИ);
		
	ИначеЕсли ТипИнформации = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		ЗаполнитьРеквизитыТабличнойЧастиДляАдреса(СтрокаКИ, ОбъектКИ);
		
	ИначеЕсли ТипИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		ЗаполнитьРеквизитыТабличнойЧастиДляТелефона(СтрокаКИ, ОбъектКИ);
		
	ИначеЕсли ТипИнформации = Перечисления.ТипыКонтактнойИнформации.Факс Тогда
		ЗаполнитьРеквизитыТабличнойЧастиДляТелефона(СтрокаКИ, ОбъектКИ);
		
	ИначеЕсли ТипИнформации = Перечисления.ТипыКонтактнойИнформации.ВебСтраница Тогда
		ЗаполнитьРеквизитыТабличнойЧастиДляВебСтраницы(СтрокаКИ, ОбъектКИ);
		
	КонецЕсли;
	
КонецПроцедуры

// Получает представление контактной информации (адреса, телефона, электронной почты и т.п.).
//
// Параметры:
//    XMLСтрока               - ОбъектXDTO, Строка - объект или XML контактной информации.
//    ВидКонтактнойИнформации - Структура - дополнительные параметры формирования представления для адресов:
//      * ВключатьСтрануВПредставление - Булево - в представление будет включена страна адреса;
//      * ФорматАдреса                 - Строка - если указано "КЛАДР", то в представление адреса 
//                                                не включаются округ и внутригородской район.
//
// Возвращаемое значение:
//    Строка - представление контактной информации.
//
Функция ПредставлениеКонтактнойИнформации(Знач XMLСтрока, Знач ВидКонтактнойИнформации = Неопределено) Экспорт
	
	Возврат УправлениеКонтактнойИнформациейСлужебный.ПредставлениеКонтактнойИнформации(XMLСтрока, ВидКонтактнойИнформации);
	
КонецФункции

Функция ЗаписиКонтактнойИнформации(КонтактнаяИнформация, ВидКонтактнойИнформации)
	
	Отбор = Новый Структура("Вид", ВидКонтактнойИнформации);
	Записи = КонтактнаяИнформация.НайтиСтроки(Отбор);
	
	Отбор = Новый Структура("Вид,ВидДляСписка", Справочники.ВидыКонтактнойИнформации.ПустаяСсылка(), ВидКонтактнойИнформации);
	ГрупповыеЗаписи = КонтактнаяИнформация.НайтиСтроки(Отбор);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Записи, ГрупповыеЗаписи);
	
	Возврат Записи;
	
КонецФункции

Функция СтруктураАдреса(АдресЗначенияПолей, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураАдреса = НовыйСтруктураАдреса();
	
	СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(АдресЗначенияПолей, ДополнительныеПараметры);
	
	СтруктураАдреса.Страна    = СведенияОбАдресе.Страна;
	СтруктураАдреса.КодСтраны = СведенияОбАдресе.КодСтраны;
	Если СтруктураАдреса.Свойство("Страна") 
		И СтрСравнить(СтруктураАдреса.Страна, Справочники.СтраныМира.Россия.Наименование) = 0 Тогда
		СтруктураАдреса.АдресРФ = Истина;
	Иначе
		СтруктураАдреса.АдресРФ = Ложь;
	КонецЕсли;
	
	СтруктураАдреса.Индекс                    = СведенияОбАдресе.Индекс;
	СтруктураАдреса.Регион                    = СведенияОбАдресе.Регион;
	СтруктураАдреса.КодРегиона                = ?(СведенияОбАдресе.Свойство("КодРегиона"), СведенияОбАдресе.КодРегиона, "");
	СтруктураАдреса.РегионСокращение          = СведенияОбАдресе.РегионСокращение;
	СтруктураАдреса.Район                     = СведенияОбАдресе.Район;
	СтруктураАдреса.РайонСокращение           = СведенияОбАдресе.РайонСокращение;
	СтруктураАдреса.Город                     = СведенияОбАдресе.Город;
	СтруктураАдреса.ГородСокращение           = СведенияОбАдресе.ГородСокращение;
	СтруктураАдреса.НаселенныйПункт           = СведенияОбАдресе.НаселенныйПункт;
	СтруктураАдреса.НаселенныйПунктСокращение = СведенияОбАдресе.НаселенныйПунктСокращение;
	СтруктураАдреса.Улица                     = СведенияОбАдресе.Улица;
	СтруктураАдреса.УлицаСокращение           = СведенияОбАдресе.УлицаСокращение;
	СтруктураАдреса.Дом                       = СведенияОбАдресе.Здание.Номер;
	СтруктураАдреса.ТипДома                   = СведенияОбАдресе.Здание.ТипЗдания;
	
	Если СведенияОбАдресе.Корпуса.Количество() > 0 Тогда
		СтруктураАдреса.Корпус     = СведенияОбАдресе.Корпуса[0].Номер;
		СтруктураАдреса.ТипКорпуса = СведенияОбАдресе.Корпуса[0].ТипКорпуса;
	КонецЕсли;
	
	Если СведенияОбАдресе.Помещения.Количество() > 0 Тогда
		СтруктураАдреса.Квартира    = СведенияОбАдресе.Помещения[0].Номер;
		СтруктураАдреса.ТипКвартиры = СведенияОбАдресе.Помещения[0].ТипПомещения;
	КонецЕсли;
	
	Возврат СтруктураАдреса;
	
КонецФункции

// Сравнивает населенные пункты.
// Параметры:
//   Адрес1 - Строка, ОбъектXDTO - XDTO объект или строка XML контактной информации.
//   Адрес2 - Строка, ОбъектXDTO - XDTO объект или строка XML контактной информации.
//
// Возвращаемое значение:
//  Булево - Истина, если населенные пункты совпадают, Ложь - если нет
//
Функция СравнитьНаселенныеПункты(Адрес1, Адрес2) Экспорт
	
	КлючНаселенногоПункта = "Страна, КодСтраны, КодРегиона, Регион, Округ, Район, Город, ВнутригородскойРайон, НаселенныйПункт";
	НаселенныйПункт1 = Новый Структура(КлючНаселенногоПункта);
	НаселенныйПункт2 = Новый Структура(КлючНаселенногоПункта);
	
	ДополнительныеПараметры =  Новый Структура("НаименованиеВключаетСокращение", Ложь);
	
	ЗаполнитьЗначенияСвойств(НаселенныйПункт1, РаботаСАдресами.СведенияОбАдресе(Адрес1, ДополнительныеПараметры));
	ЗаполнитьЗначенияСвойств(НаселенныйПункт2, РаботаСАдресами.СведенияОбАдресе(Адрес2, ДополнительныеПараметры));
	
	Если ОбщегоНазначения.ДанныеСовпадают(НаселенныйПункт1, НаселенныйПункт2) Тогда
		НаселенныеПунктыСовпадают = Истина;
	Иначе
		КодыАдреса1 = АдресныйКлассификаторБП.КодыАдреса(Адрес1, "Сервис1С");
		КодыАдреса2 = АдресныйКлассификаторБП.КодыАдреса(Адрес2, "Сервис1С");
		НаселенныеПунктыСовпадают = Лев(КодыАдреса1.ОКТМО, 6) = Лев(КодыАдреса2.ОКТМО, 6)
			И Не ПустаяСтрока(КодыАдреса1.ОКТМО)
			И Не ПустаяСтрока(КодыАдреса2.ОКТМО);
	КонецЕсли;
	
	Возврат НаселенныеПунктыСовпадают;
	
КонецФункции

Функция НовыйСтруктураАдреса()
	
	СтруктураАдреса = Новый Структура();
	СтруктураАдреса.Вставить("АдресРФ",                   Истина);
	СтруктураАдреса.Вставить("КодСтраны",                 "");
	СтруктураАдреса.Вставить("Страна",                    "");
	СтруктураАдреса.Вставить("Индекс",                    "");
	СтруктураАдреса.Вставить("Регион",                    "");
	СтруктураАдреса.Вставить("РегионСокращение",          "");
	СтруктураАдреса.Вставить("КодРегиона",                "");
	СтруктураАдреса.Вставить("Район",                     "");
	СтруктураАдреса.Вставить("РайонСокращение",           "");
	СтруктураАдреса.Вставить("Город",                     "");
	СтруктураАдреса.Вставить("ГородСокращение",           "");
	СтруктураАдреса.Вставить("НаселенныйПункт",           "");
	СтруктураАдреса.Вставить("НаселенныйПунктСокращение", "");
	СтруктураАдреса.Вставить("Улица",                     "");
	СтруктураАдреса.Вставить("УлицаСокращение",           "");
	СтруктураАдреса.Вставить("Дом",                       "");
	СтруктураАдреса.Вставить("ТипДома",                   "");
	СтруктураАдреса.Вставить("Корпус",                    "");
	СтруктураАдреса.Вставить("ТипКорпуса",                "");
	СтруктураАдреса.Вставить("Квартира",                  "");
	СтруктураАдреса.Вставить("ТипКвартиры",               "");
	СтруктураАдреса.Вставить("Представление",             "");
	СтруктураАдреса.Вставить("ЗначенияПолей",             "");
	
	Возврат СтруктураАдреса;
	
КонецФункции

#КонецОбласти
