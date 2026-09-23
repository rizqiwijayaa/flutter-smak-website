part of '../admin_dashboard_page.dart';

/// Central content limits for every Admin editor that writes public content.
enum AdminContentKind {
  veryShort,
  shortLabel,
  title,
  subtitle,
  personName,
  shortDescription,
  description,
  longContent,
  email,
  phone,
  url,
  year,
  number,
  color,
}

@immutable
class AdminContentConstraint {
  const AdminContentConstraint({
    required this.maxCharacters,
    this.maxWords,
    required this.label,
  });

  final int maxCharacters;
  final int? maxWords;
  final String label;

  static const veryShort = AdminContentConstraint(
    maxWords: 6,
    maxCharacters: 40,
    label: 'teks singkat',
  );
  static const shortLabel = AdminContentConstraint(
    maxWords: 10,
    maxCharacters: 80,
    label: 'label singkat',
  );
  static const title = AdminContentConstraint(
    maxWords: 15,
    maxCharacters: 100,
    label: 'judul',
  );
  static const subtitle = AdminContentConstraint(
    maxWords: 25,
    maxCharacters: 160,
    label: 'subjudul',
  );
  static const personName = AdminContentConstraint(
    maxCharacters: 100,
    label: 'nama',
  );
  static const shortDescription = AdminContentConstraint(
    maxWords: 50,
    maxCharacters: 300,
    label: 'ringkasan',
  );
  static const description = AdminContentConstraint(
    maxWords: 150,
    maxCharacters: 1000,
    label: 'deskripsi',
  );
  static const longContent = AdminContentConstraint(
    maxWords: 1500,
    maxCharacters: 10000,
    label: 'konten panjang',
  );
  static const email = AdminContentConstraint(
    maxCharacters: 254,
    label: 'email',
  );
  static const phone = AdminContentConstraint(
    maxCharacters: 30,
    label: 'nomor telepon',
  );
  static const url = AdminContentConstraint(
    maxCharacters: 2048,
    label: 'URL',
  );
  static const year = AdminContentConstraint(
    maxCharacters: 4,
    label: 'tahun',
  );
  static const number = AdminContentConstraint(
    maxCharacters: 20,
    label: 'angka',
  );
  static const color = AdminContentConstraint(
    maxCharacters: 7,
    label: 'warna',
  );

  AdminContentConstraint copyWith({int? maxWords, int? maxCharacters}) =>
      AdminContentConstraint(
        maxWords: maxWords ?? this.maxWords,
        maxCharacters: maxCharacters ?? this.maxCharacters,
        label: label,
      );

  int words(String value) =>
      RegExp(r'\S+').allMatches(value.trim()).length;

  bool exceeds(String value) =>
      value.characters.length > maxCharacters ||
      (maxWords != null && words(value) > maxWords!);

  String guidance(String value) {
    final characterCount = value.characters.length;
    final wordCount = words(value);
    final limits = maxWords == null
        ? 'Maks. $maxCharacters karakter'
        : 'Maks. $maxWords kata / $maxCharacters karakter';
    final current = maxWords == null
        ? '$characterCount/$maxCharacters karakter'
        : '$wordCount/$maxWords kata • $characterCount/$maxCharacters karakter';
    return exceeds(value)
        ? '$limits • Saat ini melebihi batas ($current); silakan dipersingkat'
        : '$limits • $current';
  }
}

AdminContentConstraint adminConstraintFor(
  String? label, {
  int maxLines = 1,
  int? existingMaxCharacters,
}) {
  final text = (label ?? '').toLowerCase();
  AdminContentConstraint result;
  if (text.contains('warna')) {
    result = AdminContentConstraint.color;
  } else if (text.contains('tahun') && !text.contains('ajaran')) {
    result = AdminContentConstraint.year;
  } else if (text.contains('email')) {
    result = AdminContentConstraint.email;
  } else if (text.contains('telepon') ||
      text.contains('whatsapp') ||
      text.contains('nomor')) {
    result = AdminContentConstraint.phone;
  } else if (text.contains('jumlah') ||
      text.contains('total') ||
      text.contains('kuota') ||
      text.contains('angka statistik')) {
    result = AdminContentConstraint.number;
  } else if (text.contains('url') ||
      text.contains('link') ||
      text.contains('file')) {
    result = AdminContentConstraint.url;
  } else if (text.contains('nama') &&
      (text.contains('siswa') ||
          text.contains('guru') ||
          text.contains('kepala') ||
          text.contains('personel') ||
          text == 'nama')) {
    result = AdminContentConstraint.personName;
  } else if (text.contains('isi berita') ||
      text.contains('isi konten') ||
      text.contains('sambutan') ||
      text.contains('narasi')) {
    result = AdminContentConstraint.longContent;
  } else if (text.contains('deskripsi') ||
      text.contains('ringkasan') ||
      text.contains('kutipan') ||
      text.contains('pesan') ||
      text.contains('motto') ||
      text.contains('paragraf') ||
      text.contains('jawaban') ||
      text.contains('aturan') ||
      text.contains('visi') ||
      text.contains('misi')) {
    result = maxLines >= 5
        ? AdminContentConstraint.description
        : AdminContentConstraint.shortDescription;
  } else if (text.contains('subtitle') ||
      text.contains('subjudul') ||
      text.contains('tagline')) {
    result = AdminContentConstraint.subtitle;
  } else if (text.contains('judul') ||
      text.contains('kegiatan') ||
      text.contains('prestasi') ||
      text.contains('ekstrakurikuler') ||
      text.contains('fasilitas')) {
    result = AdminContentConstraint.title;
  } else if (text.contains('status') ||
      text.contains('badge') ||
      text.contains('tombol') ||
      text.contains('label')) {
    result = AdminContentConstraint.veryShort;
  } else if (maxLines > 1) {
    result = AdminContentConstraint.description;
  } else {
    result = AdminContentConstraint.shortLabel;
  }
  if (existingMaxCharacters != null &&
      existingMaxCharacters < result.maxCharacters) {
    return result.copyWith(maxCharacters: existingMaxCharacters);
  }
  return result;
}

class _AdminContentFormatter extends TextInputFormatter {
  const _AdminContentFormatter(this.constraint);

  final AdminContentConstraint constraint;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!constraint.exceeds(newValue.text)) return newValue;
    if (!constraint.exceeds(oldValue.text)) return oldValue;

    final oldChars = oldValue.text.characters.length;
    final newChars = newValue.text.characters.length;
    final oldWords = constraint.words(oldValue.text);
    final newWords = constraint.words(newValue.text);
    final charactersImproved = newChars < oldChars;
    final wordsImproved = constraint.maxWords == null || newWords <= oldWords;
    return charactersImproved && wordsImproved ? newValue : oldValue;
  }
}

class AdminContentTextField extends StatefulWidget {
  const AdminContentTextField({
    super.key,
    required this.controller,
    required this.decoration,
    this.constraint,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.enabled,
    this.readOnly = false,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.style,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.onTap,
  });

  final TextEditingController? controller;
  final InputDecoration decoration;
  final AdminContentConstraint? constraint;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool readOnly;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final GestureTapCallback? onTap;

  @override
  State<AdminContentTextField> createState() => _AdminContentTextFieldState();
}

class _AdminContentTextFieldState extends State<AdminContentTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant AdminContentTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_refresh);
      widget.controller?.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final constraint = widget.constraint ??
        adminConstraintFor(
          widget.decoration.labelText,
          maxLines: widget.maxLines ?? 1,
        );
    return TextField(
      controller: widget.controller,
      decoration: widget.decoration.copyWith(
        helperText: constraint.guidance(widget.controller?.text ?? ''),
        helperMaxLines: 2,
        counterText: '',
      ),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      inputFormatters: [
        ...?widget.inputFormatters,
        _AdminContentFormatter(constraint),
      ],
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      enableSuggestions: widget.enableSuggestions,
      autocorrect: widget.autocorrect,
      style: widget.style,
      textAlign: widget.textAlign,
      textCapitalization: widget.textCapitalization,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
    );
  }
}

class AdminContentFormField extends StatefulWidget {
  const AdminContentFormField({
    super.key,
    required this.controller,
    required this.decoration,
    this.constraint,
    this.maxLines = 1,
    this.minLines,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.enabled,
    this.onChanged,
  });

  final TextEditingController? controller;
  final InputDecoration decoration;
  final AdminContentConstraint? constraint;
  final int? maxLines;
  final int? minLines;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<AdminContentFormField> createState() => _AdminContentFormFieldState();
}

class _AdminContentFormFieldState extends State<AdminContentFormField> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant AdminContentFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_refresh);
      widget.controller?.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final constraint = widget.constraint ??
        adminConstraintFor(
          widget.decoration.labelText,
          maxLines: widget.maxLines ?? 1,
        );
    return TextFormField(
      controller: widget.controller,
      decoration: widget.decoration.copyWith(
        helperText: constraint.guidance(widget.controller?.text ?? ''),
        helperMaxLines: 2,
        counterText: '',
      ),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: [
        ...?widget.inputFormatters,
        _AdminContentFormatter(constraint),
      ],
      enabled: widget.enabled,
      onChanged: widget.onChanged,
    );
  }
}
