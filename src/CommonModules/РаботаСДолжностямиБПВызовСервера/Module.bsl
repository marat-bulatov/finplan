#Область ПрограммныйИнтерфейс

// Добавляет в данные выбора поля типа СправочникСсылка.Должности
// "предопределенные" элементы из макета СклоненияДолжностейЛицСПравомПодписи.
//
// Параметры:
//   ДолжностиПодписантов - Неопределено, СписокЗначений - Реквизит формы, список наименований должностей
//   Параметры - Структура - параметр "ПараметрыПолученияДанных" обработчика АвтоПодбор
//
// Возвращаемое значение:
//   СписокЗначений - см. описание метода ПолучитьДанныеВыбора менеджера справочника
//
Функция ДанныеВыбора(ДолжностиПодписантов, Параметры) Экспорт
	
	ДанныеВыбора = Справочники.Должности.ПолучитьДанныеВыбора(Параметры);
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Справочники.Должности) Тогда
		Возврат ДанныеВыбора;
	КонецЕсли;
	
	Если ДолжностиПодписантов = Неопределено Тогда
		ДолжностиПодписантов = ДолжностиПодписантовДляВыбора();
	КонецЕсли;

	ШрифтКоманды   = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста);
	ШрифтПодстроки = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина);
	ЦветПодстроки  = ЦветаСтиля.ЦветУспешногоПоиска;
	
	СтрокаПоиска = Параметры.СтрокаПоиска;
	
	НаименованияДолжностей = Новый ТаблицаЗначений;
	НаименованияДолжностей.Колонки.Добавить("Наименование", ОбщегоНазначения.ОписаниеТипаСтрока(150));
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(НаименованияДолжностей,
		ДолжностиПодписантов.ВыгрузитьЗначения(), "Наименование");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДолжностиПодписантов.Наименование КАК Наименование
	|ПОМЕСТИТЬ ДолжностиПодписантов
	|ИЗ
	|	&НаименованияДолжностей КАК ДолжностиПодписантов
	|ГДЕ
	|	ДолжностиПодписантов.Наименование ПОДОБНО &Наименование
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДолжностиПодписантов.Наименование
	|ИЗ
	|	ДолжностиПодписантов КАК ДолжностиПодписантов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Должности КАК Должности
	|		ПО (Должности.Наименование = ДолжностиПодписантов.Наименование)
	|ГДЕ
	|	Должности.Ссылка ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("НаименованияДолжностей", НаименованияДолжностей);
	Запрос.УстановитьПараметр("Наименование", СтрокаПоиска + "%");
	Должности = Запрос.Выполнить().Выгрузить();
	
	Для каждого Должность из Должности Цикл
		СтрокаПодобранная = Сред(Должность.Наименование, СтрДлина(СтрокаПоиска)+1);
		СтрокаПодбора = Лев(Должность.Наименование, СтрДлина(СтрокаПоиска));
		Представление = Новый ФорматированнаяСтрока(
			Новый ФорматированнаяСтрока(СтрокаПодбора, ШрифтПодстроки, ЦветПодстроки),
			Новый ФорматированнаяСтрока(СтрокаПодобранная, ШрифтКоманды)
			);
		ДанныеВыбора.Добавить(Должность.Наименование, Представление);
	КонецЦикла;
		
	
	Возврат ДанныеВыбора;
	
КонецФункции

// Добавляет в справочник Должности из макета СклоненияДолжностейЛицСПравомПодписи.
//
// Параметры:
//   НаименованиеДолжности - Строка - Наименование новой должности.
//
// Возвращаемое значение:
//   СправочникСсылка.Должности - ссылка на созданную должность.
//
Функция ДобавитьДолжностьИзМакета(НаименованиеДолжности) Экспорт
	
	НоваяДолжность = Справочники.Должности.СоздатьЭлемент();
	НоваяДолжность.Наименование        = НаименованиеДолжности;
	НоваяДолжность.НаименованиеКраткое = НоваяДолжность.Наименование;
	НоваяДолжность.Записать();
	
	Возврат НоваяДолжность.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДолжностиПодписантовДляВыбора()
	
	СписокДолжностей = Новый СписокЗначений();
	СписокДолжностей.ЗагрузитьЗначения(РаботаСДолжностямиБП.ДолжностиПодписантов().ВыгрузитьКолонку("ИменительныйПадеж"));
	Возврат СписокДолжностей;
	
КонецФункции

#КонецОбласти