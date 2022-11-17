
Функция СтатьиДДСПриход() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СтатьиДДС.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(СтатистическийАнализ.ЧастотаИспользования, 0) КАК ЧастотаИспользования
	|ИЗ
	|	Справочник.СтатьиДДС КАК СтатьиДДС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатистическийАнализ КАК СтатистическийАнализ
	|		ПО СтатистическийАнализ.ОбъектАнализа = СтатьиДДС.Ссылка
	|ГДЕ
	|	СтатьиДДС.КатегорияДвиженияДенежныхСредств В (ЗНАЧЕНИЕ(Перечисление.КатегорииДвиженияДенежныхСредств.Поступление))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЧастотаИспользования УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивРезультат = Новый Массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		МассивРезультат.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

Функция СтатьиДДСРасход() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СтатьиДДС.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(СтатистическийАнализ.ЧастотаИспользования, 0) КАК ЧастотаИспользования
	|ИЗ
	|	Справочник.СтатьиДДС КАК СтатьиДДС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатистическийАнализ КАК СтатистическийАнализ
	|		ПО СтатистическийАнализ.ОбъектАнализа = СтатьиДДС.Ссылка
	|ГДЕ
	|	СтатьиДДС.КатегорияДвиженияДенежныхСредств В (ЗНАЧЕНИЕ(Перечисление.КатегорииДвиженияДенежныхСредств.Списание))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЧастотаИспользования УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивРезультат = Новый Массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		МассивРезультат.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции