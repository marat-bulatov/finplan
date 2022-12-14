&НаКлиенте
Процедура НастроитьСоставРегистров(Команда)

	АдресСпискаРегистров = ПодготовитьСписокРегистровДляНастройки();
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("АдресСпискаРегистров", АдресСпискаРегистров);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("НастроитьСоставРегистровЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.Операция.Форма.ФормаНастройки", СтруктураПараметров, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры



&НаКлиенте
Процедура ПереключитьАктивностьДвижений(Команда)

	Если Объект.ПометкаУдаления Тогда
		ПоказатьПредупреждение( , 
			НСтр("ru = 'Операция помечена на удаление, поэтому переключить активность нельзя.
        	|Снимите пометку удаления.'"));
		Возврат;
	КонецЕсли;
	
	ПереключитьАктивностьДвиженийНаСервере();

КонецПроцедуры

&НаСервере
Функция ПодготовитьСписокРегистровДляНастройки()

	// Актуализируем информацию о наличии движений
	Для каждого СтрокаРегистра Из Регистры Цикл
		Если СтрокаРегистра.ЕстьРеквизит Тогда 
			СтрокаРегистра.ЕстьДвижения = ЭтотОбъект[СтрокаРегистра.Имя + "НаборЗаписей"].Количество() > 0;
		КонецЕсли;
	КонецЦикла;
	
	// Поместим таблицу Регистры во временное хранилище
	Возврат ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("Регистры"), УникальныйИдентификатор);

КонецФункции

&НаСервере
Процедура ПереключитьАктивностьДвиженийНаСервере()
	
	НоваяАктивность = НЕ АктивностьДвижений;
	
	Для каждого СтрокаРегистра Из Регистры Цикл
		Если НЕ СтрокаРегистра.ЕстьРеквизит Тогда
			Продолжить;
		КонецЕсли;
		ПутьКДаннымТаблицы = СтрокаРегистра.Имя + "НаборЗаписей";
		
		НаборЗаписей = РеквизитФормыВЗначение(ПутьКДаннымТаблицы);
		НаборЗаписей.УстановитьАктивность(НоваяАктивность);
		ЗначениеВРеквизитФормы(НаборЗаписей, ПутьКДаннымТаблицы);
		
		ТекГруппа = Элементы["Группа" + СтрокаРегистра.Имя];
		Если СтрокаРегистра.ТипРегистра = "РегистрБухгалтерии" Тогда
			ТекГруппа.Картинка = ?(НоваяАктивность, 
				БиблиотекаКартинок.ЖурналПроводок, БиблиотекаКартинок.ЖурналПроводокНеактивный);
		ИначеЕсли СтрокаРегистра.ТипРегистра = "РегистрНакопления" Тогда
			ТекГруппа.Картинка = ?(НоваяАктивность, 
				БиблиотекаКартинок.РегистрНакопления, БиблиотекаКартинок.РегистрНакопленияНеактивный);
		ИначеЕсли СтрокаРегистра.ТипРегистра = "РегистрСведений" Тогда
			ТекГруппа.Картинка = ?(НоваяАктивность, 
				БиблиотекаКартинок.РегистрСведений, БиблиотекаКартинок.РегистрСведенийНеактивный);
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ФормаПереключитьАктивностьДвижений.Заголовок = ?(НоваяАктивность, 
		НСтр("ru='Выключить активность движений'"), НСтр("ru='Включить активность движений'"));
	
	АктивностьДвижений = НоваяАктивность;
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента(СтрокаУказаниеСтатуса = Неопределено)
	
	Если СтрокаУказаниеСтатуса = "НезаписанныйДокумент" Тогда
		СостояниеДокумента = 0;	
	ИначеЕсли Объект.ПометкаУдаления Тогда
		СостояниеДокумента = 2;
	ИначеЕсли НЕ АктивностьДвижений Тогда
		СостояниеДокумента = 11;
	Иначе
		СостояниеДокумента = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСоставРегистровЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	РезультатДействийПользователя = РезультатЗакрытия;
	
	// Обработаем результат действий пользователя
	Если ТипЗнч(РезультатДействийПользователя) = Тип("СписокЗначений")
	   И РезультатДействийПользователя.Количество() <> 0 Тогда
	   
		Модифицированность = Истина;
		ПрименитьНастройкуСоставаРегистров(РезультатДействийПользователя);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкуСоставаРегистров(РезультатДействийПользователя)
	
	Для каждого ИзмененныйРегистр Из РезультатДействийПользователя Цикл
		
		ИмяРегистра = ИзмененныйРегистр.Значение;
		
		РезультатПоиска = Регистры.НайтиСтроки(Новый Структура("Имя", ИмяРегистра));
		Если РезультатПоиска.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		СтрокаРегистра = РезультатПоиска[0];
		
		СтрокаРегистра.Отображение = ИзмененныйРегистр.Пометка;
		
		Если НЕ СтрокаРегистра.Отображение Тогда
			Если СтрокаРегистра.ЕстьРеквизит Тогда
				ЭтотОбъект[ИмяРегистра + "НаборЗаписей"].Очистить();
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаРегистра.ТипРегистра = "РегистрНакопления" Тогда
			ОбновляемаяТаблица = Объект.ТаблицаРегистровНакопления;
		Иначе
			ОбновляемаяТаблица = Объект.ТаблицаРегистровСведений;
		КонецЕсли;
		
		СтрокиТаблицы = ОбновляемаяТаблица.НайтиСтроки(Новый Структура("Имя", ИмяРегистра));
		
		ЕстьВТаблице = СтрокиТаблицы.Количество() > 0;
		
		Если СтрокаРегистра.Отображение И НЕ ЕстьВТаблице Тогда
			НоваяСтрока     = ОбновляемаяТаблица.Добавить();
			НоваяСтрока.Имя = ИмяРегистра;
		ИначеЕсли НЕ СтрокаРегистра.Отображение И ЕстьВТаблице Тогда
			Для каждого СтрокаТаблицы Из СтрокиТаблицы Цикл
				ОбновляемаяТаблица.Удалить(СтрокаТаблицы);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
		
	СоздатьРеквизитыФормы();
	СоздатьЭлементыФормы();

КонецПроцедуры

Процедура СоздатьРеквизитыФормы()
	
	ИменаРеквизитов = Новый Массив;
	Для каждого Реквизит Из ПолучитьРеквизиты() Цикл
		ИменаРеквизитов.Добавить(Реквизит.Имя);
	КонецЦикла;
	ДобавляемыеРеквизиты = Новый Массив;
	УдаляемыеРеквизиты   = Новый Массив;
	
	Для каждого СтрокаРегистра Из Регистры Цикл

		ИмяРеквизита = СтрокаРегистра.Имя + "НаборЗаписей";
		Если (СтрокаРегистра.Отображение ИЛИ СтрокаРегистра.Записывать)
			И ИменаРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
			ТипРеквизита  = Новый ОписаниеТипов(СтрокаРегистра.ТипРегистра + "НаборЗаписей." + СтрокаРегистра.Имя);
			НовыйРеквизит = Новый РеквизитФормы(ИмяРеквизита, ТипРеквизита, , , Истина);
			ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		ИначеЕсли НЕ (СтрокаРегистра.Отображение ИЛИ СтрокаРегистра.Записывать)
			И ИменаРеквизитов.Найти(ИмяРеквизита) <> Неопределено Тогда
			УдаляемыеРеквизиты.Добавить(ИмяРеквизита);
		КонецЕсли;
		СтрокаРегистра.ЕстьРеквизит = СтрокаРегистра.Отображение ИЛИ СтрокаРегистра.Записывать;
	КонецЦикла;
	
	Если ДобавляемыеРеквизиты.Количество() > 0 
		ИЛИ УдаляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(ДобавляемыеРеквизиты, УдаляемыеРеквизиты);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СоздатьЭлементыФормы()
	
	Элементы.ФормаПереключитьАктивностьДвижений.Заголовок = ?(АктивностьДвижений, 
		НСтр("ru='Выключить активность движений'"), НСтр("ru='Включить активность движений'"));
	
	Для каждого СтрокаРегистра Из Регистры Цикл
	
		ИмяГруппы = "Группа" + СтрокаРегистра.Имя;
		
		ТекГруппа = Элементы.Найти(ИмяГруппы);
		Если ТекГруппа = Неопределено 
			И СтрокаРегистра.Отображение Тогда

			//Найдем группу, перед которой будем вставлять новую группу
			СледующаяГруппа = Неопределено;
			Для каждого Строка Из Регистры Цикл
				Если Строка.ТипРегистра >= СтрокаРегистра.ТипРегистра
					И Строка.Синоним > СтрокаРегистра.Синоним
					И Строка.Отрисован Тогда
					СледующаяГруппа = Элементы["Группа" + Строка.Имя];
					Прервать;
				КонецЕсли;
			КонецЦикла;

			ТекГруппа = Элементы.Вставить(ИмяГруппы, Тип("ГруппаФормы"), Элементы.ПанельРегистров, СледующаяГруппа);
			
			ТекГруппа.Заголовок      = СтрокаРегистра.Синоним;
			СтрокаРегистра.Отрисован = Истина;

			// На странице регистра создаем таблицу
			ИмяТаблицы = СтрокаРегистра.Имя;
			ТекТаблица = Элементы.Найти(ИмяТаблицы);
			Если ТекТаблица <> Неопределено Тогда
				Элементы.Удалить(ТекТаблица);
			КонецЕсли;
			ТекТаблица = Элементы.Добавить(ИмяТаблицы, Тип("ТаблицаФормы"), ТекГруппа);
			ПутьКДаннымТаблицы = СтрокаРегистра.Имя + "НаборЗаписей";
			ТекТаблица.ПутьКДанным = ПутьКДаннымТаблицы;
			ТекГруппа.ПутьКДаннымЗаголовка = ПутьКДаннымТаблицы + ".КоличествоСтрок";
			// Назначаем общий обработчик
			ТекТаблица.УстановитьДействие("ПриНачалеРедактирования", "Подключаемый_ТаблицаРегистраПриНачалеРедактирования");
			
			Если СтрокаРегистра.ТипРегистра = "РегистрБухгалтерии" Тогда
				ТекГруппа.Картинка = ?(АктивностьДвижений, 
					БиблиотекаКартинок.ЖурналПроводок, БиблиотекаКартинок.ЖурналПроводокНеактивный);
			ИначеЕсли СтрокаРегистра.ТипРегистра = "РегистрНакопления" Тогда
				ТекГруппа.Картинка = ?(АктивностьДвижений, 
					БиблиотекаКартинок.РегистрНакопления, БиблиотекаКартинок.РегистрНакопленияНеактивный);
			ИначеЕсли СтрокаРегистра.ТипРегистра = "РегистрСведений" Тогда
				ТекГруппа.Картинка = ?(АктивностьДвижений, 
					БиблиотекаКартинок.РегистрСведений, БиблиотекаКартинок.РегистрСведенийНеактивный);
			КонецЕсли;

			РеквизитыНабораЗаписей = ЭтотОбъект[ПутьКДаннымТаблицы].Выгрузить(Новый Массив);

			// Некоторые колонки не показываем
			РеквизитыНабораЗаписей.Колонки.Удалить("Регистратор");
			РеквизитыНабораЗаписей.Колонки.Удалить("Активность");

			Если РеквизитыНабораЗаписей.Колонки.Найти("МоментВремени") <> Неопределено Тогда
				РеквизитыНабораЗаписей.Колонки.Удалить("МоментВремени");
			КонецЕсли;

			Если РеквизитыНабораЗаписей.Колонки.Найти("Период") <> Неопределено Тогда
				РеквизитыНабораЗаписей.Колонки.Удалить("Период");
			КонецЕсли;

			Если РеквизитыНабораЗаписей.Колонки.Найти("Организация") <> Неопределено Тогда
				РеквизитыНабораЗаписей.Колонки.Удалить("Организация");
			КонецЕсли;

			Если РеквизитыНабораЗаписей.Колонки.Найти("ИсходныйНомерСтроки") <> Неопределено Тогда
				РеквизитыНабораЗаписей.Колонки.Удалить("ИсходныйНомерСтроки");
			КонецЕсли;
			
			// Создаем колонки таблицы
			Для каждого КолонкаРеквизита Из РеквизитыНабораЗаписей.Колонки Цикл
				ИмяКолонки = СтрокаРегистра.Имя + КолонкаРеквизита.Имя;
				ТекКолонка = Элементы.Найти(ИмяКолонки);
				Если ТекКолонка = Неопределено Тогда
					ТекКолонка = Элементы.Добавить(ИмяКолонки, Тип("ПолеФормы"), ТекТаблица);
				КонецЕсли;
				ТекКолонка.ПутьКДанным = ТекТаблица.ПутьКДанным + "." + КолонкаРеквизита.Имя;
				ТекКолонка.Заголовок   = КолонкаРеквизита.Заголовок;
				ТекКолонка.Вид = ВидПоляФормы.ПолеВвода;
				Если КолонкаРеквизита.Имя = "НомерСтроки" Тогда
					ТекКолонка.Ширина = 2;
				ИначеЕсли КолонкаРеквизита.Имя = "ВидДвижения" Тогда
					ТекКолонка.Ширина = 15;
				КонецЕсли;
				
				Если СтрокаРегистра.Имя = "НДСРаздельныйУчет"
					И КолонкаРеквизита.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.СпособыУчетаНДС") Тогда
					
					НовыйПараметр = Новый ПараметрВыбора("ОграничениеСпискаВыбора", "НеОграничивать");
					НовыйМассив = Новый Массив();
					НовыйМассив.Добавить(НовыйПараметр);
					НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив); 
					ТекКолонка.ПараметрыВыбора = НовыеПараметры;
					
				КонецЕсли; 
				
			КонецЦикла;

			УстановитьСвязиПараметровВыбораКолонокСпискаРегистра(СтрокаРегистра.Имя);
			
		ИначеЕсли ТекГруппа <> Неопределено И НЕ СтрокаРегистра.Отображение Тогда
			
			Элементы.Удалить(ТекГруппа);
			СтрокаРегистра.Отрисован = Ложь;
			
		ИначеЕсли ТекГруппа <> Неопределено И СтрокаРегистра.Отображение Тогда
			
			Если СтрокаРегистра.ТипРегистра = "РегистрБухгалтерии" Тогда
				ТекГруппа.Картинка = ?(АктивностьДвижений, 
					БиблиотекаКартинок.ЖурналПроводок, БиблиотекаКартинок.ЖурналПроводокНеактивный);
			ИначеЕсли СтрокаРегистра.ТипРегистра = "РегистрНакопления" Тогда
				ТекГруппа.Картинка = ?(АктивностьДвижений, 
					БиблиотекаКартинок.РегистрНакопления, БиблиотекаКартинок.РегистрНакопленияНеактивный);
			ИначеЕсли СтрокаРегистра.ТипРегистра = "РегистрСведений" Тогда
				ТекГруппа.Картинка = ?(АктивностьДвижений, 
					БиблиотекаКартинок.РегистрСведений, БиблиотекаКартинок.РегистрСведенийНеактивный);
			КонецЕсли;
			
		КонецЕсли;

	КонецЦикла;

	//Если отображается не более одного регистра - прячем заголовок у панели регистров
	Если Регистры.НайтиСтроки(Новый Структура("Отображение", Истина)).Количество() <= 1 И НЕ Объект.СпособЗаполнения = "ТиповаяОперация" Тогда
		Элементы.ПанельРегистров.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Иначе
		Элементы.ПанельРегистров.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСвязиПараметровВыбораКолонокСпискаРегистра(ИмяРегистра)
	
	ЭлементКонтрагент         = Элементы.Найти(ИмяРегистра + "Контрагент");
	ЭлементДоговорКонтрагента = Элементы.Найти(ИмяРегистра + "ДоговорКонтрагента");
	ЭлементПатент             = Элементы.Найти(ИмяРегистра + "Патент");
	
	Если ЭлементДоговорКонтрагента <> Неопределено Тогда
		СвязиПараметровДоговор = Новый Массив;
		СвязиПараметровДоговор.Добавить(Новый СвязьПараметраВыбора("Отбор.Организация", "Объект.Организация"));		
		Если ЭлементКонтрагент <> Неопределено Тогда			
			СвязиПараметровДоговор.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Элементы."+ИмяРегистра+".ТекущиеДанные.Контрагент"));
		КонецЕсли; 
		ЭлементДоговорКонтрагента.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровДоговор);
	КонецЕсли; 

	Если ЭлементПатент <> Неопределено Тогда
		СвязиПараметровПатент = Новый Массив;
		СвязиПараметровПатент.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Объект.Организация"));
		ЭлементПатент.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровПатент);
	КонецЕсли; 
	
КонецПроцедуры // УстановитьСвязиПараметровВыбораКолонокСпискаРегистра()

&НаСервере
Процедура ЗаполнитьТаблицуРегистров(МетаданныеДокумента)

	Регистры.Очистить();
	Для каждого МетаданныеРегистра Из МетаданныеДокумента.Движения Цикл
		
		Если Не ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(МетаданныеРегистра) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаРегистра     = Регистры.Добавить();
		СтрокаРегистра.Имя = МетаданныеРегистра.Имя;
		
		ПолноеИмя    = МетаданныеРегистра.ПолноеИмя();
		ПозицияТочки = Найти(ПолноеИмя, ".");
		ТипРегистра  = Лев(ПолноеИмя, ПозицияТочки - 1);

		СтрокаРегистра.ТипРегистра = ТипРегистра;
		СтрокаРегистра.Синоним     = МетаданныеРегистра.Синоним;
		
	КонецЦикла;
	
	// Сначала показывается регистр бухгалтерии, затем регистры накопления, затем - сведений
	Регистры.Сортировать("ТипРегистра, Синоним");

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьСостояниеДокумента("НезаписанныйДокумент");
		ПодготовитьФормуНаСервере(Параметры.ЗначениеКопирования);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере(ДокументДвижений)

	ТекущаяДатаДокумента = Объект.Дата;
	ТекущаяОрганизация = Объект.Организация;

	МетаданныеОперации = Объект.Ссылка.Метаданные();
	ЗаполнитьТаблицуРегистров(МетаданныеОперации);
	Если ЗначениеЗаполнено(ДокументДвижений) Тогда
		УстановитьПривилегированныйРежим(Истина);
		РегистрыСДвижениями = ПолучитьМассивИспользуемыхРегистров(
			ДокументДвижений, ДокументДвижений.Метаданные().Движения);
		УстановитьПривилегированныйРежим(Ложь);
	Иначе
		РегистрыСДвижениями = Новый Массив;
	КонецЕсли;
	
	УстановитьОтображениеВТаблицеРегистров(РегистрыСДвижениями);
	СоздатьРеквизитыФормы();
	ПрочитатьДвиженияДокумента(ДокументДвижений);
	СоздатьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере(ТекущийОбъект.Ссылка);
	УстановитьСостояниеДокумента();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Для каждого СтрокаРегистра Из Регистры Цикл
		Если СтрокаРегистра.ЕстьРеквизит Тогда
			НаборЗаписей = РеквизитФормыВЗначение(СтрокаРегистра.Имя + "НаборЗаписей");
			ТаблицаДвижений = НаборЗаписей.Выгрузить();
			ТекущийОбъект.Движения[СтрокаРегистра.Имя].Загрузить(ТаблицаДвижений);
			СтрокаРегистра.Записывать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Функция формирует массив имен регистров, по которым документ имеет движения.
// Вызывается при подготовке записей к регистрации движений.
//
// Параметры:
//  Регистратор  - ДокументСсылка - документ, движения которого анализируются.
//  Движения     - КоллекцияЗначенийСвойстваОбъектаМетаданных - список регистров, для которых документ-регистратор.
//  ИсключаемыеРегистры - Структура, Массив - список имен регистров, которые не требуется проверять.
//
// Возвращаемое значение:
//   Массив      - список имен регистров, имеющих хотя бы одно движение.
//
Функция ПолучитьМассивИспользуемыхРегистров(Регистратор, Движения, ИсключаемыеРегистры = Неопределено) Экспорт

	Если ЗначениеЗаполнено(ИсключаемыеРегистры)
	   И ТипЗнч(ИсключаемыеРегистры) <> Тип("Структура") Тогда
	   
		ИсключаемыеРегистрыСтруктура = Новый Структура;
		Для каждого ИмяРегистра Из ИсключаемыеРегистры Цикл
			ИсключаемыеРегистрыСтруктура.Вставить(ИмяРегистра);
		КонецЦикла;

	Иначе
		
		ИсключаемыеРегистрыСтруктура = ИсключаемыеРегистры;
		
	КонецЕсли;
	
	РегистрыТребующиеОчистки = НовыеРегистрыТребующиеОчистки();
	РегистрыТребующиеОчистки.Регистратор = Регистратор;
	РегистрыТребующиеОчистки.ПроверяемыеРегистры = ИменаПроверяемыхРегистров(Движения, , ИсключаемыеРегистрыСтруктура);
	
	ПроверитьНаличиеДвижений(РегистрыТребующиеОчистки);
	
	Результат = РегистрыТребующиеОчистки.ПроверяемыеРегистры.ВыгрузитьКолонку("ИмяРегистра");
	
	Возврат Результат;

КонецФункции

// Анализирует наличие движений по регистрам. Удаляет регистры без движений из списка в РегистрыТребующиеОчистки.
//
// Параметры:
//  РегистрыТребующиеОчистки - см. НовыеРегистрыТребующиеОчистки().
//
Процедура ПроверитьНаличиеДвижений(РегистрыТребующиеОчистки)
	
	// Отсюда будем удалять пустые регистры.
	ИменаПроверяемыхРегистров = РегистрыТребующиеОчистки.ПроверяемыеРегистры;
	Если ИменаПроверяемыхРегистров.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	// Сюда будем переносить найденные пустые регистры.
	РегистрыНеТребующиеОчистки = Новый Структура;
	
	Запрос = Новый Запрос;
	Если ЗначениеЗаполнено(РегистрыТребующиеОчистки.Регистратор) Тогда
		
		ВариантОтбора = "Документ";
		
		Запрос.УстановитьПараметр("Регистратор", РегистрыТребующиеОчистки.Регистратор);
		
	Иначе
		
		ВариантОтбора = ?(ПустаяСтрока(РегистрыТребующиеОчистки.ИмяДокумента), "Организация", "Тип");
		
		Запрос.УстановитьПараметр("Организация",   РегистрыТребующиеОчистки.Организация);
		Запрос.УстановитьПараметр("ДатаНачала",    РегистрыТребующиеОчистки.ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", РегистрыТребующиеОчистки.ДатаОкончания);
		
	КонецЕсли;
	
	ШаблонПроверяющегоЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	""Хозрасчетный"" КАК ИмяРегистра
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	&ОтборПоРегистру";
	
	// Порциями делаем запросы к информационной базе за период.
	МаксимумПодзапросовВПорции = 50;
	ИменаРегистровТекущейПорции = Новый Массив;
	ОстатокПроверок = МаксимумПодзапросовВПорции + 1; // инициализируем значение для входа в алгоритм
	ТекстПроверяющегоЗапроса = "";
	Для каждого ПроверяемыйРегистр Из ИменаПроверяемыхРегистров Цикл
		
		ОстатокПроверок = ОстатокПроверок - 1;
		Если ОстатокПроверок = 0 Тогда
			
			Если Не ПустаяСтрока(ТекстПроверяющегоЗапроса) Тогда
				// Выполняем проверку, используя собранный запрос.
				Запрос.Текст = ТекстПроверяющегоЗапроса;
				РегистрыСДвижениями = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРегистра");
				РегистрыБезДвижений = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ИменаРегистровТекущейПорции, РегистрыСДвижениями);
				Для каждого ИмяРегистра Из РегистрыБезДвижений Цикл
					РегистрыНеТребующиеОчистки.Вставить(ИмяРегистра);
				КонецЦикла;
				
				ТекстПроверяющегоЗапроса = "";
				ИменаРегистровТекущейПорции.Очистить();
				
			КонецЕсли;
			
			// Инициализируем значением, которое, с одной стороны, скорее всего превышает количество регистров, где данный
			// документ является регистратором, с другой стороны, позволяет при необходимости большой список регистров
			// анализировать порциями.
			ОстатокПроверок = МаксимумПодзапросовВПорции;
			
		КонецЕсли;
		
		ИменаРегистровТекущейПорции.Добавить(ПроверяемыйРегистр.ИмяРегистра);
		
		ТекстПодзапроса = ШаблонПроверяющегоЗапроса;
		Если ОстатокПроверок < МаксимумПодзапросовВПорции Тогда // убираем имя поля из всех подзапросов кроме первого
			ТекстПодзапроса = СтрЗаменить(ТекстПодзапроса, " КАК ИмяРегистра", "");
		КонецЕсли;
		Если ВариантОтбора = "Документ" Тогда // конкретный документ
			
			ОтборПоРегистру = "Хозрасчетный.Регистратор = &Регистратор";
			
		Иначе // за период по организации
			
			ОтборПоРегистру = "";
			
			Если ПроверяемыйРегистр.ЕстьПериод Тогда
				
				ОтборПоРегистру = "Хозрасчетный.Период МЕЖДУ &ДатаНачала И &ДатаОкончания";
				
			КонецЕсли;
			
			Если ВариантОтбора = "Тип" Тогда
				
				Если Не ПустаяСтрока(ОтборПоРегистру) Тогда
					ОтборПоРегистру = ОтборПоРегистру + Символы.ПС + Символы.Таб + "И ";
				КонецЕсли;
				ОтборПоРегистру = ОтборПоРегистру + "Хозрасчетный.Регистратор ССЫЛКА Документ."
					+ РегистрыТребующиеОчистки.ИмяДокумента;
				
			КонецЕсли;
			
			Если ПроверяемыйРегистр.ЕстьОрганизация Тогда
				
				Если Не ПустаяСтрока(ОтборПоРегистру) Тогда
					ОтборПоРегистру = ОтборПоРегистру + Символы.ПС + Символы.Таб + "И ";
				КонецЕсли;
				ОтборПоРегистру = ОтборПоРегистру + "Хозрасчетный.Организация = &Организация";
				
			КонецЕсли;
			
			Если ПустаяСтрока(ОтборПоРегистру) Тогда
				ОтборПоРегистру = "ИСТИНА";
			КонецЕсли;
				
		КонецЕсли; 
		ТекстПодзапроса = СтрЗаменить(ТекстПодзапроса, "&ОтборПоРегистру", ОтборПоРегистру);
		ТекстПодзапроса = СтрЗаменить(ТекстПодзапроса, "Бухгалтерии", ПроверяемыйРегистр.ВидРегистра);
		ТекстПодзапроса = СтрЗаменить(ТекстПодзапроса, "Хозрасчетный", ПроверяемыйРегистр.ИмяРегистра);
		
		ТекстПроверяющегоЗапроса = ?(ПустаяСтрока(ТекстПроверяющегоЗапроса), "", ТекстПроверяющегоЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|") + ТекстПодзапроса;
	
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстПроверяющегоЗапроса) Тогда
		// Выполняем проверку, используя собранный запрос.
		Запрос.Текст = ТекстПроверяющегоЗапроса;
		РегистрыСДвижениями = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРегистра");
		РегистрыБезДвижений = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ИменаРегистровТекущейПорции, РегистрыСДвижениями);
		Для каждого ИмяРегистра Из РегистрыБезДвижений Цикл
			РегистрыНеТребующиеОчистки.Вставить(ИмяРегистра);
		КонецЦикла;
		
	КонецЕсли;
	
	// Удалим из общего списка те регистры, чья пустота подтверждена.
	УдалитьНепроверяемыеРегистры(ИменаПроверяемыхРегистров, РегистрыНеТребующиеОчистки);
	
КонецПроцедуры

// Удаляет из списка УменьшаемыйНабор те, чьи имена есть в ВычитаемыйНабор.
//
// Параметры:
//  УменьшаемыйНабор - ТаблицаЗначений - см. НовыеИменаРегистровДляПроверки().
//  ВычитаемыйНабор - Структура - вычитаемый список.
//
Процедура УдалитьНепроверяемыеРегистры(УменьшаемыйНабор, ВычитаемыйНабор)
	
	Если ВычитаемыйНабор.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НомерСтрокиПроверки = 0;
	КоличествоПроверяемыхСтрок = УменьшаемыйНабор.Количество();
	Пока НомерСтрокиПроверки < КоличествоПроверяемыхСтрок Цикл
		Если ВычитаемыйНабор.Свойство(УменьшаемыйНабор[НомерСтрокиПроверки].ИмяРегистра) Тогда
			УменьшаемыйНабор.Удалить(НомерСтрокиПроверки);
			КоличествоПроверяемыхСтрок = КоличествоПроверяемыхСтрок - 1;
		Иначе
			НомерСтрокиПроверки = НомерСтрокиПроверки + 1;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Формирует список имен проверяемых регистров, на основе коллекции метаданных движений документа.
//
// Параметры:
//  Движения     - КоллекцияЗначенийСвойстваОбъектаМетаданных - список регистров, для которых документ-регистратор.
//  ПроверяемыеРегистры - ТаблицаЗначений - какие регистры можно использовать. Если не указано, то можно все.
//                                       См. НовыеИменаРегистровДляПроверки().
//  ИсключаемыеРегистры - Структура - какие регистры нельзя использовать. Если не указано, то можно все.
//
// Возвращаемое значение:
//   ТаблицаЗначений - см. НовыеИменаРегистровДляПроверки().
//
Функция ИменаПроверяемыхРегистров(Движения, ПроверяемыеРегистры = Неопределено, ИсключаемыеРегистры = Неопределено)
	
	ИменаПроверяемыхПоТипу = НовыеИменаРегистровДляПроверки();
	
	Если ПроверяемыеРегистры = Неопределено Тогда // вернуть список имен всех регистров.
		
		Если ИсключаемыеРегистры = Неопределено Тогда
			ИсключаемыеРегистры = Новый Структура;
		КонецЕсли;
		
		НепериодическийРегистр = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;
	    		
		Для каждого ПроверяемыйРегистр Из Движения Цикл
			
			Если ИсключаемыеРегистры.Свойство(ПроверяемыйРегистр.Имя)
			 Или Лев(ПроверяемыйРегистр.Имя, 7) = "Удалить" Тогда
				Продолжить;
			КонецЕсли;
			
			ПризнакГруппыРегистров = ПроверяемыйРегистр.ПолноеИмя();
			ПризнакГруппыРегистров = Лев(ПризнакГруппыРегистров, СтрНайти(ПризнакГруппыРегистров, ".") - 1);
			ПризнакГруппыРегистров = ВРег(ПризнакГруппыРегистров);
			ЭтоРегистрСведений = (ПризнакГруппыРегистров = "РЕГИСТРСВЕДЕНИЙ" Или ПризнакГруппыРегистров = "INFORMATIONREGISTER");
			
			НовыйПроверяемыйРегистр = ИменаПроверяемыхПоТипу.Добавить();
			Если ЭтоРегистрСведений Тогда
				НовыйПроверяемыйРегистр.ВидРегистра = "Сведений";
			ИначеЕсли ПризнакГруппыРегистров = "РЕГИСТРБУХГАЛТЕРИИ" Или ПризнакГруппыРегистров = "ACCOUNTINGREGISTER" Тогда
				НовыйПроверяемыйРегистр.ВидРегистра = "Бухгалтерии";
			Иначе
				НовыйПроверяемыйРегистр.ВидРегистра = "Накопления";
			КонецЕсли;
			НовыйПроверяемыйРегистр.ИмяРегистра = ПроверяемыйРегистр.Имя;
			НовыйПроверяемыйРегистр.ЕстьОрганизация = (ПроверяемыйРегистр.Измерения.Найти("Организация") <> Неопределено
				Или ПроверяемыйРегистр.Реквизиты.Найти("Организация") <> Неопределено
				Или ЭтоРегистрСведений И ПроверяемыйРегистр.Ресурсы.Найти("Организация") <> Неопределено);
			НовыйПроверяемыйРегистр.ЕстьПериод = (Не ЭтоРегистрСведений
				Или ПроверяемыйРегистр.ПериодичностьРегистраСведений <> НепериодическийРегистр);
			
		КонецЦикла;

	Иначе // вернуть список с ограничением
		
		Для каждого ПроверяемыйРегистр Из Движения Цикл
			
			ИмяПроверяемогоРегистра = ПроверяемыеРегистры.Найти(ПроверяемыйРегистр.Имя, "ИмяРегистра");
			Если ИмяПроверяемогоРегистра = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НовыйПроверяемыйРегистр = ИменаПроверяемыхПоТипу.Добавить();
			НовыйПроверяемыйРегистр.ВидРегистра     = ИмяПроверяемогоРегистра.ВидРегистра;
			НовыйПроверяемыйРегистр.ИмяРегистра     = ИмяПроверяемогоРегистра.ИмяРегистра;
			НовыйПроверяемыйРегистр.ЕстьОрганизация = ИмяПроверяемогоРегистра.ЕстьОрганизация;
			НовыйПроверяемыйРегистр.ЕстьПериод      = ИмяПроверяемогоРегистра.ЕстьПериод;
			
		КонецЦикла;

	КонецЕсли;
	
	Возврат ИменаПроверяемыхПоТипу;
	
КонецФункции

// Создает таблицу для хранения информации, необходимой алгоритму очистки движений.
//
Функция НовыеИменаРегистровДляПроверки()
	
	ПроверяемыеРегистры = Новый ТаблицаЗначений;
	
	// Бухгалтерии, Сведений, Накопления
	ПроверяемыеРегистры.Колонки.Добавить("ВидРегистра",     ОбщегоНазначения.ОписаниеТипаСтрока(11));
	ПроверяемыеРегистры.Колонки.Добавить("ИмяРегистра",     Новый ОписаниеТипов("Строка"));
	ПроверяемыеРегистры.Колонки.Добавить("ЕстьОрганизация", Новый ОписаниеТипов("Булево"));
	ПроверяемыеРегистры.Колонки.Добавить("ЕстьПериод",      Новый ОписаниеТипов("Булево"));
	
	Возврат ПроверяемыеРегистры;
	
КонецФункции

Функция НовыеРегистрыТребующиеОчистки()
	
	РегистрыТребующиеОчистки = Новый Структура;
	
	// Хранит список регистров, которые можно проанализировать на наличие записанных движений.
	РегистрыТребующиеОчистки.Вставить("ПроверяемыеРегистры", НовыеИменаРегистровДляПроверки());
	
	РегистрыТребующиеОчистки.Вставить("ДатаНачала",    '00010101');
	РегистрыТребующиеОчистки.Вставить("ДатаОкончания", '00010101');
	РегистрыТребующиеОчистки.Вставить("Организация",   Справочники.Организации.ПустаяСсылка());
	РегистрыТребующиеОчистки.Вставить("ИмяДокумента",  "");
	РегистрыТребующиеОчистки.Вставить("Регистратор",   Неопределено);
	
	Возврат РегистрыТребующиеОчистки;
	
КонецФункции

&НаСервере
Процедура УстановитьОтображениеВТаблицеРегистров(РегистрыСДвижениями)

	Для каждого СтрокаРегистра Из Регистры Цикл
		
		Отбор = Новый Структура("Имя", СтрокаРегистра.Имя);
		ДобавленПользователем = Объект.ТаблицаРегистровНакопления.НайтиСтроки(Отбор).Количество() > 0
			ИЛИ Объект.ТаблицаРегистровСведений.НайтиСтроки(Отбор).Количество() > 0;
		СтрокаРегистра.Отображение = РегистрыСДвижениями.Найти(СтрокаРегистра.Имя) <> Неопределено
			ИЛИ ДобавленПользователем;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьДвиженияДокумента(ДокументДвижений)
	
	АктивностьДвижений = Истина;
	
	Для каждого СтрокаРегистра Из Регистры Цикл
		Если СтрокаРегистра.Отображение Тогда
			ИмяРеквизита = СтрокаРегистра.Имя + "НаборЗаписей";
			НаборЗаписей = РеквизитФормыВЗначение(ИмяРеквизита);
			НаборЗаписей.Отбор.Регистратор.Установить(ДокументДвижений);
			НаборЗаписей.Прочитать();
			ЗначениеВРеквизитФормы(НаборЗаписей, ИмяРеквизита);
			Если ДокументДвижений = Объект.Ссылка Тогда
				СтрокаРегистра.Записывать = ЭтотОбъект[ИмяРеквизита].Количество() > 0;
				Если СтрокаРегистра.Записывать Тогда
					АктивностьДвижений = АктивностьДвижений И ЭтотОбъект[ИмяРеквизита][0].Активность;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры