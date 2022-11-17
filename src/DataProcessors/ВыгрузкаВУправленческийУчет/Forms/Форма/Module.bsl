
Функция ПолучитьСтруктуруДанных(НачалоПериода, ОкончаниеПериода)
	
	Запрос = Новый Запрос;
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ДенежныеСредстваОбороты.Регистратор КАК Регистратор
	//|ПОМЕСТИТЬ ВТ_Регистраторы
	//|ИЗ
	//|	РегистрНакопления.ДенежныеСредства.Обороты(&НачалоПериода, &ОкончаниеПериода, Регистратор, ) КАК ДенежныеСредстваОбороты
	//|
	//|ИНДЕКСИРОВАТЬ ПО
	//|	Регистратор
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.Дата КАК ДатаОперации,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.Организация.НаименованиеСокращенное КАК НаименованиеОрганизации,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.Организация.ИНН КАК ОрганизацияИНН,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.Организация.КПП КАК ОрганизацияКПП,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.СчетОрганизации.Банк.Код КАК БанкБИК,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.СчетОрганизации.НомерСчета КАК БанковскийСчетНомерСчета,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.КатегорияОперации.Код КАК КатегорияОперацииКод,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.Контрагент.НаименованиеСокращенное КАК КонтрагентНаименование,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.Контрагент.ИНН КАК КонтрагентИНН,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.Контрагент.КПП КАК КонтрагентКПП,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.СчетОрганизации.Банк.Код КАК КонтрагентБанкКод,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.СчетОрганизации.НомерСчета КАК КонтрагентНомерСчета,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.Сумма КАК СуммаПриход,
	//|	0 КАК СуммаРасход,
	//|	0 КАК СуммаНДС,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка.СтатьяДДС КАК ТипДвиженияДенежныхСредств,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Имя КАК ТаблицаИмя,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Значение КАК ТаблицаЗначение,
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.ВидПараметра.ТипСтрокой КАК ТаблицаТипЗначение
	//|ИЗ
	//|	Документ.ПоступлениеНаРасчетныйСчет.УправленческийУчет КАК ПоступлениеНаРасчетныйСчетУправленческийУчет
	//|ГДЕ
	//|	ПоступлениеНаРасчетныйСчетУправленческийУчет.Ссылка В
	//|			(ВЫБРАТЬ
	//|				ВТ_Регистраторы.Регистратор КАК Регистратор
	//|			ИЗ
	//|				ВТ_Регистраторы КАК ВТ_Регистраторы)
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.Дата,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.Организация.НаименованиеСокращенное,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.Организация.ИНН,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.Организация.КПП,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.СчетОрганизации.Банк.Код,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.СчетОрганизации.НомерСчета,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.КатегорияОперации.Код,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.Контрагент.НаименованиеСокращенное,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.Контрагент.ИНН,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.Контрагент.КПП,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.СчетОрганизации.Банк.Код,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.СчетОрганизации.НомерСчета,
	//|	0,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.Сумма,
	//|	0,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка.СтатьяДДС,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Имя,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Значение,
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.ВидПараметра.ТипСтрокой
	//|ИЗ
	//|	Документ.СписаниеСРасчетногоСчета.УправленческийУчет КАК СписаниеСРасчетногоСчетаУправленческийУчет
	//|ГДЕ
	//|	СписаниеСРасчетногоСчетаУправленческийУчет.Ссылка В
	//|			(ВЫБРАТЬ
	//|				ВТ_Регистраторы.Регистратор КАК Регистратор
	//|			ИЗ
	//|				ВТ_Регистраторы КАК ВТ_Регистраторы)
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	ДатаОперации,
	//|	НаименованиеОрганизации,
	//|	БанкБИК,
	//|	КонтрагентНаименование
	//|ИТОГИ ПО
	//|	ДатаОперации,
	//|	НаименованиеОрганизации,
	//|	ОрганизацияИНН,
	//|	ОрганизацияКПП,
	//|	БанкБИК,
	//|	БанковскийСчетНомерСчета,
	//|	КатегорияОперацииКод,
	//|	КонтрагентНаименование,
	//|	КонтрагентИНН,
	//|	КонтрагентКПП,
	//|	КонтрагентБанкКод,
	//|	КонтрагентНомерСчета,
	//|	СуммаПриход,
	//|	СуммаРасход,
	//|	СуммаНДС,
	//|	ТипДвиженияДенежныхСредств";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ОкончаниеПериода);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВыгрузки = Новый Структура;
	СтруктураВыгрузки.Вставить("Код", "00001");
	СтруктураВыгрузки.Вставить("Имя", "Движения по р/сч");
	СтруктураВыгрузки.Вставить("Данные", Новый Массив);
	
	ВыборкаДатаОперации = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДатаОперации.Следующий() Цикл
	
		ВыборкаНаименованиеОрганизации = ВыборкаДатаОперации.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНаименованиеОрганизации.Следующий() Цикл
			
			ВыборкаОрганизацияИНН = ВыборкаНаименованиеОрганизации.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаОрганизацияИНН.Следующий() Цикл
				
				ВыборкаОрганизацияКПП = ВыборкаОрганизацияИНН.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаОрганизацияКПП.Следующий() Цикл
					
					ВыборкаБанкБИК = ВыборкаОрганизацияКПП.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаБанкБИК.Следующий() Цикл
	
						ВыборкаБанковскийСчетНомерСчета = ВыборкаБанкБИК.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						Пока ВыборкаБанковскийСчетНомерСчета.Следующий() Цикл
							
							СтруктураДанные = Новый Структура;
							СтруктураДанные.Вставить("Банк", ВыборкаБанковскийСчетНомерСчета.БанкБИК);
							СтруктураДанные.Вставить("ИНН", СокрЛП(ВыборкаБанковскийСчетНомерСчета.ОрганизацияИНН) + "/" + СокрЛП(ВыборкаБанковскийСчетНомерСчета.ОрганизацияКПП));
							СтруктураДанные.Вставить("ИМЯФИРМЫ", СокрЛП(ВыборкаБанковскийСчетНомерСчета.НаименованиеОрганизации));
							СтруктураДанные.Вставить("Счет", СокрЛП(ВыборкаБанковскийСчетНомерСчета.БанковскийСчетНомерСчета));
							СтруктураДанные.Вставить("ДатаОперации", Формат(ВыборкаБанковскийСчетНомерСчета.ДатаОперации, "ДФ=dd.MM.yyyy"));
							СтруктураДанные.Вставить("СтрокаВыписки", Новый Массив);
							
							СтруктураВыгрузки.Данные.Добавить(СтруктураДанные);
	
							ВыборкаКатегорияОперацииКод = ВыборкаБанковскийСчетНомерСчета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
							Пока ВыборкаКатегорияОперацииКод.Следующий() Цикл
	
								ВыборкаКонтрагентНаименование = ВыборкаКатегорияОперацииКод.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
								Пока ВыборкаКонтрагентНаименование.Следующий() Цикл
	
									ВыборкаКонтрагентИНН = ВыборкаКонтрагентНаименование.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
									Пока ВыборкаКонтрагентИНН.Следующий() Цикл
	
										ВыборкаКонтрагентКПП = ВыборкаКонтрагентИНН.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
										Пока ВыборкаКонтрагентКПП.Следующий() Цикл
	
											ВыборкаКонтрагентБанкКод = ВыборкаКонтрагентКПП.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
											Пока ВыборкаКонтрагентБанкКод.Следующий() Цикл
	
												ВыборкаКонтрагентНомерСчета = ВыборкаКонтрагентБанкКод.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
												Пока ВыборкаКонтрагентНомерСчета.Следующий() Цикл
		
													ВыборкаСуммаПриход = ВыборкаКонтрагентНомерСчета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
													Пока ВыборкаСуммаПриход.Следующий() Цикл
		
														ВыборкаСуммаРасход = ВыборкаСуммаПриход.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
														Пока ВыборкаСуммаРасход.Следующий() Цикл
		
															ВыборкаСуммаНДС = ВыборкаСуммаРасход.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
															Пока ВыборкаСуммаНДС.Следующий() Цикл
		
																ВыборкаТипДвиженияДенежныхСредств = ВыборкаСуммаНДС.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
																Пока ВыборкаТипДвиженияДенежныхСредств.Следующий() Цикл
																	
																	СтруктураСтрокаВыписки = Новый Структура;
																	СтруктураДанные.СтрокаВыписки.Добавить(СтруктураСтрокаВыписки);
																	
																	СтруктураСтрокаВыписки.Вставить("КатегорияОперации", ВыборкаТипДвиженияДенежныхСредств.КатегорияОперацииКод);
																	
																	КонтрагентИНН = СокрЛП(ВыборкаТипДвиженияДенежныхСредств.КонтрагентИНН);
																	КонтрагентКПП = СокрЛП(ВыборкаТипДвиженияДенежныхСредств.КонтрагентКПП);
																	
																	Если ЗначениеЗаполнено(КонтрагентКПП) Тогда
																		СтруктураСтрокаВыписки.Вставить("КлиентИНН", КонтрагентИНН + "/" + КонтрагентКПП);
																	Иначе
																		СтруктураСтрокаВыписки.Вставить("КлиентИНН", КонтрагентИНН);
																	КонецЕсли;
																	
																	СтруктураСтрокаВыписки.Вставить("КлиентИмя", СокрЛП(ВыборкаТипДвиженияДенежныхСредств.КонтрагентНаименование));
																	СтруктураСтрокаВыписки.Вставить("КлиентБанк", СокрЛП(ВыборкаТипДвиженияДенежныхСредств.КонтрагентБанкКод));
																	СтруктураСтрокаВыписки.Вставить("КлиентСчет", СокрЛП(ВыборкаТипДвиженияДенежныхСредств.КонтрагентНомерСчета));
																	СтруктураСтрокаВыписки.Вставить("Приход", Формат(ВыборкаТипДвиженияДенежныхСредств.СуммаПриход, "ЧЦ=15; ЧДЦ=2; ЧН=0"));
																	СтруктураСтрокаВыписки.Вставить("Расход", Формат(ВыборкаТипДвиженияДенежныхСредств.СуммаРасход, "ЧЦ=15; ЧДЦ=2; ЧН=0"));
																	СтруктураСтрокаВыписки.Вставить("СуммаНДС", Формат(ВыборкаТипДвиженияДенежныхСредств.СуммаНДС, "ЧЦ=15; ЧДЦ=2; ЧН=0"));
																	СтруктураСтрокаВыписки.Вставить("ТипДвижения", СокрЛП(ВыборкаТипДвиженияДенежныхСредств.ТипДвиженияДенежныхСредств));
																	
																	СтруктураСтрокаВыписки.Вставить("Параметры", Новый Массив);
																	
																	
																	// Обработка параметров
																	ВыборкаДетальныеЗаписи = ВыборкаТипДвиженияДенежныхСредств.Выбрать();
																	
																	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
																		
																		СтруктураДанныеПараметры = Новый Структура;
																		СтруктураДанныеПараметры.Вставить("Имя", ВыборкаДетальныеЗаписи.ТаблицаИмя);
																		СтруктураДанныеПараметры.Вставить("ТипЗначение", СокрЛП(ВыборкаДетальныеЗаписи.ТаблицаТипЗначение));
																		
																		Значение = ВыборкаДетальныеЗаписи.ТаблицаЗначение;
																		
																		Если ТипЗнч(Значение) = Тип("Строка") Тогда
																			СтруктураДанныеПараметры.Вставить("Значение", СокрЛП(Значение));
																			
																		ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
																			СтруктураДанныеПараметры.Вставить("Значение", СокрЛП(Значение));
																			
																		ИначеЕсли ТипЗнч(Значение) = Тип("Булево") Тогда
																			СтруктураДанныеПараметры.Вставить("Значение", ?(Значение, "Да", "Нет"));
																			
																		ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ЦФУ")
																			ИЛИ ТипЗнч(Значение) = Тип("СправочникСсылка.Брэнды")
																			ИЛИ ТипЗнч(Значение) = Тип("СправочникСсылка.ЗначенияСубконтоУправленческогоУчета") Тогда
																			
																			СтруктураДанныеПараметры.Вставить("Значение", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Значение, "Код"));	
																			
																		ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Валюты") Тогда
																			
																			КодВалюты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Значение, "Код");
																			Если КодВалюты = "643" Тогда
																				КодВалюты = "810";
																			КонецЕсли;
																			
																			СтруктураДанныеПараметры.Вставить("Значение", КодВалюты);
																			
																		ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
																			
																			ЗапросДанных = Новый Запрос("ВЫБРАТЬ
																			|	БанковскиеСчета.НомерСчета КАК НомерСчета,
																			|	БанковскиеСчета.Банк.Код КАК БИК
																			|ИЗ
																			|	Справочник.БанковскиеСчета КАК БанковскиеСчета
																			|ГДЕ
																			|	БанковскиеСчета.Ссылка = &Ссылка");
																			
																			ЗапросДанных.УстановитьПараметр("Ссылка", Значение);
																			ВыборкаДанных = ЗапросДанных.Выполнить().Выбрать();
																			Если ВыборкаДанных.Следующий() Тогда
																				СтруктураДанныеПараметры.Вставить("Значение", СокрЛП(ВыборкаДанных.НомерСчета) + "@" + СокрЛП(ВыборкаДанных.БИК));
																				СтруктураДанныеПараметры.Вставить("ТипЗначение", "СправочникСсылка.Счета");
																			КонецЕсли;
																			
																		Иначе
																			
																			СтруктураДанныеПараметры.Вставить("Значение", "");
																			
																		КонецЕсли;
																		 
																		СтруктураСтрокаВыписки.Параметры.Добавить(СтруктураДанныеПараметры);
																		
																	КонецЦикла;
																КонецЦикла;
															КонецЦикла;
														КонецЦикла;
													КонецЦикла;
												КонецЦикла;
											КонецЦикла;
										КонецЦикла;
									КонецЦикла;
								КонецЦикла;
							КонецЦикла;
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат СтруктураВыгрузки;
	
КонецФункции

&НаСервере
Процедура ВыгрузитьНаСервере()
	
	СтруктураВыгрузки = ПолучитьСтруктуруДанных(Период.ДатаНачала, Период.ДатаОкончания);
	
	ЗаписьXML = Новый ЗаписьXML();
	
	ВремКаталог = КаталогВременныхФайлов() + "IVM_temp";
	ИмяФайла = ВремКаталог + "\" + СокрЛП(Подразделение) + СтрЗаменить(Формат(ТекущаяДата(),"ДФ=dd.MM.yy"),".","") + ".xml";
	
	ЗаписьXML.ОткрытьФайл(ИмяФайла);
	
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("КатегорииДокументов");
	ЗаписатьАтрибутыСтруктуры(ЗаписьXML, СтруктураВыгрузки); 
	
	Для Каждого ЭлементМассиваДанные Из СтруктураВыгрузки.Данные Цикл
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("Данные");
		ЗаписатьАтрибутыСтруктуры(ЗаписьXML, ЭлементМассиваДанные);
		
		Для Каждого ЭлементМассиваСтрокаВыписки Из ЭлементМассиваДанные.СтрокаВыписки Цикл
			
			ЗаписьXML.ЗаписатьНачалоЭлемента("СтрокаВыписки");
			ЗаписатьАтрибутыСтруктуры(ЗаписьXML, ЭлементМассиваСтрокаВыписки);
			
			ЗаписьXML.ЗаписатьНачалоЭлемента("Параметры");
			
			Для Каждого ЭлементМассиваПараметры Из ЭлементМассиваСтрокаВыписки.Параметры Цикл
				
				ЗаписьXML.ЗаписатьНачалоЭлемента("ДанныеПараметры");
				ЗаписатьАтрибутыСтруктуры(ЗаписьXML, ЭлементМассиваПараметры);
				ЗаписьXML.ЗаписатьКонецЭлемента(); // ДанныеПараметры
				
			КонецЦикла;
			
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Параметры
			
			ЗаписьXML.ЗаписатьКонецЭлемента(); // СтрокаВыписки
			
		КонецЦикла;
		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Данные
			
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента(); //КатегорииДокументов
	ЗаписьXML.Закрыть(); 
	
КонецПроцедуры

Процедура ЗаписатьАтрибутыСтруктуры(ЗаписьXML, Структура)
	
	Для Каждого КлючЗначение Из Структура Цикл
		
		Если ТипЗнч(КлючЗначение.Значение) <> Тип("Структура")
			И ТипЗнч(КлючЗначение.Значение) <> Тип("Массив") Тогда
			
			ЗаписьXML.ЗаписатьАтрибут(КлючЗначение.Ключ, КлючЗначение.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура Выгрузить(Команда)
	ВыгрузитьНаСервере();
	ПоказатьПредупреждение(, "Работа окончена!");
КонецПроцедуры
