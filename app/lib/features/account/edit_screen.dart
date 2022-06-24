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
  final _formKey = GlobalKey<FormState>();

  bool _formValidate() => _formKey.currentState!.validate();

  void _formSave() {
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
        body: _buildScreen(context),
      );

  Widget _buildScreen(BuildContext context) {
    Account account = Provider.of<Account>(context);
    return Screen(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == '') {
                    return 'Name is required';
                  }
                  return null;
                },
                initialValue: account.metadata.name,
                onSaved: (value) {
                  account.metadata.setName(value);
                },
              ),
              const SizedBox(height: 16),
              DatePickerFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Birthday',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Birthday is required';
                  }
                  return null;
                },
                initialValue: account.metadata.birthday,
                onSaved: (value) {
                  account.metadata.setBirthday(value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Town/city',
                ),
                onTap: () async {},
                onSaved: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SexAtBirth>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Sex at birth',
                ),
                items: SexAtBirth.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_sexAtBirthText(value)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {},
                validator: (value) {
                  if (value == null) {
                    return 'Sex at birth is required';
                  }
                  return null;
                },
                value: account.metadata.sexAtBirth,
                onSaved: (value) {
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
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_relationshipStatusText(value)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {},
                validator: (value) {
                  if (value == null) {
                    return 'Relationship status is required';
                  }
                  return null;
                },
                value: account.metadata.relationshipStatus,
                onSaved: (value) {
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
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_workPeriodText(value)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {},
                validator: (value) {
                  if (value == null) {
                    return 'Work/study hours is required';
                  }
                  return null;
                },
                value: account.metadata.workPeriod,
                onSaved: (value) {
                  account.metadata.setWorkPeriod(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _sexAtBirthText(SexAtBirth sexAtBirth) {
  switch (sexAtBirth) {
    case SexAtBirth.male:
      return 'Male';
    case SexAtBirth.female:
      return 'Female';
    case SexAtBirth.unknown:
      return 'Other';
  }
}

String _relationshipStatusText(RelationshipStatus relationshipStatus) {
  switch (relationshipStatus) {
    case RelationshipStatus.single:
      return 'Single';
    case RelationshipStatus.coupled:
      return 'In a relationship';
    case RelationshipStatus.married:
      return 'Married';
  }
}

String _workPeriodText(WorkPeriod workPeriod) {
  switch (workPeriod) {
    case WorkPeriod.day:
      return 'Day worker';
    case WorkPeriod.night:
      return 'Night worker';
    case WorkPeriod.mixed:
      return 'Mixed-shift worker';
  }
}
