import 'package:chatty_ai/views/Home/ui/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty_ai/core/services/hive_service.dart';
import 'package:chatty_ai/views/Home/ui/Home_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive
    await HiveService().initialize();
    print('✅ Hive initialized successfully');
  } catch (e) {
    print('⚠️ Hive initialization failed: $e');
    print('⚠️ App will continue without local storage');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'ChattyAI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          localizationsDelegates: const [
            // GlobalMaterialLocalizations.delegate,
            // GlobalWidgetsLocalizations.delegate,
            // GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('ar', ''), // Arabic
          ],
          home: const ChatScreen(),
        );
      },
    );
  }
}
