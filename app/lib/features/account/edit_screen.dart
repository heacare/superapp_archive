import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../widgets/date_picker_form_field.dart' show DatePickerFormField;
import '../../widgets/screen.dart' show Screen;
import 'account.dart' show Account;
import 'metadata.dart' show SexAtBirth, RelationshipStatus, WorkPeriod;

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _formValidate() => _formKey.currentState!.validate();

  void _formSave() {
    _formKey.currentState!.save();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit profile'),
          centerTitle: true,
          leading: const CloseButton(),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () async {
                if (_formValidate()) {
                  _formSave();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
        body: EditScreen(
          formKey: _formKey,
        ),
      );
}

class EditScreen extends StatelessWidget {
  const EditScreen({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(final BuildContext context) {
    final Account account = Provider.of<Account>(context);
    return Screen(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildFields(context, account),
        ),
      ),
    );
  }

  Widget _buildFields(final BuildContext context, final Account account) =>
      Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
            validator: (final String? value) {
              if (value == '') {
                return 'Name is required';
              }
              return null;
            },
            initialValue: account.metadata.name,
            onSaved: (final String? value) {
              account.metadata.setName(value);
            },
          ),
          const SizedBox(height: 16),
          DatePickerFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Birthday',
            ),
            validator: (final DateTime? value) {
              if (value == null) {
                return 'Birthday is required';
              }
              return null;
            },
            initialValue: account.metadata.birthday,
            onSaved: (final DateTime? value) {
              account.metadata.setBirthday(value);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Town/city and country',
              hintText: 'London, UK',
            ),
            validator: (final String? value) {
              if (value == '') {
                return 'Town/city and country is required';
              }
              return null;
            },
            initialValue: account.metadata.regionText,
            onSaved: (final String? value) {
              account.metadata.setRegionText(value);
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<SexAtBirth>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sex at birth',
            ),
            items: SexAtBirth.values
                .map(
                  (final SexAtBirth value) => DropdownMenuItem(
                    value: value,
                    child: Text(_sexAtBirthText(value)),
                  ),
                )
                .toList(),
            onChanged: (final SexAtBirth? value) async {},
            validator: (final SexAtBirth? value) {
              if (value == null) {
                return 'Sex at birth is required';
              }
              return null;
            },
            value: account.metadata.sexAtBirth,
            onSaved: (final SexAtBirth? value) {
              account.metadata.setSexAtBirth(value);
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<RelationshipStatus>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Relationship status',
            ),
            items: RelationshipStatus.values
                .map(
                  (final RelationshipStatus value) => DropdownMenuItem(
                    value: value,
                    child: Text(_relationshipStatusText(value)),
                  ),
                )
                .toList(),
            onChanged: (final RelationshipStatus? value) async {},
            validator: (final RelationshipStatus? value) {
              if (value == null) {
                return 'Relationship status is required';
              }
              return null;
            },
            value: account.metadata.relationshipStatus,
            onSaved: (final RelationshipStatus? value) {
              account.metadata.setRelationshipStatus(value);
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<WorkPeriod>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Work/study hours',
            ),
            items: WorkPeriod.values
                .map(
                  (final WorkPeriod value) => DropdownMenuItem(
                    value: value,
                    child: Text(_workPeriodText(value)),
                  ),
                )
                .toList(),
            onChanged: (final WorkPeriod? value) async {},
            validator: (final WorkPeriod? value) {
              if (value == null) {
                return 'Work/study hours is required';
              }
              return null;
            },
            value: account.metadata.workPeriod,
            onSaved: (final WorkPeriod? value) {
              account.metadata.setWorkPeriod(value);
            },
          ),
        ],
      );
}

String _sexAtBirthText(final SexAtBirth sexAtBirth) {
  switch (sexAtBirth) {
    case SexAtBirth.male:
      return 'Male';
    case SexAtBirth.female:
      return 'Female';
    case SexAtBirth.unknown:
      return 'Other';
  }
}

String _relationshipStatusText(final RelationshipStatus relationshipStatus) {
  switch (relationshipStatus) {
    case RelationshipStatus.single:
      return 'Single';
    case RelationshipStatus.coupled:
      return 'In a relationship';
    case RelationshipStatus.married:
      return 'Married';
  }
}

String _workPeriodText(final WorkPeriod workPeriod) {
  switch (workPeriod) {
    case WorkPeriod.day:
      return 'Day worker';
    case WorkPeriod.night:
      return 'Night worker';
    case WorkPeriod.mixed:
      return 'Mixed-shift worker';
  }
}
