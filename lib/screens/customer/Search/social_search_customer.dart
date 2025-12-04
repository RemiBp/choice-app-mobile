import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();

    // Listen to text changes
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
    });

    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF666666),
                            size: 24,
                          ),
                          suffixIcon: _showClearButton
                              ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF999999),
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF2D2D2D),
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                        },
                        onSubmitted: (value) {
                          _performSearch(value);
                        },
                        onTapOutside: (event) {
                          _searchFocusNode.unfocus();
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Spacer
              const SizedBox(height: 40),

              // Centered content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      // Icon(
                      //   Icons.search_off_rounded,
                      //   size: 80,
                      //   color: Colors.grey[300],
                      // ),

                      // const SizedBox(height: 16),

                      const Text(
                        'No recent searches',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF999999),
                        ),
                      ),

                      // const SizedBox(height: 8),
                      //
                      // // Subtitle
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 40.0),
                      //   child: Text(
                      //     'Your search history will appear here',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //       color: Color(0xFF999999),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      print('Searching for: $query');
      // Implement your search logic here
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}