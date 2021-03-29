import 'package:deluca/data/provider/user_pick_provider.dart';
import 'package:deluca/data/provider/user_provider.dart';
import 'package:deluca/data/provider/user_subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Profile {
  final String name;
  final String email;
  final String totalPost;
  final String totalPicks;
  final String totalSubscriptions;

  Profile({
    required this.name,
    required this.email,
    required this.totalPicks,
    required this.totalSubscriptions,
    required this.totalPost,
  });
}

class AppData {
  static List<Profile> profiles = [
    Profile(
      name: 'Sarah Rodriguez',
      email:
          'UI/UX Designer at GTBank & Creative Director at PxDsgn Co. Creating simple digital products over. Let’s talk designs via\n email: sgnco@gmail.com',
      totalPost: '31sss2',
      totalPicks: '12.4m',
      totalSubscriptions: '13.2m',
    ),
    Profile(
      name: 'Úrsula Kalyana',
      email:
          'Senior UI/UX Designer at Guaranty Trust Bank Plc & Creative Director at PxDsgn Co. Creating simple  Let’s talk designs via\n email: sgnco@gmail.com',
      totalPost: '2',
      totalPicks: '15.4m',
      totalSubscriptions: '1.2m',
    ),
    Profile(
      name: 'Hai Garrett',
      email:
          'UI/UX Designer at GTBank & Creative Director at PxDsgn Co. Creating simple digital products over. Let’s talk designs via\n email: sgnco@gmail.com',
      totalPost: '32',
      totalPicks: '1.4m',
      totalSubscriptions: '1.2m',
    ),
    Profile(
      name: 'Clifton Peterson',
      email:
          'Senior UI/UX Designer at Guaranty Trust Bank Plc & Creative Director at PxDsgn Co. Creating simple  Let’s talk designs via\n email: sgnco@gmail.com',
      totalPost: '32',
      totalPicks: '1.4m',
      totalSubscriptions: '16.2m',
    )
  ];
}

class UserProfilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HookBuilder(builder: (context) {
        final userModel = useProvider(userProvider);
        final userSubscriptionModel = useProvider(userSubscriptionProvider);
        useFuture(useMemoized(() => userSubscriptionModel.load(), []),
            initialData: null);
        final userPickModel = useProvider(userPickProvider);
        useFuture(useMemoized(() => userPickModel.load(), []),
            initialData: null);

        final current = userModel.user;
        final profile = Profile(
          name: current?.displayName ?? '',
          email: current?.email ?? '',
          totalPicks: userPickModel.picks.length.toString(),
          totalSubscriptions:
              userSubscriptionModel.subscriptions.length.toString(),
          totalPost: '100',
        );

        return ListView(
          children: <Widget>[
            SizedBox(height: 20),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 750),
              transitionBuilder: (child, animation) => SlideTransition(
                child: child,
                position: Tween<Offset>(
                        begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                    .animate(animation),
              ),
              child: HeaderSection(
                profile: profile,
              ),
            ),
            SizedBox(height: 40),
            Container(
              child: Wrap(
                children: <Widget>[
                  for (int i = 0; i < AppData.profiles.length; i++)
                    GestureDetector(
                      onTap: () {
                        //profile = AppData.profiles[i];
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width / 3,
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Profile profile;
  HeaderSection({
    required this.profile,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 110,
            width: 100,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(100),
            //   image: DecorationImage(image: AssetImage(''), fit: BoxFit.cover),
            // ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              profile.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              profile.email,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      profile.totalPicks,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('Picks')
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      profile.totalSubscriptions,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('Subs')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
