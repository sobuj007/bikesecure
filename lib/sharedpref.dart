import 'package:native_shared_preferences/native_shared_preferences.dart';

class SharedPrefManagerNative{
//Future<NativeSharedPreferences> pref= NativeSharedPreferences.getInstance();
 
 static Future<dynamic> setPass(data)async{
     NativeSharedPreferences prefs = await NativeSharedPreferences.getInstance();
     prefs.setString("pass",data) ;

}
 static Future<dynamic> getpass()async{
   NativeSharedPreferences prefs = await NativeSharedPreferences.getInstance();
   return  prefs.getString("pass") ;
}
 static Future<dynamic> paasclear()async{
   NativeSharedPreferences prefs = await NativeSharedPreferences.getInstance();
   return  prefs.clear();
}


}