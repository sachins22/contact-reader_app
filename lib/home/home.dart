import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  List<Contact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContact();
    } else {
      if (await Permission.contacts.request().isGranted) {
        fetchContact();
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacts permission denied')),
        );
      }
    }
  }

  void fetchContact() async {
    contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      isLoading = false;
    });
  }

  // Call function
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : contacts.isEmpty
              ? const Center(child: Text('No Contacts Found'))
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    final phoneNumber = contact.phones.isNotEmpty
                        ? contact.phones.first.number
                        : null;

                    return ListTile(
                      leading: Container(
                        height: 30.h,
                        width: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 7,
                              color: Colors.white.withOpacity(0.1),
                              offset: const Offset(-3, -3),
                            ),
                            BoxShadow(
                              blurRadius: 7,
                              color: Colors.black.withOpacity(0.7),
                              offset: const Offset(3, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(6.r),
                          color: const Color(0XFF262626),
                        ),
                        child: Text(
                          contact.displayName.isNotEmpty
                              ? contact.displayName[0]
                              : '?',
                          style: TextStyle(
                            fontSize: 23.sp,
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      title: Text(
                        contact.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        phoneNumber ?? 'No Number',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0XFFC4c4c4),
                        ),
                      ),
                      horizontalTitleGap: 12.w,
                      trailing: phoneNumber != null
                          ? IconButton(
                              icon:
                                  const Icon(Icons.phone, color: Colors.green),
                              onPressed: () => _makePhoneCall(phoneNumber),
                            )
                          : null,
                    );
                  },
                ),
    );
  }
}
