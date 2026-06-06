import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../app/theme.dart';
import 'location_cubit.dart';
import 'location_state.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../settings/presentation/settings_state.dart';

class LocationManualScreen extends StatefulWidget {
  const LocationManualScreen({super.key});

  @override
  State<LocationManualScreen> createState() => _LocationManualScreenState();
}

class _LocationManualScreenState extends State<LocationManualScreen> {
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  String? _validateLat(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = double.tryParse(v.trim());
    if (n == null) return 'Invalid number';
    if (n < -90 || n > 90) return 'Must be between -90 and 90';
    return null;
  }

  String? _validateLon(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = double.tryParse(v.trim());
    if (n == null) return 'Invalid number';
    if (n < -180 || n > 180) return 'Must be between -180 and 180';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final lat = double.parse(_latController.text.trim());
    final lon = double.parse(_lonController.text.trim());
    context.read<LocationCubit>().selectManualCoordinates(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);
    final surfElev = CohereColors.surfElevColor(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) {
        final p = prev.settings.location;
        final c = curr.settings.location;
        if (c == null) return false;
        if (p == null) return true;
        return p.latitude != c.latitude || p.longitude != c.longitude;
      },
      listener: (context, _) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: surfPage,
        body: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, locationState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sticky header
                ColoredBox(
                  color: surfPage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: statusBarHeight * 2 + 8),
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          TextButton.icon(
                            onPressed: () => Navigator.of(context).maybePop(),
                            style: TextButton.styleFrom(
                              foregroundColor: accent,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: Icon(
                              Directionality.of(context) == TextDirection.rtl
                                  ? Icons.chevron_right
                                  : Icons.chevron_left,
                              size: 18,
                            ),
                            label: const Text(
                              'Location',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LOCATION',
                              style: cohereMonoLabel(context, fontSize: 11, color: inkMute),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manual Coordinates',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter exact coordinates for your location.',
                              style: TextStyle(fontSize: 14, color: inkMute, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _latController,
                          validator: _validateLat,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.next,
                          style: TextStyle(fontSize: 15, color: ink),
                          decoration: _fieldDecoration(
                            label: 'Latitude',
                            hint: 'e.g. 24.8607',
                            inkMute: inkMute,
                            surfElev: surfElev,
                            rule: rule,
                            accent: accent,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _lonController,
                          validator: _validateLon,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          style: TextStyle(fontSize: 15, color: ink),
                          decoration: _fieldDecoration(
                            label: 'Longitude',
                            hint: 'e.g. 67.0011',
                            inkMute: inkMute,
                            surfElev: surfElev,
                            rule: rule,
                            accent: accent,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: locationState.isResolvingName ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: locationState.isResolvingName
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: surfPage,
                                  ),
                                )
                              : const Text(
                                  'Set Location',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required Color inkMute,
    required Color surfElev,
    required Color rule,
    required Color accent,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: inkMute),
      hintStyle: TextStyle(color: inkMute),
      filled: true,
      fillColor: surfElev,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: rule),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: rule),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
