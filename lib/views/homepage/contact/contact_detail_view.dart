import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/models/contact_model.dart';
import 'package:myapp/utils/palletes.dart';

class ContactDetailView extends StatefulWidget {
  final ContactModel? contact;
  final bool updateProfile;

  const ContactDetailView({
    super.key,
    this.contact,
    this.updateProfile = false,
  });

  @override
  ContactDetailState createState() {
    return ContactDetailState();
  }
}

class ContactDetailState extends State<ContactDetailView> {
  bool isValidate = false;
  final _formKey = GlobalKey<FormState>();
  ContactModel contact = ContactModel();

  @override
  void initState() {
    contact = widget.contact ?? ContactModel();
    super.initState();
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Palette.white,
        elevation: 4.0,
        shadowColor: Palette.lightGray.withOpacity(0.3),
        backgroundColor: Palette.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.0,
            color: Palette.black,
          ),
        ),
        title: Text(
          widget.updateProfile ? 'Update Profile' : 'Contact Details',
          style: TextStyle(
            color: Palette.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Center(
                  child: _profileAvatar,
                ),
                const SizedBox(height: 35.0),
                _header('Main Information'),
                const SizedBox(height: 10.0),
                _textField(
                  label: 'First Name',
                  iconData: Icons.person_outline,
                  hint: 'Enter first name',
                  optional: false,
                  value: contact.firstName,
                  attr: 'firstName',
                ),
                const SizedBox(height: 20.0),
                _textField(
                  label: 'Last Name',
                  iconData: Icons.person_outline,
                  hint: 'Enter last name',
                  optional: false,
                  value: contact.lastName,
                  attr: 'lastName',
                ),
                const SizedBox(height: 30.0),
                _header('Sub Information'),
                const SizedBox(height: 10.0),
                _textField(
                  label: 'Email',
                  iconData: Icons.email_outlined,
                  hint: 'Enter email',
                  validator: (value) {
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value ?? '')) {
                      return 'Please enter a valid email';
                    }
                  },
                  value: contact.email,
                  attr: 'email',
                ),
                const SizedBox(height: 20.0),
                _textField(
                  label: 'Date of Birth',
                  iconData: Icons.calendar_month,
                  hint: 'Enter birthday',
                  value: contact.dob,
                  validator: (value) {
                    final RegExp regex = RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$');
                    if (!regex.hasMatch(value ?? '')) {
                      return 'Invalid date format. Please use dd/mm/yyyy';
                    }
                  },
                  attr: 'dob',
                ),
                const SizedBox(height: 50.0),
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
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _formKey.currentState!.save();
                        if (widget.contact == null) {
                          contact.id = generateRandomString(10);
                        } else {
                          contact.id = widget.contact!.id;
                        }
                        Navigator.pop(context, contact);
                      }
                    },
                    child: Text(
                      (widget.contact != null) ? 'Update' : 'Save',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 20.0,
                          ),
                    ),
                  ),
                ),
                if (widget.contact != null && !widget.updateProfile)
                  const SizedBox(height: 20.0),
                if (widget.contact != null && !widget.updateProfile)
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Palette.red),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, contact.id);
                      },
                      child: Text(
                        'Remove',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.0,
                                  color: Palette.red,
                                ),
                      ),
                    ),
                  ),
                const SizedBox(height: kBottomNavigationBarHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _profileAvatar {
    return CircleAvatar(
      radius: 40.0,
      backgroundColor: Palette.blue,
      child: widget.contact != null
          ? Text(
              widget.contact!.nameAbbr,
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

  Widget _header(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Palette.blue,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
          ),
        ),
        // SizedBox(height: 2.0),
        const Divider(),
      ],
    );
  }

  Widget _textField({
    required String label,
    bool optional = true,
    required IconData iconData,
    required String hint,
    Function(String?)? validator,
    String? value,
    required String attr,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              if (!optional)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Palette.red,
                    fontFeatures: const [FontFeature.superscripts()],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        TextFormField(
          onSaved: (newValue) {
            final model = contact.toJson();
            setState(() {
              model[attr] = newValue;
              contact = ContactModel.fromJson(model);
            });
          },
          initialValue: value,
          validator: (value) {
            if (!optional) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
            }
            if (validator != null) {
              return validator(value);
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIconColor: Palette.blue,
            prefixIcon: Icon(iconData),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Palette.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Palette.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Palette.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ],
    );
  }
}
