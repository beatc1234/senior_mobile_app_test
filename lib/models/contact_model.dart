class ContactModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;

  ContactModel({this.id, this.firstName, this.lastName, this.email, this.dob});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dob': dob,
    };
  }

  String get fullName {
    String fullname = 'Full Name';
    if (firstName != null) {
      fullname = '';
      fullname += firstName!;
    }
    if (lastName != null) {
      fullname += ' ${lastName!}';
    }
    return fullname;
  }

  String? get nameAbbr {
    String? abbr;
    if (firstName != null && firstName!.isNotEmpty) {
      abbr = (abbr ?? '') + firstName![0].toUpperCase();
    }
    if (lastName != null && lastName!.isNotEmpty) {
      abbr = (abbr ?? '') + lastName![0].toUpperCase();
    }
    return abbr;
  }

  String get firstNameFirstLetter {
    String firstLetter = '';
    if (firstName != null) {
      firstLetter += firstName![0].toUpperCase();
    }
    return firstLetter;
  }
}
