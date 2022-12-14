&НаКлиенте
Перем НужноЗакрыватьФорму;


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СсылкаПрисоединенныйФайл = Параметры.Ссылка;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	Кому КАК Кому,
	|	Дата КАК Дата
	|ИЗ
	|	Справочник.%1.КонтрольКопий
	|ГДЕ
	|	Ссылка = &Ссылка";
	
	Запрос = Новый Запрос(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗапроса, СсылкаПрисоединенныйФайл.Метаданные().Имя));
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаПрисоединенныйФайл);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаКопий.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Если НужноЗакрыватьФорму = Неопределено ИЛИ НЕ НужноЗакрыватьФорму Тогда
		
			Отказ = Истина;
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), "Сохранить данные?", РежимДиалогаВопрос.ДаНетОтмена);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		СохранитьДанныеНаСервере();
		НужноЗакрыватьФорму = Истина;
		Закрыть();
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		НужноЗакрыватьФорму = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	ПрисоединенныйФайлОбъект = СсылкаПрисоединенныйФайл.ПолучитьОбъект();
	ПрисоединенныйФайлОбъект.КонтрольКопий.Очистить();
	
	Для Каждого СтрокаТЧ Из ТаблицаКопий Цикл
			
		ЗаполнитьЗначенияСвойств(ПрисоединенныйФайлОбъект.КонтрольКопий.Добавить(), СтрокаТЧ); 
			
	КонецЦикла;
	ПрисоединенныйФайлОбъект.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКопийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры



