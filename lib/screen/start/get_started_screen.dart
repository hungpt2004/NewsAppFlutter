import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app_flutter/constant/constant.dart';
import 'package:news_app_flutter/providers/loading_provider.dart';
import 'package:news_app_flutter/providers/theme_provider.dart';
import 'package:news_app_flutter/screen/auth/login_screen.dart';
import 'package:news_app_flutter/screen/home_screen.dart';
import 'package:news_app_flutter/theme/message_dialog.dart';
import 'package:news_app_flutter/widget/bottom_navbar/bottom_navbar_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../model/category.dart';
import '../../theme/style.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  // final bool isDark;

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  int activeIndex = 0;

  final List<Category> categories = [
    Category(name: "Health", urlImage: "assets/images/health.jpg"),
    Category(name: "Sport", urlImage: "assets/images/sport.jpg"),
    Category(name: "Business", urlImage: "assets/images/business.jpg"),
    Category(name: "Fashion", urlImage: "assets/images/fashion.jpg"),
    Category(name: "Security", urlImage: "assets/images/security.jpg"),
  ];

  Future<void> _launchUrl() async {
    const url =
        "https://www.figma.com/design/TN26gsemHxQ5O0xfPRKyp5/News-App-UI-Kit-(Community)?node-id=89-1";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMessageDialog(context, "Could not launch URL", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final loadProvider = LoadingProvider.of(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildTopBar(themeProvider),
            _buildRotatingLogo(themeProvider),
            Style.space(40, 0),
            _buildDivider(context),
            _buildTitleAndCarousel(themeProvider),
            _buildHeading(themeProvider),
            Style.space(40, 0),
            _buildButton(
                themeProvider,
                "Get Started",
                const LoginScreen(),
                themeProvider.isDark ? Colors.white : primaryColors,
                loadProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _launchUrl,
            icon: const Icon(Icons.info),
            tooltip: 'Information about app',
          ),
          IconButton(
            onPressed: () {
              Future.delayed(const Duration(seconds: 5));
              themeProvider.toggleTheme();
            },
            icon: Icon(
              themeProvider.isDark ? Icons.brightness_2_rounded : Icons.sunny,
              color: themeProvider.isDark ? Colors.yellow : Colors.black,
            ),
            tooltip: 'Change brightness mode',
          ),
        ],
      ),
    );
  }

  Widget _buildRotatingLogo(ThemeProvider themeProvider) {
    return Center(
      child: Container(
        height: 150,
        width: Style.styleWidthDevice(context),
        decoration: const BoxDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Divider(color: Colors.grey.withOpacity(0.2)),
    );
  }

  Widget _buildTitleAndCarousel(ThemeProvider themeProvider) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35, // Responsive height
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildText("Breaking Boundaries with Media", 20, false,
                themeProvider.isDark),
            const SizedBox(height: 16),
            CarouselSlider.builder(
              itemCount: categories.length,
              itemBuilder: (context, index, realIndex) =>
                  _buildCategoryCard(categories[index]),
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() => activeIndex = index);
                },
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                aspectRatio: 16 / 9,
                viewportFraction: 0.7,
                enlargeCenterPage: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(ThemeProvider themeProvider) {
    return Center(
      child: _buildText("NewPulses", 40, false, themeProvider.isDark),
    );
  }

  Widget _buildButton(ThemeProvider themeProvider, String text, Widget page,
      Color color, LoadingProvider loadProvider) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(color),
            elevation: const WidgetStatePropertyAll(15),
            animationDuration: const Duration(milliseconds: 500),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
          ),
          onPressed: () async {
            await loadProvider.loading();
            Style.navigatorPush(context, page);
          },
          child: loadProvider.isLoading
              ? Padding(padding: const EdgeInsets.all(5),child: Style.loading(),)
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: textFontContent,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.isDark ? primaryColors : Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildText(
      String message, double size, bool isTitle, bool isDarkTheme) {
    return Text(
      message,
      style: TextStyle(
        fontSize: size,
        fontFamily: isTitle ? textFontContent : textFontTitle,
        fontWeight: FontWeight.w400,
        color: isDarkTheme ? Colors.white : primaryColors,
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(category.urlImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Center(
          child: Text(
            category.name,
            style: const TextStyle(
              fontFamily: textFontTitle,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
