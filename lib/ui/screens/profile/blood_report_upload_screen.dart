import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../../widgets/open_full_screen_image.dart';
import '../../widgets/pdf_viewer_screen.dart';
import '../bottom_bar_screen.dart';
import 'widget/profile_section_card.dart';

class UploadedReportFile {
  final String name;
  final String size;
  final String? path;
  final int bytes;
  final String extension;

  UploadedReportFile({
    required this.name,
    required this.size,
    this.path,
    required this.bytes,
    required this.extension,
  });

  bool get isPdf => extension.toLowerCase() == 'pdf';
}

class BloodReportUploadScreen extends StatefulWidget {
  final bool isBack;
  const BloodReportUploadScreen({super.key, this.isBack = false});

  @override
  State<BloodReportUploadScreen> createState() => _BloodReportUploadScreenState();
}

class _BloodReportUploadScreenState extends State<BloodReportUploadScreen> {
  static const int maxFileSizeInBytes = 25 * 1024 * 1024; // 25 MB
  static const List<String> allowedExtensions = ['pdf'];

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _dateError;

  final List<UploadedReportFile> _uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('MMMM dd, yyyy').format(_selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  void _onBack() {
    if (widget.isBack && Navigator.canPop(context)) {
      navigation.pop(context);
    } else {
      bottomPageController.jumpToPage(BottomBarScreenIndex.home);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
        _dateError = null;
      });
    }
  }

  Future<void> _pickDocuments() async {
    try {
      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (files.isNotEmpty) {
        for (final PlatformFile pFile in files) {
          final int fileSize = pFile.lengthSync() ?? (await pFile.length()) ?? 0;
          final String fileName = pFile.name;
          final String ext = (pFile.extension ?? fileName.split('.').last).toLowerCase();

          if (!allowedExtensions.contains(ext)) {
            if (mounted) {
              showSnackBar(
                context: context,
                isError: true,
                message: "File \"$fileName\" is not supported. Only PDF, JPG, and PNG are allowed.",
              );
            }
            continue;
          }

          if (fileSize > maxFileSizeInBytes) {
            if (mounted) {
              showSnackBar(
                context: context,
                isError: true,
                message: "File \"$fileName\" exceeds maximum limit of 25MB (${_formatFileSize(fileSize)}).",
              );
            }
            continue;
          }

          setState(() {
            _uploadedFiles.add(
              UploadedReportFile(
                name: fileName,
                size: _formatFileSize(fileSize),
                path: pFile.path,
                bytes: fileSize,
                extension: ext,
              ),
            );
          });
        }
      }
    } catch (e) {
      appLog("File picker error: $e");
      if (mounted) {
        showSnackBar(
          context: context,
          isError: true,
          message: "Could not select file: $e",
        );
      }
    }
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        final File file = File(image.path);
        final int fileSize = await file.length();
        final String fileName = image.name;
        final String ext = fileName.split('.').last.toLowerCase();

        if (fileSize > maxFileSizeInBytes) {
          if (mounted) {
            showSnackBar(
              context: context,
              isError: true,
              message: "File \"$fileName\" exceeds maximum limit of 25MB (${_formatFileSize(fileSize)}).",
            );
          }
          return;
        }

        setState(() {
          _uploadedFiles.add(
            UploadedReportFile(
              name: fileName,
              size: _formatFileSize(fileSize),
              path: image.path,
              bytes: fileSize,
              extension: ext.isEmpty ? 'jpg' : ext,
            ),
          );
        });
      }
    } catch (e) {
      appLog("Image picker error: $e");
      if (mounted) {
        showSnackBar(
          context: context,
          isError: true,
          message: "Could not capture image: $e",
        );
      }
    }
  }

  void _showUploadOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  "Upload Blood Report",
                  fontFamily: fontPlayfairDisplay,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                  ),
                ),
                const SizedBox(height: 4),
                const CommonText(
                  "Supports PDF, JPG, PNG up to 25MB",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6D615C),
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDADB).withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.picture_as_pdf_outlined, color: appColors.primary, size: 20),
                    ),
                  ),
                  title: const CommonText(
                    "Upload Document",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  subtitle: const CommonText(
                    "Browse device files",
                    style: TextStyle(fontSize: 11, color: Color(0xFF6D615C)),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickDocuments();
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2EDEB),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.camera_alt_outlined, color: appColors.neutral, size: 20),
                    ),
                  ),
                  title: const CommonText(
                    "Take Photo of Report",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  subtitle: const CommonText(
                    "Use camera to capture physical report sheets",
                    style: TextStyle(fontSize: 11, color: Color(0xFF6D615C)),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImageFromSource(ImageSource.camera);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2EDEB),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.photo_library_outlined, color: appColors.neutral, size: 20),
                    ),
                  ),
                  title: const CommonText(
                    "Choose from Gallery",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  subtitle: const CommonText(
                    "Select report images from photo album",
                    style: TextStyle(fontSize: 11, color: Color(0xFF6D615C)),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImageFromSource(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  bool _validate() {
    bool isValid = true;
    if (_dateController.text.trim().isEmpty) {
      _dateError = "Date of record is required";
      isValid = false;
    } else {
      _dateError = null;
    }

    if (_uploadedFiles.isEmpty) {
      showSnackBar(
        context: context,
        isError: true,
        message: "Please upload at least one report file (PDF, JPG, or PNG up to 25MB)",
      );
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      appLog("Blood Report Uploaded Successfully with ${_uploadedFiles.length} file(s)!");
      showSnackBar(
        context: context,
        isError: false,
        message: "Blood Report Uploaded Successfully!",
      );
      _onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBack();
      },
      child: Scaffold(
        backgroundColor: appColors.bgColor,
        appBar: CommonAppBar(
          appBarColor: appColors.bgColor.withValues(alpha: 0.85),
          centerTitle: true,
          leading: buildInkWell(
            onTap: _onBack,
            child: Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back,
                size: 24,
                color: appColors.neutral,
              ),
            ),
          ),
          title: const CommonText(
            "Blood Report Upload",
            fontFamily: fontPlayfairDisplay,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF1D1B1A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Card 1: Report / Collection Date
            _buildReportDateSection(),
            const SizedBox(height: 16),

            // Card 2: Upload Report Files (PDF, JPG, PNG up to 25MB)
            _buildUploadFilesSection(),
            const SizedBox(height: 16),

            // Card 3: Notes or Symptoms for Your Coach
            _buildNotesSection(),
            const SizedBox(height: 32),

            // Bottom Button: Save & Upload Blood Report
            CommonButton(
              name: "Save & Upload Blood Report",
              icon: Icons.arrow_forward_rounded,
              isIconFirst: false,
              imageSize: 16,
              btnColor: appColors.primary,
              radius: 999,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              onTap: _onSave,
            ),
            SizedBox(height: bottomPadding(context) + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReportDateSection() {
    return ProfileSectionCard(
      title: "Report / Collection Date",
      icon: appIcons.calender,
      children: [
        Row(
          children: const [
            Expanded(
              child: CommonText(
                "The date your blood sample was drawn or the report was issued. *",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF534343),
                  height: 1.35,
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CommonTextField(
          label: '',
          controller: _dateController,
          hint: "October 26, 2024",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          readOnly: true,
          suffixIcon: IconButton(
            icon: Icon(Icons.edit_calendar_outlined, size: 18, color: appColors.primary),
            onPressed: () => _selectDate(context),
          ),
          error: _dateError,
        ),
      ],
    );
  }

  Widget _buildUploadFilesSection() {
    return ProfileSectionCard(
      title: "Upload Report Files",
      icon: appIcons.reportUpload,
      iconData: Icons.upload_file_outlined,
      children: [
        Row(
          children: const [
            Expanded(
              child: CommonText(
                "Upload high-resolution PDF or clear photos of your laboratory report sheets. *",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF534343),
                  height: 1.35,
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Big Upload Box
        GestureDetector(
          onTap: _showUploadOptionsModal,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F5F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFEDE5E2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cloud Upload Circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFDADB).withValues(alpha: 0.6),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      color: appColors.primary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                CommonText(
                  "Tap to upload PDF or take photo",
                  textAlign: TextAlign.center,
                  fontFamily: fontPlayfairDisplay,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                const CommonText(
                  "Supports PDF, JPG, PNG up to 25MB (multiple pages allowed)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6D615C),
                    height: 1.35,
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
              ],
            ),
          ),
        ),

        // Uploaded Files List
        if (_uploadedFiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...List.generate(_uploadedFiles.length, (index) {
            final file = _uploadedFiles[index];
            return buildInkWell(
              onTap: () {
                if(file.isPdf) {
                  navigation.pushSlideAnimation(context, PDFViewerScreen(
                    assetsPDF: file.path,
                  ));
                } else {
                  print("object ::::::: ${file.path}");
                  navigation.pushSlideAnimation(context,
                    OpenFullImage(file: file.path!),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: index == 0 ? 0 : 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F2EF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDADB).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          file.isPdf
                              ? Icons.picture_as_pdf_outlined
                              : Icons.image_outlined,
                          color: appColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            file.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D1B1A),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          CommonText(
                            file.size,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6D615C),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: Color(0xFF6D615C),
                      ),
                      onPressed: () => _removeFile(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildNotesSection() {
    return ProfileSectionCard(
      title: "Notes or Symptoms for Your Coach",
      icon: appIcons.edit,
      iconData: Icons.edit_note_rounded,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 12,
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            children: [
              TextSpan(
                text: "Any doctor recommendations or specific symptoms. ",
                style: TextStyle(color: Color(0xFF534343)),
              ),
              TextSpan(
                text: "(Optional)",
                style: TextStyle(color: Color(0xFF857373)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 5,
            minLines: 4,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1D1B1A),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText:
                  "e.g., Tested fasting at 8:00 AM. Doctor noted slightly elevated fasting insulin and recommended monitoring with our clinical dietitian...",
              hintStyle: TextStyle(
                fontSize: 13,
                color: Color(0xFF857373),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
