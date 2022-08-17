# sbp

Flutter plugin, with which you can get a list of banks installed on the device user, as well as 
launch a link to pay for the SBP of the form https://qr.nspk.ru/.../

<p float="left">
 <img src="https://github.com/smenateam/sbp/blob/master/doc/screenshots/sbp_android1.jpg?raw=true" height="600">
 <img src="https://github.com/smenateam/sbp/blob/master/doc/screenshots/sbp_android2.jpg?raw=true" height="600">
</p>

## Adding dependencies
To use the plugin, add it to the pubspec.yaml file.

## Installing

### IOS

Add URL schemes to `LSApplicationQueriesSchemes` in `Info.plist` file:
This list is needed in order to make it possible to open third-party installed applications on
iOS. The list of banks supported by SBP can be obtained at [c2bmembers.json](https://qr.nspk.ru/proxyapp/c2bmembers.json).

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

<b>Warning!</b> Starting with iOS 15, the maximum number of the scheme list should not exceed
50.Detailed information can be obtained from this [link](https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl#discussion)

## Description of functions with examples

To use sbp and get current information on supported banks, SBP needs to be raised
own server, which will pull up new information on banks once in a while.
<b>Warning!</b>If you use json, don't forget to change the links to images in the file
/sbp/lib/data/c2bmembers_data.dart as they take a long time to load or not to load at all (IOS).

Links to current banks from the official website of the SBP
* [Android](https://qr.nspk.ru/.well-known/assetlinks.json)
* [IOS](https://qr.nspk.ru/proxyapp/c2bmembers.json)

Or you can use the current json I added to the project on 08/11/2022:
* Android: /sbp/lib/data/asset_links_data.dart
* IOS: /sbp/lib/data/c2bmembers_data.dart

### Android

```
List<ApplicationInfoModel> informations = await Sbp.getAndroidInstalledByAssetLinksJsonBanks(assetLinksData)
```

A variable is passed (json /sbp/lib/data/asset_links_data.dart), which is parsed and returns a List<ApplicationInfoModel>.
<b>ApplicationInfoModel</b> contains fields such as:
* name - app name
* packageName - application packageName
* bitmap - bitmap application icons

I also foresaw that json can change (if you raise your server with data paging)  

```
List<ApplicationInfoModel> informations = await Sbp.getAndroidInstalledByPackageNameBanks(List<String> packageNames)
```

We pass the packageNames list of banks supported by the SBP. Returns List<String> packageNames,
installed on the user's device

```
Sbp.openAndroidBank(String url, String packageName)
```

We pass the url of the form https://qr.nspk.ru/.../ and the packageName of the application in which you want to open the SBP

### IOS

```
List<C2bmembersModel> informations = await Sbp.getIOSInstalledByC2bmembersJsonBanks(c2bmembersData)
```

A variable is passed (json /sbp/lib/data/c2bmembers_data.dart), which is parsed and returns 
<b>List C2bmembersModel </b>.
<b>Sbp.getIOSInstalledByC2bmembersJsonBanks(Map<String, dynamic> c2bmembersData): IOS</b>  
Передается переменная(json /sbp/lib/data/c2bmembers_data.dart), которая парсится и возвращает
<b>List<C2bmembersModel></b>.
<b>C2bmembersModel</b> contains fields such as:
* version - json version
* c2bmembersModel - <b>List C2bmemberModel</b> installed applications
  * <b>C2bmemberModel</b> contains fields such as:
    * bankName - bank name
    * logoURL - link to picture
    * schema - application schema
    * packageName - application packageName

I also foresaw that json can change (if you raise your server with data paging)

```
List<C2bmembersModel> informations = Sbp.getIOSInstalledBySchemesBanks(List<String> schemes)
```

We pass a list of schemas supported by the SBP banks. List<String> schemes,
installed on the user's device

```
Sbp.openIOSBank(String url, String schema)
```

We pass the url of the form https://qr.nspk.ru/.../ and the schema of the application in which you want to open the SBP