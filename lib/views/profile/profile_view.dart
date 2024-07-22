import 'package:flutter/material.dart';
import 'package:myapp/controllers/user_controller.dart';
import 'package:myapp/models/contact_model.dart';
import 'package:myapp/utils/palletes.dart';
import 'package:myapp/views/authentication/login_view.dart';
import 'package:myapp/views/homepage/contact/contact_detail_view.dart';

class ProfileView extends StatefulWidget {
  final String id;

  const ProfileView({super.key, required this.id});
  @override
  State<StatefulWidget> createState() {
    return ProfileViewState();
  }
}

// Suggested code may be subject to a license. Learn more: ~LicenseLog:2017560244.
class ProfileViewState extends State<ProfileView> {
  final UserController _userController = UserController();
  ContactModel? user;

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  void loadUser() async {
    await _userController.loadUser(widget.id).then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Palette.white,
        elevation: 4.0,
        shadowColor: Palette.lightGray.withOpacity(0.3),
        backgroundColor: Palette.white,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Palette.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: () async {
                await _userController.saveSession('').then((val) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(isLogOut: true),
                    ),
                  );
                });
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Palette.blue,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Center(
              child: _profileAvatar,
            ),
            const SizedBox(height: 20.0),
            Text(
              user?.fullName.toString() ?? 'Full Name',
              style: TextStyle(
                color: Palette.black2,
                fontSize: 18.0,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              user?.email ?? 'Email',
              style: TextStyle(
                color: Palette.black2,
                fontSize: 18.0,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              user?.dob ?? 'Date of Birth',
              style: TextStyle(
                color: Palette.black2,
                fontSize: 18.0,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 25.0),
            SizedBox(
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  shadowColor: Colors.transparent,
                  backgroundColor: const Color(0xFFecf7fd),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactDetailView(
                        contact: user,
                        updateProfile: true,
                      ),
                    ),
                  ).then((value) async {
                    if (value is ContactModel) {
                      await _userController.saveUser(value).then((value) {
                        if (value == true) {
                          loadUser();
                        }
                      });
                    }
                  });
                },
                child: Text(
                  'Update my detail',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 20.0,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _profileAvatar {
    return CircleAvatar(
      radius: 40.0,
      backgroundColor: Palette.blue,
      child: user?.fullName != 'Full Name'
          ? Text(
              user?.nameAbbr ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.w100,
              ),
            )
          : Icon(
              Icons.person_outline,
              color: Palette.white,
              size: 40.0,
            ),
    );
  }
}
