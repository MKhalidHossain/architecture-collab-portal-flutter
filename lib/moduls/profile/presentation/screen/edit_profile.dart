import 'dart:ui';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: 'John Doe');
    emailController = TextEditingController(text: 'johndoe@example.com');
    phoneController = TextEditingController(text: '+999359325385');
    locationController = TextEditingController(text: 'Los Angela’s CA');
    industryController = TextEditingController(text: 'Residential');
    bioController = TextEditingController(text: 'We are industry creator');
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    industryController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.black26,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Profile picture change coming soon!',
                            ),
                          ),
                        );
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
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A6C70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            // Here you can access final values via controllers
                            // e.g., fullNameController.text
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile saved successfully!'),
                              ),
                            );
                          },
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
