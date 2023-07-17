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

### Android

Starting with android 11 in AndroidManifest.xml, you need to specify applications that our
application can see

```
 <queries>
  <array>
    <package android:name="ru.sberbankmobile" />
    <package android:name="ru.gazprombank.android.mobilebank.app" />
    <package android:name="ru.letobank.Prometheus" />
    ...
    <package android:name="logo.com.mbanking" />
    <package android:name="com.openbank" />
  </queries>
```

### IOS

Add URL schemes to `LSApplicationQueriesSchemes` in `Info.plist` file:
This list is needed in order to make it possible to open third-party installed applications on iOS.
The list of banks supported by SBP can be obtained
at [c2bmembers.json](https://qr.nspk.ru/proxyapp/c2bmembers.json).

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
50.Detailed information can be obtained from
this [link](https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl#discussion)

## Description of functions with examples

To use sbp and get current information on supported banks, SBP needs to be raised own server, which
will pull up new information on banks once in a while.
<b>Warning!</b>If you use json, don't forget to change the links to images in the file
/sbp/lib/data/c2bmembers_data.dart as they take a long time to load or not to load at all (IOS).

Links to current banks from the official website of the SBP

* [IOS/Android](https://qr.nspk.ru/proxyapp/c2bmembers.json)

Or you can use the current json I added to the project on 17/07/2023:

* IOS/Android: /sbp/lib/data/c2bmembers_data.dart

### Android

```
Sbp.openAndroidBank(String url, String packageName)
```

We pass the url of the form ('https://qr.nspk.ru/...' deprecated) schema://qr.nspk.ru/.... and the packageName of the application in which you want to open the SBP

### IOS

```
Sbp.openIOSBank(String url, String schema)
```

We pass the url of the form https://qr.nspk.ru/.../ and the schema of the application in which you
want to open the SBP

### IOS/Android

```
List<C2bmemberModel> informations = await Sbp.getInstalledBanks(
  C2bmembersModel.fromJson(c2bmembersData),
  useAndroidLocalIcons:false,
  useAndroidLocalNames:false,
)
```

<b>getInstalledBanks</b> contains fields such as:

* C2bmembersModel - (/sbp/lib/models/c2bmembers_model.dart)
* useAndroidLocalIcons - if you want to use native android application icons, then put
  true and use the bitmap variable to display the bank icon
* useAndroidLocalNames - if you want to use the native name of the android application, then put
  true and use the localName variable to display the name of the bank
* A variable is passed c2bmembersData (json /sbp/lib/data/c2bmembers_data.dart), which is parsed and
  returns a C2bmembersModel.

<b>C2bmembersModel</b> contains fields such as:
* version - json version
* c2bmembersModel - <b>List C2bmemberModel</b> installed applications
    * <b>C2bmemberModel</b> contains fields such as:
        * bankName - bank name
        * logoURL - link to picture
        * schema - application schema
        * packageName - application packageName
        * icon - icon app from assets
        * bitmap - bitmap app on device(only for Android)
        * localName - local name app on device(only for Android)

```
openBank(String url, C2bmemberModel c2bmemberModel)
```

We pass the url of the form https://qr.nspk.ru/.../ and the c2bmemberModel of the application in
which you want to open the SBP

If you want to use local bank icons from assets , you need to include them in the project (see file /sbp/lib/data/c2bmembers_data.dart field icon):
```
flutter:
  assets:
    - packages/sbp/assets/sbp.png
    - packages/sbp/assets/...
    etc
```