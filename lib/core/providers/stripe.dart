import 'dart:convert';
import 'package:flutter/material.dart';
import '/core/app_export.dart';

class StripeProvider extends ChangeNotifier {
  final BuildContext context;
  late AuthenticationProvider auth;
  late ConnectivityProvider connectivity;

  StripeProvider(this.context) {
    Stripe.publishableKey = Environment.publishableKey;
    Stripe.merchantIdentifier = Environment.merchantIdentifier;

    auth = context.read<AuthenticationProvider>();
    connectivity = context.read<ConnectivityProvider>();
  }

  String get trace {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split('\n');

    if (frames.length > 1) {
      final callerFrame = frames[1].trim();
      final regex = RegExp(r'#\d+\s+(\S+)\.(\S+)\s+\(.*\)');
      final match = regex.firstMatch(callerFrame);

      if (match != null) {
        final className = match.group(1);
        final methodName = match.group(2);
        return "$className::$methodName";
      } else {
        return "$runtimeType::unknown";
      }
    } else {
      return "$runtimeType::unknown";
    }
  }

  Future<Payment> payment(num amount, [String currency = 'USD']) async {
    dynamic intent = {};
    try {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      intent = await createIntents('${amount * 100}', currency);

      SetupPaymentSheetParameters params = SetupPaymentSheetParameters(
        paymentIntentClientSecret: intent!['client_secret'],
        style: ThemeMode.light,
        merchantDisplayName: 'Ikay',
      );

      await Stripe.instance.initPaymentSheet(paymentSheetParameters: params);

      await Stripe.instance.presentPaymentSheet();

      return Payment.fromJson({
        'error': false,
        'data': intent,
        'message': 'payment process complete',
      });
    } on NoInternetException catch (error) {
      notifyListeners();
      console.internet(error, trace);
      return Payment.fromJson({
        'error': true,
        'data': intent,
        'message': error.toString(),
      });
    } on PaymentIntentException catch (error) {
      notifyListeners();
      console.intent(error, trace);
      return Payment.fromJson({
        'error': true,
        'data': intent,
        'message': error.toString(),
      });
    } on StripeException catch (exception) {
      notifyListeners();
      console.stripe(exception, trace);
      return Payment.fromJson({
        'error': true,
        'data': intent,
        'message': exception.error.message.toString(),
      });
    } catch (error) {
      notifyListeners();
      console.error(error, trace);
      return Payment.fromJson({
        'error': true,
        'data': intent,
        'message': error.toString(),
      });
    }
  }

  Future<dynamic> createIntents(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      Response response = await post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${Environment.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw json.decode(response.body);
      }
    } catch (error) {
      console.error(error, trace);
      throw PaymentIntentException(error.toString());
    }
  }
}
