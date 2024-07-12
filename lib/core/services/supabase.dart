import 'package:flutter/material.dart';
import '/core/app_export.dart';

class SupabaseService with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  late ConnectivityProvider connectivity;

  SupabaseService(this.context) {
    connectivity = context.read<ConnectivityProvider>();
  }

  GoTrueClient get auth {
    return supabase.auth;
  }

  SupabaseStorageClient get storage {
    return supabase.storage;
  }

  SupabaseQueryBuilder from(String table) {
    return supabase.from(table);
  }

  Future rpc(String fn, {Map<String, dynamic> body = const {}}) async {
    Map<String, dynamic>? params = {};

    Box box = await Hive.openBox('Users');

    Map<String, dynamic>? header = {
      'id': box.get('Id'),
      'uuid': box.get('Uuid'),
    };

    params.addAll({
      'header': header,
      'body': body,
    });

    return supabase.rpc(fn, params: params).then((response) {
      return response;
    }, onError: (error) {
      throw error;
    });
  }
}
