
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("Статус") Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""Статус"".'");
	КонецЕсли;
	
	ЗначениеРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Параметры.Статус,
		"Название, Описание");
	ЭтотОбъект.Заголовок = ЗначениеРеквизитов.Название;
	
	ЧастиОписания = Новый Массив;
	ЧастиОписания.Добавить(ЗначениеРеквизитов.Описание);
	ЧастиОписания.Добавить(".");
	ЧастиОписания.Добавить(Символы.ПС);
	ЧастиОписания.Добавить(Новый ФорматированнаяСтрока(
		НСтр("ru = 'Подробнее о сервисе'"),
		,
		,
		,
		СПАРКРискиКлиентСервер.АдресСтраницыОписанияСервисаСПАРКРиски()));
	Элементы.ДекорацияОписание.Заголовок = Новый ФорматированнаяСтрока(ЧастиОписания);
	
КонецПроцедуры

#КонецОбласти