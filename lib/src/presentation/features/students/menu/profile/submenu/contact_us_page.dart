import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What can we help?'),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: SpacingColumn(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact our application service for assistance or to report features that are not working properly',
              style: textTheme.bodyMedium?.copyWith(color: primaryTextColor),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      ReusableFunctionHelper.urlLauncher(
                          'https://forms.gle/4nC6ckakFDU4rpyT7');
                    },
                    child: Text('Google Form'))),
            Center(child: Text('OR')),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      ReusableFunctionHelper.urlLauncher(
                          'https://www.instagram.com/npe.digital/');
                    },
                    child: Text('DM on Instagram'))),
            Center(child: Text('OR')),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      ReusableFunctionHelper.urlLauncher(
                          'https://wa.me/+6285172065497');
                    },
                    child: Text('Chat via WhatsApp'))),
          ],
        ),
      )),
    );
  }
}
