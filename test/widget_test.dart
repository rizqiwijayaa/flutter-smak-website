import 'package:flutter_test/flutter_test.dart';
import 'package:website_smak/main.dart';

void main() {
  testWidgets('renders the SMAK landing page', (tester) async {
    await tester.pumpWidget(const SmakApp());
    expect(find.text('Sekolah Menengah Atas Katolik'), findsWidgets);
    expect(find.text('Berita & Pengumuman'), findsOneWidget);
  });
}
