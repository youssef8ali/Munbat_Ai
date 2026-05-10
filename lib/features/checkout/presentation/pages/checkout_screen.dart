// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import '../widgets/checkout_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  int quantity = 1;
  String selectedPayment = 'cash';

  final double productPrice = 12.50;
  final double shippingCost = 2.50;

  double get subtotal => productPrice * quantity;
  double get total => subtotal + shippingCost;

  void _confirmOrder() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order confirmed!'),
          backgroundColor: Color(0xFF00C853),
        ),
      );
      // Handle order submission ya jo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text('Checkout' ,style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product card
              ProductCard(
                quantity: quantity,
                price: productPrice,
                onQuantityChanged: (newQuantity) {
                  setState(() => quantity = newQuantity);
                },
              ),
              SizedBox(height: AppConstants.paddingLarge),
              // Shipping address form
              ShippingAddressSection(formKey: _formKey),
              SizedBox(height: AppConstants.paddingLarge),
              // Payment method
              const PaymentMethodSection(),
              SizedBox(height: AppConstants.paddingLarge),
              // Order summary
              OrderSummarySection(
                subtotal: subtotal,
                shipping: shippingCost,
                total: total,
              ),
              SizedBox(height: AppConstants.paddingLarge),
              // Confirm button
              ConfirmOrderButton(onPressed: _confirmOrder),
              SizedBox(height: AppConstants.paddingLarge),

            ],
          ),
        ),
      ),
    );
  }
}