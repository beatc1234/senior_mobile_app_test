import 'package:flutter/material.dart';
import 'package:myapp/controllers/contact_controller.dart';
import 'package:myapp/controllers/user_controller.dart';
import 'package:myapp/models/contact_model.dart';
import 'package:myapp/utils/palletes.dart';
import 'package:myapp/views/homepage/contact/contact_detail_view.dart';

class ContactListView extends StatefulWidget {
  final String id;

  const ContactListView({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return ContactListViewState();
  }
}

class ContactListViewState extends State<ContactListView> {
  List<ContactModel> contacts = [];
  List<ContactModel> newContacts = [];
  List<String> deleted = [];
  Map<String, List<ContactModel>> _groupedData = {};
  Map<String, List<ContactModel>> _groupedDataCpy = {};
  final ContactController _contactController = ContactController();
  final UserController _userController = UserController();
  ContactModel? user;

  @override
  void initState() {
    loadUser();
    loadContacts();
    super.initState();
  }

  void loadUser() async {
    await _userController.loadUser(widget.id).then((value) {
      setState(() {
        user = value;
      });
    });
  }

  void loadContacts() async {
    resetGroup();
    await _contactController.loadUsersFromJson().then((value) {
      setState(() {
        contacts = value;
        contacts
            .sort((a, b) => (a.firstName ?? '').compareTo(b.firstName ?? ''));
        groupContacts();
      });
    });
  }

  void groupContacts() {
    for (var item in contacts) {
      if (!_groupedData.containsKey(item.firstName![0].toUpperCase())) {
        _groupedData[item.firstNameFirstLetter] = [item];
      } else {
        _groupedData[item.firstNameFirstLetter]?.add(item);
      }
    }
    _groupedDataCpy = {..._groupedData};
  }

  void resetGroup() {
    _groupedData = {};
    _groupedDataCpy = {};
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
            'My Contacts',
            style: TextStyle(
              color: Palette.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search your contact list...',
                  hintStyle: TextStyle(
                    color: Palette.darkGray,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.darkGray,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.darkGray,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.darkGray,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: const Icon(Icons.search),
                ),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _groupedData = Map.fromEntries(_groupedDataCpy.entries
                        .where((entry) => entry.value
                            .where((element) => element.fullName
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .isNotEmpty));
                  } else {
                    _groupedData = _groupedDataCpy;
                  }
                  setState(() {});
                },
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    loadContacts();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _groupedData.length,
                    itemBuilder: (context, groupIndex) {
                      final groupKey = _groupedData.keys.elementAt(groupIndex);
                      final items = _groupedData[groupKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          Text(
                            groupKey,
                            style: TextStyle(
                              color: Palette.blue,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 15.0);
                            },
                            padding: EdgeInsets.zero,
                            itemCount: items.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContactDetailView(
                                        contact: items[index],
                                      ),
                                    ),
                                  ).then((val) {
                                    if (val is ContactModel) {
                                      setState(() {
                                        items[index] = val;
                                      });
                                    }
                                    if (val is String) {
                                      deleted.add(val);
                                      contacts.removeWhere(
                                          (element) => element.id == val);
                                      contacts.addAll(newContacts);
                                      resetGroup();
                                      groupContacts();
                                      setState(() {});
                                    }
                                  });
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Palette.blue,
                                    child: Text(
                                      items[index].nameAbbr,
                                      style: TextStyle(
                                        color: Palette.white,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          items[index].fullName,
                                          style: TextStyle(
                                            color: Palette.black2,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ),
                                      if (user?.id.toString() ==
                                          items[index].id.toString())
                                        Text(
                                          ' (You)',
                                          style: TextStyle(
                                            color: Palette.darkGray,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactDetailView(),
              ),
            ).then((val) {
              if (val is ContactModel) {
                setState(() {
                  newContacts.add(val);
                  contacts.addAll(newContacts);
                  contacts
                      .removeWhere((element) => deleted.contains(element.id));
                  resetGroup();
                  groupContacts();
                });
              }
            });
          },
          shape: const CircleBorder(),
          backgroundColor: Palette.blue,
          child: Text(
            '+',
            style: TextStyle(
              color: Palette.white,
              fontSize: 25.0,
            ),
          ),
        ));
  }
}
