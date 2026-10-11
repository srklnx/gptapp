import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/sheep_providers.dart';
import '../domain/sheep_record.dart';

class EditSheepPage extends ConsumerStatefulWidget {
  const EditSheepPage({required this.sheepId, super.key});

  final String sheepId;

  @override
  ConsumerState<EditSheepPage> createState() => _EditSheepPageState();
}

class _EditSheepPageState extends ConsumerState<EditSheepPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tag;
  late final TextEditingController _name;
  late final TextEditingController _rfid;
  late final TextEditingController _color;
  late final TextEditingController _markings;
  late final TextEditingController _source;
  late final TextEditingController _purchasePrice;
  late final TextEditingController _notes;
  late final TextEditingController _customBreed;

  late String _breed;
  late SheepSex _sex;
  DateTime? _birthDate;
  bool _birthDateUnknown = false;
  String _groupName = '';
  DateTime? _pendingPurchaseDate;

  static const _breeds = [
    'Awassi',
    'Najdi',
    'Najdi Cross',
    'Assaf',
    'Dorper',
    'Merino',
    'Local',
    'Crossbred',
    'Mixed',
    'Unknown',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final record = ref.read(sheepByIdProvider(widget.sheepId))!;
    _tag = TextEditingController(text: record.tagNumber);
    _name = TextEditingController(text: record.name ?? '');
    _rfid = TextEditingController(text: record.eidRfid ?? '');
    _color = TextEditingController(text: record.color ?? '');
    _markings = TextEditingController(text: record.markings ?? '');
    _source = TextEditingController(text: record.source ?? '');
    _purchasePrice = TextEditingController(
      text: record.purchasePrice == null ? '' : record.purchasePrice!.toString(),
    );
    _notes = TextEditingController(text: record.notes);
    _customBreed = TextEditingController();
    _breed = record.breed;
    _sex = record.sex;
    _birthDate = record.birthDate;
    _birthDateUnknown = record.birthDateUnknown;
    _groupName = record.groupName;
  }

  @override
  void dispose() {
    _tag.dispose();
    _name.dispose();
    _rfid.dispose();
    _color.dispose();
    _markings.dispose();
    _source.dispose();
    _purchasePrice.dispose();
    _notes.dispose();
    _customBreed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final sheep = ref.watch(sheepByIdProvider(widget.sheepId));
    if (sheep == null) return Center(child: Text(strings.profileNotFound));
    return Form(
      key: _formKey,
      child: ListView(
        key: const Key('edit-sheep-page'),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(strings.editSheep, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          _SectionTitle(strings.identificationSection),
          TextFormField(
            key: const Key('edit-sheep-tag'),
            controller: _tag,
            decoration: InputDecoration(
              labelText: strings.tagNumber,
              border: const OutlineInputBorder(),
            ),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? strings.invalidValue : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('edit-sheep-name'),
            controller: _name,
            decoration: InputDecoration(
              labelText: strings.sheepName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('edit-sheep-rfid'),
            controller: _rfid,
            decoration: InputDecoration(
              labelText: strings.rfidEid,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(strings.animalInfoSection),
          DropdownButtonFormField<SheepSex>(
            key: const Key('edit-sheep-sex'),
            initialValue: _sex,
            decoration: InputDecoration(
              labelText: strings.sex,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final sex in SheepSex.values)
                DropdownMenuItem(value: sex, child: Text(_sexLabel(strings, sex))),
            ],
            onChanged: (value) => setState(() => _sex = value ?? _sex),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            key: const Key('edit-sheep-breed'),
            initialValue: _breeds.contains(_breed) ? _breed : 'Other',
            decoration: InputDecoration(
              labelText: strings.breed,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final breed in _breeds)
                DropdownMenuItem(value: breed, child: Text(_breedLabel(strings, breed))),
            ],
            onChanged: (value) => setState(() => _breed = value ?? _breed),
          ),
          if (_breed == 'Other') ...[
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              key: const Key('edit-sheep-custom-breed'),
              controller: _customBreed,
              decoration: InputDecoration(
                labelText: strings.customBreed,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            key: const Key('edit-sheep-birth-unknown'),
            contentPadding: EdgeInsets.zero,
            title: Text(strings.birthDateUnknown),
            value: _birthDateUnknown,
            onChanged: (value) => setState(() => _birthDateUnknown = value),
          ),
          if (!_birthDateUnknown)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cake_outlined),
              title: Text(
                _birthDate == null
                    ? strings.birthDate
                    : LocaleFormatters.dateForContext(context, _birthDate!),
              ),
              onTap: _pickBirthDate,
            ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('edit-sheep-color'),
            controller: _color,
            decoration: InputDecoration(
              labelText: strings.color,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('edit-sheep-markings'),
            controller: _markings,
            decoration: InputDecoration(
              labelText: strings.markings,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(strings.managementSection),
          TextFormField(
            key: const Key('edit-sheep-group'),
            initialValue: _groupName,
            decoration: InputDecoration(
              labelText: strings.primaryGroup,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => _groupName = value,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('edit-sheep-source'),
            controller: _source,
            decoration: InputDecoration(
              labelText: strings.source,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.shopping_cart_outlined),
            title: Text(
              (_pendingPurchaseDate ?? sheep.purchaseDate) == null
                  ? strings.purchaseDate
                  : LocaleFormatters.dateForContext(
                      context,
                      _pendingPurchaseDate ?? sheep.purchaseDate!,
                    ),
            ),
            onTap: _pickPurchaseDate,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('edit-sheep-price'),
            controller: _purchasePrice,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: strings.purchasePrice,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(strings.notes),
          TextFormField(
            key: const Key('edit-sheep-notes'),
            controller: _notes,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(strings.photo),
          Container(
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(strings.photoPlaceholder, textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const Key('cancel-edit-sheep'),
                  onPressed: () => context.pop(),
                  child: Text(strings.cancel),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  key: const Key('save-edit-sheep'),
                  onPressed: () => _save(strings),
                  child: Text(strings.saveChanges),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null && mounted) setState(() => _birthDate = date);
  }

  Future<void> _pickPurchaseDate() async {
    final sheep = ref.read(sheepByIdProvider(widget.sheepId))!;
    final date = await showDatePicker(
      context: context,
      initialDate: sheep.purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null && mounted) setState(() => _pendingPurchaseDate = date);
  }

  void _save(AppLocalizations strings) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final tag = LocaleFormatters.westernizeDigits(_tag.text.trim());
    if (tag.isEmpty) return;
    final sheep = ref.read(sheepByIdProvider(widget.sheepId))!;
    final breed = _breed == 'Other'
        ? (_customBreed.text.trim().isEmpty ? 'Other' : _customBreed.text.trim())
        : _breed;
    final price = LocaleFormatters.parseNumber(
      LocaleFormatters.westernizeDigits(_purchasePrice.text.trim()),
    )?.toDouble();
    try {
      ref.read(sheepDirectoryControllerProvider.notifier).updateSheep(
        current: sheep,
        tagNumber: tag,
        name: _name.text.trim().isEmpty ? null : _name.text.trim(),
        eidRfid: _rfid.text.trim().isEmpty ? null : _rfid.text.trim(),
        sex: _sex,
        breed: breed,
        birthDate: _birthDateUnknown ? null : _birthDate,
        birthDateUnknown: _birthDateUnknown,
        color: _color.text.trim().isEmpty ? null : _color.text.trim(),
        markings: _markings.text.trim().isEmpty ? null : _markings.text.trim(),
        groupName: _groupName.trim().isEmpty ? sheep.groupName : _groupName.trim(),
        source: _source.text.trim().isEmpty ? null : _source.text.trim(),
        purchaseDate: _pendingPurchaseDate ?? sheep.purchaseDate,
        purchasePrice: price,
        notes: _notes.text.trim(),
        occurredAt: DateTime.now(),
        recordedBy: 'Ahmed',
      );
      if (mounted) context.pop();
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.duplicateTagMessage)),
      );
    }
  }

  static String _sexLabel(AppLocalizations s, SheepSex sex) => switch (sex) {
    SheepSex.ewe => s.sexEwe,
    SheepSex.ram => s.sexRam,
    SheepSex.lamb => s.sexLamb,
  };

  static String _breedLabel(AppLocalizations s, String breed) => switch (breed) {
    'Awassi' => s.breedAwassi,
    'Najdi' => s.breedNajdi,
    'Najdi Cross' => s.breedNajdiCross,
    'Assaf' => s.breedAssaf,
    'Dorper' => s.breedDorper,
    'Merino' => s.breedMerino,
    'Local' => s.breedLocal,
    'Crossbred' => s.breedCrossbred,
    'Mixed' => s.breedMixed,
    'Unknown' => s.breedUnknown,
    'Other' => s.breedOther,
    _ => breed,
  };
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
