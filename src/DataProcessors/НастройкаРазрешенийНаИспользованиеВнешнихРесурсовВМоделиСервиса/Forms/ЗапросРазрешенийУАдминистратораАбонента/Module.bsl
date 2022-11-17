#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВнешнийАдресУправляющегоПриложения = Константы.ВнешнийАдресУправляющегоПриложения.Получить();
	ИдентификаторПакета = Параметры.ИдентификаторПакета;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОжиданиеПримененияЗапросаРазрешений", 5, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОбработкаЗапросовЗаголовокОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "internal://sm" Тогда
		
		СтандартнаяОбработка = Ложь;
		ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(ВнешнийАдресУправляющегоПриложения + "?N=" + ИмяПользователя() + "&C=PermissionRequest" + Строка(ИдентификаторПакета));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОжиданиеПримененияЗапросаРазрешений()
	
	Результат = РезультатОбработкиЗапросов(ИдентификаторПакета);
	
	Если Результат = Неопределено Тогда
		ПодключитьОбработчикОжидания("ОжиданиеПримененияЗапросаРазрешений", 5, Истина);
	Иначе
		
		Если Результат Тогда
			
			Закрыть(КодВозвратаДиалога.ОК);
			
		Иначе
			
			Закрыть(КодВозвратаДиалога.Отмена);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РезультатОбработкиЗапросов(Знач ИдентификаторПакета)
	
	Результат = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.РезультатОбработкиПакета(ИдентификаторПакета);
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Если Результат = Перечисления.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса.ЗапросОдобрен Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
