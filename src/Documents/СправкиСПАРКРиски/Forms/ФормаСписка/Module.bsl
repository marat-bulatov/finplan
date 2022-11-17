///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СПАРКРиски.ИспользованиеРазрешено() Тогда
		Элементы.ГруппаПанель.Видимость = Ложь;
		Элементы.КакНастроитьAdobeReader.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Элементы.ЗапроситьСправку.Видимость = Пользователи.РолиДоступны("ЗапросНовойСправкиСПАРКРиски", , Ложь);
	Если ЗначениеЗаполнено(Параметры.Контрагент) Тогда
		
		Контрагент = Параметры.Контрагент;
		
		// Проверка корректности параметра отбора.
		СвойстваСправочниковКонтрагенты = СПАРКРиски.СвойстваСправочниковКонтрагентов();
		ТипКонтрагент = ТипЗнч(Контрагент);
		
		ОписаниеСправочника = СвойстваСправочниковКонтрагенты.Найти(ТипКонтрагент, "ТипСсылка");
		Если ОписаниеСправочника = Неопределено Тогда
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Неизвестный тип контрагента (%1). Необходимо заполнить описание справочника в методе
					|ПриОпределенииСвойствСправочниковКонтрагентов() общего модуля СПАРКРискиПереопределяемый.'"),
				ТипКонтрагент);
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
		
		Если ОписаниеСправочника.Иерархический
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ЭтоГруппа") = Истина Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Получение справок 1СПАРК Риски недоступно для группы. Выберите элемент справочника.'"));
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		// Настройка отображения элементов формы.
		Элементы.ГруппаКонтрагентОтбор.Видимость = Ложь;
		Элементы.Контрагент.Видимость            = Ложь;
		
		// Установить отбор в списке.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Контрагент", Контрагент);
		
		Элементы.КонтрагентОтборГиперссылка.Видимость = Параметры.ПоказыватьОтбор;
		Если Параметры.ПоказыватьОтбор Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Справки 1СПАРК Риски: %1'"),
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Контрагент, "Наименование"));
		КонецЕсли;
		
	Иначе
		
		Элементы.КонтрагентОтборГиперссылка.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентОтборПриИзменении(Элемент)
	
	УстановитьОтборПоКонтрагенту();
	
КонецПроцедуры

&НаКлиенте
Процедура КакНастроитьAdobeReader(Команда)
	
	URLИнструкций = "http://downloads.v8.1c.ru/content/Instruction/how-to-setup-Adobe-acrobat-digital-signature-verification.pdf";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(URLИнструкций);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);
	ОткрытьСправкуСПАРКРиски(Неопределено, ДанныеСтроки.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапроситьСправку(Команда)
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поле ""Контрагент"" не заполнено.'"),
			,
			"Контрагент");
		Возврат;
	КонецЕсли;
	
	ЗапроситьНовуюСправку();
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеПолученныеСправки(Команда)
	
	Состояние(, , НСтр("ru = 'Переход на Портал 1С:ИТС'"));
	ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
		АдресСтраницыЛичныйКабинетВсеСправки(),
		НСтр("ru = 'Справки 1СПАРК Риски'"));
	Состояние();
	
КонецПроцедуры

&НаКлиенте
Процедура КакПользоватьсяСправкой(Команда)
	
	URLИнструкций = "http://downloads.v8.1c.ru/content/Instruction/1spark-report.pdf";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(URLИнструкций);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьСправкуСПАРКРиски(Результат, СправкаСсылка) Экспорт
	
	Состояние(, , НСтр("ru = 'Открытие справки 1СПАРК Риски...'"));
	РезультатПолученияДанныхФайла = ДанныеДляПросмотраФайлаСправки(СправкаСсылка);
	Состояние();
	Если РезультатПолученияДанныхФайла.ДанныеФайла <> Неопределено Тогда
		
		РаботаСФайламиКлиент.ОткрытьФайл(РезультатПолученияДанныхФайла.ДанныеФайла, Ложь);
		
	ИначеЕсли РезультатПолученияДанныхФайла.ВидОшибки.Пустая() Тогда
		
		Если Не ПустаяСтрока(РезультатПолученияДанныхФайла.Сообщение) Тогда
			ПоказатьПредупреждение(, РезультатПолученияДанныхФайла.Сообщение);
		КонецЕсли;
		
	Иначе
		
		ОбработатьОшибку(
			РезультатПолученияДанныхФайла,
			Новый ОписаниеОповещения("ОткрытьСправкуСПАРКРиски", ЭтотОбъект, СправкаСсылка));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоКонтрагенту()
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор,
			"Контрагент",
			Контрагент,
			,
			,
			Истина);
		
	Иначе
		
		ОтборыПоКонтрагенту = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.Отбор, "Контрагент");
		Для Каждого ТекущийОтбор Из ОтборыПоКонтрагенту Цикл
			ТекущийОтбор.Использование = Ложь;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьНовуюСправку(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Состояние(, , НСтр("ru = 'Запрос новой справки 1СПАРК Риски'"));
	РезультатЗапросаСправки = ЗапроситьНовуюСправкуВСервисеСПАРКРиски();
	Состояние();
	
	Если Не РезультатЗапросаСправки.СправкаСсылка.Пустая() Тогда
		
		Элементы.Список.ТекущаяСтрока = РезультатЗапросаСправки.СправкаСсылка;
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Справки 1СПАРК Риски'"),
			,
			НСтр("ru = 'Подготовка новой справки 1СПАРК Риски.'"),
			БиблиотекаКартинок.Информация32,
			,
			"Справки1СПАРКРиски");
		
	ИначеЕсли РезультатЗапросаСправки.ВидОшибки.Пустая() Тогда
		
		Если Элементы.ГруппаКонтрагентОтбор.Видимость Тогда
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				РезультатЗапросаСправки.Сообщение,
				,
				"Контрагент");
			
		Иначе
			
			ПоказатьПредупреждение(, РезультатЗапросаСправки.Сообщение);
			
		КонецЕсли;
		
	ИначеЕсли Не ПустаяСтрока(РезультатЗапросаСправки.Сообщение) Тогда
		
		ПоказатьПредупреждение(, РезультатЗапросаСправки.Сообщение);
		
	Иначе
		
		ОбработатьОшибку(
			РезультатЗапросаСправки,
			Новый ОписаниеОповещения("ЗапроситьНовуюСправку", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибку(РезультатДействия, ОповещениеПриПодключенииИнтернетПоддержки)
	
	Если РезультатДействия.ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ВнутренняяОшибкаСервиса") Тогда
		
		ПоказатьПредупреждение(
			,
			НСтр("ru = 'Не удалось подключиться к сервису 1СПАРК Риски. Сервис временно недоступен.
				|Повторите попытку подключения позже.'"));
		
	ИначеЕсли РезультатДействия.ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ИспользованиеЗапрещено") Тогда
		
		ПоказатьПредупреждение(
			,
			НСтр("ru = 'Использование сервиса 1СПАРК Риски недоступно в текущем режиме работы.'"));
		
	ИначеЕсли РезультатДействия.ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ОшибкаПодключения") Тогда
		
		ПараметрыФормы = Новый Структура("СообщениеОбОшибке, ИнформацияОбОшибке",
			РезультатДействия.СообщениеОбОшибке,
			РезультатДействия.ИнформацияОбОшибке);
		
		ОткрытьФорму(
			"Документ.СправкиСПАРКРиски.Форма.НеУдалосьПодключитьсяКСервису",
			ПараметрыФормы,
			ЭтотОбъект);
		
	ИначеЕсли РезультатДействия.ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ИнтернетПоддержкаНеПодключена") Тогда
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ПриОтветеНаВопросОПодключенииИнтернетПоддержки",
				ЭтотОбъект,
				ОповещениеПриПодключенииИнтернетПоддержки),
			НСтр("ru = 'Для работы с сервисом 1СПАРК Риски необходимо подключить Интернет-поддержку пользователей.
				|Подключить?'"),
			РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли РезультатДействия.ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит")
			И ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПодключениеСервисовСопровождения") Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("СообщениеОбОшибке", РезультатДействия.СообщениеОбОшибке);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПодключитьТестовыйПериодЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		МодульПодключениеСервисовСопровожденияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ПодключениеСервисовСопровожденияКлиент");
		
		МодульПодключениеСервисовСопровожденияКлиент.ПодключитьТестовыйПериод(
			СПАРКРискиКлиентСервер.ИдентификаторСервиса(),
			ЭтотОбъект,
			ОписаниеОповещения);
		
	ИначеЕсли ЗначениеЗаполнено(РезультатДействия.СообщениеОбОшибке) Тогда
		
		ПоказатьПредупреждение(, РезультатДействия.СообщениеОбОшибке);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОПодключенииИнтернетПоддержки(КодВозврата, ОповещениеПриПодключенииИнтернетПоддержки) Экспорт
	
	Если КодВозврата <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
		Новый ОписаниеОповещения(
			"ПодключитьИнтернетПоддержкуЗавершение",
			ЭтотОбъект,
			ОповещениеПриПодключенииИнтернетПоддержки),
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ОповещениеПриПодключенииИнтернетПоддержки) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если ОповещениеПриПодключенииИнтернетПоддержки <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПриПодключенииИнтернетПоддержки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапроситьНовуюСправкуВСервисеСПАРКРиски()
	
	Если Не СПАРКРиски.ИспользованиеРазрешено() Тогда
		// Обеспечение безопасности серверных методов.
		ВызватьИсключение НСтр("ru = 'Использование недоступно в текущем режиме работы.'");
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ВидОшибки"         , Перечисления.ВидыОшибокСПАРКРиски.ПустаяСсылка());
	Результат.Вставить("Сообщение"         , "");
	Результат.Вставить("СообщениеОбОшибке" , "");
	Результат.Вставить("ИнформацияОбОшибке", "");
	Результат.Вставить("СправкаСсылка"     , Документы.СправкиСПАРКРиски.ПустаяСсылка());
	
	ИдентификаторУслуги = СПАРКРиски.ИдентификаторУслугиСправкиПоКомпаниям();
	Если Не ИнтернетПоддержкаПользователей.УслугаПодключена(ИдентификаторУслуги) Тогда
		
		// Проверка наличия услуги по данным ИБ выполняется на
		// прикладном уровне до вызова операции сервиса.
		РезультатВызоваОперации = Новый Структура;
		РезультатВызоваОперации.Вставить("ВидОшибки", Перечисления.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит);
		РезультатВызоваОперации.Вставить("СообщениеОбОшибке",
			НСтр("ru = 'Услуга не подключена.'"));
		РезультатВызоваОперации.Вставить("ИнформацияОбОшибке",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось запросить новую справку 1СПАРК Риски.
					|Услуга с идентификатором %1 не подключена.'"),
				ИдентификаторУслуги));
		
		СПАРКРиски.ЗаписатьИнформациюВЖурналРегистрации(РезультатВызоваОперации.ИнформацияОбОшибке);
		ПодготовитьОписаниеОшибки(Результат, РезультатВызоваОперации);
		Возврат Результат;
		
	КонецЕсли;
	
	СвойстваСправочниковКонтрагенты = СПАРКРиски.СвойстваСправочниковКонтрагентов();
	ТипКонтрагент = ТипЗнч(Контрагент);
	
	ОписаниеСправочника = СвойстваСправочниковКонтрагенты.Найти(ТипКонтрагент, "ТипСсылка");
	Если ОписаниеСправочника = Неопределено Тогда
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный тип контрагента (%1). Необходимо заполнить описание справочника в методе
				|ПриОпределенииСвойствСправочниковКонтрагентов() общего модуля СПАРКРискиПереопределяемый.'"),
			ТипКонтрагент);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗначенияРеквизитов = СПАРКРиски.ЗначенияРеквизитовКонтрагентов(Контрагент);
	Если ЗначенияРеквизитов.Количество() = 0 Тогда
		// Контрагент отсутствует в информационной базе.
		Результат.Сообщение = НСтр("ru = 'Не удалось получить данные контрагента. Данные контрагента были удалены или недостаточно прав.'");
		Возврат Результат;
	КонецЕсли;
	
	ДанныеКонтрагента     = ЗначенияРеквизитов[0];
	ДанныеКонтрагента.ИНН = СокрЛП(ДанныеКонтрагента.ИНН);
	ОшибкаИНН             = "";
	
	// Вид контрагента может быть не заполнен, если не завершено
	// обновление информационной базы.
	ВидКонтрагента = СПАРКРиски.ОбработатьВидКонтрагента(
		ДанныеКонтрагента.ВидКонтрагента);
		
	Если Не ДанныеКонтрагента.ПодлежитПроверке Тогда
		
		Результат.Сообщение = НСтр("ru = 'Выбранный контрагент не может быть проверен в сервисе 1СПАРК Риски.'");
		Возврат Результат;
		
	ИначеЕсли Не СПАРКРиски.ИННСоответствуетТребованиям(ДанныеКонтрагента.ИНН, ВидКонтрагента, ОшибкаИНН) Тогда
		
		Результат.Сообщение = ОшибкаИНН;
		Возврат Результат;
		
	КонецЕсли;
	
	СписокИНН = Новый Массив;
	СписокИНН.Добавить(ДанныеКонтрагента.ИНН);
	
	Если Не ЗначениеЗаполнено(ДанныеКонтрагента.ВидКонтрагента)
		Или ДанныеКонтрагента.ВидКонтрагента = Перечисления.ВидыКонтрагентовСПАРКРиски.ЮридическоеЛицо Тогда
		РезультатВызоваОперации = СервисСПАРКРиски.НачатьПодготовкуСправокЮридическихЛиц(
			СписокИНН);
	Иначе
		РезультатВызоваОперации = СервисСПАРКРиски.НачатьПодготовкуСправокИндивидуальныхПредпринимателей(
			СписокИНН);
	КонецЕсли;
	
	Если Не РезультатВызоваОперации.ВидОшибки.Пустая() Тогда
		ПодготовитьОписаниеОшибки(Результат, РезультатВызоваОперации);
		Возврат Результат;
	КонецЕсли;
	
	ИдентификаторСправки = РезультатВызоваОперации.ИдентификаторыСправок[ДанныеКонтрагента.ИНН];
	Если Не ЗначениеЗаполнено(ИдентификаторСправки) Тогда
		СПАРКРиски.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при запросе новой справки для ИНН %1.
					|Сервис не возвратил идентификатор справки.'"),
				ДанныеКонтрагента.ИНН));
		Результат.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ВнутренняяОшибкаСервиса;
	КонецЕсли;
	
	// Создать документ.
	СправкаОбъект = Документы.СправкиСПАРКРиски.СоздатьДокумент();
	СправкаОбъект.Дата           = РезультатВызоваОперации.ДатаЗапроса;
	СправкаОбъект.Контрагент     = Контрагент;
	СправкаОбъект.ИНН            = ДанныеКонтрагента.ИНН;
	СправкаОбъект.ВидКонтрагента = ВидКонтрагента;
	СправкаОбъект.Состояние      = Перечисления.СостоянияСправкиСПАРКРиски.Готовится;
	СправкаОбъект.Идентификатор  = ИдентификаторСправки;
	СправкаОбъект.Записать();
	
	ДобавитьЗаданиеПроверкиСостоянияГотовностиСправки(
		СправкаОбъект.Ссылка,
		ИдентификаторСправки);
	
	Элементы.Список.Обновить();
	Результат.СправкаСсылка = СправкаОбъект.Ссылка;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьЗаданиеПроверкиСостоянияГотовностиСправки(Справка, ИдентификаторСправки)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Истина);
	ПараметрыЗадания.Вставить("Метаданные",
		Метаданные.РегламентныеЗадания.ПроверкаГотовностиСправкиСПАРКРиски);
	ПараметрыЗадания.Вставить("Ключ", Строка(ИдентификаторСправки));
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(Справка);
	ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
	
	РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	
КонецПроцедуры

&НаСервере
Функция ДанныеДляПросмотраФайлаСправки(Знач Справка)
	
	Результат = Новый Структура;
	Результат.Вставить("Сообщение"         , "");
	Результат.Вставить("ВидОшибки"         , Перечисления.ВидыОшибокСПАРКРиски.ПустаяСсылка());
	Результат.Вставить("СообщениеОбОшибке" , "");
	Результат.Вставить("ИнформацияОбОшибке", "");
	Результат.Вставить("ДанныеФайла"       , Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	СправкиСПАРКРиски.Состояние КАК Состояние,
	|	СправкиСПАРКРиски.Идентификатор КАК ИдентификаторСправки,
	|	ЕСТЬNULL(СправкиСПАРКРискиПрисоединенныеФайлы.Ссылка, НЕОПРЕДЕЛЕНО) КАК ФайлСсылка,
	|	СправкиСПАРКРиски.ИНН КАК ИНН,
	|	СправкиСПАРКРиски.ВидКонтрагента КАК ВидКонтрагента
	|ИЗ
	|	Документ.СправкиСПАРКРиски КАК СправкиСПАРКРиски
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СправкиСПАРКРискиПрисоединенныеФайлы КАК СправкиСПАРКРискиПрисоединенныеФайлы
	|		ПО СправкиСПАРКРиски.Ссылка = СправкиСПАРКРискиПрисоединенныеФайлы.ВладелецФайла
	|ГДЕ
	|	СправкиСПАРКРиски.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Справка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Результат.Сообщение = НСтр("ru = 'Выбранная справка отсутствует в информационной базе или
			|недостаточно прав для просмотра.'");
		Возврат Результат;
	КонецЕсли;
	
	// Вид контрагента может быть не заполнен, если не завершено
	// обновление информационной базы.
	ВидКонтрагента = СПАРКРиски.ОбработатьВидКонтрагента(
		Выборка.ВидКонтрагента);
	
	СостоянияСправки = Перечисления.СостоянияСправкиСПАРКРиски;
	Состояние        = Выборка.Состояние;
	Если Состояние = СостоянияСправки.Получена Тогда
		
		Если Выборка.ФайлСсылка = Неопределено Тогда
			ФайлСсылка = Неопределено;
			ЗагрузитьФайлСправки(
				Справка,
				Выборка.ИдентификаторСправки,
				Выборка.ИНН,
				ВидКонтрагента,
				ФайлСсылка,
				Результат);
			Если ФайлСсылка <> Неопределено Тогда
				Результат.ДанныеФайла = РаботаСФайлами.ДанныеФайла(
					ФайлСсылка,
					ЭтотОбъект.УникальныйИдентификатор);
			КонецЕсли;
		Иначе
			Результат.ДанныеФайла = РаботаСФайлами.ДанныеФайла(
				Выборка.ФайлСсылка,
				ЭтотОбъект.УникальныйИдентификатор);
		КонецЕсли;
		
		Возврат Результат;
		
	ИначеЕсли Состояние = СостоянияСправки.Готовится
		Или Состояние = СостоянияСправки.НеУдалосьПроверитьСостояниеСправки Тогда
		
		СостояниеПередПроверкой = Состояние;
		ПроверитьСостояниеСправки(
			Справка,
			Выборка.ИдентификаторСправки,
			ВидКонтрагента,
			Состояние,
			Результат);
		Если Состояние <> СостояниеПередПроверкой Тогда
			// Если состояние справки изменилось.
			Элементы.Список.Обновить();
		КонецЕсли;
		
		Если Состояние = СостоянияСправки.Получена Тогда
			ФайлСсылка = Неопределено;
			ЗагрузитьФайлСправки(
				Справка,
				Выборка.ИдентификаторСправки,
				Выборка.ИНН,
				ВидКонтрагента,
				ФайлСсылка,
				Результат);
			Если ФайлСсылка <> Неопределено Тогда
				Результат.ДанныеФайла = РаботаСФайлами.ДанныеФайла(
					ФайлСсылка,
					ЭтотОбъект.УникальныйИдентификатор);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Результат.ВидОшибки.Пустая() И Результат.ДанныеФайла = Неопределено Тогда
		
		Если Состояние = СостоянияСправки.Готовится Тогда
			Результат.Сообщение = НСтр("ru = 'На текущий момент подготовка справки не завершена.
				|Повторите попытку позже.'");
		Иначе
			// Справка не получена в связи с ошибкой подготовки справки в сервисе.
			Результат.Сообщение = НСтр("ru = 'Справка не может быть открыта для просмотра
				|в связи с ошибкой подготовки справки в сервисе 1СПАРК Риски.'");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗагрузитьФайлСправки(
		ДокументСсылка,
		ИдентификаторСправки,
		ИНН,
		ВидКонтрагента,
		ФайлСсылка,
		Результат)
	
	Если ВидКонтрагента = Перечисления.ВидыКонтрагентовСПАРКРиски.ЮридическоеЛицо Тогда
		РезультатВызоваОперации = СервисСПАРКРиски.ЗагрузитьФайлСправкиЮридическихЛиц(
			ИдентификаторСправки);
	Иначе
		РезультатВызоваОперации = СервисСПАРКРиски.ЗагрузитьФайлСправкиИндивидуальныхПредпринимателей(
			ИдентификаторСправки);
	КонецЕсли;
	
	Если Не РезультатВызоваОперации.ВидОшибки.Пустая() Тогда
		ПодготовитьОписаниеОшибки(Результат, РезультатВызоваОперации);
		Возврат;
	КонецЕсли;
	
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("Автор"           , Пользователи.АвторизованныйПользователь());
	ПараметрыФайла.Вставить("ВладелецФайлов"  , ДокументСсылка);
	ПараметрыФайла.Вставить("ИмяБезРасширения",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Справка 1СПАРК Риски %1'"),
			ИНН));
	ПараметрыФайла.Вставить("РасширениеБезТочки", "pdf");
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное",
		ТекущаяУниверсальнаяДата());
	
	ФайлСсылка = РаботаСФайлами.ДобавитьФайл(
		ПараметрыФайла,
		ПоместитьВоВременноеХранилище(РезультатВызоваОперации.ФайлСправки));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьСостояниеСправки(
		ДокументСсылка,
		ИдентификаторСправки,
		ВидКонтрагента,
		Состояние,
		Результат)
	
	СостоянияСправки = Перечисления.СостоянияСправкиСПАРКРиски;
	
	Идентификаторы = Новый Массив;
	Идентификаторы.Добавить(ИдентификаторСправки);
	Если ВидКонтрагента = Перечисления.ВидыКонтрагентовСПАРКРиски.ЮридическоеЛицо Тогда
		РезультатВызоваОперации = СервисСПАРКРиски.СостояниеПодготовкиСправокЮридическихЛиц(
			Идентификаторы);
	Иначе
		РезультатВызоваОперации = СервисСПАРКРиски.СостояниеПодготовкиСправокИндивидуальныхПредпринимателей(
			Идентификаторы);
	КонецЕсли;
	
	Если Не РезультатВызоваОперации.ВидОшибки.Пустая() Тогда
		ПодготовитьОписаниеОшибки(Результат, РезультатВызоваОперации);
		Возврат;
	КонецЕсли;
	
	СостояниеСправкиВСервисе = РезультатВызоваОперации.СостояниеСправок[ИдентификаторСправки];
	Если СостояниеСправкиВСервисе = Неопределено Тогда
		СостояниеСправкиВСервисе = СостоянияСправки.ОшибкаПодготовки;
	КонецЕсли;
	
	Если СостояниеСправкиВСервисе <> СостоянияСправки.Готовится Тогда
		СПАРКРиски.УстановитьСостояниеСправки(ДокументСсылка, СостояниеСправкиВСервисе);
		СПАРКРиски.ОтменитьЗаданиеПроверкиГотовностиСправкиСПАРКРиски(ИдентификаторСправки);
		Если СостояниеСправкиВСервисе <> Перечисления.СостоянияСправкиСПАРКРиски.Получена Тогда
			СПАРКРиски.ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при подготовке справки с идентификатором %1.
						|%2'"),
					ИдентификаторСправки,
					Состояние));
		КонецЕсли;
	ИначеЕсли Состояние = СостоянияСправки.НеУдалосьПроверитьСостояниеСправки Тогда
		// Если при проверке в регламентном задании произошла ошибка
		// и регламентное задание было удалено и справка еще находится
		// в состоянии подготовки, тогда установить состояние справки "Готовится"
		// и добавить новое регламентное задание для автоматической проверки состояния.
		СПАРКРиски.УстановитьСостояниеСправки(ДокументСсылка, СостояниеСправкиВСервисе);
		ДобавитьЗаданиеПроверкиСостоянияГотовностиСправки(ДокументСсылка, ИдентификаторСправки);
	КонецЕсли;
	
	Состояние = СостояниеСправкиВСервисе;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПодготовитьОписаниеОшибки(Результат, РезультатВызоваОперации)
	
	Результат.ВидОшибки = РезультатВызоваОперации.ВидОшибки;
	Если РезультатВызоваОперации.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ОшибкаПодключения Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
			Результат.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось подключиться к сервису 1СПАРК Риски.
					|%1
					|
					|Обратитесь к администратору.'"),
				РезультатВызоваОперации.СообщениеОбОшибке);
		Иначе
			Результат.СообщениеОбОшибке  = РезультатВызоваОперации.СообщениеОбОшибке;
			Результат.ИнформацияОбОшибке = РезультатВызоваОперации.ИнформацияОбОшибке;
		КонецЕсли;
		
	ИначеЕсли РезультатВызоваОперации.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ИнтернетПоддержкаНеПодключена
		И Не ИнтернетПоддержкаПользователей.ДоступноПодключениеИнтернетПоддержки() Тогда
		
		Результат.Сообщение = НСтр("ru = 'Для работы с сервисом 1СПАРК Риски необходимо подключить Интернет-поддержку пользователей.
			|Обратитесь к администратору.'");
		
	ИначеЕсли РезультатВызоваОперации.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит Тогда
		
		Результат.СообщениеОбОшибке = ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '<body><b>Получение справок 1СПАРК Риски недоступно </b>
					|<br/>
					|<br/>Недостаточно лимита справок для выполнения операции.
					|Для пополнения лимита необходимо <a href=""%1"">приобрести тариф</a>,
					|который включает в себя возможность получения справок.'"),
				СПАРКРискиКлиентСервер.АдресСтраницыТарифовСервисаНаПортале1С()));
		
	ИначеЕсли РезультатВызоваОперации.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ОшибкаАутентификации Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
			Результат.СообщениеОбОшибке = НСтр("ru = 'Ошибка аутентификации в сервисе 1СПАРК Риски.'");
		Иначе
			Результат.СообщениеОбОшибке =
				НСтр("ru = 'Ошибка аутентификации в сервисе 1СПАРК Риски.
					|Обратитесь к администратору.'");
		КонецЕсли;
		
	Иначе
		
		Результат.СообщениеОбОшибке = РезультатВызоваОперации.СообщениеОбОшибке;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресСтраницыЛичныйКабинетВсеСправки()
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Документы.СправкиСПАРКРиски) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав.'");
	КонецЕсли;
	
	Результат = СПАРКРиски.АдресСтраницыЛичныйКабинетВсеСправки();
	Тикет = "";
	Если ОбщегоНазначения.РазделениеВключено() Или Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		РезультатПолученияТикета = ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки(Результат);
		УстановитьПривилегированныйРежим(Ложь);
		Тикет = РезультатПолученияТикета.Тикет;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Тикет) Тогда
		Результат = ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
			"/ticket/auth?token=" + Тикет,
			ИнтернетПоддержкаПользователей.НастройкиСоединенияССерверами());
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПодключитьТестовыйПериодЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен") Тогда
		ЗапроситьНовуюСправку();
	ИначеЕсли Результат = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно")
		И ЗначениеЗаполнено(ДополнительныеПараметры.СообщениеОбОшибке) Тогда
		ПоказатьПредупреждение(, ДополнительныеПараметры.СообщениеОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
