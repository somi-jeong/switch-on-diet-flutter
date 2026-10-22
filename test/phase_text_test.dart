import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/screens/tabs/widgets/top_info_card.dart';

void main() {
  test('phase card text follows the program phase boundaries', () {
    String title(int day) => TopInfoCard.phaseText(day).$1;

    expect(title(1), title(3));
    expect(title(4), isNot(title(3)));
    expect(title(7), title(4));
    expect(title(8), isNot(title(7)));
    expect(title(14), title(8));
    expect(title(15), isNot(title(14)));
    expect(title(21), title(15));
    expect(title(22), isNot(title(21)));
    expect(title(28), title(22));
  });
}
