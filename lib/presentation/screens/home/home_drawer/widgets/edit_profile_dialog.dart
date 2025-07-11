import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/colors_manager.dart';
import '../../../../cubit/governorate_cubit/governorate_cubit.dart';
import '../../../../cubit/governorate_cubit/governorate_state.dart';
import '../../../../cubit/profile_cubit/profile_cubit.dart';
import '../../../../cubit/zone_cubit/zone_cubit.dart';
import '../../../../cubit/zone_cubit/zone_state.dart';

class EditProfileDialog extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final String currentNationalId;
  final int? currentGovern; // Changed to nullable int for initial value
  final int? currentZone; // Changed to nullable int for initial value
  final void Function(String name, String email, String phone, String nationalId, int? governId, int? zoneId) onSave;

  const EditProfileDialog({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    required this.currentNationalId,
    this.currentGovern, // Now optional
    this.currentZone,    // Now optional
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController nationalIdController;
  int? selectedGovernorateId;
  int? selectedZoneId;

  final Color primaryBlue = ColorsManager.buttonColorApp; // أزرق مريح

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
    phoneController = TextEditingController(text: widget.currentPhone);
    nationalIdController = TextEditingController(text: widget.currentNationalId);

    selectedGovernorateId = widget.currentGovern;
    selectedZoneId = widget.currentZone;

    // Load zones for the initial governorate if available
    if (selectedGovernorateId != null) {
      // Delay fetching zones slightly to ensure the Cubit is ready if this is the first time the dialog is opened
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ZoneCubit>().fetchZones(govName: selectedGovernorateId.toString());
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          'Edit Profile',
          style: TextStyle(
            color: ColorsManager.buttonColorApp,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      content: SingleChildScrollView( // Added SingleChildScrollView for potentially long content
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameController, 'Username'),
            const SizedBox(height: 10),
            _buildTextField(emailController, 'Email'),
            const SizedBox(height: 10),
            _buildTextField(phoneController, 'Phone'),
            const SizedBox(height: 10),
            _buildTextField(nationalIdController, 'National Id'),
            const SizedBox(height: 10),

            // Governorate Dropdown
            BlocBuilder<GovernorateCubit, GovernorateState>(
              builder: (context, state) {
                if (state is GovernorateLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is GovernorateError) {
                  return Text('Error loading governorates: ${state.message}');
                }
                if (state is GovernorateLoaded) {
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Governorate",
                      labelStyle: TextStyle(color: primaryBlue),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedGovernorateId,
                    items: state.governorates.map((gov) {
                      return DropdownMenuItem<int>(
                        value: gov.id,
                        child: Text(gov.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGovernorateId = value;
                        selectedZoneId = null; // Reset zone when governorate changes
                      });
                      if (value != null) {
                        context.read<ZoneCubit>().fetchZones(govName: value.toString());
                      }
                    },
                    isExpanded: true, // Make dropdown expand to full width
                  );
                }
                return const SizedBox.shrink(); // Fallback for initial state or other unhandled states
              },
            ),
            const SizedBox(height: 10),

            // Zone Dropdown
            BlocBuilder<ZoneCubit, ZoneState>(
              builder: (context, state) {
                if (state is ZonesLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is ZoneError) {
                  return Text('Error loading zones: ${state.message}');
                }
                if (state is ZonesLoaded) {
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Zone",
                      labelStyle: TextStyle(color: primaryBlue),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedZoneId,
                    items: state.zones.map((zone) {
                      return DropdownMenuItem<int>(
                        value: zone.zoneId,
                        child: Text(zone.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedZoneId = value;
                      });
                    },
                    isExpanded: true,
                  );
                }
                return const SizedBox.shrink(); // Fallback
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: primaryBlue)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primaryColorApp,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            widget.onSave(
              nameController.text.trim(),
              emailController.text.trim(),
              phoneController.text.trim(),
              nationalIdController.text.trim(),
              selectedGovernorateId, // Pass the selected ID
              selectedZoneId,         // Pass the selected ID
            );
            Navigator.pop(context);
            context.read<ProfileCubit>().getProfileInfo();

          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryBlue),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      cursorColor: primaryBlue,
      style: const TextStyle(color: Colors.black87),
    );
  }
}