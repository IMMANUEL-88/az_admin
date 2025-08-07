import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/utils/constants/sizes.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../functions/addtask.dart';
import '../utils/constants/colors.dart';

class Announcement extends StatefulWidget {
  const Announcement({super.key});

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  final TextEditingController _announcementController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormatter = DateFormat('HH:mm:ss');
  final DateFormat _displayDateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    try {
      List<Map<String, dynamic>> messages =
          await AddAnnouncement().getPreviousAnnouncements();
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      print('Failed to fetch messages: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading announcements: $e')),
      );
    }
  }

  String _formatTime(String timeString) {
    try {
      // Handle both "HH:mm:ss" and "HH:mm" formats
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
      return timeString;
    } catch (e) {
      print('Error formatting time: $e');
      return timeString;
    }
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final now = DateTime.now();

      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        return 'Today';
      } else if (dateTime.year == now.year &&
                 dateTime.month == now.month &&
                 dateTime.day == now.day - 1) {
        return 'Yesterday';
      } else {
        return _displayDateFormatter.format(dateTime);
      }
    } catch (e) {
      print('Error formatting date: $e');
      return dateString;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    final shimmerCount = _isLoading ? 6 : _messages.length;

    // Group messages by date
    final groupedMessages = <String, List<Map<String, dynamic>>>{};
    for (final message in _messages) {
      final date = _formatDate(message['date']);
      groupedMessages.putIfAbsent(date, () => []).add(message);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: EAppBar(
        title: Text('Announcements', style: Theme.of(context).textTheme.headlineMedium),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Iconsax.menu_board4))],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? _buildShimmerList(dark, shimmerCount)
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: groupedMessages.length,
                    itemBuilder: (context, index) {
                      final date = groupedMessages.keys.elementAt(index);
                      final messages = groupedMessages[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              date,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: dark ? Colors.white : EColors.dark,
                              ),
                            ),
                          ),
                          ...messages.map((message) {
                            final time = _formatTime(message['time'] ?? '00:00');
                            return _buildMessageBubble(message, time, dark);
                          }).toList(),
                        ],
                      );
                    },
                  ),
          ),
          _buildInputField(dark),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, String time, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: EHelperFunctions.screenWidth() * 0.8,
          ),
          decoration: BoxDecoration(
            color: dark ? EColors.darkContainer : EColors.lightContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          margin: const EdgeInsets.only(top: 5, right: 20, bottom: 5),
          child: Text(
            message['message'],
            style: TextStyle(color: dark ? EColors.light : EColors.dark),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ESizes.lg),
          child: Text(
            time,
            style: TextStyle(
              color: dark ? EColors.lightGrey : EColors.darkGrey,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildShimmerList(bool dark, int itemCount) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: dark ? Colors.grey[700]! : Colors.grey[300]!,
            highlightColor: dark ? Colors.grey[500]! : Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  width: EHelperFunctions.screenWidth() * 0.5,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 50,
                  height: 10,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(bool dark) {
    return Container(
      padding: const EdgeInsets.all(ESizes.md),
      decoration: BoxDecoration(
        color: dark ? EColors.dark : EColors.light,
        border: Border(top: BorderSide(color: dark ? Colors.grey[800]! : Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _announcementController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.announcement),
                hintText: 'Send message...',
                filled: true,
                fillColor: dark ? Colors.grey[800] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Iconsax.send_14),
            onPressed: _sendAnnouncement,
            color: EColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Future<void> _sendAnnouncement() async {
    final message = _announcementController.text.trim();
    if (message.isEmpty) return;

    final now = DateTime.now();
    final date = _dateFormatter.format(now);
    final time = _timeFormatter.format(now);

    try {
      await AddAnnouncement().addData(message, date, time);
      _announcementController.clear();
      await _fetchMessages();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send: $e')),
      );
    }
  }
}
