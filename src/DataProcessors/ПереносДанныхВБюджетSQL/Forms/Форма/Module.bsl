
&НаСервере
Процедура ЗагрузкаЦФУНаСервере()
	_ЗапускРегламентныхЗаданий.АвтоматическаяЗагрузкаЦФУ();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаЦФУ(Команда)
	ЗагрузкаЦФУНаСервере();
	ПоказатьПредупреждение(, "Работа окончена!");
КонецПроцедуры

&НаСервере
Функция ВыгрузкаДанныхВФайлНаСервере()
	
	ПравилаОбмена = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ПравилаОбмена");
	ИмяФайлаПравилОбмена = ПолучитьИмяВременногоФайла("xml");
	
	ИмяФайлаДанных = ПолучитьИмяВременногоФайла("xml");
	
	ПравилаОбмена.Записать(ИмяФайлаПравилОбмена);
	
	Обработка = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	Обработка.РежимОбмена = "Выгрузка";
	Обработка.ИмяФайлаОбмена = ИмяФайлаДанных;
	Обработка.ИмяФайлаПравилОбмена = ИмяФайлаПравилОбмена;
	Обработка.НеВыводитьНикакихИнформационныхСообщенийПользователю = Истина;
	
	АдресВХранилище = Новый УникальныйИдентификатор;
	ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Обработка.ИмяФайлаПравилОбмена), АдресВХранилище);
	
	ФайлОбмена = Новый ЧтениеXML();
	ФайлОбмена.ОткрытьФайл(Обработка.ИмяФайлаПравилОбмена);
	
	Обработка.ВыполнитьВыгрузку();
	
	АдресВХранилище = Новый УникальныйИдентификатор;
	Возврат ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Обработка.ИмяФайлаОбмена), АдресВХранилище);
	
КонецФункции

&НаКлиенте
Процедура ВыгрузкаДанныхВФайл(Команда)
	
	АдресФайлаРезультата = ВыгрузкаДанныхВФайлНаСервере();
	ИмяФайла = Нстр("ru = 'Файл выгрузки.xml'");
	ПолучитьФайл(АдресФайлаРезультата, ИмяФайла);
	
КонецПроцедуры