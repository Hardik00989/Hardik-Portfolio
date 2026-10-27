import 'portfolio_data.dart';
import 'package:web/web.dart' as web;

void downloadCv() {
  final link = web.HTMLAnchorElement()
    ..href = Uri.base.resolve(PortfolioData.cvFile).toString()
    ..download = PortfolioData.cvFile;
  web.document.body?.append(link);
  link.click();
  link.remove();
}
