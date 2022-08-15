# sbp

Flutter плагин, с помощью которого можно получить список банков установленных на устройстве 
пользователя, а также запустить ссылку на оплату по СБП вида https://qr.nspk.ru/.../

<p float="left">
 <img src="/docs/sbp/screenshots/sbp_android1.jpg?raw=true" height="600">
 <img src="/docs/sbp/screenshots/sbp_android2.jpg?raw=true" height="600">
</p>

## Добавление зависимостей
Для использования плагина добавьте его в pubspec.yaml файл.

## Установка

### IOS

Добавьте URL schemes в `LSApplicationQueriesSchemes` в `Info.plist` файл:
Этот список нужен для того, чтобы дать возможность открывать сторонние установленные приложения на 
IOS. Список поддерживаемых СБП банков можно получить по ссылке [c2bmembers.json](https://qr.nspk.ru/proxyapp/c2bmembers.json).

```
 <key>LSApplicationQueriesSchemes</key>
  <array>
    <string>bank100000000000</string>
    <string>bank100000000001</string>
    ...
    <string>bank100000000999</string>
    <string>bank100000001000</string>
  </array>
```

<b>Предупреждение!</b> Начиная с iOS 15 максимальное количество списка scheme не должно быть больше
50.Детальную информацию можно получить по этой [ссылке](https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl#discussion)

## Описание функций

Для использования sbp и получения текущей информации по поддерживаемым банкам СБП нужно поднять 
собственный сервер, который будет раз в какой-то период подтягивать новую информацию по банкам.  
<b>Предупреждение!</b>Если будете пользоваться json, не забудьте поменять ссылки на картинки в файле
/sbp/lib/data/c2bmembers_data.dart так, как они грузятся долго или не грузятся вообще.

Ссылки с текущими банками с оффициального сайта СБП
* [Android](https://qr.nspk.ru/.well-known/assetlinks.json)
* [IOS](https://qr.nspk.ru/proxyapp/c2bmembers.json)

Либо можно воспользоваться текущим json добавленным мною в проект 11.08.2022:
* Android: /sbp/lib/data/asset_links_data.dart
* IOS: /sbp/lib/data/c2bmembers_data.dart

<b>Sbp.getAndroidInstalledByAssetLinksJsonBanks(List<Map<String, dynamic>> assetLinks): Android</b>  
Передается переменная(json /sbp/lib/data/asset_links_data.dart), которая парсится и возвращает List<ApplicationInfoModel>.
<b>ApplicationInfoModel</b> содержит в себе поля такие как:
* name - имя приложения
* packageName - packageName приложения
* bitmap - bitmap иконки приложения

<b>Sbp.getIOSInstalledByC2bmembersJsonBanks(Map<String, dynamic> c2bmembersData): IOS</b>  
Передается переменная(json /sbp/lib/data/c2bmembers_data.dart), которая парсится и возвращает
<b>List<C2bmembersModel></b>.
<b>C2bmembersModel</b> содержит в себе поля такие как:
* version - версия json
* c2bmembersModel - <b>List<C2bmemberModel></b> установленных приложений
  * <b>C2bmemberModel</b> содержит в себе поля такие как:
    * bankName - имя банка
    * logoURL - ссылка на картинку
    * schema - schema приложения
    * packageName - packageName приложения

Также я предусмотрел то, что json может поменяться(если поднимать свой сервер с подкачкой данных)  

<b>Sbp.getAndroidInstalledByPackageNameBanks(List<String> packageNames) : Android</b>  
Передаем список packageNames поддерживаемых СБП банков. Возвращается List<String> packageNames,
которые установлены на устройстве пользователя

<b>Sbp.getIOSInstalledBySchemesBanks(List<String> schemes)</b>  
Передаем список schemas поддерживаемых СБП банков. List<String> schemes,
которые установлены на устройстве пользователя


<b>Sbp.openAndroidBank(String url, String packageName)</b>  
Передаем url вида https://qr.nspk.ru/.../ и packageName приложения, в котором нужно открыть СБП

<b>Sbp.openIOSBank(String url, String packageName)</b>  
Передаем url вида https://qr.nspk.ru/.../ и schema приложения, в котором нужно открыть СБП