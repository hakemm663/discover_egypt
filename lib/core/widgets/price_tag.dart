import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final String? currency;
  final String? unit;
  final double? originalPrice;
  final bool large;

  const PriceTag({
    super.key,
    required this.price,
    this.currency = '\$',
    this.unit,
    this.originalPrice,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasDiscount) ...[
          Text(
            '$currency${originalPrice!.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: large ? 14 : 12,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          '$currency${price.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: large ? 24 : 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFC89B3C),
          ),
        ),
        if (unit != null)
          Text(
            '/$unit',
            style: TextStyle(
              fontSize: large ? 14 : 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}

class DiscountBadge extends StatelessWidget {
  final int percentage;

  const DiscountBadge({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '-$percentage%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}