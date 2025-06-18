import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() {
  runApp(const CalibrationShopApp());
}

class CalibrationShopApp extends StatelessWidget {
  const CalibrationShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RideWave Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _ipController =
      TextEditingController(text: '172.20.10.5');
  String _currentSuspensionMode = 'MODE 1';
  Color _currentModeColor = Colors.green;

  final List<CalibrationFile> _cartItems = [];
  final List<CalibrationFile> _purchasedItems = [];
  final List<CalibrationFile> _activeCalibrations = [];

  UserProfile _userProfile = UserProfile(
    name: 'sriram',
    email: 'sriramm@endurance.co.in',
    bikeModel: 'Pulsar NS200',
    bikeCompany: 'Bajaj',
    profileImage: 'assets/user.png',
  );

  final List<BikeCompany> bikeCompanies = [
    BikeCompany(
      id: '1',
      name: 'Bajaj',
      logo: 'assets/bajaj.png',
      calibrations: [
        CalibrationFile(
          id: 'b1',
          name: 'RAIN MODE',
          description: 'Enhanced wet traction & stability control',
          price: 0,
          hexUrl:
              'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Rain_cal.hex',
          image: 'assets/rain_mode.png',
          color: const Color(0xFF64B5F6),
          company: 'Bajaj',
          isPremium: false,
          compatibleModels: ['Pulsar NS200', 'Dominar 400', 'Pulsar RS200'],
        ),
        CalibrationFile(
          id: 'b2',
          name: 'ROAD MODE',
          description: 'Max performance for street riding',
          price: 0,
          hexUrl:
              'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Road_cal.hex',
          image: 'assets/road_mode.png',
          color: const Color(0xFFE57373),
          company: 'Bajaj',
          isPremium: false,
          compatibleModels: ['Pulsar NS200', 'Dominar 400', 'Pulsar RS200'],
        ),
        CalibrationFile(
          id: 'b3',
          name: 'OFF-ROAD MODE',
          description: 'Optimized for rough terrain',
          price: 0,
          hexUrl:
              'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Off_Road_cal.hex',
          image: 'assets/offroad_mode.png',
          color: const Color(0xFF81C784),
          company: 'Bajaj',
          isPremium: false,
          compatibleModels: ['Pulsar NS200', 'Dominar 400'],
        ),
        CalibrationFile(
          id: 'b4',
          name: 'TRACK MODE PRO',
          description: 'Race track optimized with advanced tuning',
          price: 12.99,
          hexUrl: 'https://...track_pro.hex',
          image: 'assets/track_mode.png',
          color: const Color(0xFFFF5252),
          company: 'Bajaj',
          isPremium: true,
          compatibleModels: ['Pulsar RS200', 'Dominar 400'],
        ),
      ],
    ),
    BikeCompany(
      id: '2',
      name: 'Royal Enfield',
      logo: 'assets/re.png',
      calibrations: [
        CalibrationFile(
          id: 're1',
          name: 'CLASSIC CRUISE',
          description: 'Smooth throttle for relaxed cruising',
          price: 0,
          hexUrl: 'https://...classic.hex',
          image: 'assets/classic_mode.png',
          color: const Color(0xFF9575CD),
          company: 'Royal Enfield',
          isPremium: false,
          compatibleModels: ['Classic 350', 'Meteor 350'],
        ),
        CalibrationFile(
          id: 're2',
          name: 'HIMALAYAN EXPLORE',
          description: 'Optimized for high altitude performance',
          price: 8.99,
          hexUrl: 'https://...himalayan.hex',
          image: 'assets/adventure_mode.png',
          color: const Color(0xFF4DB6AC),
          company: 'Royal Enfield',
          isPremium: true,
          compatibleModels: ['Himalayan 450', 'Himalayan 411'],
        ),
        CalibrationFile(
          id: 're3',
          name: 'INTERCEPTOR POWER',
          description: 'Enhanced mid-range torque',
          price: 9.99,
          hexUrl: 'https://...interceptor.hex',
          image: 'assets/power_mode.png',
          color: const Color(0xFFFF8A65),
          company: 'Royal Enfield',
          isPremium: true,
          compatibleModels: ['Interceptor 650', 'Continental GT'],
        ),
      ],
    ),
    BikeCompany(
      id: '3',
      name: 'KTM',
      logo: 'assets/ktm.png',
      calibrations: [
        CalibrationFile(
          id: 'ktm1',
          name: 'SUPERMOTO AGGRESSIVE',
          description: 'Sharp throttle response for aggressive riding',
          price: 14.99,
          hexUrl: 'https://...supermoto.hex',
          image: 'assets/aggressive_mode.png',
          color: const Color(0xFFF44336),
          company: 'KTM',
          isPremium: true,
          compatibleModels: ['Duke 390', 'Duke 250', 'RC 390'],
        ),
        CalibrationFile(
          id: 'ktm2',
          name: 'TRACK SLICK',
          description: 'Optimized for track days with slick tires',
          price: 15.99,
          hexUrl: 'https://...trackslick.hex',
          image: 'assets/track_slick.png',
          color: const Color(0xFFFF9800),
          company: 'KTM',
          isPremium: true,
          compatibleModels: ['RC 390', 'RC 200'],
        ),
        CalibrationFile(
          id: 'ktm3',
          name: 'STREET MODE',
          description: 'Balanced performance for daily riding',
          price: 0,
          hexUrl: 'https://...street.hex',
          image: 'assets/street_mode.png',
          color: const Color(0xFF2196F3),
          company: 'KTM',
          isPremium: false,
          compatibleModels: ['Duke 390', 'Duke 250', 'RC 390'],
        ),
      ],
    ),
    BikeCompany(
      id: '4',
      name: 'Yamaha',
      logo: 'assets/yamaha.png',
      calibrations: [
        CalibrationFile(
          id: 'yam1',
          name: 'R-SERIES TRACK',
          description: 'Race-inspired tuning for R-series bikes',
          price: 11.99,
          hexUrl: 'https://...rseries.hex',
          image: 'assets/rseries_mode.png',
          color: const Color(0xFFE91E63),
          company: 'Yamaha',
          isPremium: true,
          compatibleModels: ['R15 V4', 'R7', 'MT-15'],
        ),
        CalibrationFile(
          id: 'yam2',
          name: 'ECO COMMUTE',
          description: 'Fuel efficiency optimized for daily commuting',
          price: 0,
          hexUrl: 'https://...eco.hex',
          image: 'assets/eco_mode.png',
          color: const Color(0xFF8BC34A),
          company: 'Yamaha',
          isPremium: false,
          compatibleModels: ['FZ-S', 'FZ-X', 'MT-15'],
        ),
        CalibrationFile(
          id: 'yam3',
          name: 'MT POWER',
          description: 'Enhanced torque for wheelie control',
          price: 12.99,
          hexUrl: 'https://...mtpower.hex',
          image: 'assets/mt_mode.png',
          color: const Color(0xFF9C27B0),
          company: 'Yamaha',
          isPremium: true,
          compatibleModels: ['MT-15', 'MT-03'],
        ),
      ],
    ),
    BikeCompany(
      id: '5',
      name: 'Harley-Davidson',
      logo: 'assets/harley.png',
      calibrations: [
        CalibrationFile(
          id: 'hd1',
          name: 'CRUISER COMFORT',
          description: 'Smooth power delivery for long rides',
          price: 0,
          hexUrl: 'https://...cruiser.hex',
          image: 'assets/cruiser_mode.png',
          color: const Color(0xFF795548),
          company: 'Harley-Davidson',
          isPremium: false,
          compatibleModels: ['Street 750', 'Iron 883'],
        ),
        CalibrationFile(
          id: 'hd2',
          name: 'V-TWIN THUNDER',
          description: 'Aggressive map for maximum V-twin rumble',
          price: 16.99,
          hexUrl: 'https://...vtwin.hex',
          image: 'assets/vtwin_mode.png',
          color: const Color(0xFF3F51B5),
          company: 'Harley-Davidson',
          isPremium: true,
          compatibleModels: ['Fat Boy', 'Softail'],
        ),
        CalibrationFile(
          id: 'hd3',
          name: 'TOURING PRO',
          description: 'Optimized for loaded touring with pillion',
          price: 14.99,
          hexUrl: 'https://...touring.hex',
          image: 'assets/touring_mode.png',
          color: const Color(0xFF607D8B),
          company: 'Harley-Davidson',
          isPremium: true,
          compatibleModels: ['Road King', 'Street Glide'],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RIDEWAVE PRO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _tabController.animateTo(5),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildShopTab(),
          _buildCartTab(),
          _buildAbsTab(),
          _buildSuspensionTab(),
          _buildUploadTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(icon: Icon(Icons.shop)),
            Tab(icon: Icon(Icons.shopping_cart)),
            Tab(icon: Icon(Icons.flash_on)),
            Tab(icon: Icon(Icons.car_repair)),
            Tab(icon: Icon(Icons.upload)),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }

  Widget _buildShopTab() {
    final compatibleCalibrations = bikeCompanies
        .expand((company) => company.calibrations.where(
              (cal) =>
                  cal.compatibleModels.isEmpty ||
                  cal.compatibleModels.contains(_userProfile.bikeModel),
            ))
        .toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'By Company'),
                Tab(text: 'For Your Bike'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Companies view
                ListView.builder(
                  itemCount: bikeCompanies.length,
                  itemBuilder: (context, index) {
                    final company = bikeCompanies[index];
                    return ExpansionTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(company.logo),
                      ),
                      title: Text(
                        company.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: company.calibrations.length,
                            itemBuilder: (context, calIndex) {
                              return CalibrationCard(
                                file: company.calibrations[calIndex],
                                onPurchase: () =>
                                    _addToCart(company.calibrations[calIndex]),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Personalized recommendations
                compatibleCalibrations.isEmpty
                    ? const Center(
                        child: Text(
                            'No compatible calibrations found for your bike'))
                    : CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return CalibrationCard(
                                  file: compatibleCalibrations[index],
                                  onPurchase: () =>
                                      _addToCart(compatibleCalibrations[index]),
                                ).animate().fadeIn(delay: (100 * index).ms);
                              }, childCount: compatibleCalibrations.length),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    return _cartItems.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Icon(Icons.flash_on, color: item.color)),
                        ),
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${item.price.toStringAsFixed(2)}'),
                            Text(item.company,
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeFromCart(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '\$${_cartItems.fold(0.0, (double sum, item) => sum + item.price).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _checkout,
                      icon: const Icon(Icons.payment),
                      label: const Text('CHECKOUT'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildAbsTab() {
    return Column(
      children: [
        if (_activeCalibrations.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'ACTIVE CALIBRATIONS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ..._activeCalibrations
              .map((item) => _buildCalibrationItem(item, true)),
        ],
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'PURCHASED CALIBRATIONS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        _purchasedItems.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No purchased calibrations'),
              )
            : Column(
                children: _purchasedItems
                    .map((item) => _buildCalibrationItem(item,
                        _activeCalibrations.any((cal) => cal.id == item.id)))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildCalibrationItem(CalibrationFile file, bool isActive) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: file.color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(child: Icon(Icons.flash_on, color: file.color)),
        ),
        title: Text(file.name),
        subtitle: Text(file.company),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteCalibration(file),
            ),
            ElevatedButton(
              onPressed: () => _flashToEsp32(file),
              style: ElevatedButton.styleFrom(
                backgroundColor: file.color,
                foregroundColor: Colors.white,
              ),
              child: const Text('FLASH'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCalibration(CalibrationFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${file.name}?'),
        content:
            Text('This will remove the calibration from your purchased items.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _purchasedItems.removeWhere((item) => item.id == file.id);
                _activeCalibrations.removeWhere((item) => item.id == file.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${file.name} deleted')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuspensionTab() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _currentModeColor.withOpacity(0.8),
                _currentModeColor.withOpacity(0.4),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.car_repair, size: 60, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                _currentSuspensionMode,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current Suspension Mode',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _suspensionModes.length,
            itemBuilder: (context, index) {
              final mode = _suspensionModes[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: mode['color'].withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(mode['icon'], color: mode['color']),
                  ),
                  title: Text(
                    mode['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(mode['description']),
                  trailing: _currentSuspensionMode == mode['name']
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () => _setSuspensionMode(
                    mode['mode'],
                    mode['name'],
                    mode['color'],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUploadTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UPLOAD CUSTOM CALIBRATION',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select HEX file from device storage:'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickAndUploadHexFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('SELECT HEX FILE'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('ESP32 CONNECTION'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      labelText: 'Device IP Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.developer_board),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    TextEditingController nameController =
        TextEditingController(text: _userProfile.name);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(_userProfile.profileImage),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Rider Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: () {
                            setState(() {
                              _userProfile = UserProfile(
                                name: nameController.text,
                                email: _userProfile.email,
                                bikeModel: _userProfile.bikeModel,
                                bikeCompany: _userProfile.bikeCompany,
                                profileImage: _userProfile.profileImage,
                              );
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Name saved')),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userProfile.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PURCHASE HISTORY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _purchasedItems.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No purchases yet'),
                          )
                        : Column(
                            children: _purchasedItems
                                .map((item) => ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: item.color.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                            child: Icon(Icons.flash_on,
                                                color: item.color)),
                                      ),
                                      title: Text(item.name),
                                      subtitle: Text(
                                          '\$${item.price.toStringAsFixed(2)}'),
                                      trailing: Text(item.company,
                                          style: const TextStyle(fontSize: 12)),
                                    ))
                                .toList(),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(CalibrationFile file) {
    setState(() {
      _cartItems.add(file);
      _tabController.animateTo(1);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${file.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _checkout() {
    setState(() {
      _purchasedItems.addAll(_cartItems);
      _cartItems.clear();
      _tabController.animateTo(2);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase successful!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Future<void> _flashToEsp32(CalibrationFile file) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Flashing ${file.name}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      final response = await http.post(
        Uri.parse('http://${_ipController.text}/flash'),
        body: {'hex_url': file.hexUrl},
      );

      if (response.statusCode == 200) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${file.name} flashed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to flash: ${response.body}');
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _setSuspensionMode(String mode, String name, Color color) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Setting suspension to $name mode...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    try {
      final response = await http.post(
        Uri.parse('http://${_ipController.text}/suspension'),
        body: {'mode': mode},
      );

      if (response.statusCode == 200) {
        setState(() {
          _currentSuspensionMode = name;
          _currentModeColor = color;
        });
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Suspension set to $name mode'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to set suspension mode');
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickAndUploadHexFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['hex'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      _uploadHexFile(file);
    }
  }

  Future<void> _uploadHexFile(File file) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String hexContent = await file.readAsString();

      final response = await http.post(
        Uri.parse('http://${_ipController.text}/flash_upload'),
        body: {'hex_content': hexContent},
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File uploaded and flashed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to flash: ${response.body}');
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleCalibration(CalibrationFile file, bool enable) {
    setState(() {
      if (enable) {
        _activeCalibrations.add(file);
        _flashToEsp32(file);
      } else {
        _activeCalibrations.removeWhere((cal) => cal.id == file.id);
        _disableCalibration(file);
      }
    });
  }

  Future<void> _disableCalibration(CalibrationFile file) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final response = await http.post(
        Uri.parse('http://${_ipController.text}/disable'),
        body: {'calibration_id': file.id},
      );

      if (response.statusCode == 200) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${file.name} disabled'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        throw Exception('Failed to disable calibration');
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error disabling calibration: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _changeBikeInfo() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => BikeSelectionDialog(
        currentCompany: _userProfile.bikeCompany,
        currentModel: _userProfile.bikeModel,
      ),
    );

    if (result != null) {
      setState(() {
        _userProfile = UserProfile(
          name: _userProfile.name,
          email: _userProfile.email,
          bikeCompany: result['company']!,
          bikeModel: result['model']!,
          profileImage: _userProfile.profileImage,
        );
      });
    }
  }

  final List<Map<String, dynamic>> _suspensionModes = [
    {
      'name': 'MODE 0',
      'description': 'Soft suspension for maximum comfort',
      'icon': Icons.airline_seat_recline_normal,
      'color': Colors.blue,
      'mode': 'MODE 0'
    },
    {
      'name': 'MODE 1',
      'description': 'Balanced ride quality and handling',
      'icon': Icons.directions_car,
      'color': Colors.green,
      'mode': 'MODE 1'
    },
    {
      'name': 'MODE 2',
      'description': 'Aggressive driving',
      'icon': Icons.speed,
      'color': Colors.red,
      'mode': 'MODE 2'
    },
  ];
}

class BikeCompany {
  final String id;
  final String name;
  final String logo;
  final List<CalibrationFile> calibrations;

  BikeCompany({
    required this.id,
    required this.name,
    required this.logo,
    required this.calibrations,
  });
}

class CalibrationFile {
  final String id;
  final String name;
  final String description;
  final double price;
  final String hexUrl;
  final String image;
  final Color color;
  final String company;
  final bool isPremium;
  final List<String> compatibleModels;
  final double rating;
  final int downloads;

  CalibrationFile({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.hexUrl,
    required this.image,
    required this.color,
    required this.company,
    this.isPremium = false,
    this.compatibleModels = const [],
    this.rating = 4.5,
    this.downloads = 1000,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String bikeModel;
  final String bikeCompany;
  final String profileImage;

  UserProfile({
    required this.name,
    required this.email,
    required this.bikeModel,
    required this.bikeCompany,
    required this.profileImage,
  });
}

class CalibrationCard extends StatelessWidget {
  final CalibrationFile file;
  final VoidCallback onPurchase;

  const CalibrationCard({
    super.key,
    required this.file,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => CalibrationDetails(file: file),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'image_${file.id}',
                child: Container(
                  decoration: BoxDecoration(
                    color: file.color.withOpacity(0.2),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child:
                            Icon(Icons.flash_on, size: 60, color: file.color),
                      ),
                      if (file.isPremium)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'PREMIUM',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    file.company,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        '${file.rating}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      if (file.price == 0)
                        const Text(
                          'FREE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        )
                      else
                        Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              file.price.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPurchase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            file.isPremium ? Colors.deepPurple : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(file.isPremium ? 'BUY NOW' : 'ADD TO CART'),
                    ),
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

class CalibrationDetails extends StatelessWidget {
  final CalibrationFile file;

  const CalibrationDetails({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'image_${file.id}',
              child: Container(
                width: double.infinity,
                height: 250,
                color: file.color.withOpacity(0.2),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(Icons.flash_on, size: 100, color: file.color),
                    ),
                    if (file.isPremium)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'PREMIUM',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        file.price == 0
                            ? 'FREE'
                            : '\$${file.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: file.price == 0 ? Colors.green : Colors.blue,
                        ),
                      ),
                      Chip(
                        label: Text('${file.rating} ★'),
                        backgroundColor: Colors.amber.withOpacity(0.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${file.company}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(file.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  const Text(
                    'COMPATIBLE MODELS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: file.compatibleModels
                        .map((model) => Chip(
                              label: Text(model),
                              backgroundColor: Colors.blue.withOpacity(0.1),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'FEATURES',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._buildFeatureList(),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.flash_on),
                      label: const Text('FLASH TO DEVICE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    return [
      _buildFeatureItem('Enhanced Performance'),
      _buildFeatureItem('Custom Throttle Mapping'),
      _buildFeatureItem('Optimized Fuel Efficiency'),
      _buildFeatureItem('Real-time Monitoring'),
      _buildFeatureItem('Advanced Traction Control'),
    ];
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[400]),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

class BikeSelectionDialog extends StatefulWidget {
  final String currentCompany;
  final String currentModel;

  const BikeSelectionDialog({
    super.key,
    required this.currentCompany,
    required this.currentModel,
  });

  @override
  State<BikeSelectionDialog> createState() => _BikeSelectionDialogState();
}

class _BikeSelectionDialogState extends State<BikeSelectionDialog> {
  late String _selectedCompany;
  late String _selectedModel;

  final Map<String, List<String>> _bikeModels = {
    'Bajaj': ['Pulsar NS200', 'Dominar 400', 'Pulsar RS200', 'Avenger 220'],
    'Royal Enfield': [
      'Classic 350',
      'Meteor 350',
      'Himalayan 450',
      'Interceptor 650'
    ],
    'KTM': ['Duke 390', 'Duke 250', 'RC 390', 'RC 200'],
    'Yamaha': ['R15 V4', 'MT-15', 'FZ-S', 'FZ-X'],
    'Harley-Davidson': ['Street 750', 'Iron 883', 'Fat Boy', 'Road King'],
  };

  @override
  void initState() {
    super.initState();
    _selectedCompany = widget.currentCompany;
    _selectedModel = widget.currentModel;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Your Bike'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedCompany,
            items: _bikeModels.keys
                .map((company) => DropdownMenuItem(
                      value: company,
                      child: Text(company),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCompany = value!;
                _selectedModel = _bikeModels[value]!.first;
              });
            },
            decoration: InputDecoration(
              labelText: 'Manufacturer',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedModel,
            items: _bikeModels[_selectedCompany]!
                .map((model) => DropdownMenuItem(
                      value: model,
                      child: Text(model),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedModel = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Model',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'company': _selectedCompany,
            'model': _selectedModel,
          }),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
