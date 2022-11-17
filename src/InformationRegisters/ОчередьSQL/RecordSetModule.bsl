
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.TID = 0 Тогда
			Запись.TID = ТекущаяУниверсальнаяДатаВМиллисекундах();
			Запись.UID = Новый УникальныйИдентификатор();
			ЭтотОбъект.Отбор.TID.Установить(Запись.TID);
			ЭтотОбъект.Отбор.UID.Установить(Запись.UID);
		КонецЕсли;
	КонецЦикла;
	
	Задание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчередьSQL);
	Задание.Использование = Истина;
	Задание.Записать();
	
КонецПроцедуры
