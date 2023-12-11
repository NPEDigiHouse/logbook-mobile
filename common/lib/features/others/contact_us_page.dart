import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/spacing_column.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What can we help?'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: SpacingColumn(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact our application service for assistance or to report features that are not working properly',
              style: textTheme.bodyMedium?.copyWith(color: primaryTextColor),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      Utils.urlLauncher('https://forms.gle/4nC6ckakFDU4rpyT7');
                    },
                    child: const Text('Google Form'))),
            const Center(child: Text('OR')),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      Utils.urlLauncher(
                          'https://www.instagram.com/npe.digital/');
                    },
                    child: const Text('DM on Instagram'))),
            const Center(child: Text('OR')),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      Utils.urlLauncher('https://wa.me/+6285172065497');
                    },
                    child: const Text('Chat via WhatsApp'))),
          ],
        ),
      )),
    );
  }
}
