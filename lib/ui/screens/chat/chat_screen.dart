import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';
import '../../../core/blocs/chat/chat_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/chat/chat_messages_model.dart';
import '../../widgets/common_text.dart';
import '../bottom_bar_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<ChatMessageItem> _messages = [];
  final List<File> _selectedImages = [];

  bool _isSending = false;
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;
  String? _errorMessage;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchMessages(page: 1);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    // In reverse: true, maxScrollExtent is the top of the chat (older messages)
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && !_isLoadingInitial && _currentPage < _lastPage) {
        _loadMore();
      }
    }
  }

  void _loadMore() {
    if (_isLoadingMore || _currentPage >= _lastPage) return;
    setState(() {
      _isLoadingMore = true;
    });
    _fetchMessages(page: _currentPage + 1, isLoadMore: true);
  }

  void _fetchMessages({int page = 1, bool isLoadMore = false}) {
    BlocProvider.of<ChatBloc>(context).add(
      UserGetMessagesEvent(
        url: Urls.getMessage,
        queryParameters: {
          "page": page,
          "per_page": 30,
        },
        isLoadMore: isLoadMore,
      ),
    );
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        } else {
          _scrollController.jumpTo(0.0);
        }
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final XFile? file = await _imagePicker.pickImage(
          source: source,
          imageQuality: 85,
        );
        if (file != null) {
          setState(() {
            _selectedImages.add(File(file.path));
          });
        }
      } else {
        final List<XFile> files = await _imagePicker.pickMultiImage(
          imageQuality: 85,
        );
        if (files.isNotEmpty) {
          setState(() {
            _selectedImages.addAll(files.map((e) => File(e.path)));
          });
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context: context,
          isError: true,
          message: "Unable to pick image: $e",
        );
      }
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      "Share Photos",
                      fontFamily: fontPlayfairDisplay,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1B1A),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close_rounded, size: 22, color: Color(0xFF7A7270)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const CommonText(
                  "Send photos of your meals, symptoms, or activity to Coach Devanshi",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A7270),
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildPickerOption(
                        icon: Icons.camera_alt_rounded,
                        title: "Camera",
                        subtitle: "Take a picture",
                        color: const Color(0xFF8B484D),
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPickerOption(
                        icon: Icons.photo_library_rounded,
                        title: "Gallery",
                        subtitle: "Select photos",
                        color: const Color(0xFF576245),
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            CommonText(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            const SizedBox(height: 2),
            CommonText(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF7A7270),
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedImages.isEmpty) return;

    final List<File> filesToSend = List.from(_selectedImages);

    // Optimistic local item
    final localMsg = ChatMessageItem(
      uuid: DateTime.now().millisecondsSinceEpoch.toString(),
      message: text.isNotEmpty ? text : null,
      isMe: true,
      isSending: true,
      localAttachments: filesToSend.isNotEmpty ? filesToSend : null,
      createdAt: DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
    );

    setState(() {
      _messages.insert(0, localMsg);
      _messageController.clear();
      _selectedImages.clear();
      _isSending = true;
    });

    _scrollToBottom(animated: true);

    final Map<String, dynamic> body = {
      if (text.isNotEmpty) "message": text,
      if (filesToSend.isNotEmpty) "attachments[]": filesToSend,
    };

    BlocProvider.of<ChatBloc>(context).add(
      UserSendMessageEvent(
        url: Urls.sendTextMessage,
        body: body,
        isMultipart: filesToSend.isNotEmpty,
        localMessage: localMsg,
      ),
    );
  }

  void _showFullScreenImage({String? networkUrl, File? localFile}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Image Viewer",
      barrierColor: Colors.black.withValues(alpha: 0.9),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, _, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: localFile != null
                    ? Image.file(localFile)
                    : (networkUrl != null && networkUrl.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: networkUrl,
                        fit: BoxFit.contain,
                        placeholder: (_, _) => const Center(
                          child: CircularProgressIndicator(color: Colors.white70),
                        ),
                        errorWidget: (_, _, _) => const Icon(
                          Icons.broken_image_rounded,
                          color: Colors.white70,
                          size: 50,
                        ),
                      )
                    : const SizedBox.shrink()),
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(ctx).top + 16,
                right: 16,
                child: InkWell(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  DateTime? _parseDateTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final text = raw.trim();
    final formats = [
      DateFormat('dd-MM-yyyy HH:mm:ss'),
      DateFormat('dd-MM-yyyy hh:mm:ss a'),
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('yyyy-MM-ddTHH:mm:ss'),
      DateFormat('yyyy-MM-dd'),
    ];

    for (var f in formats) {
      try {
        return f.parse(text);
      } catch (_) {}
    }
    return DateTime.tryParse(text);
  }

  String _formatMessageTime(String? raw) {
    final parsed = _parseDateTime(raw);
    if (parsed != null) {
      return DateFormat('hh:mm a').format(parsed);
    }
    return raw ?? "";
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return "Today";
    } else if (target == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    } else if (target.year == today.year) {
      return DateFormat('d MMMM').format(date);
    } else {
      return DateFormat('d MMMM yyyy').format(date);
    }
  }

  bool _isSameCalendarDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoading) {
          setState(() {
            _isLoadingInitial = true;
            _errorMessage = null;
          });
        } else if (state is ChatMessagesSuccess) {
          setState(() {
            _isLoadingInitial = false;
            _isLoadingMore = false;
            _errorMessage = null;

            final meta = state.model.data?.meta;
            if (meta != null) {
              _currentPage = meta.currentPage ?? (state.isLoadMore ? _currentPage + 1 : 1);
              _lastPage = meta.lastPage ?? 1;
            }

            final incoming = List<ChatMessageItem>.from(state.model.data?.messages ?? []);

            // Match if user sent message based on is_mine, user ID, or sender_type
            final myUserId = userData.value?.id;
            for (var msg in incoming) {
              if (msg.isMine != null) {
                msg.isMe = msg.isMine;
              } else if (myUserId != null && msg.senderId != null && msg.senderId == myUserId) {
                msg.isMe = true;
              }
            }

            // Ensure descending order (newest at index 0, oldest at end)
            incoming.sort((a, b) {
              final dtA = _parseDateTime(a.createdAt);
              final dtB = _parseDateTime(b.createdAt);
              if (dtA == null && dtB == null) return 0;
              if (dtA == null) return 1;
              if (dtB == null) return -1;
              return dtB.compareTo(dtA);
            });

            if (state.isLoadMore) {
              final existingUuids = _messages.map((m) => m.uuid).toSet();
              for (var msg in incoming) {
                if (msg.uuid == null || !existingUuids.contains(msg.uuid)) {
                  _messages.add(msg);
                }
              }
            } else {
              final pending = _messages.where((m) => m.isSending || m.hasError).toList();
              _messages.clear();
              _messages.addAll(pending);
              _messages.addAll(incoming);
              _scrollToBottom(animated: false);
            }
          });
        } else if (state is ChatMessagesFailed) {
          setState(() {
            _isLoadingInitial = false;
            _isLoadingMore = false;
            _errorMessage = state.message;
          });
        } else if (state is ChatMessageSentSuccess) {
          setState(() {
            _isSending = false;
            if (state.localMessage != null) {
              state.localMessage!.isSending = false;
              state.localMessage!.hasError = false;
            }
          });
          // Refresh page 1 from server
          _fetchMessages(page: 1, isLoadMore: false);
        } else if (state is ChatMessageSentFailed) {
          setState(() {
            _isSending = false;
            if (state.localMessage != null) {
              state.localMessage!.isSending = false;
              state.localMessage!.hasError = true;
            }
          });
          showSnackBar(
            context: context,
            isError: true,
            message: state.message.isNotEmpty ? state.message : "Failed to send message. Please retry.",
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F6F0),
        appBar: _buildChatAppBar(),
        body: Column(
          children: [
            // Message List / State Area
            Expanded(
              child: _buildBodyContent(),
            ),

            // Selected Images Preview Tray
            if (_selectedImages.isNotEmpty) _buildSelectedImagesTray(),

            // Chat Input Bar
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildChatAppBar() {
    return AppBar(
      backgroundColor: appColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      leading: buildInkWell(
        onTap: () => navigation.pop(context),
        child: Container(
          alignment: Alignment.center,
          child: Icon(Icons.arrow_back, size: 24, color: appColors.neutral),
        ),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFDADB).withValues(alpha: 0.4),
                  border: Border.all(color: appColors.primary.withValues(alpha: 0.2), width: 1.5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    appImages.userAvatarPlaceholder,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Center(
                      child: Icon(Icons.person, color: appColors.primary, size: 24),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText(
                  "Coach Devanshi",
                  fontFamily: fontPlayfairDisplay,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const CommonText(
                      "Clinical Holistic Coach • Active",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF576245),
                        fontWeight: FontWeight.w500,
                      ),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: appColors.neutral, size: 22),
          tooltip: "Refresh messages",
          onPressed: () {
            _currentPage = 1;
            _fetchMessages(page: 1, isLoadMore: false);
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBodyContent() {
    if (_isLoadingInitial) {
      return _buildShimmerLoading();
    }

    if (_errorMessage != null && _messages.isEmpty) {
      return _buildErrorState(_errorMessage!);
    }

    if (_messages.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: appColors.primary,
      onRefresh: () async {
        _currentPage = 1;
        _fetchMessages(page: 1, isLoadMore: false);
      },
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _messages.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Pagination loader at top of chat history (highest index in reverse: true)
          if (index == _messages.length) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: appColors.primary,
                ),
              ),
            );
          }

          final message = _messages[index];
          final currentDate = _parseDateTime(message.createdAt);
          final olderDate = (index < _messages.length - 1)
              ? _parseDateTime(_messages[index + 1].createdAt)
              : null;

          final bool showDateHeader = currentDate != null &&
              (olderDate == null || !_isSameCalendarDay(currentDate, olderDate));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDateHeader) _buildDateHeader(currentDate),
              _buildMessageBubble(message),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEBE6DC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CommonText(
          _formatDateHeader(date),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6D615C),
          ),
          fontFamily: fontFamilyPlusJakartaSans,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageItem message) {
    final isMe = message.isMe ?? false;
    final hasAttachments = (message.attachments != null && message.attachments!.isNotEmpty) ||
        (message.localAttachments != null && message.localAttachments!.isNotEmpty);

    final bubbleBg = isMe ? appColors.primary : appColors.white;
    final textColor = isMe ? Colors.white : const Color(0xFF1D1B1A);
    final timeColor = isMe ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF8A827F);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, bottom: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFDADB).withValues(alpha: 0.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  appImages.userAvatarPlaceholder,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(Icons.person, color: appColors.primary, size: 16),
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.76,
              ),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Attachments Section
                  if (hasAttachments) ...[
                    _buildAttachmentsView(message),
                    if (message.message != null && message.message!.trim().isNotEmpty)
                      const SizedBox(height: 8),
                  ],

                  // Text Message Section
                  if (message.message != null && message.message!.trim().isNotEmpty) ...[
                    CommonText(
                      message.message!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Timestamp and Delivery Status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText(
                        _formatMessageTime(message.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: timeColor,
                        ),
                        fontFamily: fontFamilyPlusJakartaSans,
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        if (message.isSending)
                          const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Colors.white,
                            ),
                          )
                        else if (message.hasError)
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 13,
                            color: Colors.white,
                          )
                        else if (message.isRead == true)
                          Icon(
                            Icons.done_all_rounded,
                            size: 13,
                            color: Colors.white.withValues(alpha: 0.95),
                          )
                        else
                          Icon(
                            Icons.done_rounded,
                            size: 13,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsView(ChatMessageItem message) {
    // 1. Local files while sending
    if (message.localAttachments != null && message.localAttachments!.isNotEmpty) {
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: message.localAttachments!.map((file) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => _showFullScreenImage(localFile: file),
                  child: Image.file(
                    file,
                    width: 180,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                if (message.isSending) Positioned.fill(
                  child: Container(
                    color: Colors.black38,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    // 2. Server attachments
    if (message.attachments != null && message.attachments!.isNotEmpty) {
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: message.attachments!.map((att) {
          final url = att.url ?? "";
          if (url.isEmpty) return const SizedBox.shrink();

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
              onTap: () => _showFullScreenImage(networkUrl: url),
              child: CachedNetworkImage(
                imageUrl: url,
                width: 180,
                height: 140,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 180,
                  height: 140,
                  color: Colors.black12,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: appColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 180,
                  height: 140,
                  color: Colors.black12,
                  child: const Center(
                    child: Icon(Icons.broken_image_rounded, color: Colors.grey, size: 30),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSelectedImagesTray() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: appColors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE8E2DE), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                "Selected ${_selectedImages.length} photo${_selectedImages.length > 1 ? 's' : ''}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF576245),
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedImages.clear();
                  });
                },
                child: const CommonText(
                  "Clear all",
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8B484D),
                    fontWeight: FontWeight.w600,
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final file = _selectedImages[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        file,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImages.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B484D),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    final bool canSend = _messageController.text.trim().isNotEmpty || _selectedImages.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.paddingOf(context).bottom + 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment Button
          IconButton(
            onPressed: _showImagePickerSheet,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFEB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: appColors.primary,
                size: 20,
              ),
            ),
            tooltip: "Attach photo",
          ),

          // Message Input Field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5F2),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE5DDD8)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1D1B1A),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9E9E9E),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Send Button
          InkWell(
            onTap: canSend && !_isSending ? _sendMessage : null,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: canSend ? appColors.primary
                  : appColors.primary.withValues(alpha: 0.35),
                shape: BoxShape.circle,
                boxShadow: canSend ? [
                  BoxShadow(
                    color: appColors.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ] : null,
              ),
              child: Center(
                child: _isSending ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ) : const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFFDADB).withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 44,
                  color: appColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CommonText(
              "Start Your Consultation",
              fontFamily: fontPlayfairDisplay,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
              ),
            ),
            const SizedBox(height: 10),
            const CommonText(
              "Ask questions, share meal photos, or update Coach Devanshi on your digestion, energy, and routine.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6D615C),
                height: 1.5,
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildPromptChip("🥗 Here is my lunch today"),
                _buildPromptChip("💧 Water intake update"),
                _buildPromptChip("🧘 Energy level feels great"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return InkWell(
      onTap: () {
        _messageController.text = text;
        setState(() {});
        _focusNode.requestFocus();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2DCD5)),
        ),
        child: CommonText(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF534343),
          ),
          fontFamily: fontFamilyPlusJakartaSans,
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFF8B484D)),
            const SizedBox(height: 16),
            CommonText(
              "Unable to load chat",
              fontFamily: fontPlayfairDisplay,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
              ),
            ),
            const SizedBox(height: 8),
            CommonText(
              message.isNotEmpty ? message : "Could not fetch messages. Please check your connection.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF7A7270),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _fetchMessages(),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: 6,
      itemBuilder: (context, index) {
        final isRight = index % 2 == 1;
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  width: index == 2 ? 220 : 160,
                  height: index == 3 ? 100 : 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
