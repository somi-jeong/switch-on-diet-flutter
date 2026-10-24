import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/time/clock.dart';

final clockProvider = Provider<Clock>((ref) => const JstClock());
