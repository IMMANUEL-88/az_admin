import 'package:admin/navigation_pages/navigation_menu.dart';
import 'package:admin/utils/constants/colors.dart';
import 'package:admin/utils/constants/image_strings.dart';
import 'package:admin/utils/constants/sizes.dart';
import 'package:admin/utils/constants/text_strings.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:admin/utils/loaders/fullscreen_loader.dart';
import 'package:admin/utils/valildators/validators.dart';
import 'package:flutter/material.dart';
import 'package:admin/Api/Api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/styles/spacing_style.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController pass = TextEditingController();
  TextEditingController adid = TextEditingController();

  @override
  void dispose() {
    pass.dispose();
    adid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: ESpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: ESizes.spaceBtwSections,
              ),
              SizedBox(
                child: Column(
                  children: [
                    Image(
                      height: 100,
                      image: AssetImage(
                          dark ? EImages.darkAppLogo : EImages.lightAppLogo),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "A T T E N D Z O N E",
                      style: GoogleFonts.rubik(
                          color: dark ? EColors.light : EColors.dark,
                          fontWeight: FontWeight.bold),

                      //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: ESizes.spaceBtwSections),
              Text(
                ETexts.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                //style: TextStyle(color: Colors.black, fontSize: 45),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                ETexts.loginSubTitle,
                style: Theme.of(context).textTheme.bodyMedium,
                //style: TextStyle(fontSize: 17, color: Colors.black),
              ),
              const SizedBox(
                height: ESizes.spaceBtwSections,
              ),

              TextFormField(
                controller: adid,
                validator: (value) => EValidator.validateEmail(value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: ETexts.uid,
                ),
              ),
              const SizedBox(
                height: ESizes.spaceBtwInputFields,
              ),
              TextFormField(
                controller: pass,
                validator: (value) => EValidator.validateEmail(value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: ETexts.password,
                ),
              ),
              const SizedBox(
                height: ESizes.spaceBtwInputFields,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Remember Me
                  // Row(
                  //   children: [
                  //     const Text(ETexts.rememberMe),
                  //   ],
                  // ),

                  //Forgot Password
                  TextButton(
                    onPressed: () {},
                    child: const Text(ETexts.forgetPassword),
                  ),
                ],
              ),
              const SizedBox(height: ESizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text(
                    "Sign in",
                  ),
                ),
              ),
              // OutlinedButton(onPressed: (){}, child: Text('Login',style: Theme.of(context)
              //     .textTheme
              //     .bodySmall!
              //     .apply(color: dark ? EColors.light : EColors.dark),)),
              SizedBox(
                height: screenHeight * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: dark ? EColors.light : EColors.dark,
                      thickness: 1,
                      indent: 5,
                      endIndent: 1,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    ETexts.supportText1,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Flexible(
                    child: Divider(
                      color: dark ? EColors.light : EColors.dark,
                      thickness: 1,
                      indent: 1,
                      endIndent: 5,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    try {
      // Show loading immediately
      EFullScreenLoader.openLoadingDialog('Logging in...');

      // Call the login API
      final response =
          await Api().loginAdmin(adid.text.trim(), pass.text.trim());

      // Save login state and token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', response['token']);
      await prefs.setString('userId', response['userId']);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Login Successful"),
        duration: Duration(seconds: 2),
      ));

      // Navigate directly without delay

      await Future.delayed(Duration(seconds: 6));
      EFullScreenLoader.stopLoading();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationMenu()),
      );
    } catch (e) {
      EFullScreenLoader.stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login failed: ${e.toString()}"),
        duration: const Duration(seconds: 2),
      ));
    }
  }
}
