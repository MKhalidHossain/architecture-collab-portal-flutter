import 'dart:io';
import 'dart:ui';
import 'package:dana_bozzetto/core/notifiers/button_status_notifier.dart';
import 'package:dana_bozzetto/core/notifiers/snackbar_notifier.dart';
import 'package:dana_bozzetto/core/utils/helpers/image_loader.dart';
import 'package:dana_bozzetto/moduls/profile/model/update_profile_request_model.dart';
import 'package:dana_bozzetto/moduls/auth/controller/update_profile_controller.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? initialProfile;

  const EditProfileScreen({super.key, this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for live editing
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController industryController;
  late TextEditingController bioController;
  late final UpdateProfileController updateProfileController;
  late final SnackbarNotifier snackbarNotifier;
  File? avatarFile;
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
    updateProfileController = UpdateProfileController(snackbarNotifier);
    final profile = widget.initialProfile ?? const <String, dynamic>{};

    String readString(String key) {
      final value = profile[key];
      return value?.toString() ?? '';
    }

    String readAvatarUrl() {
      final avatar = profile['avatar'];
      if (avatar is Map) {
        final url = avatar['url']?.toString() ?? '';
        if (url.isNotEmpty) {
          return url;
        }
      }
      return '';
    }

    fullNameController = TextEditingController(text: readString('name'));
    emailController = TextEditingController(text: readString('email'));
    phoneController = TextEditingController(text: readString('phoneNumber'));
    locationController = TextEditingController(text: readString('address'));
    industryController = TextEditingController(text: readString('companyName'));
    bioController = TextEditingController(text: '');
    avatarUrl = readAvatarUrl();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    industryController.dispose();
    bioController.dispose();
    updateProfileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listenable = Listenable.merge([
      updateProfileController.processStatusNotifier,
    ]);
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF80807E),
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/ab.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: const Color.fromARGB(255, 18, 18, 18).withOpacity(0.43),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Picture
                Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.black26,
                      backgroundImage: avatarFile != null
                          ? FileImage(avatarFile!)
                          : avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null,
                      child: avatarFile == null && avatarUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white70,
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final imageBytes = await ImageLoader.instance
                            .pickImage();
                        if (imageBytes == null) {
                          return;
                        }
                        final file = await ImageLoader.instance
                            .uint8ListToFile(
                          imageBytes,
                          'profile_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
                        );
                        if (!mounted) return;
                        setState(() {
                          avatarFile = file;
                        });
                      },
                      child: const Text(
                        'Click to Change Profile Picture',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Main Glass Card
                _glassCard(
                  child: Column(
                    children: [
                      _alwaysEditableField(
                        icon: Icons.person_outline,
                        label: 'Full Name',
                        controller: fullNameController,
                      ),
                      _alwaysEditableField(
                        icon: Icons.email_outlined,
                        label: 'Email Address',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _alwaysEditableField(
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      _alwaysEditableField(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        controller: locationController,
                      ),
                      _alwaysEditableField(
                        icon: Icons.apartment_outlined,
                        label: 'Industry',
                        controller: industryController,
                      ),

                      // Always Editable Bio
                      _alwaysEditableBioField(),

                      const SizedBox(height: 28),

                      // Save Button
                      AnimatedBuilder(
                        animation: listenable,
                        builder: (context, child) {
                          final isLoading = updateProfileController
                              .processStatusNotifier
                              .status is LoadingStatus;
                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A6C70),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      final payload =
                                          UpdateProfileRequestModel(
                                        name: fullNameController.text.trim(),
                                        companyName:
                                            industryController.text.trim(),
                                        address: locationController.text.trim(),
                                        email: emailController.text.trim(),
                                        phoneNumber:
                                            phoneController.text.trim(),
                                        avatarPath: avatarFile?.path,
                                      );
                                      final success =
                                          await updateProfileController
                                              .updateProfile(
                                        param: payload,
                                      );
                                      if (!mounted) return;
                                      if (success) {
                                        Navigator.pop(context, true);
                                      }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Glass Card Wrapper
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  // Always Editable Field (TextField visible all the time)
  Widget _alwaysEditableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 24, 24, 24).withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Always Editable Bio Field
  Widget _alwaysEditableBioField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 24, 24, 24).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bio',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      23,
                      23,
                      23,
                    ).withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: bioController,
                      maxLines: 5,
                      minLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add a bio...',
                        hintStyle: TextStyle(color: Colors.white54),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
