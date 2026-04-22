import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../providers/theme_provider.dart';
import '../../../../../../utils/profix_colors.dart';
import '../../../../../../utils/profixStyles.dart';
import '../../../../../../utils/profix_colors.dart';
import '../../../../../../utils/profixStyles.dart';
import '../../../../../../models/technician_model.dart';
import '../../../../../../screens/customer_home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
static const String routeName = 'searchScreen';
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCat = "All";
  String searchQuery = "";
  String activeSort = "";
  bool isMapVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  // تم إرجاع القائمة كاملة (9 فنيين) كما طلبت
  final List<Map<String, dynamic>> technicians = [
    {'name': 'Ahmed Hassan', 'job': 'Plumber', 'rate': 4.9, 'jobs': '234', 'dist': 1.2, 'status': 'Available', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Ahmed'},
    {'name': 'Omar Salem', 'job': 'Electrician', 'rate': 4.8, 'jobs': '189', 'dist': 2.5, 'status': 'Available', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Omar'},
    {'name': 'Youssef Ali', 'job': 'Carpenter', 'rate': 4.7, 'jobs': '156', 'dist': 3.1, 'status': 'Busy', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Youssef'},
    {'name': 'Khaled Mohamed', 'job': 'Plumber', 'rate': 4.6, 'jobs': '98', 'dist': 0.8, 'status': 'Available', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Khaled'},
    {'name': 'Mahmoud Ibrahim', 'job': 'Electrician', 'rate': 4.5, 'jobs': '145', 'dist': 4.2, 'status': 'Available', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Mahmoud'},
    {'name': 'Hany Adel', 'job': 'Plumber', 'rate': 4.4, 'jobs': '120', 'dist': 1.5, 'status': 'Available', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Hany'},
    {'name': 'Samy Ali', 'job': 'Carpenter', 'rate': 4.3, 'jobs': '85', 'dist': 2.2, 'status': 'Busy', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Samy'},
    {'name': 'Mostafa Zed', 'job': 'Electrician', 'rate': 4.2, 'jobs': '210', 'dist': 3.5, 'status': 'Available', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Mostafa'},
    {'name': 'Ibrahim Noah', 'job': 'Plumber', 'rate': 4.1, 'jobs': '60', 'dist': 5.0, 'status': 'Available', 'img': 'https://api.dicebear.com/7.x/avataaars/png?seed=Noah'},
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<AppThemeProvider>(context);
    bool isDark = themeProvider.isDarkTheme();

    List<Map<String, dynamic>> filteredList = technicians.where((t) {
      bool matchesCat = selectedCat == "All" || t['job'] == selectedCat;
      bool matchesSearch = t['name'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    if (activeSort == "Rating") {
      filteredList.sort((a, b) => b['rate'].compareTo(a['rate']));
    } else if (activeSort == "Distance") {
      filteredList.sort((a, b) => a['dist'].compareTo(b['dist']));
    } else if (activeSort == "Availability") {
      filteredList = filteredList.where((t) => t['status'] == "Available").toList();
    }

    return Scaffold(
      backgroundColor: isDark ? ProfixColors.darkTheme : ProfixColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                "Find Technicians",
                style: ProfixStyles.text2xlBold.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: (v) => setState(() => searchQuery = v),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Search by name...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
                  filled: true,
                  fillColor: isDark ? ProfixColors.darkTheme2 : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Categories Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: ["All", "Plumber", "Carpenter", "Electrician"].map((cat) {
                  bool isSel = selectedCat == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCat = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel ? ProfixColors.primary : (isDark ? const Color(0xFF424B5A) : const Color(0xFFBDC5D0)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Filters Row - تم حل مشكلة الـ Overflow هنا
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded( // استخدمنا Expanded لضمان أن الفلاتر تأخذ المساحة المتاحة ولا تخرج عنها
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _filterBtn("Rating", Icons.star_border, isDark),
                          _filterBtn("Distance", Icons.location_on_outlined, isDark),
                          _filterBtn("Availability", Icons.access_time, isDark),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => isMapVisible = !isMapVisible),
                    child: Row(
                      children: [
                        Icon(Icons.map_outlined, size: 18, color: isDark ? Colors.white70 : Colors.black54),
                        Text(
                          " Map",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (isMapVisible) _buildMapSection(),

            Divider(thickness: 1, color: isDark ? Colors.white12 : Colors.grey.shade200, indent: 20, endIndent: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                "${filteredList.length} technicians found",
                style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (context, index) => ProviderCard(data: filteredList[index], isDark: isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterBtn(String label, IconData icon, bool isDark) {
    bool isActive = activeSort == label;
    return GestureDetector(
      onTap: () => setState(() => activeSort = isActive ? "" : label),
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? ProfixColors.primary.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? ProfixColors.primary : (isDark ? Colors.white70 : Colors.black54)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  color: isActive ? ProfixColors.primary : (isDark ? Colors.white70 : Colors.black54),
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: Icon(Icons.map, color: ProfixColors.primary, size: 40)),
    );
  }
}

class ProviderCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;
  const ProviderCard({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = data['status'] == "Available";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderProfileScreen(
              technician: TechnicianModel(
                id: data['name'].hashCode.toString(), // Pseudo ID
                name: data['name'],
                image: data['img'],
                specialty: data['job'],
                rating: data['rate'],
                jobsDone: int.parse(data['jobs']),
                distance: data['dist'],
                isAvailable: isAvailable,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? ProfixColors.darkTheme2 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'technician-${data['name'].hashCode.toString()}',
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(data['img']),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['name'],
                        style: ProfixStyles.textBaseBold.copyWith(
                            color: isDark ? Colors.white : Colors.black
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data['status'],
                          style: TextStyle(
                              color: isAvailable ? Colors.green : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(data['job'], style: ProfixStyles.textSmGray),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(" ${data['rate']}", style: ProfixStyles.textXsBold.copyWith(color: isDark ? Colors.white : Colors.black)),
                      const SizedBox(width: 10),
                      Icon(Icons.work_outline, color: Colors.grey, size: 14),
                      Text(" ${data['jobs']} jobs", style: ProfixStyles.textXsGray),
                      const SizedBox(width: 10),
                      Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                      Text(" ${data['dist']} km", style: ProfixStyles.textXsGray),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}