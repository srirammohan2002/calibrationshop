import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

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
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
    name: 'Rider',
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
          rating: 3.8,
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
          rating: 4.0,
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
          rating: 3.9,
        ),
        CalibrationFile(
          id: 'b4',
          name: 'RELAX MODE',
          description: 'Relax',
          price: 0.9,
          rating: 4.7,
          // monthlyPrice: '15/month',
          hexUrl: 'https://...track_pro.hex',
          image: 'assets/track_mode.png',
          color: const Color(0xFFFF5252),
          company: 'Bajaj',
          isPremium: true, // This is still marked as premium
          compatibleModels: ['Pulsar RS200', 'Dominar 400'],
        ),
        CalibrationFile(
          id: 'b5',
          name: 'ADVENTURE MODE',
          description: 'Optimized for challenging terrain',
          rating: 4.8,
          price: 0.6,
          //monthlyPrice: '30/month',
          hexUrl: 'https://...Adventure.hex',
          image: 'assets/Adventure_mode.png',
          color: const Color(0xffe15454),
          company: 'Bajaj',
          isPremium: true,
          compatibleModels: ['Dominar 400'],
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
          rating: 4.1,
        ),
        CalibrationFile(
            id: '2',
            name: 'Touring Mode',
            description: 'touring mode balances power and comfort',
            price: 220,
            hexUrl: 'https://...touring.hex',
            image: 'ssets/touring_mode.png',
            color: const Color(0xff5604f1),
            company: 'Royal Enfield',
            isPremium: true,
            compatibleModels: ['Himalayan']),
        CalibrationFile(
          id: '2',
          name: 'ADVENTURE MODE',
          description: 'Optimized for challenging terrain',
          rating: 4.8,
          price: 200,
          //monthlyPrice: '30/month',
          hexUrl: 'https://...Adventure.hex',
          image: 'assets/Adventure_mode.png',
          color: const Color(0xffe15454),
          company: 'Bajaj',
          isPremium: true,
          compatibleModels: ['Dominar 400'],
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
            name: 'STREET MODE',
            description: 'Balanced performance for daily riding',
            price: 0,
            hexUrl: 'https://...street.hex',
            image: 'assets/street_mode.png',
            color: const Color(0xFF2196F3),
            company: 'KTM',
            isPremium: false,
            compatibleModels: ['Duke 390', 'Duke 250', 'RC 390']),
      ],
    ),
  ];

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30),
            const SizedBox(width: 10),
            const Text('RIDEWAVE PRO'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _tabController.animateTo(3),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildShopTab(),
          _buildCartTab(),
          _buildFlashTab(),
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
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }

  Widget _buildShopTab() {
    // Get the current company
    final currentCompany = bikeCompanies.firstWhere(
      (company) => company.name == _userProfile.bikeCompany,
      orElse: () => bikeCompanies.first,
    );

    // Get compatible calibrations
    final companyCalibrations = currentCompany.calibrations
        .where((cal) =>
            cal.compatibleModels.isEmpty ||
            cal.compatibleModels.contains(_userProfile.bikeModel))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand header with logo
          Row(
            children: [
              Image.asset(
                currentCompany.logo,
                height: 30,
                width: 30,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.motorcycle, size: 30),
              ),
              const SizedBox(width: 10),
              Text(
                '${currentCompany.name} ${_userProfile.bikeModel}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Calibration cards
          Expanded(
            child: companyCalibrations.isEmpty
                ? const Center(
                    child: Text(
                      'No calibrations available for your bike model',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: companyCalibrations.length,
                    itemBuilder: (context, index) {
                      return CalibrationCard(
                        file: companyCalibrations[index],
                        onPurchase: () =>
                            _addToCart(companyCalibrations[index]),
                      ).animate().fadeIn(delay: (100 * index).ms);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    return _cartItems.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Your cart is empty',
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
                            Text(item.isPremium
                                ? '₹${(item.price * 70).toStringAsFixed(0)}/month'
                                : 'FREE'),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '₹${(_cartItems.fold(0.0, (double sum, item) => sum + (item.price * 70)).toStringAsFixed(0))}/month',
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
                        backgroundColor: Color(0xffc1afe0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildFlashTab() {
    return SingleChildScrollView(
      child: Column(
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
          const SizedBox(height: 16),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'SUSPENSION MODE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suspensionModes.map((mode) {
                return ChoiceChip(
                  label: Text(mode['name']),
                  selected: _currentSuspensionMode == mode['name'],
                  onSelected: (selected) {
                    if (selected) {
                      _setSuspensionMode(
                        mode['mode'],
                        mode['name'],
                        mode['color'],
                      );
                    }
                  },
                  selectedColor: mode['color'],
                  labelStyle: TextStyle(
                    color: _currentSuspensionMode == mode['name']
                        ? Colors.white
                        : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
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
              icon: const Icon(Icons.delete, color: Colors.red),
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

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _userProfile.customBikeImage != null
                              ? FileImage(_userProfile.customBikeImage!)
                              : (_userProfile.profileImage.startsWith('http')
                                      ? NetworkImage(_userProfile.profileImage)
                                      : AssetImage(_userProfile.profileImage))
                                  as ImageProvider,
                        ),
                        FloatingActionButton.small(
                          onPressed: _changeProfilePicture,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.camera_alt, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _userProfile.name,
                      decoration: const InputDecoration(
                        labelText: 'Rider Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        suffixIcon: Icon(Icons.edit),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _userProfile.name = value;
                        });
                      },
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

            // Bike Information Card with Fixed Overflow
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BIKE INFORMATION',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Brand Selection Dropdown
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _userProfile.bikeCompany,
                        decoration: const InputDecoration(
                          labelText: 'Brand',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.branding_watermark),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        isExpanded: true,
                        items: bikeCompanies.map((BikeCompany company) {
                          return DropdownMenuItem<String>(
                            value: company.name,
                            child: Row(
                              children: [
                                Image.asset(
                                  company.logo,
                                  height: 24,
                                  width: 24,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.motorcycle, size: 24),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    company.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _userProfile.bikeCompany = newValue!;
                            _userProfile.bikeModel = bikeCompanies
                                .firstWhere((c) => c.name == newValue)
                                .calibrations
                                .first
                                .compatibleModels
                                .first;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Model Selection Dropdown
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _userProfile.bikeModel,
                        decoration: const InputDecoration(
                          labelText: 'Model',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.motorcycle),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        isExpanded: true,
                        items: bikeCompanies
                            .firstWhere(
                              (c) => c.name == _userProfile.bikeCompany,
                              orElse: () => bikeCompanies.first,
                            )
                            .calibrations
                            .expand((cal) => cal.compatibleModels)
                            .toSet()
                            .map((String model) {
                          return DropdownMenuItem<String>(
                            value: model,
                            child: Text(
                              model,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _userProfile.bikeModel = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Custom Bike Image Upload
                    if (_userProfile.bikeModel == 'Custom Bike') ...[
                      OutlinedButton.icon(
                        onPressed: _pickBikeImage,
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Upload Bike Photo'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_userProfile.customBikeImage != null)
                        Container(
                          height: 150,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_userProfile.customBikeImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ESP32 Connection and Upload Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ESP32 CONNECTION',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ipController,
                      decoration: const InputDecoration(
                        labelText: 'Device IP Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.developer_board),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'UPLOAD CUSTOM CALIBRATION',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Purchase History Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PURCHASE HISTORY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _purchasedItems.isEmpty
                        ? Column(
                            children: [
                              Icon(Icons.history,
                                  size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No purchases yet',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          )
                        : Column(
                            children: _purchasedItems.map((item) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: item.color.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child:
                                      Icon(Icons.flash_on, color: item.color),
                                ),
                                title: Text(item.name),
                                subtitle: Text(
                                  '${item.company} • ${item.isPremium ? '₹${(item.price * 70).toStringAsFixed(0)}/month' : 'FREE'}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: Text(
                                  'Purchased',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
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
      // Determine corresponding suspension mode
      String suspensionMode = 'MODE 1'; // Default to road mode
      if (file.name.toLowerCase().contains('rain')) {
        suspensionMode = 'MODE 0';
      } else if (file.name.toLowerCase().contains('off-road')) {
        suspensionMode = 'MODE 2';
      }

      // Flash ABS calibration
      final absResponse = await http.post(
        Uri.parse('http://${_ipController.text}/flash'),
        body: {'hex_url': file.hexUrl},
      );

      if (absResponse.statusCode != 200) {
        throw Exception('Failed to flash ABS: ${absResponse.body}');
      }

      // Flash corresponding suspension mode
      final suspensionResponse = await http.post(
        Uri.parse('http://${_ipController.text}/suspension'),
        body: {'mode': suspensionMode},
      );

      if (suspensionResponse.statusCode == 200) {
        // Find the suspension mode details to update UI
        final mode = _suspensionModes.firstWhere(
          (m) => m['mode'] == suspensionMode,
          orElse: () => _suspensionModes[1], // Default to MODE 1 if not found
        );

        setState(() {
          _currentSuspensionMode = mode['name'];
          _currentModeColor = mode['color'];
          if (!_activeCalibrations.any((cal) => cal.id == file.id)) {
            _activeCalibrations.add(file);
          }
        });

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
                '${file.name} and suspension ${mode['name']} flashed successfully!'),
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

  void _deleteCalibration(CalibrationFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${file.name}?'),
        content: const Text(
            'This will remove the calibration from your purchased items.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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

  Future<void> _pickBikeImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      setState(() {
        _userProfile.customBikeImage = File(pickedFile.files.single.path!);
      });
    }
  }

  Future<void> _changeProfilePicture() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      setState(() {
        _userProfile.profileImage = pickedFile.files.single.path!;
      });
    }
  }
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
    this.rating = 4.0,
    this.downloads = 1000,
  });
}

class UserProfile {
  String name;
  final String email;
  String bikeModel;
  String bikeCompany;
  String profileImage;
  File? customBikeImage;

  UserProfile({
    required this.name,
    required this.email,
    required this.bikeModel,
    required this.bikeCompany,
    required this.profileImage,
    this.customBikeImage,
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalibrationDetails(file: file),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
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
                      child: Icon(Icons.flash_on, size: 60, color: file.color),
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
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        file.rating.toStringAsFixed(1),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${(file.price * 70).toStringAsFixed(0)}/month',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              'Subscription',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
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
                      child: Text(file.isPremium ? 'SUBSCRIBE' : 'ADD TO CART'),
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
            Container(
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
                            : '₹${(file.price * 70).toStringAsFixed(0)}/month',
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
