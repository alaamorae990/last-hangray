
// import 'package:card_swiper/card_swiper.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:provider/provider.dart';

// import '../../consts/contss.dart';
// import '../../services/global_methods.dart';
// import '../../services/utils.dart';
// import '../../widgets/auth_button.dart';
// import '../../widgets/button_phone.dart';
// import '../../widgets/text_phone.dart';
// import '../../widgets/text_widget.dart';
// import '../loading_manager.dart';
// import 'forget_pass.dart';
// import 'global_phone.dart';
// import 'login.dart';

// class PhoneScreen extends StatefulWidget {
//   static String routeName = '/phone';
//   const PhoneScreen({Key? key}) : super(key: key);

//   @override
//   State<PhoneScreen> createState() => _PhoneScreenState();
// }

// class _PhoneScreenState extends State<PhoneScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController phoneController = TextEditingController();
// final TextEditingController nameController = TextEditingController();
// final TextEditingController addreesController = TextEditingController();
// final TextEditingController emailController = TextEditingController();
// final TextEditingController passController = TextEditingController();
//   final _emailFocusNode = FocusNode();
//   final _passFocusNode = FocusNode();
//   final _phoneFocusNode = FocusNode();
//   final _addressFocusNode = FocusNode();
//   bool _obscureText = true;
//   @override
//   void dispose() {
//     super.dispose();
//     phoneController.dispose();
//      nameController.dispose();
//       addreesController.dispose();
//        emailController.dispose();
//         passController.dispose();
         
//   }

//   @override
//   Widget build(BuildContext context) {
//         final theme = Utils(context).getTheme;
//     Color color = Utils(context).color;
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Swiper(
//             duration: 800,
//             autoplayDelay: 6000,

//             itemBuilder: (BuildContext context, int index) {
//               return Image.asset(
//                 Constss.authImagesPaths[index],
//                 fit: BoxFit.cover,
//               );
//             },
//             autoplay: true,
//             itemCount: Constss.authImagesPaths.length,

//             // control: const SwiperControl(),
//           ),
//           Container(
//             color: Colors.black.withOpacity(0.7),
//           ),
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 const SizedBox(
//                   height: 60.0,
//                 ),
//                 InkWell(
//                   borderRadius: BorderRadius.circular(12),
//                   onTap: () => Navigator.canPop(context)
//                       ? Navigator.pop(context)
//                       : null,
//                   child: Icon(
//                     IconlyLight.arrowLeft2,
//                     color: theme == true ? Colors.white : Colors.black,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 40.0,
//                 ),
//                 TextWidget(
//                   text: 'Welcome',
//                   color: Colors.white,
//                   textSize: 30,
//                   isTitle: true,
//                 ),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 TextWidget(
//                   text: "Sign up to continue",
//                   color: Colors.white,
//                   textSize: 18,
//                   isTitle: false,
//                 ),
//                 const SizedBox(
//                   height: 30.0,
//                 ),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         textInputAction: TextInputAction.next,
//                         onEditingComplete: () => FocusScope.of(context)
//                             .requestFocus(_emailFocusNode),
//                         keyboardType: TextInputType.name,
//                         controller: nameController,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "This Field is missing";
//                           } else {
//                             return null;
//                           }
//                         },
//                         style: const TextStyle(color: Colors.white),
//                         decoration: const InputDecoration(
//                           hintText: 'Full name',
//                           hintStyle: TextStyle(color: Colors.white),
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           errorBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         focusNode: _emailFocusNode,
//                         textInputAction: TextInputAction.next,
//                         onEditingComplete: () => FocusScope.of(context)
//                             .requestFocus(_passFocusNode),
//                         keyboardType: TextInputType.emailAddress,
//                         controller: emailController,
//                         validator: (value) {
//                           if (value!.isEmpty ) {
//                             return "Please enter a valid Email";
//                           } else {
//                             return null;
//                           }
//                         },
//                         style: const TextStyle(color: Colors.white),
//                         decoration: const InputDecoration(
//                           hintText: 'Email',
//                           hintStyle: TextStyle(color: Colors.white),
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           errorBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         focusNode: _passFocusNode,
//                         textInputAction: TextInputAction.next,
//                         onEditingComplete: () => FocusScope.of(context)
//                             .requestFocus(_phoneFocusNode),
//                         keyboardType: TextInputType.emailAddress,
//                         controller: passController,
//                         validator: (value) {
//                           if (value!.isEmpty ) {
//                             return "Please enter a valid password";
//                           } else {
//                             return null;
//                           }
//                         },
//                         style: const TextStyle(color: Colors.white),
//                         decoration: const InputDecoration(
//                           hintText: 'Password',
//                           hintStyle: TextStyle(color: Colors.white),
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           errorBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         focusNode: _phoneFocusNode,
//                         textInputAction: TextInputAction.next,
//                         onEditingComplete: () => FocusScope.of(context)
//                             .requestFocus(_addressFocusNode),
//                         keyboardType: TextInputType.emailAddress,
//                         controller: phoneController,
//                         validator: (value) {
//                           if (value!.isEmpty ) {
//                             return "Please enter a valid Phone Number";
//                           } else {
//                             return null;
//                           }
//                         },
//                         style: const TextStyle(color: Colors.white),
//                         decoration: const InputDecoration(
//                           hintText: 'Phone Number',
//                           hintStyle: TextStyle(color: Colors.white),
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           errorBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                         ),
//                       ),
                      
//                       //Password
//                       // TextFormField(
//                       //   focusNode: _passFocusNode,
//                       //   obscureText: _obscureText,
//                       //   keyboardType: TextInputType.visiblePassword,
//                       //   controller: _passTextController,
//                       //   validator: (value) {
//                       //     if (value!.isEmpty || value.length < 7) {
//                       //       return "Please enter a valid password";
//                       //     } else {
//                       //       return null;
//                       //     }
//                       //   },
//                       //   style: const TextStyle(color: Colors.white),
//                       //   onEditingComplete: () => FocusScope.of(context)
//                       //       .requestFocus(_addressFocusNode),
//                       //   decoration: InputDecoration(
//                       //     suffixIcon: GestureDetector(
//                       //       onTap: () {
//                       //         setState(() {
//                       //           _obscureText = !_obscureText;
//                       //         });
//                       //       },
//                       //       child: Icon(
//                       //         _obscureText
//                       //             ? Icons.visibility
//                       //             : Icons.visibility_off,
//                       //         color: Colors.white,
//                       //       ),
//                       //     ),
//                       //     hintText: 'Password',
//                       //     hintStyle: const TextStyle(color: Colors.white),
//                       //     enabledBorder: const UnderlineInputBorder(
//                       //       borderSide: BorderSide(color: Colors.white),
//                       //     ),
//                       //     focusedBorder: const UnderlineInputBorder(
//                       //       borderSide: BorderSide(color: Colors.white),
//                       //     ),
//                       //     errorBorder: const UnderlineInputBorder(
//                       //       borderSide: BorderSide(color: Colors.red),
//                       //     ),
//                       //   ),
//                       // ),
//                       const SizedBox(
//                         height: 20,
//                       ),

//                       TextFormField(
//                         focusNode: _addressFocusNode,
//                         textInputAction: TextInputAction.done,
//                         // onEditingComplete: _submitFormOnRegister,
//                         controller: addreesController,
//                         validator: (value) {
//                           if (value!.isEmpty || value.length < 10) {
//                             return "Please enter a valid  address";
//                           } else {
//                             return null;
//                           }
//                         },
//                         style: const TextStyle(color: Colors.white),
//                         maxLines: 2,
//                         textAlign: TextAlign.start,
//                         decoration: const InputDecoration(
//                           hintText: 'Delivery address',
//                           hintStyle: TextStyle(color: Colors.white),
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           errorBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 // Align(
//                 //   alignment: Alignment.centerRight,
//                 //   child: TextButton(
//                 //     onPressed: () {
//                 //       GlobalMethods.navigateTo(
//                 //           ctx: context,
//                 //           routeName: ForgetPasswordScreen.routeName);
//                 //     },
//                 //     child: const Text(
//                 //       'Forget password?',
//                 //       maxLines: 1,
//                 //       style: TextStyle(
//                 //           color: Colors.lightBlue,
//                 //           fontSize: 18,
//                 //           decoration: TextDecoration.underline,
//                 //           fontStyle: FontStyle.italic),
//                 //     ),
//                 //   ),
//                 // ),
//                 AuthButton(
//                   buttonText: 'Sign up',
//                   fct: () {
//                                 context
//                   .read<FirebaseAuthMethods>()
//                    .phoneSignIn(context, phoneController.text,nameController.text,addreesController.text,emailController.text,passController.text);
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                       text: 'Already a user?',
//                       style:
//                           const TextStyle(color: Colors.white, fontSize: 18),
//                       children: <TextSpan>[
//                         TextSpan(
//                             text: ' Sign in',
//                             style: const TextStyle(
//                                 color: Colors.lightBlue, fontSize: 18),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () {
//                                 Navigator.pushReplacementNamed(
//                                     context, LoginScreen.routeName);
//                               }),
//                       ]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//     // Scaffold(
//     //   body: Column(
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: [
//     //       CustomTextField(
//     //         controller: nameController,
//     //         hintText: 'Enter your name',
//     //       ),
//     //       CustomTextField(
//     //         controller: phoneController,
//     //         hintText: 'Enter phone number',
//     //       ),
//     //       CustomTextField(
//     //         controller: addreesController,
//     //         hintText: 'Enter your address',
//     //       ),
//     //       CustomButton(
//     //         onTap: () {
//     //           context
//     //               .read<FirebaseAuthMethods>()
//     //               .phoneSignIn(context, phoneController.text,nameController.text,addreesController.text);
//     //         },
//     //         text: 'OK',
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }
// }