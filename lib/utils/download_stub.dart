import 'portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';

void downloadCv() {
  launchUrl(Uri.base.resolve(PortfolioData.cvFile));
}
