import 'package:flutter/material.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const kTitleTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 25,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    );

    const kSubtitleTextStyle = TextStyle(
      color: Colors.black38,
      fontSize: 16,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    );
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/not-found.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 30,
            child: Text(
              'Pagina no encontrada',
              style: kTitleTextStyle.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 30,
            child: Text(
              'Oops! La pagina a la que intentas acceder\nno fue encontrada',
              style: kSubtitleTextStyle.copyWith(
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Positioned(
            bottom: 100,
            left: 30,
            right: 250,
            child: ReusableButton(
              childText: 'Volver',
              buttonColor: Colors.black,
              childTextColor: Colors.white,
              onPressed: () {
                AppNavigator().navigationToReplacementPage(
                    thePageRouteName: AppRoutes.mainPage);
              },
            ),
          ),
        ],
      ),
    );
  }
}
