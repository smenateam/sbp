# sbp

Flutter плагин, с помощью которого можно получить список банков установленных на устройстве 
пользователя, а также запустить ссылку на оплату по СБП вида https://qr.nspk.ru/.../

## Добавление зависимостей
Для использования плагина добавьте его в pubspec.yaml файл.

## Установка

### IOS

Добавьте URL schemes в `LSApplicationQueriesSchemes` в `Info.plist` файл:
Этот список нужен для того, чтобы дать возможность открывать сторонние установленные приложения на 
IOS. Список поддерживаемых СБП банков можно получить по ссылке [c2bmembers.json](https://qr.nspk.ru/proxyapp/c2bmembers.json).
<b>Предупреждение!</b> Начиная с iOS 15 максимальное количество списка scheme не должно быть больше
50.Детальную информацию можно получить по этой [ссылке](https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl#discussion)


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

## Описание функций

Для использования sbp и получения текущей информации по поддерживаемым банкам СБП нужно поднять 
собственный сервер, который будет раз в какой-то период подтягивать новую информацию по банкам
Ссылки с текущими банками с оффициального сайта СБП
* [Android](https://qr.nspk.ru/.well-known/assetlinks.json)
* [IOS](https://qr.nspk.ru/proxyapp/c2bmembers.json)

Либо можно воспользоваться текущим json добавленным мною в проект 11.08.2022:
* Android: /sbp/lib/asset_links_data.dart
* IOS: /sbp/lib/c2bmembers_data.dart

Sbp.getAndroidInstalledByAssetLinksJsonBanks(List<Map<String, dynamic>> assetLinks): Android
Передается переменная(json /sbp/lib/asset_links_data.dart), которая парсится и возвращает 
List<ApplicationInfoModel>. 
ApplicationInfoModel содержит в себе поля такие как:
* name - имя приложения
* packageName - packageName приложения
* bitmap - bitmap иконки приложения

Sbp.getIOSInstalledByC2bmembersJsonBanks(Map<String, dynamic> c2bmembersData): IOS
Передается переменная(json /sbp/lib/c2bmembers_data.dart), которая парсится и возвращает
List<C2bmembersModel>.
C2bmembersModel содержит в себе поля такие как:
* version - версия json
* c2bmembersModel - List<C2bmemberModel> установленных приложений
  * C2bmemberModel содержит в себе поля такие как:
    * bankName - имя банка
    * logoURL - ссылка на картинку
    * schema - schema приложения
    * packageName - packageName приложения

Также я предусмотрел то, что json может поменяться(если поднимать свой сервер с подкачкой данных)

Sbp.getAndroidInstalledByPackageNameBanks(List<String> packageNames) : Android
Передаем список packageNames поддерживаемых СБП банков. Возвращается List<String> packageNames,
которые установлены на устройстве пользователя

Sbp.getIOSInstalledBySchemesBanks(List<String> schemes)
Передаем список schemas поддерживаемых СБП банков. List<String> schemes,
которые установлены на устройстве пользователя

