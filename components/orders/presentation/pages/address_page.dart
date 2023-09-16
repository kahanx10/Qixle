// ignore_for_file: use_build_context_synchronously

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/payment_configurations.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/common/presentation/widgets/my_textfield.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/orders/data/services/address_service.dart';
import 'package:amazon_clone/components/orders/data/services/order_service.dart';
import 'package:amazon_clone/components/orders/presentation/pages/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';

class AddressPage extends StatefulWidget {
  static const String routeName = '/address_route';
  final String totalPrice;

  const AddressPage({
    Key? key,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  late double totalPrice;

  String addressToBeUsed = "";
  List<PaymentItem> paymentItems = [];

  List<dynamic> productsForOrder = [];

  @override
  void initState() {
    super.initState();

    totalPrice = double.parse(widget.totalPrice);
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void showPaymentAlertDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constants.selectedColor,
          title: Text(
            title,
            style: GoogleFonts.leagueSpartan(
              fontSize: 20,
              color: Constants.backgroundColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.025,
            ),
          ),
          content: Text(
            content,
            style: GoogleFonts.leagueSpartan(
              fontSize: 16,
              color: Constants.backgroundColor,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.025,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  color: Constants.backgroundColor,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.025,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the alert dialog
              },
            ),
            Flexible(
              child: ApplePayButton(
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                  defaultApplePayConfigStrig,
                ),
                onPaymentResult: onPayResult,
                paymentItems: paymentItems,
                height: 50,
                loadingIndicator: const Center(
                  child: Constants.loading,
                ),
              ),
            ),
            Flexible(
              child: GooglePayButton(
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                  defaultGooglePayConfigStrig,
                ),
                onPaymentResult: onPayResult,
                paymentItems: paymentItems,
                height: 50,
                type: GooglePayButtonType.buy,
                loadingIndicator: Constants.loading,
              ),
            ),
          ],
        );
      },
    );
  }

  void onPayResult(res) async {
    try {
      var navigator = Navigator.of(context);
      var user =
          (context.read<UserBloc>().state as UserAuthenticatedState).user;

      var order = await OrderService.placeOrder(
        context: context,
        address: user.address,
        totalPrice: totalPrice,
        products: productsForOrder,
      );

      navigator.pop();

      navigator.pushReplacementNamed(
        OrderDetailsPage.routeName,
        arguments: order,
      );
    } catch (e) {
      MessageService.showSnackBar(context, message: e.toString());
    }
  }

  void onNextPressed() async {
    try {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';

        await AddressService.saveUserAddress(
          context,
          address: addressToBeUsed,
        );

        _addressFormKey.currentState!.reset();

        finalizeProducts();
      } else if (addressToBeUsed.isNotEmpty) {
        _addressFormKey.currentState!.reset();

        finalizeProducts();
      } else {
        MessageService.showSnackBar(
          context,
          message: 'Enter all details correctly!',
        );
      }
    } catch (e) {
      MessageService.showSnackBar(
        context,
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    addressToBeUsed =
        (context.watch<UserBloc>().state as UserAuthenticatedState)
            .user
            .address;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Column(
                children: [
                  Text(
                    'Almost There',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    height: 2,
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                  ),
                  Text(
                    'Just point us where, and we\'ll bring it with care!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueSpartan(
                      height: 1.2,
                      fontSize: 20,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Lottie.asset('assets/lottie/city.json'),
                  if (addressToBeUsed.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Constants.selectedColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Note: Leave the form blank to use:',
                                  style: GoogleFonts.leagueSpartan(
                                    // fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  color: Constants.selectedColor,
                                  height: 2,
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 10,
                                  ),
                                ),
                                Text(
                                  addressToBeUsed.toUpperCase(),
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                color: Colors.grey.shade200,
                                height: 2,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),
                            ),
                            Text(
                              'OR',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 18,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(
                              child: Container(
                                color: Colors.grey.shade200,
                                height: 2,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  Form(
                    key: _addressFormKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: MyTextField(
                                title: 'Door No.',
                                controller: flatBuildingController,
                                hintText: 'Enter Flat/House No.',
                                obscureText: false,
                                validator: (val) {
                                  if (val != null && val.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Door No. is required!';
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              child: MyTextField(
                                title: 'Locality',
                                controller: areaController,
                                hintText: 'Enter Area/Street',
                                obscureText: false,
                                validator: (val) {
                                  if (val != null && val.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Locality is required!';
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        MyTextField(
                          title: 'City',
                          controller: cityController,
                          hintText: 'Enter Town/City/Village',
                          obscureText: false,
                          validator: (val) {
                            if (val != null && val.isNotEmpty) {
                              return null;
                            } else {
                              return 'City is required!';
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        MyTextField(
                          title: 'Pincode',
                          controller: pincodeController,
                          hintText: 'Enter Your Area Pincode',
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          validator: (val) {
                            if (val != null &&
                                val.isNotEmpty &&
                                val.length == 6) {
                              return null;
                            } else if (val != null && val.length != 6) {
                              return 'Pincode should be of 6 digits!';
                            } else {
                              return 'Pincode is required!';
                            }
                          },
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              color: Colors.grey.shade200,
              height: 2,
              margin: const EdgeInsets.only(bottom: 20),
            ),
            // If any error occurs in iOS due to ApplePayButton, change platform to 11.0 in Podfile
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 25),
                Flexible(
                  child: MyButton(
                      textStyle: GoogleFonts.leagueSpartan(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      height: 50,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.backgroundColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: 'Back'),
                ),
                const SizedBox(width: 25),
                Flexible(
                  child: MyButton(
                      textStyle: GoogleFonts.leagueSpartan(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      height: 50,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.selectedColor,
                        foregroundColor: Constants.backgroundColor,
                      ),
                      onPressed: () {
                        onNextPressed();
                      },
                      text: 'Next'),
                ),
                const SizedBox(width: 25),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  finalizeProducts() async {
    var user = (context.read<UserBloc>().state as UserAuthenticatedState).user;

    var res = await OrderService.finalizeCart(
      context,
      cart: user.cart,
    );

    if (res == null) {
      MessageService.showSnackBar(
        context,
        message: 'Some error occurred, please try agan!',
      );
      return;
    }

    if (res['totalPrice'] != 0 && res['products'].isNotEmpty) {
      if (paymentItems.isEmpty) {
        paymentItems.add(
          PaymentItem(
            amount: res['totalPrice'].toString(),
            label: 'Total Amount',
            status: PaymentItemStatus.final_price,
          ),
        );
      } else {
        paymentItems[0] = PaymentItem(
          amount: res['totalPrice'].toString(),
          label: 'Total Amount',
          status: PaymentItemStatus.final_price,
        );
      }

      productsForOrder = res['products'];
      totalPrice = double.parse(res['totalPrice'].toString());

      showPaymentAlertDialog(
        context,
        'Place Order',
        'Time to finally grab your bag!',
      );
    } else {
      MessageService.showSnackBar(
        context,
        message: 'Too late! All products are out of stock :(',
      );
    }
  }
}
