import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/payment_configurations.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/presentation/widgets/my_textfield.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/data/services/address_service.dart';
import 'package:amazon_clone/components/orders/data/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pay/pay.dart';

class AddressPage extends StatefulWidget {
  static const String routeName = '/address_route';
  final String totalAmount;

  const AddressPage({
    Key? key,
    required this.totalAmount,
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

  String addressToBeUsed = "";
  List<PaymentItem> paymentItems = [];

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void onPayResult(res) async {
    try {
      var user =
          (context.read<UserBloc>().state as UserAuthenticatedState).user;
      var addressToBeUsedForPayment = user.address;
      if (addressToBeUsedForPayment.isEmpty) {
        AddressService.saveUserAddress(
          context,
          address: addressToBeUsed,
        );
      }

      await OrderService.placeOrder(
        context: context,
        address: addressToBeUsedForPayment,
        totalSum: double.parse(widget.totalAmount),
        cart: user.cart,
      );

      Navigator.of(context).pop();
    } catch (e) {
      MessageService.showSnackBar(context, message: e.toString());
    }
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "none";

    bool isFormFilled = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isFormFilled) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      MessageService.showSnackBar(context, message: 'All fields are required!');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = (context.watch<UserBloc>().state as UserAuthenticatedState)
        .user
        .address;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Constants.backgroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Lottie.asset('assets/lottie/city.json'),
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
                          flex: 2,
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
                        if (val != null && val.isNotEmpty && val.length == 6) {
                          return null;
                        } else if (val != null && val.length != 6) {
                          return 'Pincode should be of 6 digits!';
                        } else {
                          return 'Pincode is required!';
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              // If any error occurs in iOS due to ApplePayButton, change platform to 11.0 in Podfile
              ApplePayButton(
                width: double.infinity,
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                  defaultApplePayConfigStrig,
                ),
                onPaymentResult: onPayResult,
                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                height: 50,
                onPressed: () => payPressed(address),
              ),
              // If any error occurs in iOS due to GooglePayButton, change minSdkVersion to 19 in build.gradle
              GooglePayButton(
                onPressed: () => payPressed(address),
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                  defaultGooglePayConfigStrig,
                ),
                onPaymentResult: onPayResult,
                paymentItems: paymentItems,
                height: 50,
                type: GooglePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
