import 'package:flutter/material.dart';
import 'package:news_app_flutter/providers/favourite_provider.dart';
import 'package:news_app_flutter/providers/theme_provider.dart';
import '../../theme/message_dialog.dart';
import '../../theme/style.dart';
import 'news_detail_screen.dart';

class FavouriteNewsScreen extends StatefulWidget {
  const FavouriteNewsScreen({super.key});


  @override
  State<FavouriteNewsScreen> createState() => _FavouriteNewsScreenState();
}

class _FavouriteNewsScreenState extends State<FavouriteNewsScreen> {
  @override
  Widget build(BuildContext context) {

    final provider = FavouriteProvider.of(context);
    final themeProvider = ThemeProvider.of(context); //instance of provider

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background Container
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: !themeProvider.isDark ? Colors.white : Colors.black12,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  child: Style.styleTitlePage("Favorites News", 35, themeProvider)
                ),
              ),
            ),
            // FutureBuilder for Articles
            Positioned.fill(
              top: 100, // Adjust the top position to avoid overlap with the title
              child: ListView.builder(
                itemCount: provider.articles.length,
                itemBuilder: (context, index) {
                  final article = provider.articles[index];
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          //IMAGE
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10), // Thêm góc bo cho Container
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              //IMAGE
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Style.networkImage(article.urlToImage!)
                              ),
                            ),
                          ),

                          //OVERLAY
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                onTap: () {
                                  Style.navigatorPush(context, NewsDetails(
                                    articleIndex: provider.articles[index],
                                  ),);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.3),
                                ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: SizedBox(
                                          width: double.infinity * 0.2,
                                          height: 50,
                                          child: Style.styleTitleOnCard(article.title, 17)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              child: Style.styleContentOnCard(article.author ?? '', 12)
                                            ),
                                            Style.styleContentOnCard(formatDate(article.publishedAt),10)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}