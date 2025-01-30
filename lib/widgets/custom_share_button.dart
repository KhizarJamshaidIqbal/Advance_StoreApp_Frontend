import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CustomShareButton extends StatelessWidget {
  final String productLink;
  final double? size;
  final Color? color;

  const CustomShareButton({
    Key? key,
    required this.productLink,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  void _shareProduct() {
    Share.share(
      productLink,
      subject: 'Check out this amazing product!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.share_rounded,
        size: size,
        color: color ?? Theme.of(context).iconTheme.color,
      ),
      onPressed: _shareProduct,
      tooltip: 'Share Product',
    );
  }
}
