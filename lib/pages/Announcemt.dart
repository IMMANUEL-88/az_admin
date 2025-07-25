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
  bool _isLoading = true; // Loading state
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    try {
      List<Map<String, dynamic>> messages = await add_Announcement().getPreviousAnnouncements();
      setState(() {
        _messages = messages;
        _isLoading = false; // Data has been fetched
      });
      _scrollToBottom(); // Scroll to the bottom after updating messages
    } catch (e) {
      print('Failed to fetch messages: $e');
      setState(() {
        _isLoading = false; // Stop loading even on error
      });
    }
  }

  String _formatTime(String dateString) {
    try {
      DateFormat inputFormat = DateFormat('HH:mm:ss');
      DateTime dateTime = inputFormat.parse(dateString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
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
    int shimmerCount = _isLoading ? 6 : _messages.length; // Use dynamic shimmer count

    // Group messages by date
    Map<String, List<Map<String, dynamic>>> groupedMessages = {};
    for (var message in _messages) {
      String date = _formatDate(message['date']);
      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(message);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: EAppBar(
        title: Text(
          'Announcements',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Iconsax.menu_board4))],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? _buildShimmerList(dark, shimmerCount) // Dynamic shimmer count
                : ListView.builder(
              controller: _scrollController, // Assign the scroll controller
              itemCount: groupedMessages.length,
              itemBuilder: (context, index) {
                String date = groupedMessages.keys.elementAt(index);
                List<Map<String, dynamic>> messages = groupedMessages[date]!;

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
                      final time = _formatTime(message['time']);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: EHelperFunctions.screenHeight() * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(color: dark ? EColors.light : EColors.dark),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
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

  // Build shimmer effect for loading
  Widget _buildShimmerList(bool dark, int itemCount) {
    return ListView.builder(
      itemCount: itemCount, // Use dynamic shimmer count during loading
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
                  height: EHelperFunctions.screenHeight() * 0.05,
                  width: EHelperFunctions.screenWidth()*0.5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  margin: const EdgeInsets.only(top: 5, right: 20, bottom: 5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ESizes.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 10,
                        color: Colors.grey,
                      ),
                    ],
                  ),
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
      height: EHelperFunctions.screenHeight() * 0.110,
      width: EHelperFunctions.screenHeight() * 1,
      color: dark ? Colors.black : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(ESizes.md),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: dark ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: TextField(
                    controller: _announcementController,
                    obscureText: false,
                    style: TextStyle(color: dark ? Colors.black : Colors.white), // Text color
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.announcement),
                      iconColor: dark? Colors.grey[400]: EColors.dark,
                      hintText: 'Send message....',
                      hintStyle: TextStyle(color: dark ? Colors.grey[400] : Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: () {
                  DateTime now = DateTime.now();
                  String formattedDate = '${now.year}-${now.month}-${now.day}';
                  String time = "${now.hour}:${now.minute}:${now.second}";
                  if (_announcementController.text == '') {
                    print('type something');
                  } else {
                    _addAnnouncement(_announcementController.text, formattedDate, time);
                  }
                },
                icon: const Icon(Iconsax.send_14),
                iconSize: 30,
                color: dark ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addAnnouncement(String announcement, String date, String time) async {
    try {
      await add_Announcement().addData(announcement, date, time);
      _fetchMessages();
      _announcementController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Message Sent"),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Failed to send message: $e');
    }
  }
}
