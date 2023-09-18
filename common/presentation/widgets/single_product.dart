import 'package:amazon_clone/common/data/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String imageUrl;

  const SingleProduct({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PulseCircle(
      imageUrl: imageUrl,
    );
  }
}

class PulseCircle extends StatefulWidget {
  const PulseCircle({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  _PulseCircleState createState() => _PulseCircleState();
}

class _PulseCircleState extends State<PulseCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _positionAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.only(
              top: 25,
              right: 15,
              left: 15,
            ),
            child: Transform.translate(
              offset: Offset(0, -_positionAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.backgroundColor,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        width: 120,
                        height: 120,
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      width: 150,
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
