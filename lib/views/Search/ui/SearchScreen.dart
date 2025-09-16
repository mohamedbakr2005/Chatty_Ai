import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'package:chatty_ai/views/ChatScreen/ui/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Box<Conversation> conversationBox;
  List<Conversation> _searchResults = [];

  @override
  void initState() {
    super.initState();
    conversationBox = Hive.box<Conversation>('conversations');
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchChats(_searchController.text);
  }

  void _searchChats(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final allConversations = conversationBox.values.toList();
    final results = allConversations.where((convo) {
      final titleMatch =
          convo.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
      final messageMatch = convo.messages.any(
        (msg) => msg.text.toLowerCase().contains(query.toLowerCase()),
      );
      return titleMatch || messageMatch;
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: TextField(
          cursorColor: Colors.black,
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search chats...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.black, fontSize: 18.sp),
          autofocus: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ],
      ),
      body: _searchResults.isEmpty && _searchController.text.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Search your chats",
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final convo = _searchResults[index];
                return ListTile(
                  title: Text(convo.title ?? "New Chat"),
                  subtitle: Text(
                    convo.messages.first.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(conversationId: convo.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
