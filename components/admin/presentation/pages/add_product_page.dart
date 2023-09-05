import 'dart:io';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/common/presentation/widgets/my_app_bar.dart';
import 'package:amazon_clone/common/presentation/widgets/my_textfield.dart';
import 'package:amazon_clone/components/admin/data/services/product_service.dart';
import 'package:amazon_clone/components/admin/logic/blocs/products_bloc.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/add_product_page';
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  List<File> images = [];

  final _addProductFormKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  var _category = 'Mobiles';

  final _dropdownMenuEntries = <String>[
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text(
          'Add Product',
          style: TextStyle(fontSize: 16),
        ),
        isTitleCentered: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CarouselSlider(
                  items: [
                    images.isNotEmpty
                        ? CarouselSlider(
                            items: [
                              ...images.map(
                                (file) => Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Image.file(
                                      file,
                                      fit: BoxFit.cover,
                                      height: 200,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(
                                              () {
                                                images.removeWhere(
                                                  (element) =>
                                                      file.path == element.path,
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Constants.backgroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            options: CarouselOptions(
                              viewportFraction: 1,
                              height: 200,
                              enableInfiniteScroll: false,
                            ),
                          )
                        : SizedBox(
                            child: Center(
                              child: Text(
                                'No images added yet.\nSwipe right to add images here!',
                                style: TextStyle(color: Colors.grey.shade400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                    GestureDetector(
                      onTap: () async {
                        var imageFiles =
                            await ProductService.pickProductImages();

                        if (imageFiles.isNotEmpty) {
                          if (imageFiles.length > 4) {
                            BlocProvider.of<UiFeedbackCubit>(context)
                                .showSnackbar(
                              'You can only add up to 5 images!',
                            );
                          }

                          for (int i = 0; i < imageFiles.length; i++) {
                            images.add(imageFiles[i]);

                            if (imageFiles.length == 4) {
                              break;
                            }
                          }
                        }

                        setState(() {});
                      },
                      child: DottedBorder(
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12.0),
                        dashPattern: const [10, 4],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: double.infinity,
                          height: 150,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.folder_open_rounded,
                                  size: 40,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Select product images here.\nSwipe left to view them!',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 200,
                    enableInfiniteScroll: false,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                MyTextField(
                  obscureText: false,
                  controller: _productNameController,
                  hintText: 'Product Name',
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      return null;
                    }
                    return 'Please enter a product name';
                  },
                ),
                const SizedBox(
                  height: 12.0,
                ),
                MyTextField(
                  maxLines: 7,
                  obscureText: false,
                  controller: _descriptionController,
                  hintText: 'Description',
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      return null;
                    }
                    return 'Please enter a product description';
                  },
                ),
                const SizedBox(
                  height: 12.0,
                ),
                MyTextField(
                  obscureText: false,
                  controller: _priceController,
                  hintText: 'Price',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    final isDigitsOnly = num.tryParse(value);
                    if (isDigitsOnly == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12.0,
                ),
                MyTextField(
                  obscureText: false,
                  controller: _quantityController,
                  hintText: 'Quantity',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    final isDigitsOnly = num.tryParse(value);
                    if (isDigitsOnly == null) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    iconEnabledColor: Constants.selectedColor,
                    value: _category,
                    onChanged: (newVal) {
                      setState(() {
                        _category = newVal!;
                      });
                    },
                    items: _dropdownMenuEntries
                        .map(
                          (String item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                color: item == _category
                                    ? Constants.selectedColor
                                    : null,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                AppButton(
                  width: double.infinity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.selectedColor,
                    foregroundColor: Constants.backgroundColor,
                  ),
                  onPressed: () {
                    if (images.isEmpty) {
                      BlocProvider.of<UiFeedbackCubit>(context).showSnackbar(
                        'You need to add minimum one image!',
                      );

                      return;
                    }

                    if (_addProductFormKey.currentState!.validate()) {
                      var token = (BlocProvider.of<UserBloc>(context).state
                              as UserAuthenticatedState)
                          .user
                          .token;

                      BlocProvider.of<ProductBloc>(context).add(
                        AddProductEvent(
                          token: token,
                          productName: _productNameController.text,
                          description: _descriptionController.text,
                          quantity: int.parse(_quantityController.text),
                          price: double.parse(_priceController.text),
                          images: images.map((file) => file.path).toList(),
                          category: _category,
                        ),
                      );

                      setState(() {
                        images.clear();
                        _addProductFormKey.currentState!.reset();
                      });

                      BlocProvider.of<UiFeedbackCubit>(context).showSnackbar(
                        'Go back to home page to view added products!',
                      );
                    }
                  },
                  label: 'Sell',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
}
