
#Область РаботаССоединением

Функция ПолучитьСоединениеАДО(ИмяБазы) Экспорт
	
	ИмяВладельцаБезопасныхДанных = "БазаДанных_" + СокрЛП(ИмяБазы);
	КлючиБезопасныхДанных = "ИмяСервера, ИмяБазыДанных, ИмяПользователя, Пароль";
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеПодключенияБазы = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ИмяВладельцаБезопасныхДанных, КлючиБезопасныхДанных);
	УстановитьПривилегированныйРежим(Ложь);
	
	ШаблонСтрокиСоединения = "Provider=SQLOLEDB.1; Persist Security Info=True; Data Source=%1; Initial Catalog=%2; User ID=%3; Password=%4;";
	
	СтрокаСоединения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ШаблонСтрокиСоединения, 
						ДанныеПодключенияБазы.ИмяСервера,
						ДанныеПодключенияБазы.ИмяБазыДанных,
						ДанныеПодключенияБазы.ИмяПользователя,
						ДанныеПодключенияБазы.Пароль);
	Попытка
		АДОСоединение = Новый COMОбъект("ADODB.Connection");
		АДОСоединение.ConnectionTimeOut = 600;
		АДОСоединение.CursorLocation = 3;
		АДОСоединение.Open(СтрокаСоединения);
		Возврат АДОСоединение;
	Исключение
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ЗакрытьСоединениеАДО(СоединениеАДО) Экспорт
	
	Если СоединениеАДО <> Неопределено Тогда
		СоединениеАДО.Close();
		СоединениеАДО = Неопределено;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ЗапросыАДО

Функция ВыполнитьЗапросАДО(СоединениеАДО, СтрокаЗапроса, ВТаблицуЗначений = Истина) Экспорт
	
	Если НЕ Константы.РаботаСОчередьюSQLРазрешена.Получить() Тогда // Переключим если надо
		
		// Блокируем на время теста
		БлокМассив = Новый Массив;
		БлокМассив.Добавить("INSERT");
		БлокМассив.Добавить("DELETE");
		БлокМассив.Добавить("UPDATE");
		БлокМассив.Добавить("SP_PM_REJECT");
		БлокМассив.Добавить("SP_PM_UNPAY");
		БлокМассив.Добавить("SP_PM_PAY");
		БлокМассив.Добавить("SP_PM_WAIT");
		
		Если Лев(СокрЛП(ВРЕГ(СтрокаЗапроса)), 6) <> "SELECT" Тогда
			
			Для Каждого Элемент Из БлокМассив Цикл
				
				Если Найти(ВРЕГ(СтрокаЗапроса), Элемент) > 0 Тогда
					Возврат Истина;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		// Конец блокирования
		
	КонецЕсли;
	
	ТЗ_Запроса = Новый ТаблицаЗначений;
	МассивЗапроса = Новый Массив;
	
	Попытка

		Command = Новый COMОбъект("ADODB.Command");
		Command.ActiveConnection = СоединениеАДО;
		Command.CommandText = СтрокаЗапроса;
		Command.CommandTimeout = 0;		//120;
		Command.CommandType = 1; 		//ТипКомандыАДО("adCmdText");

		// Опишем переменные свойств рекордсета
		adUseClient = 3;
		adOpenStatic = 3;
		adLockReadOnly = 1;
		
		RecordSet = Новый COMОбъект("ADODB.RecordSet");
		RecordSet.CursorLocation = adUseClient;
		RecordSet.CursorType = adOpenStatic;
		RecordSet.LockType = adLockReadOnly;

		RecordSet = Command.Execute();
		
		МассивКолонок = Новый Массив;
		Для т = 0 По RecordSet.Fields.Count - 1 Цикл
			ИмяКолонки = RecordSet.Fields.Item(т).Name;
			МассивКолонок.Добавить(ИмяКолонки);
			ТЗ_Запроса.Колонки.Добавить(ИмяКолонки);
		КонецЦикла;
		
		Пока RecordSet.EOF() = 0 Цикл
			
			Если ВТаблицуЗначений Тогда
				НоваяСтрока = ТЗ_Запроса.Добавить();
				Для Каждого ИмяКолонки Из МассивКолонок Цикл
					НоваяСтрока[ИмяКолонки] = RecordSet.Fields(ИмяКолонки).Value;
				КонецЦикла;
			Иначе
				СтруктураЗапроса = Новый Структура;
				Для Каждого ИмяКолонки Из МассивКолонок Цикл
					СтруктураЗапроса.Вставить(ИмяКолонки, RecordSet.Fields(ИмяКолонки).Value);
				КонецЦикла;
				МассивЗапроса.Добавить(СтруктураЗапроса);
			КонецЕсли;				
			
			RecordSet.MoveNext();	
			
		КонецЦикла;
		
		RecordSet.Close();
		Если ВТаблицуЗначений Тогда
			Возврат ТЗ_Запроса;
		Иначе
			Возврат МассивЗапроса;
		КонецЕсли;
		
	Исключение
		
		ВызватьИсключение ОписаниеОшибки();
		
	КонецПопытки;
	
	Возврат Неопределено;
	
КонецФункции

Функция ВыполнитьКомандуАДО(СоединениеАДО, СтрокаЗапроса, ВызыватьИсключение = Ложь) Экспорт
	
	Попытка

		Cmd = Новый COMОбъект("ADODB.Command");
		Cmd.ActiveConnection = СоединениеАДО;
		Cmd.CommandText = СтрокаЗапроса;
		Cmd.CommandTimeout = 120;
		Cmd.CommandType = 1; //ТипКомандыАДО("adCmdText");

		Cmd.Execute();
		
	Исключение
		
		Если ВызыватьИсключение Тогда
			ВызватьИсключение ОписаниеОшибки();
		КонецЕсли;
		
	КонецПопытки;
	
	Возврат Неопределено;
	
КонецФункции

Функция ВыполнитьЗапрос(СоединениеАДО, СтрокаЗапроса) Экспорт
	
	Попытка

		Cmd = Новый COMОбъект("ADODB.Command");
		Cmd.ActiveConnection = СоединениеАДО;
		Cmd.CommandText = СтрокаЗапроса;
		Cmd.CommandTimeout = 120;
		Cmd.CommandType = 1; //ТипКомандыАДО("adCmdText");

		Cmd.Execute();
		
		Возврат Истина;
		
	Исключение
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти