class Payment {
  bool error;
  Data data;
  String message;

  Payment({
    required this.error,
    required this.data,
    required this.message,
  });

  factory Payment.fromJson(Map<String?, dynamic> json) {
    return Payment(
      error: json['error'],
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }

  get paid => !error;

  get status => error == true ? 'UNPAID' : 'PAID';

  Map<String?, dynamic> toJson() {
    return {
      'error': error,
      'data': data.toJson(),
      'message': message,
      'paid': paid,
      'status': status,
    };
  }
}

class Data {
  String id;
  String? object;
  num? amount;
  num? amountCapturable;
  AmountDetails? amountDetails;
  num? amountReceived;
  dynamic application;
  dynamic applicationFeeAmount;
  dynamic automaticPaymentMethods;
  dynamic canceledAt;
  dynamic cancellationReason;
  String? captureMethod;
  Charges? charges;
  String clientSecret;
  String? confirmationMethod;
  num? created;
  String? currency;
  dynamic customer;
  dynamic description;
  dynamic invoice;
  dynamic lastPaymentError;
  dynamic latestCharge;
  bool? livemode;
  Map<String?, dynamic>? metadata;
  dynamic nextAction;
  dynamic onBehalfOf;
  dynamic paymentMethod;
  dynamic paymentMethodConfigurationDetails;
  PaymentMethodOption? paymentMethodOptions;
  List<String?>? paymentMethodTypes;
  dynamic processing;
  dynamic receiptEmail;
  dynamic review;
  dynamic setupFutureUsage;
  dynamic shipping;
  dynamic source;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String? status;
  dynamic transferData;
  dynamic transferGroup;

  Data({
    this.id = "NONE",
    this.object,
    this.amount,
    this.amountCapturable,
    this.amountDetails,
    this.amountReceived,
    this.application,
    this.applicationFeeAmount,
    this.automaticPaymentMethods,
    this.canceledAt,
    this.cancellationReason,
    this.captureMethod,
    this.charges,
    this.clientSecret = "NONE",
    this.confirmationMethod,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.invoice,
    this.lastPaymentError,
    this.latestCharge,
    this.livemode,
    this.metadata,
    this.nextAction,
    this.onBehalfOf,
    this.paymentMethod,
    this.paymentMethodConfigurationDetails,
    this.paymentMethodOptions,
    this.paymentMethodTypes,
    this.processing,
    this.receiptEmail,
    this.review,
    this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.transferData,
    this.transferGroup,
  });

  factory Data.fromJson(Map<String?, dynamic> json) {
    return Data(
      id: json['id'],
      object: json['object'],
      amount: json['amount'],
      amountCapturable: json['amount_capturable'],
      amountDetails: json['amount_details'] != null
          ? AmountDetails.fromJson(json['amount_details'])
          : null,
      amountReceived: json['amount_received'],
      application: json['application'],
      applicationFeeAmount: json['application_fee_amount'],
      automaticPaymentMethods: json['automatic_payment_methods'],
      canceledAt: json['canceled_at'],
      cancellationReason: json['cancellation_reason'],
      captureMethod: json['capture_method'],
      charges:
          json['charges'] != null ? Charges.fromJson(json['charges']) : null,
      clientSecret: json['client_secret'],
      confirmationMethod: json['confirmation_method'],
      created: json['created'],
      currency: json['currency'],
      customer: json['customer'],
      description: json['description'],
      invoice: json['invoice'],
      lastPaymentError: json['last_payment_error'],
      latestCharge: json['latest_charge'],
      livemode: json['livemode'],
      metadata: json['metadata'] != null
          ? Map<String?, dynamic>.from(json['metadata'])
          : null,
      nextAction: json['next_action'],
      onBehalfOf: json['on_behalf_of'],
      paymentMethod: json['payment_method'],
      paymentMethodConfigurationDetails:
          json['payment_method_configuration_details'],
      paymentMethodOptions: json['payment_method_options'] != null
          ? PaymentMethodOption.fromJson(json['payment_method_options'])
          : null,
      paymentMethodTypes: json['payment_method_types'] != null
          ? List<String?>.from(json['payment_method_types'])
          : null,
      processing: json['processing'],
      receiptEmail: json['receipt_email'],
      review: json['review'],
      setupFutureUsage: json['setup_future_usage'],
      shipping: json['shipping'],
      source: json['source'],
      statementDescriptor: json['statement_descriptor'],
      statementDescriptorSuffix: json['statement_descriptor_suffix'],
      status: json['status'],
      transferData: json['transfer_data'],
      transferGroup: json['transfer_group'],
    );
  }

  Map<String?, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'amount': amount,
      'amount_capturable': amountCapturable,
      'amount_details': amountDetails?.toJson(),
      'amount_received': amountReceived,
      'application': application,
      'application_fee_amount': applicationFeeAmount,
      'automatic_payment_methods': automaticPaymentMethods,
      'canceled_at': canceledAt,
      'cancellation_reason': cancellationReason,
      'capture_method': captureMethod,
      'charges': charges?.toJson(),
      'client_secret': clientSecret,
      'confirmation_method': confirmationMethod,
      'created': created,
      'currency': currency,
      'customer': customer,
      'description': description,
      'invoice': invoice,
      'last_payment_error': lastPaymentError,
      'latest_charge': latestCharge,
      'livemode': livemode,
      'metadata': metadata,
      'next_action': nextAction,
      'on_behalf_of': onBehalfOf,
      'payment_method': paymentMethod,
      'payment_method_configuration_details': paymentMethodConfigurationDetails,
      'payment_method_options': paymentMethodOptions?.toJson(),
      'payment_method_types': paymentMethodTypes,
      'processing': processing,
      'receipt_email': receiptEmail,
      'review': review,
      'setup_future_usage': setupFutureUsage,
      'shipping': shipping,
      'source': source,
      'statement_descriptor': statementDescriptor,
      'statement_descriptor_suffix': statementDescriptorSuffix,
      'status': status,
      'transfer_data': transferData,
      'transfer_group': transferGroup,
    };
  }
}

class AmountDetails {
  Map<String?, dynamic>? tip;

  AmountDetails({this.tip});

  factory AmountDetails.fromJson(Map<String?, dynamic> json) {
    return AmountDetails(
        tip: json['tip'] != null
            ? Map<String?, dynamic>.from(json['tip'])
            : null);
  }

  Map<String?, dynamic> toJson() {
    return {
      'tip': tip,
    };
  }
}

class Charges {
  String? object;
  List<dynamic>? data;
  bool? hasMore;
  num? totalCount;
  String? url;

  Charges({
    this.object,
    this.data,
    this.hasMore,
    this.totalCount,
    this.url,
  });

  factory Charges.fromJson(Map<String?, dynamic> json) {
    return Charges(
      object: json['object'],
      data: json['data'] != null ? List<dynamic>.from(json['data']) : null,
      hasMore: json['has_more'],
      totalCount: json['total_count'],
      url: json['url'],
    );
  }

  Map<String?, dynamic> toJson() {
    return {
      'object': object,
      'data': data,
      'has_more': hasMore,
      'total_count': totalCount,
      'url': url,
    };
  }
}

class PaymentMethodOption {
  Cards? card;

  PaymentMethodOption({this.card});

  factory PaymentMethodOption.fromJson(Map<String?, dynamic> json) {
    return PaymentMethodOption(
      card: json['card'] != null ? Cards.fromJson(json['card']) : null,
    );
  }

  Map<String?, dynamic> toJson() {
    return {
      'card': card?.toJson(),
    };
  }
}

class Cards {
  dynamic installments;
  dynamic mandateOptions;
  dynamic network;
  String? requestThreeDSecure;

  Cards({
    this.installments,
    this.mandateOptions,
    this.network,
    this.requestThreeDSecure,
  });

  factory Cards.fromJson(Map<String?, dynamic> json) {
    return Cards(
      installments: json['installments'],
      mandateOptions: json['mandate_options'],
      network: json['network'],
      requestThreeDSecure: json['request_three_d_secure'],
    );
  }

  Map<String?, dynamic> toJson() {
    return {
      'installments': installments,
      'mandate_options': mandateOptions,
      'network': network,
      'request_three_d_secure': requestThreeDSecure,
    };
  }
}
