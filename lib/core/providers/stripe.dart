import 'dart:convert';

import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:http/http.dart' as http;

class StripeProvider extends ChangeNotifier {
  final BuildContext context;
  late ConnectivityProvider connectivity;
  Props props = Props(data: [], initialData: []);

  String secretKey =
      'sk_test_51JXpyCFGJlqg5MKbY1QvJ6SDfxHqup8uDSo5OvViftVHu0kHkaswjB9RtxJ4aSt78uPm7P50IZ4qURPYZyjwX6DE00iXMUa44s';

  StripeProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
  }

  Future<void> makePayment() async {
    try {
      //STEP 1: Create Payment Intent
      var paymentIntent = await createPaymentIntent('100', 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) {})
          .onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      console.log('Error is:---> $e');
    } catch (e) {
      console.log('$e');
    }
  }
}
