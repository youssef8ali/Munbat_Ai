// lib/screens/widgets/checkout_widgets.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';

// Product card with quantity selector
class ProductCard extends StatelessWidget {
  final int quantity;
  final double price;
  final Function(int) onQuantityChanged;

  const ProductCard({
    super.key,
    required this.quantity,
    required this.price,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Icon(
              Icons.local_florist,
              size: 50,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppConstants.paddingMedium),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Copper Fungicide Spray',
                  style: AppTextStyles.h4,
                ),
                SizedBox(height: AppConstants.paddingSmall),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Quantity selector
          QuantitySelector(
            quantity: quantity,
            onQuantityChanged: onQuantityChanged,
          ),
        ],
      ),
    );
  }
}

// Quantity selector buttons
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Decrease button
        GestureDetector(
          onTap: () {
            if (quantity > 1) {
              onQuantityChanged(quantity - 1);
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.remove, size: 18),
          ),
        ),
        SizedBox(height: AppConstants.paddingSmall),
        // Quantity display
        Text(
          '$quantity',
          style: AppTextStyles.bodyMedium,
        ),
        SizedBox(height: AppConstants.paddingSmall),
        // Increase button
        GestureDetector(
          onTap: () {
            onQuantityChanged(quantity + 1);
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.add,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// Shipping address section with form
class ShippingAddressSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ShippingAddressSection({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppConstants.paddingMedium),
        Form(
          key: formKey,
          child: Column(
            children: [
              // Full name field
              CustomTextField(
                label: 'Full Name',
                hint: 'Mohamed Refo',
              ),
              SizedBox(height: AppConstants.paddingMedium),
              // Street address field
              CustomTextField(
                label: 'Street Address',
                hint: '123 Green St',
              ),
              SizedBox(height: AppConstants.paddingMedium),
              // City and zip row
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'City',
                      hint: 'Mansoure',
                    ),
                  ),
                  SizedBox(width: AppConstants.paddingMedium),
                  SizedBox(
                    width: 100,
                    child: CustomTextField(
                      label: 'Zip',
                      hint: '10001',
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.paddingMedium),
              // Phone number field
              CustomTextField(
                label: 'Phone Number',
                hint: '+20100 6978 914',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom text field
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
        SizedBox(height: AppConstants.paddingSmall),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }
}

// Payment method section
class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppConstants.paddingMedium),
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Row(
            children: [
              Icon(
                Icons.attach_money,
                color: AppColors.primary,
              ),
              SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cash on Delivery',
                      style: AppTextStyles.h4,
                    ),
                    Text(
                      'Pay when you receive your order',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Order summary section
class OrderSummarySection extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;

  const OrderSummarySection({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppConstants.paddingMedium),
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Column(
            children: [
              // Subtotal row
              SummaryRow(
                label: 'Subtotal',
                value: '\$${subtotal.toStringAsFixed(2)}',
              ),
              SizedBox(height: AppConstants.paddingSmall),
              // Shipping row
              SummaryRow(
                label: 'Shipping',
                value: '\$${shipping.toStringAsFixed(2)}',
              ),
              Divider(height: 24),
              // Total row
              SummaryRow(
                label: 'Total',
                value: '\$${total.toStringAsFixed(2)}',
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Summary row for order breakdown
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppTextStyles.h4 : AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: isBold ? AppTextStyles.h4 : AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}

// Confirm order button
class ConfirmOrderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmOrderButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Confirm Order',
              style: AppTextStyles.button,
            ),
            SizedBox(width: AppConstants.paddingSmall),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}