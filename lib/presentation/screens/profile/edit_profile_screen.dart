import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  File? _image;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final agent = ref.read(authProvider).valueOrNull?.agent;
    _nameController.text = agent?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked == null) return;
      setState(() => _image = File(picked.path));
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(context, 'Could not access ${source.name}');
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.dark2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.textPrimary,
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.textPrimary,
                ),
                title: const Text(
                  'Camera',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(authProvider.notifier)
          .updateProfile(name: _nameController.text, image: _image);
      if (!mounted) return;
      AppSnackbar.show(context, 'Profile updated');
      context.go('/profile');
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final img = (ref.watch(authProvider).valueOrNull?.agent?.image ?? '')
        .trim();
    final imageUrl = img.isEmpty
        ? null
        : (img.startsWith('http')
              ? img
              : '${ApiConstants.publicOrigin}/storage/${img.startsWith('/') ? img.substring(1) : img}');

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: InkWell(
                  onTap: _showImagePickerSheet,
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.dark2,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ClipOval(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            )
                          : (imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    width: 96,
                                    height: 96,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.textMuted,
                                    ),
                                  )),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.dark2,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.textPrimary),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(_saving ? 'Saving...' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
