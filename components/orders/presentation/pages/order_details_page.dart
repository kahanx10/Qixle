import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/components/admin/data/services/admin_service.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:amazon_clone/components/orders/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';

class OrderDetailsPage extends StatefulWidget {
  static const String routeName = '/order_details_route';
  final Order order;

  const OrderDetailsPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late int currentStep;
  double minSize = 0.15;
  double maxSize = 0.8;

  String buttonText = 'View';

  final _dragController = DraggableScrollableController();
  bool _isExpanded = false;

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchedProductsPage.routeName,
      arguments: query,
    );
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;

    _dragController.addListener(() {
      setState(() {
        if (_dragController.size >= (maxSize - 0.05)) {
          buttonText = 'Hide';
          _isExpanded = true;
        } else {
          buttonText = 'View';
          _isExpanded = false;
        }
      });
    });
  }

  void changeOrderStatus(int status) async {
    try {
      var newStatus = await AdminService.changeOrderStatus(
        context,
        status: status + 1,
        orderId: widget.order.id,
      );
      setState(() {
        currentStep = newStatus;
      });
    } catch (e) {
      MessageService.showSnackBar(context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
            .user;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.only(
              top: 60.0,
              bottom: 20,
              left: 30,
              right: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Arriving date',
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat('dd MMM, y').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  widget.order.orderedAt,
                                ).add(
                                  const Duration(
                                    days: 4,
                                  ),
                                ),
                              ),
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 4.0),
                              child: Icon(Icons.alarm_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Constants.backgroundColor,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // subtle shadow
                              blurRadius: 8, // soften the shadow
                              spreadRadius:
                                  0.05, // extent of shadow, negative values can also be used
                              offset: const Offset(
                                -0.2,
                                0.2,
                              ), // Move to bottom-left by 4 units
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            LineIcons.arrowLeft,
                            color: Constants.selectedColor,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Lottie.asset('assets/lottie/order.json'),
                ),
                Transform.translate(
                  offset: const Offset(0, -90),
                  child: Text(
                    'Relax while we bring it...\nWe\'ll knock your door soon!',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35, // Adjust initial size
            minChildSize: 0.35, // Adjust minimum size
            maxChildSize: 0.65, // Adjust maximum size
            builder: (context, scrollController) {
              return Container(
                // constraints: const BoxConstraints(maxHeight: 500),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Constants.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.black12,
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Theme(
                    data: ThemeData(
                      colorScheme: ColorScheme.fromSwatch()
                          .copyWith(primary: Constants.selectedColor),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Stepper(
                          type: StepperType.vertical,
                          physics: const ScrollPhysics(),
                          currentStep: currentStep,
                          controlsBuilder: (context, details) {
                            if (user.type == 'admin' && currentStep != 3) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: MyButton(
                                    width: 250,
                                    useWidth: true,
                                    text: 'Done',
                                    onPressed: () =>
                                        changeOrderStatus(details.currentStep),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor:
                                          Constants.backgroundColor,
                                      backgroundColor: Constants.selectedColor,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                          steps: [
                            Step(
                              title: Text(
                                'Pending',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 19,
                                  color: currentStep > 0
                                      ? Constants.selectedColor
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              content: Text(
                                'Your order is yet to be delivered',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 19,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              isActive: currentStep > 0,
                              state: currentStep > 0
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: Text(
                                'Completed',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 19,
                                  color: currentStep > 1
                                      ? Constants.selectedColor
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              content: Text(
                                'Your order has been delivered, you are yet to sign.',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 19,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              isActive: currentStep > 1,
                              state: currentStep > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: Text(
                                'Received',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 19,
                                  color: currentStep > 2
                                      ? Constants.selectedColor
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              content: Text(
                                'Your order has been delivered and signed by you.',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 19,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              isActive: currentStep > 2,
                              state: currentStep > 2
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: Text(
                                'Delivered',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 19,
                                  color: currentStep >= 3
                                      ? Constants.selectedColor
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              content: Text(
                                'Your order has been delivered and signed by you!',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 19,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              isActive: currentStep >= 3,
                              state: currentStep >= 3
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          DraggableScrollableSheet(
            controller: _dragController,
            initialChildSize: minSize, // Adjust initial size
            minChildSize: minSize, // Adjust minimum size
            maxChildSize: maxSize, // Adjust maximum size
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Constants.selectedColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: GestureDetector(
                  onVerticalDragUpdate: (_) {}, // Absorb drag updates
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _isExpanded
                                  ? 'Your order details'
                                  : 'See your order\ndetails',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 16,
                                color: Constants.backgroundColor,
                                fontWeight: _isExpanded
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            MyButton(
                              useWidth: true,
                              width: 150,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade900,
                                  foregroundColor: Constants.backgroundColor),
                              onPressed: () {
                                setState(() {
                                  _isExpanded =
                                      !_isExpanded; // Toggle the state
                                });
                                if (_isExpanded) {
                                  _dragController.animateTo(
                                    maxSize,
                                    curve: Curves.easeOut,
                                    duration: const Duration(
                                      milliseconds: 500,
                                    ),
                                  ); // Fully expand
                                } else {
                                  _dragController.animateTo(
                                    minSize,
                                    curve: Curves.easeIn,
                                    duration: const Duration(
                                      milliseconds: 350,
                                    ),
                                  ); // // Collapse to min size (adjust as needed)
                                }
                              },
                              text: buttonText,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (_isExpanded)
                          Text(
                            '{ order: ${widget.order.id} }',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 14,
                              color: Constants.backgroundColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: widget.order.products.length > 1 ? 300 : null,
                          padding: const EdgeInsets.all(30),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 21, 21, 21),
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (int i = 0;
                                    i < widget.order.products.length;
                                    i++)
                                  Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  100,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius:
                                                        18, // Increase this for more diffuse shadow
                                                    spreadRadius:
                                                        -3, // Slight negative value to soften the edges
                                                    offset: Offset(2,
                                                        -2), // Adjust as needed
                                                    color: Colors.black26,
                                                  ),
                                                ]),
                                          ),
                                          Image.network(
                                            widget
                                                .order
                                                .products[i]['product']
                                                    ['images'][0]
                                                .toString(),
                                            height: 120,
                                            width: 120,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.order.products[i]
                                                      ['product']['name'] +
                                                  ' (${widget.order.products[i]['quantity'].toString()})',
                                              style: GoogleFonts.leagueSpartan(
                                                fontSize: 16,
                                                color:
                                                    Constants.backgroundColor,
                                                fontWeight: FontWeight.w500,
                                                height: 1,
                                                letterSpacing: 0.1,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              '\$${widget.order.products[i]['product']['price'].toString()}',
                                              style: GoogleFonts.leagueSpartan(
                                                fontSize: 18,
                                                color:
                                                    Constants.backgroundColor,
                                                fontWeight: FontWeight.bold,
                                                height: 1,
                                                letterSpacing: 0.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 70,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 21, 21, 21),
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Request Cancellation',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 14,
                                color: Constants.backgroundColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        if (_isExpanded)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  'Your shipping address',
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 14,
                                    color: Constants.backgroundColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_isExpanded)
                          Container(
                            height: 150,
                            padding: const EdgeInsets.all(30),
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 21, 21, 21),
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 16,
                                    color: Constants.backgroundColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  widget.order.address,
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 14,
                                    color: Constants.backgroundColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
