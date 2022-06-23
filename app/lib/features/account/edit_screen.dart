import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

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

  bool _formValid() {
    FormState state = _formKey.currentState!;
    return state.validate();
  }

  void _formSave() {
    FormState state = _formKey.currentState!;
    state.save();
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
                if (_formValid()) {
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

  @override
  Widget _buildScreen(BuildContext context) {
    Account account = Provider.of<Account>(context);
    return Screen(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  if (value == null) {
                    return 'wtf';
                  }
                  return null;
                },
                initialValue: account.metadata.name,
                onSaved: (value) {
                  account.metadata.setName(value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Birthday',
                ),
                onTap: () async {},
                onSaved: (value) {},
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
