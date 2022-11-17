&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДоговорКонтрагента") Тогда
		ДоговорКонтрагента = Параметры.ДоговорКонтрагента;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПривязкиДоговораКЦФУ, "ДоговорКонтрагента", ДоговорКонтрагента);
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ДоговорыКонтрагентовСвойства.КатегорияОперации КАК КатегорияОперации
		|ИЗ
		|	РегистрСведений.ДоговорыКонтрагентовСвойства КАК ДоговорыКонтрагентовСвойства
		|ГДЕ
		|	ДоговорыКонтрагентовСвойства.ДоговорКонтрагента = &ДоговорКонтрагента");
		
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			КатегорияОперации = Выборка.КатегорияОперации;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПривязкиДоговораКЦФУПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыОткрытия = Новый Структура("ДоговорКонтрагента", ДоговорКонтрагента);
	ОткрытьФорму("РегистрСведений.ПривязкиДоговоровЦФУ.Форма.ФормаЗаписи", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	Набор = РегистрыСведений.ДоговорыКонтрагентовСвойства.СоздатьНаборЗаписей();
	Набор.Отбор.ДоговорКонтрагента.Установить(ДоговорКонтрагента);
	
	Если ЗначениеЗаполнено(КатегорияОперации) Тогда
		Запись = Набор.Добавить();
		Запись.ДоговорКонтрагента = ДоговорКонтрагента;
		Запись.КатегорияОперации = КатегорияОперации;
	КонецЕсли;
	
	Набор.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ПриЗакрытииНаСервере();
	ОповеститьОбИзменении(Тип("СправочникСсылка.ДоговорыКонтрагентов"));
КонецПроцедуры


