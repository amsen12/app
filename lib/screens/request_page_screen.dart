import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/models.dart';

import '../providers/app_provider.dart';

import '../providers/theme_provider.dart';

import '../widgets/shared_widgets.dart';

import '../utils/profix_colors.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';



class RequestsPageScreen extends StatefulWidget {

  final Function(String) onSelectRequest;

  final Function(String) onChat;

  const RequestsPageScreen({super.key, required this.onSelectRequest, required this.onChat});



  @override

  State<RequestsPageScreen> createState() => _RequestsPageScreenState();

}



class _RequestsPageScreenState extends State<RequestsPageScreen> {

  RequestStatus? _selectedStatus;



  final _filters = <String, RequestStatus?>{

    'All': null,

    'Pending': RequestStatus.pending,

    'In Progress': RequestStatus.inProgress,

    'Completed': RequestStatus.completed,

    'Rejected': RequestStatus.rejected,

  };



  @override

  Widget build(BuildContext context) {

    var themeProvider = Provider.of<AppThemeProvider>(context);

    bool isDark = themeProvider.isDarkTheme();

    final app = context.watch<AppProvider>();

    final filtered = _selectedStatus == null ? app.requests : app.requests.where((r) => r.status == _selectedStatus).toList();



    // تحديد الألوان بناءً على حالة الثيم لتطابق الصور

    final Color scaffoldBg = isDark ? const Color(0xFF131B2B) : Colors.white;

    final Color appBarBg = isDark ? const Color(0xFF131B2B) : Colors.white;

    final Color textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    final Color chipUnselectedBg = isDark ? const Color(0xFF424B5A) : const Color(0xFFBDC5D0);

    final Color chipUnselectedText = isDark ? Colors.white70 : const Color(0xFF44474E);

    final Color dividerColor = isDark ? Colors.white12 : Colors.grey.shade200;



    return Scaffold(

      backgroundColor: scaffoldBg,

      appBar: AppBar(

        backgroundColor: appBarBg,

        elevation: 0,

        toolbarHeight: 140, // تم زيادة الارتفاع قليلاً لراحة التصميم

        titleSpacing: 0,

        title: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // العنوان "My Requests"

            Padding(

              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),

              child: Text(

                'My Requests',

                style: TextStyle(

                  color: textColor,

                  fontWeight: FontWeight.bold,

                  fontSize: 22,

                ),

              ),

            ),

            // ليتسة الفلاتر (Chips)

            SingleChildScrollView(

              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              child: Row(

                children: _filters.entries.map((e) {

                  final isSelected = _selectedStatus == e.value;

                  return Padding(

                    padding: const EdgeInsets.only(right: 8),

                    child: GestureDetector(

                      onTap: () => setState(() => _selectedStatus = e.value),

                      child: Container(

                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                        decoration: BoxDecoration(

                          // اللون الأزرق السماوي للأزرار المختارة كما في الصورة

                          color: isSelected ? const Color(0xFF38B6FF) : chipUnselectedBg,

                          borderRadius: BorderRadius.circular(25),

                        ),

                        child: Text(

                          e.key,

                          style: TextStyle(

                            fontSize: 14,

                            fontWeight: FontWeight.w600,

                            color: isSelected ? Colors.white : chipUnselectedText,

                          ),

                        ),

                      ),

                    ),

                  );

                }).toList(),

              ),

            ),

            const SizedBox(height: 20),

            Divider(height: 1, thickness: 1, color: dividerColor),

          ],

        ),

      ),

      body: filtered.isEmpty

          ? EmptyState(

        icon: Icons.list_alt_outlined,

        title: 'No requests found',

        subtitle: _selectedStatus == null ? 'Create a new request to get started' : 'Try selecting a different status',

      )

          : ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: filtered.length + 1,

        itemBuilder: (context, index) {

          if (index == 0) {

            return Padding(

              padding: const EdgeInsets.only(bottom: 12),

              child: Text(

                '${filtered.length} requests',

                style: TextStyle(

                    fontSize: 15,

                    color: isDark ? Colors.white70 : Colors.grey.shade600,

                    fontWeight: FontWeight.w500

                ),

              ),

            );

          }

          final req = filtered[index - 1];

          return Padding(

            padding: const EdgeInsets.only(bottom: 12),

            child: RequestCard(

              request: req,

              onTap: () => widget.onSelectRequest(req.id),

              showChat: req.status == RequestStatus.inProgress,

              onChatTap: () => widget.onChat(req.id),

            ),

          );

        },

      ),

    );

  }

}