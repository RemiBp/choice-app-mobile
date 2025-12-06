import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/customWidgets/no_item_found.dart';
import 'package:choice_app/screens/customer/home/choice_provider.dart';
import 'package:choice_app/screens/customer/other_user_profile/other_user_profile_view.dart';
import 'package:choice_app/screens/restaurant/home/choice_provider.dart';
import 'package:choice_app/screens/restaurant/profile_menu/profile_menu_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showClearButton = false;

  late CustomerChoiceProvider choiceProvider;

  @override
  void initState() {
    super.initState();

    choiceProvider = Provider.of<CustomerChoiceProvider>(
      context,
      listen: false,
    );
    choiceProvider.init(context);

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
    Provider.of<CustomerChoiceProvider>(context);
    final users = choiceProvider.searchUsersResponse?.data ?? [];
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
                          suffixIcon:
                              _showClearButton
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
                        onChanged: (value) {},
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
                child:
                    users.isEmpty
                        ? Center(
                          child: NoItemFound(
                            image: Assets.noNotificationIcon,
                            title: 'No Users Found',
                            subTitle: 'Try searching with a different keyword.',
                            margin: EdgeInsets.zero,
                          ),
                        )
                        :
                    ListView.builder(
                          // itemCount: 3,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => OtherUserProfileView(
                                            // userId: 0,
                                            userId: user.id ?? 0,
                                          ),
                                    ),
                                  );
                                },
                                child: UserTile(
                                  // name: 'Unknown',
                                  // username: '',
                                  // imageUrl: '',
                                  name:
                                      user.fullName ??
                                      user.userName ??
                                      'Unknown',
                                  username: user.userName ?? '',
                                  imageUrl: user.profileImageUrl ?? '',
                                ),
                              ),
                            );
                          },
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
      choiceProvider.searchOtherUsers(query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
