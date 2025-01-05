import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tailershop/constants/appColors.dart';
import 'package:tailershop/provider/auth.dart';
import 'package:direct_call_plus/direct_call_plus.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Contact Us'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${p.contact_us_text}',
                  style: GoogleFonts.laila(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                p.show_contact_number
                    ? Column(
                        children: [
                          Text(
                            'Phone Number:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${p.contact_us_number}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          floatingActionButton: p.show_contact_number
              ? FloatingActionButton(
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(Icons.call, color: Colors.white),
                  onPressed: () async {
                    await DirectCallPlus.makeCall(
                        p.contact_us_number.toString());
                  })
              : null);
    });
  }
}
