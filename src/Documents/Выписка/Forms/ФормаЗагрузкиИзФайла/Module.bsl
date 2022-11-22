#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие); // или ВыборКаталога или Сохранение
	Диалог.Фильтр = "Документ TXT (*.txt)|*.txt"; // Строка с файловыми фильтрами
	Диалог.Заголовок = "Выберите документ TXT"; // Текст заголовка окна выбора
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("ФайлВыборЗавершение", ЭтотОбъект);
	
	Диалог.Показать(ОповещениеЗавершения); // Открываем окно выбора файла
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("ЗагружатьПриходы", ЗагружатьПриходы);
	Результат.Вставить("ЗагружатьСписания", ЗагружатьСписания);
	Результат.Вставить("ЗагружатьТолькоКомиссии", ЗагружатьТолькоКомиссии);
	Результат.Вставить("НеОчищатьТабличнуюЧастьВыписки", НеОчищатьТабличнуюЧастьВыписки);
	Результат.Вставить("Организация", Организация);
	Результат.Вставить("СчетОрганизации", СчетОрганизации);
	Результат.Вставить("Дата", Дата);
	
	Закрыть(Новый Структура("ДанныеВыписок, Параметры", ДанныеВыписок, Результат));
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьДанныеОкончание(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.ПомещениеФайлаОтменено Тогда 
		Возврат;
	КонецЕсли;  
	
	Если ЭтоАдресВременногоХранилища(Результат.Адрес) ТОгда
		
		ЗагруженныйФайл = ПолучитьИзВременногоХранилища(Результат.Адрес);
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
		ЗагруженныйФайл.Записать(ИмяВременногоФайла);
		Дата = '00010101';
		Организация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
		ЭтоСписание = Неопределено;
		
		СтруктураСекции = Новый Структура;
		Старт = Ложь;
		МассивИнформации = Новый Массив;
		//МассивРасчетныхСчетов = Новый Массив;
		
		Текст = Новый ЧтениеТекста(ИмяВременногоФайла); 
		Строка = Текст.ПрочитатьСтроку();
		
		Пока Строка <> Неопределено Цикл 
			
			Если Найти(Строка, "ДатаНачала") > 0 И Дата = '00010101' Тогда // Старт секции
				ДатаТекст = RegularExpressions.ПодстрокаRegExp(Строка, "\d{2}.\d{2}.\d{4}");
				Дата = Дата(Сред(ДатаТекст, 7, 4) + Сред(ДатаТекст, 4, 2) + Сред(ДатаТекст, 1, 2));
				Продолжить;
			КонецЕсли;
			
			//// Определим Организацию и Дату
			
			Если Найти(Строка, "СекцияДокумент") > 0 Тогда // Старт секции
				Старт = Истина;
				СтруктураСекции = Новый Структура;
			КонецЕсли;
			
			Если НЕ Старт Тогда
				Строка = Текст.ПрочитатьСтроку();
				Продолжить;
			КонецЕсли;
			
			Если Найти(Строка, "КонецДокумента") > 0 Тогда // Конец секции
				МассивИнформации.Добавить(СтруктураСекции);	
			КонецЕсли;
			
			ПозицияЗнакаРавно = Найти(Строка, "=");
			
			Если ПозицияЗнакаРавно > 0 Тогда
				ИмяКлюча = Лев(Строка, ПозицияЗнакаРавно - 1);
				Значение = Сред(Строка, ПозицияЗнакаРавно + 1);
				СтруктураСекции.Вставить(ИмяКлюча, Значение);
			КонецЕсли;
			
			Строка = Текст.ПрочитатьСтроку(); 
			
		КонецЦикла;
		
		Текст.Закрыть();
		
		УдалитьФайлы(ИмяВременногоФайла);
		
		// Ищем Организацию
		Если МассивИнформации.Количество() > 0 Тогда
			Информация = МассивИнформации[0];
			ЭтоСписание = Информация.Свойство("ДатаСписано") И Информация.ДатаСписано <> "";
			
			Если ЭтоСписание Тогда
				Организация = ПолучитьОрганизациюПоИНН(Информация.ПлательщикИНН);
			Иначе
				Организация = ПолучитьОрганизациюПоИНН(Информация.ПолучательИНН);
			КонецЕсли;
		КонецЕсли;
		
		ДанныеВыписок = ЗагрузитьДанныеНаСервере(МассивИнформации);
		
		Для Каждого ЭлементСписка Из ДанныеВыписок Цикл
			
			Если Элементы.СчетОрганизации.СписокВыбора.НайтиПоЗначению(ЭлементСписка.Значение.СчетОрганизации) = Неопределено Тогда
				Элементы.СчетОрганизации.СписокВыбора.Добавить(ЭлементСписка.Значение.СчетОрганизации);
			КонецЕсли;
			
			Если Элементы.СчетОрганизации.СписокВыбора.Количество() <> 0 Тогда
				СчетОрганизации = Элементы.СчетОрганизации.СписокВыбора[0].Значение;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Элементы.СчетОрганизации.СписокВыбора.Количество() = 1 Тогда
			Элементы.СчетОрганизации.Доступность = Ложь;
		КонецЕсли;
		
		ЗаполнитьИнформациюПоСуществующимВыпискам();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлВыборЗавершение(ВыбФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбФайлы <> Неопределено Тогда
		
		Файл = ВыбФайлы[0];
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьДанныеОкончание", ЭтотОбъект);
		НачатьПомещениеФайлаНаСервер(ОписаниеОповещения,,,, Файл);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьДанныеНаСервере(МассивИнформации)
	
	ЗапросКомиссий = Новый Запрос("ВЫБРАТЬ
	|	СтрокиЗаполненияВыписокКомиссия.СтрокаКомиссии
	|ИЗ
	|	РегистрСведений.СтрокиЗаполненияВыписокКомиссия КАК СтрокиЗаполненияВыписокКомиссия");
	
	ВыборкаКомиссий = ЗапросКомиссий.Выполнить().Выбрать();
	
	ТекстПоискаКомиссии = "";
	Пока ВыборкаКомиссий.Следующий() Цикл
		Если ТекстПоискаКомиссии = "" Тогда
			ТекстПоискаКомиссии = "(" + СокрЛП(ВыборкаКомиссий.СтрокаКомиссии) + ")";
		Иначе
			ТекстПоискаКомиссии = ТекстПоискаКомиссии + "|(" + СокрЛП(ВыборкаКомиссий.СтрокаКомиссии) + ")";
		КонецЕсли;
	КонецЦикла;
	
	МассивПаттерновЗамены = Новый Массив;
	МассивПаттерновЗамены.Добавить("(\,)");
	МассивПаттерновЗамены.Добавить(ТекстПоискаКомиссии);
	
	//МассивИнформации = ПолучитьМассивИнформацииИзФайла(ПутьКФайлу);
	
	// Выборка по данным заполнения
//	ЗапросПоДаннымЗаполнения = Новый Запрос("ВЫБРАТЬ
//	|	СведенияДляАвтозаполненияВыписок.ТекстЗапроса,
//	|	СведенияДляАвтозаполненияВыписок.СтатьяДДС,
//	|	СведенияДляАвтозаполненияВыписок.Контрагент,
//	|	СведенияДляАвтозаполненияВыписок.СчетКонтрагента,
//	|	СведенияДляАвтозаполненияВыписок.КатегорияОперации,
//	|	СведенияДляАвтозаполненияВыписок.АлгоритмРасчета,
//	|	СведенияДляАвтозаполненияВыписок.ИспользуетсяАлгоритмРасчета,
//	|	СведенияДляАвтозаполненияВыписок.Приоритет КАК Приоритет
//	|ИЗ
//	|	РегистрСведений.СведенияДляАвтозаполненияВыписок КАК СведенияДляАвтозаполненияВыписок
//	|ГДЕ
//	|	(СведенияДляАвтозаполненияВыписок.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
//	|			ИЛИ СведенияДляАвтозаполненияВыписок.Организация = &Организация)
//	|	И (СведенияДляАвтозаполненияВыписок.СчетОрганизации = ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяСсылка)
//	|			ИЛИ СведенияДляАвтозаполненияВыписок.СчетОрганизации = &БанковскийСчет)
//	|
//	|УПОРЯДОЧИТЬ ПО
//	|	СведенияДляАвтозаполненияВыписок.Организация,
//	|	СведенияДляАвтозаполненияВыписок.СчетОрганизации,
//	|	Приоритет");
//	
//	ЗапросПоДаннымЗаполнения.УстановитьПараметр("Организация", Организация);
//	ЗапросПоДаннымЗаполнения.УстановитьПараметр("БанковскийСчет", СчетОрганизации);
//	
//	ВыборкаПоДаннымЗаполнения = ЗапросПоДаннымЗаполнения.Выполнить().Выбрать();
	
	НаименованиеОрганизации = Организация.Наименование;
	МассивДанныхВыписок = Новый СписокЗначений;
	
	ПереченьКолонок = "";
	Для Каждого Колонка Из Метаданные.Документы.Выписка.ТабличныеЧасти.ДанныеВыписки.Реквизиты Цикл
		Если ПереченьКолонок = "" Тогда
			ПереченьКолонок = Колонка.Имя;
		Иначе
			ПереченьКолонок = ПереченьКолонок + ", " + Колонка.Имя;
		КонецЕсли;
	КонецЦикла;
	ПереченьКолонок = ПереченьКолонок + ", СтруктураДоработки";
	ПереченьКолонок = ПереченьКолонок + ", ЭтоПриход";
	ПереченьКолонок = ПереченьКолонок + ", Организация, СчетОрганизации";
	ПереченьКолонок = ПереченьКолонок + ", УправленческийУчет";
	СтруктураОбразец = Новый ФиксированнаяСтруктура(ПереченьКолонок);
	
	ЗапросСуммыНДС = Новый Запрос("ВЫБРАТЬ
		|	СтрокиЗаполненияВыписокНДС.СтрокаПоиска КАК СтрокаПоиска,
		|	СтрокиЗаполненияВыписокНДС.СтрокаСуммыШаг1 КАК СтрокаСуммыШаг1,
		|	СтрокиЗаполненияВыписокНДС.СтрокаСуммыШаг2 КАК СтрокаСуммыШаг2,
		|	СтрокиЗаполненияВыписокНДС.СтрокаСуммыШаг3 КАК СтрокаСуммыШаг3
		|ИЗ
		|	РегистрСведений.СтрокиЗаполненияВыписокНДС КАК СтрокиЗаполненияВыписокНДС");
		
	ВыборкаСуммыНДС = ЗапросСуммыНДС.Выполнить().Выбрать();

	ЗапросПоКатегорииОперации = Новый Запрос("ВЫБРАТЬ
	|	НастройкиИмпортаВыписок.ВидОплаты КАК ВидОплаты,
	|	НастройкиИмпортаВыписок.ПриходРасход КАК ПриходРасход,
	|	НастройкиИмпортаВыписок.ПлательщикИНН КАК ПлательщикИНН,
	|	НастройкиИмпортаВыписок.ПолучательИНН КАК ПолучательИНН,
	|	НастройкиИмпортаВыписок.ПоказательКБК КАК ПоказательКБК,
	|	НастройкиИмпортаВыписок.СтрокаПоиска КАК СтрокаПоиска,
	|	НастройкиИмпортаВыписок.КатегорияОпераций КАК КатегорияОпераций,
	|	НастройкиИмпортаВыписок.Реквизиты КАК Реквизиты,
	|	НастройкиИмпортаВыписок.СтатьяДДС КАК СтатьяДДС,
	|	НастройкиИмпортаВыписок.АлгоритмРасчета КАК АлгоритмРасчета,
	|	НастройкиИмпортаВыписок.ИспользуетсяАлгоритмРасчета КАК ИспользуетсяАлгоритмРасчета
	|ИЗ
	|	РегистрСведений.НастройкиИмпортаВыписок КАК НастройкиИмпортаВыписок
	|
	|УПОРЯДОЧИТЬ ПО
	|	НастройкиИмпортаВыписок.Приоритет");
	
	ВыборкаПоУправленческомуУчету = ЗапросПоКатегорииОперации.Выполнить().Выбрать();
	
	// Финансовые планы
	ЗапросПоФинансовымПланам = Новый Запрос("ВЫБРАТЬ
	|	ФинансовыйПланПланирование.Ссылка КАК Ссылка,
	|	ФинансовыйПланПланирование.НомерСтроки КАК НомерСтроки,
	|	ФинансовыйПланПланирование.Организация КАК Организация,
	|	ФинансовыйПланПланирование.СчетОрганизации КАК СчетОрганизации,
	|	ФинансовыйПланПланирование.СтатьяДДС КАК СтатьяДДС,
	|	ФинансовыйПланПланирование.Контрагент КАК Контрагент,
	|	ФинансовыйПланПланирование.СчетКонтрагента КАК СчетКонтрагента,
	|	ФинансовыйПланПланирование.НазначениеПлатежа КАК НазначениеПлатежа,
	|	ФинансовыйПланПланирование.Валюта КАК Валюта,
	|	ФинансовыйПланПланирование.ВалютаЗаявки КАК ВалютаЗаявки,
	|	ФинансовыйПланПланирование.Сумма КАК Сумма,
	|	ФинансовыйПланПланирование.СуммаНДС КАК СуммаНДС,
	|	ФинансовыйПланПланирование.ВалютнаяСумма КАК ВалютнаяСумма,
	|	ФинансовыйПланПланирование.КатегорияОперации КАК КатегорияОперации,
	|	ФинансовыйПланПланирование.Процент КАК Процент,
	|	ФинансовыйПланПланирование.КурсОплатыФиксированный КАК КурсОплатыФиксированный,
	|	ФинансовыйПланПланирование.Договор КАК Договор,
	|	ФинансовыйПланПланирование.ОтменаПлатежа КАК ОтменаПлатежа,
	|	ФинансовыйПланПланирование.ОплатаВыполнена КАК ОплатаВыполнена,
	|	ФинансовыйПланПланирование.АвторСтроки КАК АвторСтроки,
	|	ФинансовыйПланПланирование.Комментарий КАК Комментарий,
	|	ФинансовыйПланПланирование.НомерЗаявки КАК НомерЗаявки,
	|	ФинансовыйПланПланирование.GUIDСтрокиФинансовогоПлана КАК GUIDСтрокиФинансовогоПлана,
	|	ФинансовыйПланПланирование.IDЗаявки КАК IDЗаявки,
	|	ФинансовыйПланПланирование.ЗаявкаВзятаВРаботу КАК ЗаявкаВзятаВРаботу
	|ИЗ
	|	Документ.ФинансовыйПлан.Планирование КАК ФинансовыйПланПланирование
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(ФинансовыйПланПланирование.Ссылка.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаАнализа, ДЕНЬ)
	|	И НЕ ФинансовыйПланПланирование.Ссылка.ПометкаУдаления
	|	И ФинансовыйПланПланирование.Организация = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФинансовыйПланУправленческийУчетЗаявок.НомерСтроки КАК НомерСтроки,
	|	ФинансовыйПланУправленческийУчетЗаявок.GUIDСтрокиФинансовогоПлана КАК GUIDСтрокиФинансовогоПлана,
	|	ФинансовыйПланУправленческийУчетЗаявок.Имя КАК Имя,
	|	ФинансовыйПланУправленческийУчетЗаявок.Значение КАК Значение,
	|	ФинансовыйПланУправленческийУчетЗаявок.ТипРеквизита КАК ТипРеквизита,
	|	ФинансовыйПланУправленческийУчетЗаявок.ЗапретРедактирования КАК ЗапретРедактирования,
	|	ФинансовыйПланУправленческийУчетЗаявок.Необязательный КАК Необязательный,
	|	ФинансовыйПланУправленческийУчетЗаявок.ВидПараметра КАК ВидПараметра,
	|	ФинансовыйПланУправленческийУчетЗаявок.Формула КАК Формула
	|ИЗ
	|	Документ.ФинансовыйПлан.УправленческийУчетЗаявок КАК ФинансовыйПланУправленческийУчетЗаявок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ФинансовыйПлан.Планирование КАК ФинансовыйПланПланирование
	|		ПО ФинансовыйПланУправленческийУчетЗаявок.GUIDСтрокиФинансовогоПлана = ФинансовыйПланПланирование.GUIDСтрокиФинансовогоПлана
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(ФинансовыйПланУправленческийУчетЗаявок.Ссылка.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаАнализа, ДЕНЬ)
	|	И НЕ ФинансовыйПланУправленческийУчетЗаявок.Ссылка.ПометкаУдаления
	|	И ФинансовыйПланПланирование.Организация = &Организация");
	
	ЗапросПоФинансовымПланам.УстановитьПараметр("ДатаАнализа", Дата);
	ЗапросПоФинансовымПланам.УстановитьПараметр("Организация", Организация);
	РезультатПоФинансовымПланам = ЗапросПоФинансовымПланам.ВыполнитьПакет();
	ВыборкаПоФинансовымПланам = РезультатПоФинансовымПланам[0].Выбрать();
	ВыборкаПоУУФинансовыхПланов = РезультатПоФинансовымПланам[1].Выбрать();
	
	МассивСтатейПриход = Новый Массив;
	МассивСтатейРасход = Новый Массив;
	
	МассивСтатейПриход.Добавить(Справочники.СтатьиДДС.Инкассация);
	МассивСтатейПриход.Добавить(Справочники.СтатьиДДС.Приход);
	МассивСтатейПриход.Добавить(Справочники.СтатьиДДС.ПриходПоКК);
	
	МассивСтатейРасход.Добавить(Справочники.СтатьиДДС.Аренда);
	МассивСтатейРасход.Добавить(Справочники.СтатьиДДС.Зарплата);
	МассивСтатейРасход.Добавить(Справочники.СтатьиДДС.ЗарплатаНаКК);
	МассивСтатейРасход.Добавить(Справочники.СтатьиДДС.ЗаТовары);
	МассивСтатейРасход.Добавить(Справочники.СтатьиДДС.КомиссияБанка);
	МассивСтатейРасход.Добавить(Справочники.СтатьиДДС.Налог);
	МассивСтатейРасход.Добавить(Справочники.СтатьиДДС.Расход);
	
	МассивИспользованныхЗаявок = Новый Массив;
	
	Для Каждого Информация Из МассивИнформации Цикл
		
		Сумма = Число(Информация.Сумма);
		НазначениеПлатежа = Информация.НазначениеПлатежа;
		ВРЕГ_НазначениеПлатежа = ВРЕГ(НазначениеПлатежа);
		
		ЭтоСписание = Информация.Свойство("ДатаСписано") И Информация.ДатаСписано <> "";
		//ЭтоКомиссия = RegularExpressions.ТестRegExp(НазначениеПлатежа, ТекстПоискаКомиссии);
		ЭтоКомиссия = Ложь;
		
		Если НЕ ЗагружатьПриходы И НЕ ЭтоСписание Тогда
			Продолжить;
		
		ИначеЕсли НЕ ЗагружатьСписания И НЕ ЗагружатьТолькоКомиссии И ЭтоСписание Тогда
			Продолжить;
			
		//ИначеЕсли ЭтоСписание И ЗагружатьТолькоКомиссии И Не ЭтоКомиссия Тогда
		//	Продолжить;
			
		КонецЕсли;

		НоваяСтрока = Новый Структура(СтруктураОбразец);
		МассивДанныхВыписок.Добавить(НоваяСтрока);
		
		НоваяСтрока.GUIDСтрокиВыписки = Новый УникальныйИдентификатор;
		НоваяСтрока.СтруктураДоработки = Новый Структура;
		// СтруктураДоработки = НоваяСтрока.СтруктураДоработки;
		НоваяСтрока.НазначениеПлатежа = НазначениеПлатежа;

		КонтрагентБанк = "";
		
		Если ЭтоСписание Тогда
			
				
			НоваяСтрока.Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН", Информация.ПлательщикИНН);
			Если Информация.Свойство("ПлательщикСчет") Тогда
				НомерСчета = Информация.ПлательщикСчет;
			ИначеЕсли Информация.Свойство("ПлательщикРасчСчет") Тогда
				НомерСчета = Информация.ПлательщикРасчСчет;
			КонецЕсли;
			
			БИКБанкаОрганизации = Информация.ПлательщикБИК;
			НоваяСтрока.СчетОрганизации = Справочники.БанковскиеСчета.НайтиПоРеквизиту("НомерСчета", НомерСчета,, НоваяСтрока.Организация);
			
			Если ЗначениеЗаполнено(НоваяСтрока.СчетОрганизации) И ЗначениеЗаполнено(НоваяСтрока.СчетОрганизации.Банк) Тогда
				КонтрагентБанк = НоваяСтрока.СчетОрганизации.Банк.Контрагент;
			КонецЕсли;
			
			Если ЗагружатьТолькоКомиссии ИЛИ ЭтоКомиссия Тогда
				НоваяСтрока.СтатьяДДС = Справочники.СтатьиДДС.КомиссияБанка;
				НоваяСтрока.Контрагент = КонтрагентБанк;
				
				Если RegularExpressions.ТестRegExp(НазначениеПлатежа, "за\s+прием\s+наличных\s+денежных\s+средств")
					ИЛИ RegularExpressions.ТестRegExp(НазначениеПлатежа, "за\s+пересчет\s+наличных\s+денежных\s+средств\s+в\s+инкассаторских\s+сумках") Тогда
					НоваяСтрока.КатегорияОперации = Справочники.КатегорииОпераций.НайтиПоНаименованию("Комиссия банка по инкассации");
				Иначе
					НоваяСтрока.КатегорияОперации = Справочники.КатегорииОпераций.НайтиПоНаименованию("Комиссия банка");
				КонецЕсли;
			Иначе
				
				НоваяСтрока.СтатьяДДС = Справочники.СтатьиДДС.Расход;
				
				Если ЗначениеЗаполнено(Информация.ПолучательИНН) Тогда
					НоваяСтрока.Контрагент = ПолучитьКонтрагентаПоИНН(Информация.ПолучательИНН);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(НоваяСтрока.Контрагент) И Информация.Свойство("ПолучательРасчСчет") И ЗначениеЗаполнено(Информация.ПолучательРасчСчет) Тогда
					НоваяСтрока.СчетКонтрагента = ПолучитьБанковскийСчет(Информация.ПолучательРасчСчет, Информация.ПолучательБИК, НоваяСтрока.Контрагент);
				ИначеЕсли ЗначениеЗаполнено(НоваяСтрока.Контрагент) И Информация.Свойство("ПолучательСчет") И ЗначениеЗаполнено(Информация.ПолучательСчет) Тогда
					НоваяСтрока.СчетКонтрагента = ПолучитьБанковскийСчет(Информация.ПолучательСчет, Информация.ПолучательБИК, НоваяСтрока.Контрагент);
				КонецЕсли;
				
			КонецЕсли;
			
			Если Информация.ВидОплаты <> "17" Тогда
				
				ВыборкаПоФинансовымПланам.Сбросить();
				НайденаСтрокаФинПлана = Ложь;
				
				// Ищем по фильтру "Организация, Контрагент, Сумма"
				Пока ВыборкаПоФинансовымПланам.НайтиСледующий(Новый Структура("Организация, Контрагент, Сумма", Организация, НоваяСтрока.Контрагент, Сумма)) Цикл
					
					Если МассивИспользованныхЗаявок.Найти(ВыборкаПоФинансовымПланам.НомерЗаявки) <> Неопределено Тогда
						Продолжить;
					КонецЕсли;
					
					НайденаСтрокаФинПлана = Истина;
					Прервать;
					
				КонецЦикла;
				
				// Ищем по фильтру "Организация, Контрагент"
				Если НЕ НайденаСтрокаФинПлана Тогда

					ВыборкаПоФинансовымПланам.Сбросить();
					Пока ВыборкаПоФинансовымПланам.НайтиСледующий(Новый Структура("Организация, Сумма", Организация, Сумма)) Цикл
						
						Если МассивИспользованныхЗаявок.Найти(ВыборкаПоФинансовымПланам.НомерЗаявки) <> Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						НайденаСтрокаФинПлана = Истина;
						Прервать;
						
					КонецЦикла;
					
				КонецЕсли;
				
				// Ищем по фильтру "Организация"
				Если НЕ НайденаСтрокаФинПлана Тогда
					
					ВыборкаПоФинансовымПланам.Сбросить();
					Пока ВыборкаПоФинансовымПланам.НайтиСледующий(Новый Структура("Организация", Организация)) Цикл
						
						Если ВыборкаПоФинансовымПланам.Сумма <> 0 Тогда
							
							Если МассивИспользованныхЗаявок.Найти(ВыборкаПоФинансовымПланам.НомерЗаявки) <> Неопределено Тогда
								Продолжить;
							КонецЕсли;
							
							Разница = ВыборкаПоФинансовымПланам.Сумма - Сумма / ВыборкаПоФинансовымПланам.Сумма;
							Разница = Макс(Разница, -Разница);
							
							Если Разница < 0.02 Тогда
								НайденаСтрокаФинПлана = Истина;
								Прервать;
							КонецЕсли;
							
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
							
				Если НайденаСтрокаФинПлана Тогда
					
					НоваяСтрока.GUIDСтрокиФинансовогоПлана = ВыборкаПоФинансовымПланам.GUIDСтрокиФинансовогоПлана;
					
					Если ЗначениеЗаполнено(ВыборкаПоФинансовымПланам.НомерЗаявки) Тогда
						
						ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоФинансовымПланам, "НомерЗаявки, IDЗаявки");
						МассивИспользованныхЗаявок.Добавить(НоваяСтрока.НомерЗаявки);
						
					КонецЕсли;
					
					Если ЗначениеЗаполнено(ВыборкаПоФинансовымПланам.КатегорияОперации) Тогда
						
						НоваяСтрока.КатегорияОперации = ВыборкаПоФинансовымПланам.КатегорияОперации;
						
						НоваяСтрока.УправленческийУчет = Новый Массив;
						
						ВыборкаПоУУФинансовыхПланов.Сбросить();
						Пока ВыборкаПоУУФинансовыхПланов.НайтиСледующий(Новый Структура("GUIDСтрокиФинансовогоПлана", ВыборкаПоФинансовымПланам.GUIDСтрокиФинансовогоПлана)) Цикл
							
							НоваяСтрокаУУ = Новый Структура;
							НоваяСтрока.УправленческийУчет.Добавить(НоваяСтрокаУУ);
							
							Для Каждого Колонка Из РезультатПоФинансовымПланам[1].Колонки Цикл
								НоваяСтрокаУУ.Вставить(Колонка.Имя, ВыборкаПоУУФинансовыхПланов[Колонка.Имя]);
							КонецЦикла;
							
						КонецЦикла;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			// РасходХ
			
			Если Не ЗначениеЗаполнено(НоваяСтрока.КатегорияОперации)
				И ЗначениеЗаполнено(Информация.ПолучательИНН)
				И ЗначениеЗаполнено(Справочники.Организации.НайтиПоРеквизиту("ИНН", Информация.ПолучательИНН)) Тогда
				
				Если Значениезаполнено(НоваяСтрока.СчетКонтрагента) И (НоваяСтрока.СчетКонтрагента.ВалютаДенежныхСредств <> НоваяСтрока.СчетОрганизации.ВалютаДенежныхСредств) Тогда
					НоваяСтрока.КатегорияОперации = Справочники.КатегорииОпераций.НайтиПоНаименованию("Конвертация р/сч Х, отправка денег", Истина);	
				Иначе
					НоваяСтрока.КатегорияОперации = Справочники.КатегорииОпераций.НайтиПоНаименованию("Расход Х", Истина);
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			НоваяСтрока.Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН", Информация.ПолучательИНН);
			Если Информация.Свойство("ПолучательСчет") Тогда
				НомерСчета = Информация.ПолучательСчет;
			ИначеЕсли Информация.Свойство("ПолучательРасчСчет") Тогда
				НомерСчета = Информация.ПолучательРасчСчет;
			КонецЕсли;
			
			
			БИКБанкаОрганизации = Информация.ПолучательБИК;
			НоваяСтрока.СчетОрганизации = Справочники.БанковскиеСчета.НайтиПоРеквизиту("НомерСчета", НомерСчета,, НоваяСтрока.Организация);
			
			Если ЗначениеЗаполнено(НоваяСтрока.СчетОрганизации) И ЗначениеЗаполнено(НоваяСтрока.СчетОрганизации.Банк) Тогда
				КонтрагентБанк = НоваяСтрока.СчетОрганизации.Банк.Контрагент;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(НоваяСтрока.КатегорияОперации)
				И ЗначениеЗаполнено(Информация.ПлательщикИНН)
				И ЗначениеЗаполнено(Справочники.Организации.НайтиПоРеквизиту("ИНН", Информация.ПлательщикИНН)) Тогда
				
				Если Значениезаполнено(НоваяСтрока.СчетКонтрагента) И (НоваяСтрока.СчетКонтрагента.ВалютаДенежныхСредств <> НоваяСтрока.СчетОрганизации.ВалютаДенежныхСредств) Тогда
					НоваяСтрока.КатегорияОперации = Справочники.КатегорииОпераций.НайтиПоНаименованию("Конвертация р/сч Х, получение денег", Истина);	
				Иначе
					НоваяСтрока.КатегорияОперации = Справочники.КатегорииОпераций.НайтиПоНаименованию("Приход Х", Истина);
				КонецЕсли;
				
			КонецЕсли;
			
			Если Найти(ВРЕГ_НазначениеПлатежа, "ТОРГОВАЯ ВЫРУЧКА") > 0 Тогда
				НоваяСтрока.СтатьяДДС = Справочники.СтатьиДДС.Инкассация;
			Иначе
				НоваяСтрока.СтатьяДДС = Справочники.СтатьиДДС.Приход;
				
				Если ЗначениеЗаполнено(Информация.ПлательщикИНН) Тогда
					НоваяСтрока.Контрагент = ПолучитьКонтрагентаПоИНН(Информация.ПлательщикИНН);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(НоваяСтрока.Контрагент) И Информация.Свойство("ПлательщикРасчСчет") И ЗначениеЗаполнено(Информация.ПлательщикРасчСчет) Тогда
					НоваяСтрока.СчетКонтрагента = ПолучитьБанковскийСчет(Информация.ПлательщикРасчСчет, Информация.ПлательщикБИК, НоваяСтрока.Контрагент);
				ИначеЕсли ЗначениеЗаполнено(НоваяСтрока.Контрагент) И Информация.Свойство("ПлательщикСчет") И ЗначениеЗаполнено(Информация.ПлательщикСчет) Тогда
					НоваяСтрока.СчетКонтрагента = ПолучитьБанковскийСчет(Информация.ПлательщикСчет, Информация.ПлательщикБИК, НоваяСтрока.Контрагент);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НоваяСтрока.СчетОрганизации) Тогда
			Сообщить("Не найден расчетный счет организации " + НоваяСтрока.Организация + " номер " + НомерСчета + " БИК " + БИКБанкаОрганизации);
		КонецЕсли;
		
		НоваяСтрока.ВалютнаяСумма = Сумма;

		Если ЭтоСписание Тогда
			НоваяСтрока.СуммаРасход = Сумма;
		Иначе
			НоваяСтрока.СуммаПриход = Сумма;
		КонецЕсли;
		
		
		// Определяем Категорию Операции
		
		НоваяСтрока.Вставить("ДанныеЗаполненияПоУправленческомуУчету", Новый Массив);
		
		ВыборкаПоУправленческомуУчету.Сбросить();
		Пока ВыборкаПоУправленческомуУчету.Следующий() Цикл
			
			Если ВыборкаПоУправленческомуУчету.ВидОплаты <> 0 И ВыборкаПоУправленческомуУчету.ВидОплаты <> Число(Информация.ВидОплаты) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВыборкаПоУправленческомуУчету.ПоказательКБК) И ВыборкаПоУправленческомуУчету.ПоказательКБК <> Информация.ПоказательКБК Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(НоваяСтрока.СтатьяДДС) Тогда
				
				Если ВыборкаПоУправленческомуУчету.ПриходРасход = 0 Тогда
					
					Если МассивСтатейПриход.Найти(НоваяСтрока.СтатьяДДС) = Неопределено Тогда
						Продолжить;
					Конецесли;
					
					Если ЗначениеЗаполнено(ВыборкаПоУправленческомуУчету.ПлательщикИНН) И (НЕ ЗначениеЗаполнено(НоваяСтрока.Контрагент) ИЛИ ВыборкаПоУправленческомуУчету.ПлательщикИНН <> НоваяСтрока.Контрагент.ИНН)
						ИЛИ ЗначениеЗаполнено(ВыборкаПоУправленческомуУчету.ПолучательИНН) И (НЕ ВыборкаПоУправленческомуУчету.ПолучательИНН = НоваяСтрока.Организация.ИНН) Тогда
						
						Продолжить;
						
					КонецЕсли;
					
				КонецЕсли;
				
				Если ВыборкаПоУправленческомуУчету.ПриходРасход = 1 Тогда
					
					Если МассивСтатейРасход.Найти(НоваяСтрока.СтатьяДДС) = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(ВыборкаПоУправленческомуУчету.ПолучательИНН) И (НЕ ЗначениеЗаполнено(НоваяСтрока.Контрагент) ИЛИ ВыборкаПоУправленческомуУчету.ПолучательИНН <> НоваяСтрока.Контрагент.ИНН)
						ИЛИ ЗначениеЗаполнено(ВыборкаПоУправленческомуУчету.ПлательщикИНН) И (НЕ ВыборкаПоУправленческомуУчету.ПлательщикИНН = НоваяСтрока.Организация.ИНН) Тогда
						
						Продолжить;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВыборкаПоУправленческомуУчету.СтрокаПоиска) Тогда
				
				Если НЕ RegularExpressions.ТестRegExp(НоваяСтрока.НазначениеПлатежа, ВыборкаПоУправленческомуУчету.СтрокаПоиска) Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВыборкаПоУправленческомуУчету.КатегорияОпераций) Тогда
				НоваяСтрока.КатегорияОперации = ВыборкаПоУправленческомуУчету.КатегорияОпераций;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВыборкаПоУправленческомуУчету.СтатьяДДС) Тогда
				НоваяСтрока.СтатьяДДС = ВыборкаПоУправленческомуУчету.СтатьяДДС;
			КонецЕсли;
			
			РеквизитыКатегории = ВыборкаПоУправленческомуУчету.Реквизиты.Получить();        
			Для Каждого Элемент Из РеквизитыКатегории Цикл
				НоваяСтрока.ДанныеЗаполненияПоУправленческомуУчету.Добавить(Новый Структура("Имя, Значение", Элемент.Имя, Элемент.Значение));
			КонецЦикла;
			
			Если ВыборкаПоУправленческомуУчету.ИспользуетсяАлгоритмРасчета Тогда
				//УстановитьБезопасныйРежим(Истина);
				Выполнить(ВыборкаПоУправленческомуУчету.АлгоритмРасчета);
				//УстановитьБезопасныйРежим(Ложь);
			КонецЕсли;
			
			Прервать;
			
		КонецЦикла;
		
		// НДС
		
		ВыборкаСуммыНДС.Сбросить();
		
		Пока ВыборкаСуммыНДС.Следующий() Цикл

			Если RegularExpressions.ТестRegExp(НазначениеПлатежа, ВыборкаСуммыНДС.СтрокаПоиска) Тогда
				
				СтрокаНДС = RegularExpressions.ПодстрокаRegExp(НазначениеПлатежа, ВыборкаСуммыНДС.СтрокаПоиска);
				СтрокаНДС = RegularExpressions.ПодстрокаRegExp(СтрокаНДС, ВыборкаСуммыНДС.СтрокаСуммыШаг1);
				
				Если ЗначениеЗаполнено(ВыборкаСуммыНДС.СтрокаСуммыШаг2) Тогда
					СтрокаНДС = RegularExpressions.ПодстрокаRegExp(СтрокаНДС, ВыборкаСуммыНДС.СтрокаСуммыШаг2);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ВыборкаСуммыНДС.СтрокаСуммыШаг3) Тогда
					СтрокаНДС = RegularExpressions.ПодстрокаRegExp(СтрокаНДС, ВыборкаСуммыНДС.СтрокаСуммыШаг3);
				КонецЕсли;
				
				СтрокаНДС = СтрЗаменить(СтрокаНДС, ",", ".");
				СтрокаНДС = СтрЗаменить(СтрокаНДС, "-", ".");
				СтрокаНДС = СтрЗаменить(СтрокаНДС, " ", "");
				
				Попытка
					НоваяСтрока.СуммаНДС = Число(СтрокаНДС);
				Исключение
				КонецПопытки;
				
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
		
		НоваяСтрока.ЭтоПриход = Не ЭтоСписание;
		
	КонецЦикла;
	
	Возврат(МассивДанныхВыписок);
	
КонецФункции
#КонецОбласти





&НаСервере
Функция ПолучитьОрганизациюПоИНН(ИНН)
	Возврат Справочники.Организации.НайтиПоРеквизиту("ИНН", ИНН);
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		
		Параметры.Свойство("Организация", Организация);
		Параметры.Свойство("СчетОрганизации", СчетОрганизации);
		
	КонецЕсли;
	
	ЗагружатьПриходы = Истина;
	ЗагружатьСписания = Истина;
	
КонецПроцедуры


&НаСервере
Функция ПолучитьМассивИнформацииИзФайла(ИмяФайла)
	
	СтруктураСекции = Новый Структура;
	Старт = Ложь;
	МассивИнформации = Новый Массив;
	
	Текст = Новый ЧтениеТекста(ИмяФайла); 
	Строка = Текст.ПрочитатьСтроку();
	
	Пока Строка <> Неопределено Цикл 
		
		Если Найти(Строка, "СекцияДокумент") > 0 Тогда // Старт секции
			Старт = Истина;
			СтруктураСекции = Новый Структура;
		КонецЕсли;
		
		Если НЕ Старт Тогда
			Строка = Текст.ПрочитатьСтроку();
			Продолжить;
		КонецЕсли;
		
		Если Найти(Строка, "КонецДокумента") > 0 Тогда // Конец секции
			МассивИнформации.Добавить(СтруктураСекции);	
		КонецЕсли;
		
		ПозицияЗнакаРавно = Найти(Строка, "=");
		
		Если ПозицияЗнакаРавно > 0 Тогда
			ИмяКлюча = Лев(Строка, ПозицияЗнакаРавно - 1);
			Значение = Сред(Строка, ПозицияЗнакаРавно + 1);
			СтруктураСекции.Вставить(ИмяКлюча, Значение);
		КонецЕсли;
		
		Строка = Текст.ПрочитатьСтроку(); 
		
	КонецЦикла;
	
	Текст.Закрыть();
	
	Возврат МассивИнформации;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоИНН(СтрокаИНН)
	Возврат ЗначениеЗаполнено(СтрокаИНН)
		И ТипЗнч(СтрокаИНН) = Тип("Строка")
		И (СтрДлина(СтрокаИНН) = 10 ИЛИ СтрДлина(СтрокаИНН) = 12)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаИНН);
КонецФункции
	
&НаСервере
Функция ПолучитьКонтрагентаПоИНН(ИНН)
	
	Контрагент = Неопределено;
	
	Если ЭтоИНН(ИНН) Тогда
		
		Контрагент = Справочники.Контрагенты.НайтиПоРеквизиту("ИНН", ИНН);
		
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			
			Если СтрДлина(ИНН) = 10 Тогда
				РеквизитыКонтрагента = РаботаСКонтрагентами.РеквизитыЮридическогоЛицаПоИНН(ИНН);
			Иначе
				РеквизитыКонтрагента = РаботаСКонтрагентами.РеквизитыПредпринимателяПоИНН(ИНН);
			КонецЕсли;
			
			Если ТипЗнч(РеквизитыКонтрагента) = Тип("Структура") И НЕ ЗначениеЗаполнено(РеквизитыКонтрагента.ОписаниеОшибки) Тогда
				
				НовыйКонтрагент = Справочники.Контрагенты.СоздатьЭлемент();
				Если СтрДлина(ИНН) = 10 Тогда
					НовыйКонтрагент.ВидКонтрагента = Перечисления.ВидыКонтрагента.ЮридическоеЛицо;
				ИначеЕсли СтрДлина(ИНН) = 12 Тогда
					НовыйКонтрагент.ВидКонтрагента = Перечисления.ВидыКонтрагента.ИндивидуальныйПредприниматель;
				КонецЕсли;
				
				НовыйКонтрагент.Родитель = Справочники.Контрагенты.НайтиПоНаименованию("Автоматически созданные");
				ЗаполнитьЗначенияСвойств(НовыйКонтрагент, РеквизитыКонтрагента);
				НовыйКонтрагент.Записать();
				
				Сообщить("Создан контрагент: " + НовыйКонтрагент);
				
				Контрагент = НовыйКонтрагент.Ссылка;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Контрагент;
	
КонецФункции

&НаСервере
Функция ПолучитьБанковскийСчет(НомерСчета, БИК, Контрагент)
	
	СчетКонтрагента = Справочники.БанковскиеСчета.НайтиПоРеквизиту("НомерСчета", НомерСчета,, Контрагент);
	
	Если Не ЗначениеЗаполнено(СчетКонтрагента) Тогда
		
		Банк = Справочники.КлассификаторБанков.НайтиПоКоду(БИК);
		КодВалютыСчета = БанковскиеПравила.КодВалютыБанковскогоСчета(НомерСчета);
		ВалютаСчета = Справочники.Валюты.НайтиПоКоду(?(КодВалютыСчета = "810", "643", КодВалютыСчета));
		
		Если ЗначениеЗаполнено(Банк) Тогда
			
			НовыйСчетКонтрагента = Справочники.БанковскиеСчета.СоздатьЭлемент();
			НовыйСчетКонтрагента.Владелец = Контрагент;
			НовыйСчетКонтрагента.НомерСчета = НомерСчета;
			НовыйСчетКонтрагента.Банк = Банк;
			НовыйСчетКонтрагента.ВалютаДенежныхСредств = ВалютаСчета;
			НовыйСчетКонтрагента.Валютный = ВалютаСчета <> ПараметрыСеанса.ВалютаРегламентированногоУчета;
			НовыйСчетКонтрагента.ВидСчета = Перечисления.ВидыБанковскихСчетов.Текущий;
			НовыйСчетКонтрагента.Записать();
			
			СчетКонтрагента = НовыйСчетКонтрагента.Ссылка;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СчетКонтрагента;
	
КонецФункции

&НаКлиенте
Процедура СчетОрганизацииПриИзменении(Элемент)
	ЗаполнитьИнформациюПоСуществующимВыпискам();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюПоСуществующимВыпискам()
	
	Элементы.ДекорацияИнформация.Заголовок = "";
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(СчетОрганизации) И ЗначениеЗаполнено(Дата) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Выписка.Представление КАК Представление
		|ИЗ
		|	Документ.Выписка КАК Выписка
		|ГДЕ
		|	Выписка.Организация = &Организация
		|	И Выписка.СчетОрганизации = &СчетОрганизации
		|	И НАЧАЛОПЕРИОДА(Выписка.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
		|	И НЕ Выписка.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Выписка.Дата");
		
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("СчетОрганизации", СчетОрганизации);
		Запрос.УстановитьПараметр("Дата", Дата);
		
		Выборка = Запрос.Выполнить().Выбрать();

		СтекИнформации = Новый Массив;
		
		Пока Выборка.Следующий() Цикл
			
			Если СтекИнформации.Количество() = 0 Тогда
				СтекИнформации.Добавить(Новый ФорматированнаяСтрока("Существующие выписки:", Новый Шрифт(,, Истина,), WebЦвета.Синий)); 
				СтекИнформации.Добавить(Символы.ВК + Символы.ПС);
				СтекИнформации.Добавить(Символы.ВК + Символы.ПС);
				СтекИнформации.Добавить(Новый ФорматированнаяСтрока(Выборка.Представление, Новый Шрифт(,, Истина,), WebЦвета.ТемноЗеленый)); 
			Иначе
				СтекИнформации.Добавить(Символы.ВК + Символы.ПС);
				СтекИнформации.Добавить(Новый ФорматированнаяСтрока(Выборка.Представление, Новый Шрифт(,, Истина,), WebЦвета.ТемноЗеленый)); 
			КонецЕсли;

		КонецЦикла;
		
		СтрокаИнформации = Новый ФорматированнаяСтрока("");
		
		Для Каждого Элемент Из СтекИнформации Цикл
			СтрокаИнформации = Новый ФорматированнаяСтрока(СтрокаИнформации, Элемент);
		КонецЦикла;
		
		Элементы.ДекорацияИнформация.Заголовок = СтрокаИнформации;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТестRegExp(ТекстДляТестирования, ВыражениеRegExp)
	Возврат RegularExpressions.ТестRegExp(ТекстДляТестирования, ВыражениеRegExp);
КонецФункции

&НаСервере
Функция ПодстрокаRegExp(Текст, ВыражениеRegExp)
	Возврат RegularExpressions.ПодстрокаRegExp(Текст, ВыражениеRegExp);
КонецФункции



						