import 'package:extinctx/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider((ref) => DatabaseService());
