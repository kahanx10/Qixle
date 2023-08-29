import 'dart:io';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/common/presentation/widgets/my_app_bar.dart';
import 'package:amazon_clone/common/presentation/widgets/my_textfield.dart';
import 'package:amazon_clone/components/products/data/services/product_service.dart';
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
              children: [
                CarouselSlider(
                  items: [
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

                          for (int i = 0; i < 5; i++) {
                            images.add(imageFiles[i]);
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
                                  'Select Product Images',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
                                'No Images Added',
                                style: TextStyle(color: Colors.grey.shade400),
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
                ),
                const SizedBox(
                  height: 12.0,
                ),
                MyTextField(
                  maxLines: 7,
                  obscureText: false,
                  controller: _descriptionController,
                  hintText: 'Description',
                ),
                const SizedBox(
                  height: 12.0,
                ),
                MyTextField(
                  obscureText: false,
                  controller: _priceController,
                  hintText: 'Price',
                ),
                const SizedBox(
                  height: 12.0,
                ),
                MyTextField(
                  obscureText: false,
                  controller: _quantityController,
                  hintText: 'Quantity',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.selectedColor,
                    foregroundColor: Constants.backgroundColor,
                  ),
                  onPressed: () {},
                  label: 'Sell',
                  isExpanded: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
