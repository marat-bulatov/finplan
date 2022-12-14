
#Область СлужебныеПроцедурыИФункции
Функция ПолучитьДанныеУправленческогоУчетаПоКатегории(КатегорияОперации, Заявка = Неопределено)
	
	МассивДанных = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(КатегорияОперации) Тогда
		Возврат МассивДанных;
	КонецЕсли;
	
	Для Каждого СтрокаПараметров Из КатегорияОперации.Параметры Цикл
		
		Если СтрокаПараметров.Имя = "КоррСчет"
			ИЛИ СтрокаПараметров.Внутренний Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураДанных = Новый Структура;
		
		Для Каждого Реквизит Из Метаданные.Справочники.КатегорииОпераций.ТабличныеЧасти.Параметры.Реквизиты Цикл
			
			СтруктураДанных.Вставить(Реквизит.Имя, СтрокаПараметров[Реквизит.Имя]);
			
		КонецЦикла;
		
		МассивДанных.Добавить(СтруктураДанных);
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции

Функция ЗаполнитьДанныеУправленческогоУчетаТипамиПВХ(МассивДанных)
	
	Для Каждого ЭлементДанных Из МассивДанных Цикл
		
		Если ЗначениеЗаполнено(СокрЛП(ЭлементДанных.Тип)) Тогда
			
			ВидПараметра = ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.НайтиПоРеквизиту("ТипСтрокой", ЭлементДанных.Тип);
			
			Если ВидПараметра <> ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ПустаяСсылка() Тогда
				ЭлементДанных.Вставить("ВидПараметра", ВидПараметра);
			КонецЕсли;
			
		ИначеЕсли ЭлементДанных.Имя	= "ТипКредКарты" Тогда
			
			ЭлементДанных.Вставить("ВидПараметра", ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ТипСубконтоТипКарты);
			ЭлементДанных.Вставить("Значение", Справочники.ЗначенияСубконтоУправленческогоУчета.НайтиПоКоду("Visa"));
			
		ИначеЕсли ЭлементДанных.Имя	= "Счет_ОтвЛ" Тогда
			
			ЭлементДанных.Вставить("ВидПараметра", ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ТипСправочникБанковскиеСчета);
			//ЭлементДанных.Вставить("Значение", Справочники.ЗначенияСубконтоУправленческогоУчета.НайтиПоКоду("Visa"));
			
		ИначеЕсли ЭлементДанных.Имя	= "Контрагент" Тогда			
			ЭлементДанных.Вставить("ВидПараметра", ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ТипСправочникКонтрагенты);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПодготовитьДанныеУправленческогоУчета(КатегорияОперации) Экспорт
	
	Возврат ЗаполнитьДанныеУправленческогоУчетаТипамиПВХ(ПолучитьДанныеУправленческогоУчетаПоКатегории(КатегорияОперации));
	
КонецФункции

//Функция ДанныеТаблицыПоВнешнимДанным(КатегорияОперации, Данные) Экспорт
//	
//	ИменаКолонок = "Имя, Значение, ТипРеквизита, ЗапретРедактирования, Необязательный, ВидПараметра, Формула";
//	МассивДанных = Новый Массив;
//	
//	// Заполняем из Категории
//	Для Каждого СтрокаПараметры Из ПодготовитьДанныеУправленческогоУчета(КатегорияОперации) Цикл
//		
//		СтруктураТаблицы = Новый Структура(ИменаКолонок);
//		ЗаполнитьЗначенияСвойств(СтруктураТаблицы, СтрокаПараметры);
//		МассивДанных.Добавить(СтруктураТаблицы);
//		
//	КонецЦикла;
//	
//	Для Каждого СтруктураДанных Из МассивДанных Цикл
//		
//		Если СтруктураДанных.ВидПараметра = ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ТипСправочникЦФУ Тогда
//			СтруктураДанных.Значение = Справочники.ЦФУ.НайтиПоКоду(СокрЛП(Данные.codeCFU));
//			
//		ИначеЕсли СтруктураДанных.ВидПараметра = ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ТипСправочникБрэнды Тогда
//			СтруктураДанных.Значение = Справочники.Брэнды.НайтиПоКоду(СокрЛП(Данные.codeBrand));
//			
//		КонецЕсли;
//		
//		Для т = 0 по 8 Цикл
//			
//			Параметр = Данные["Параметр" + т];
//			Если Параметр = СтруктураДанных.Имя Тогда
//				
//				ФорматПараметра = Данные["ФорматПараметра" + т];
//				ЗначениеПараметра = Данные["s_sub" + (т + 1)];
//				СтруктураДанных = СтруктураДанных;
//				
//				Если СтруктураДанных.ВидПараметра = ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ТипСправочникЦФУ
//					ИЛИ СтруктураДанных.ВидПараметра = ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ТипСправочникБрэнды Тогда
//					
//					Продолжить;
//					
//				ИначеЕсли СтруктураДанных.ВидПараметра = ПланыВидовХарактеристик.РеквизитыУправленческогоУчета.ТипСправочникКонтрагенты Тогда
//					СтруктураДанных.Значение = Справочники.Контрагенты.НайтиПоКоду(ЗначениеПараметра);
//					
//				ИначеЕсли СтруктураДанных.ВидПараметра.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ЗначенияСубконтоУправленческогоУчета") Тогда
//					СтруктураДанных.Значение = Справочники.ЗначенияСубконтоУправленческогоУчета.НайтиПоКоду(ЗначениеПараметра,,, СтруктураДанных.ВидПараметра);
//					
//				КонецЕсли;
//				
//			КонецЕсли;
//			
//		КонецЦикла;
//		
//	КонецЦикла;
//	
//	
//КонецФункции

Процедура ОбновитьТаблицуУправленческогоУчета(Объект, СтрокиОбработки) Экспорт
	
	Для Каждого СтрокаТаблицыУправленческогоУчета Из СтрокиОбработки Цикл
		
		СтрокаТаблицыВыписки = Объект.ДанныеВыписки.НайтиСтроки(Новый Структура("GUIDСтрокиВыписки", СтрокаТаблицыУправленческогоУчета.GUIDСтрокиВыписки))[0];
		
		Если СтрокаТаблицыУправленческогоУчета.Имя = "ВалютнаяСумма" Тогда
			СтрокаТаблицыУправленческогоУчета.Значение = СтрокаТаблицыВыписки.ВалютнаяСумма;
			
		ИначеЕсли СтрокаТаблицыУправленческогоУчета.Имя = "Сумма" Тогда
			СтрокаТаблицыУправленческогоУчета.Значение = Max(СтрокаТаблицыВыписки.СуммаПриход - СтрокаТаблицыВыписки.СуммаРасход, -(СтрокаТаблицыВыписки.СуммаПриход - СтрокаТаблицыВыписки.СуммаРасход));
			
		ИначеЕсли СтрокаТаблицыУправленческогоУчета.Имя = "НДС" Тогда
			СтрокаТаблицыУправленческогоУчета.Значение = СтрокаТаблицыВыписки.СуммаНДС;
			
		ИначеЕсли СтрокаТаблицыУправленческогоУчета.Имя = "Контрагент" Тогда
			СтрокаТаблицыУправленческогоУчета.Значение = СтрокаТаблицыВыписки.Контрагент;
			
		ИначеЕсли СтрокаТаблицыУправленческогоУчета.Имя = "Валюта" Тогда
			
			Если Объект.Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
				СтрокаТаблицыУправленческогоУчета.Значение = ПараметрыСеанса.ВалютаРегламентированногоУчета;
			Иначе
				СтрокаТаблицыУправленческогоУчета.Значение = Объект.Валюта;
			КонецЕсли;
			
		КонецЕсли;
		
		// Попробуем применить формулу
		Формула = ВРЕГ(СтрокаТаблицыУправленческогоУчета.Формула);
		
		Если СтрокаТаблицыУправленческогоУчета.Имя = "ТипКредКарты" Тогда
			Формула = "";
		КонецЕсли;
		
		Формула = СтрЗаменить(Формула, "ТАБЛИЦА.КОНТРАГЕНТ", "ТАБЛИЦА.КОНТРАГЕНТ");
		Формула = СтрЗаменить(Формула, "ТАБЛИЦА.СЧЕТКОНТРАГЕНТА", "ТАБЛИЦА.СЧЕТКОНТРАГЕНТА");
		
		Если Формула = "СЧЕТ" Тогда
			Формула = СтрЗаменить(Формула, "СЧЕТ", "ОБЪЕКТ.СЧЕТОРГАНИЗАЦИИ");
		КонецЕсли;
		
		Формула = СтрЗаменить(Формула, "ТАБЛИЦА.ПРИХОД", "СТРОКАТАБЛИЦЫВЫПИСКИ.СУММАПРИХОД");
		Формула = СтрЗаменить(Формула, "ТАБЛИЦА.РАСХОД", "СТРОКАТАБЛИЦЫВЫПИСКИ.СУММАРАСХОД");
		Формула = СтрЗаменить(Формула, "-ОБЪЕКТ.СУММА", "СТРОКАТАБЛИЦЫВЫПИСКИ.ВАЛЮТНАЯСУММА");
			
		Если СокрЛП(Формула) <> "" Тогда
			
			//@skip-check module-unused-local-variable
			Таблица = СтрокаТаблицыВыписки;
			Значение = Неопределено;
			
			//@skip-check empty-except-statement
			Попытка
				УстановитьБезопасныйРежим(Истина);
				Выполнить("Значение = " + Формула);
				УстановитьБезопасныйРежим(Ложь);
				СтрокаТаблицыУправленческогоУчета.Значение = Значение;
			Исключение
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//Процедура ОбновитьДанныеУправленческогоУчета(Форма) Экспорт
//	
//	Объект = Форма.Объект;
//	Объект.УправленческийУчет.Очистить();
//	
//	Для Каждого СтруктураДанных Из ПодготовитьДанныеУправленческогоУчета(Объект.КатегорияОперации) Цикл
//		ЗаполнитьЗначенияСвойств(Объект.УправленческийУчет.Добавить(), СтруктураДанных);
//	КонецЦикла;
//	ОбновитьТаблицуУправленческогоУчета(Объект);
//	
//КонецПроцедуры

//Процедура ОбновитьДанныеУправленческогоУчетаДокумента(ДокументОбъект) Экспорт
//	
//	ДокументОбъект.УправленческийУчет.Очистить();
//	
//	Для Каждого СтруктураДанных Из УправленческийУчетСервер.ПодготовитьДанныеУправленческогоУчета(ДокументОбъект.КатегорияОперации) Цикл
//		ЗаполнитьЗначенияСвойств(ДокументОбъект.УправленческийУчет.Добавить(), СтруктураДанных);
//	КонецЦикла;
//	УправленческийУчетСервер.ОбновитьТаблицуУправленческогоУчета(ДокументОбъект);
//	
//КонецПроцедуры

#КонецОбласти

