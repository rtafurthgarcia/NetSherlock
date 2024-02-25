import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:netsherlock/models/new_shodan_asset_model.dart';
import 'package:netsherlock/services/shodan_assets_service.dart';
import 'package:netsherlock/shared.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({super.key});
  
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShodanAssetsService(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text ("Bug reporting"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6.0),
            child: Consumer<ShodanAssetsService>(
              builder: (context, shodanAssetsService, child) {
                if (shodanAssetsService.state == ShodanState.loading) {
                  return const LinearProgressIndicator();
                } else {
                  return Container();
                }
              }
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an e-mail address';
                        }

                        if (! EmailValidator.validate(value)) {
                          return "Please enter a valid e-mail address";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: commentsController,
                      decoration: const InputDecoration(labelText: 'Comments'),
                      minLines: 4,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some valid comments, otherwise its all useless to me.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                     ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          String email = emailController.text;
                          String name = nameController.text;
                          String comments = commentsController.text;
                          
                          SentryId sentryId = await Sentry.captureMessage("Bug Report");

                          final userFeedback = SentryUserFeedback(
                              eventId: sentryId,
                              comments: comments,
                              email: email,
                              name: name,
                          );

                          await Sentry.captureUserFeedback(userFeedback);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                            content: Text("Thanks for your report, $name"),
                            action: SnackBarAction(
                              label: "See you soon!",
                              onPressed: () {
                                // accept my fate.
                              }),
                            )
                          );

                          Navigator.maybePop(context);
                        }
                      },
                      child: const Text('Send report'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}