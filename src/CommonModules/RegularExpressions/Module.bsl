
#Область СлужебныеПроцедурыИФункции
Функция ПолучитьОбъектRegExp() Экспорт
	
	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.IgnoreCase = Истина; //Игнорировать регистр
    RegExp.Global = Истина; //Поиск всех вхождений шаблона
    RegExp.MultiLine = Истина; //Многострочный режим

	Возврат(RegExp);
	
КонецФункции

Функция ТестRegExp(ТекстДляТестирования, ВыражениеRegExp) Экспорт
	
	RegExp = ПолучитьОбъектRegExp();
	RegExp.Pattern = ВыражениеRegExp;
	
	Результат = RegExp.Test(ТекстДляТестирования);
	RegExp = Неопределено;
	Возврат Результат;
	
КонецФункции

Функция ReplaceRegExp(ИсходныйТекст, ВыражениеRegExp, ТекстЗамены = "") Экспорт
	
	RegExp = ПолучитьОбъектRegExp();
	RegExp.Pattern = ВыражениеRegExp;
	
	Результат = RegExp.Replace(ИсходныйТекст, ТекстЗамены);
	RegExp = Неопределено;
	Возврат Результат;
	
КонецФункции

Функция ПодстрокаRegExp(Текст, ВыражениеRegExp) Экспорт
	
	RegExp = ПолучитьОбъектRegExp();
	RegExp.Pattern = ВыражениеRegExp;
	
	Matches = RegExp.Execute(Текст);
	Если Matches.Count > 0 Тогда
		Результат = Matches.Item(0).Value;
	Иначе
		Результат = "";
	КонецЕсли;
	
	RegExp = Неопределено;
	Возврат Результат;
	
КонецФункции

Функция ТестСтроки(ТекстДляТестирования, ВыражениеТестирования) Экспорт
	
    Чтение = Новый ЧтениеXML;
    Чтение.УстановитьСтроку(
                "<Model xmlns=""http://v8.1c.ru/8.1/xdto"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:type=""Model"">
                |<package targetNamespace=""sample-my-package"">
                |<valueType name=""testtypes"" base=""xs:string"">
                |<pattern>" + ВыражениеТестирования + "</pattern>
                |</valueType>
                |<objectType name=""TestObj"">
                |<property xmlns:d4p1=""sample-my-package"" name=""TestItem"" type=""d4p1:testtypes""/>
                |</objectType>
                |</package>
                |</Model>");

    Модель = ФабрикаXDTO.ПрочитатьXML(Чтение);
    МояФабрикаXDTO = Новый ФабрикаXDTO(Модель);
    Пакет = МояФабрикаXDTO.Пакеты.Получить("sample-my-package");
    Тест = МояФабрикаXDTO.Создать(Пакет.Получить("TestObj"));

    Попытка
        Тест.TestItem = ТекстДляТестирования;
        Возврат Истина
    Исключение
        Возврат Ложь
    КонецПопытки;
	
КонецФункции
#КонецОбласти