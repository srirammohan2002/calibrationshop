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
      title: 'Calibration Pro',
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
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
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

  final List<CalibrationFile> calibrationFiles = [
    CalibrationFile(
      id: '1',
      name: 'RAIN MODE',
      description: 'Enhanced wet traction & stability control',
      price: 5,
      hexUrl:
          'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Rain_cal.hex',
      image: 'assets/rain_mode.png',
      color: const Color(0xFF64B5F6),
    ),
    CalibrationFile(
      id: '2',
      name: 'ROAD MODE',
      description: 'Max performance',
      price: 6,
      hexUrl:
          'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Road_cal.hex',
      image: 'assets/sports_mode.png',
      color: const Color(0xFFE57373),
    ),
    CalibrationFile(
      id: '3',
      name: 'OFF-ROAD MODE',
      description: 'Fuel efficiency optimized',
      price: 5.99,
      hexUrl:
          'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Off_Road_cal.hex',
      image: 'assets/eco_mode.png',
      color: const Color(0xFF81C784),
    ),
  ];

  final List<Map<String, dynamic>> suspensionModes = [
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
    _tabController = TabController(length: 5, vsync: this);
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
        title: const Text('AUTOTUNE PRO'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(icon: Icon(Icons.shop), text: 'Shop'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Cart'),
            Tab(icon: Icon(Icons.flash_on), text: 'ABS'),
            Tab(icon: Icon(Icons.car_repair), text: 'Suspension'),
            Tab(icon: Icon(Icons.upload), text: 'Upload'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildShopTab(),
          _buildCartTab(),
          _buildAbsTab(),
          _buildSuspensionTab(),
          _buildUploadTab(),
        ],
      ),
    );
  }

  Widget _buildShopTab() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return CalibrationCard(
                file: calibrationFiles[index],
                onPurchase: () => _addToCart(calibrationFiles[index]),
                onFlash: () => _flashToEsp32(calibrationFiles[index]),
              ).animate().fadeIn(delay: (100 * index).ms);
            }, childCount: calibrationFiles.length),
          ),
        ),
      ],
    );
  }

  Widget _buildCartTab() {
    return _cartItems.isEmpty
        ? const Center(child: Text('Your cart is empty'))
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return Card(
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
                        subtitle: Text('\$Rs{item.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeFromCart(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
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
              ),
            ],
          );
  }

  Widget _buildAbsTab() {
    return _purchasedItems.isEmpty
        ? const Center(child: Text('No purchased calibrations'))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: _purchasedItems.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _flashToEsp32(_purchasedItems[index]),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                _purchasedItems[index].color.withOpacity(0.2),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.flash_on,
                                size: 60, color: _purchasedItems[index].color),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _purchasedItems[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () =>
                                  _flashToEsp32(_purchasedItems[index]),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40),
                                backgroundColor: _purchasedItems[index].color,
                              ),
                              child: const Text('FLASH',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
            itemCount: suspensionModes.length,
            itemBuilder: (context, index) {
              final mode = suspensionModes[index];
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Future<void> _flashToEsp32(CalibrationFile file) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Preparing ${file.name}...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
}

class CalibrationFile {
  final String id;
  final String name;
  final String description;
  final double price;
  final String hexUrl;
  final String image;
  final Color color;
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
    this.rating = 4.5,
    this.downloads = 1000,
  });
}

class CalibrationCard extends StatelessWidget {
  final CalibrationFile file;
  final VoidCallback onPurchase;
  final VoidCallback onFlash;

  const CalibrationCard({
    super.key,
    required this.file,
    required this.onPurchase,
    required this.onFlash,
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
                  child: Center(
                    child: Icon(Icons.flash_on, size: 60, color: file.color),
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        '${file.rating}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onFlash,
                          icon: const Icon(Icons.flash_on, size: 18),
                          label: const Text('FLASH'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onPurchase,
                        icon: const Icon(Icons.shopping_cart),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
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
                child: Center(
                  child: Icon(Icons.flash_on, size: 100, color: file.color),
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
                        '\$${file.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Chip(
                        label: Text('${file.rating} ★'),
                        backgroundColor: Colors.amber.withOpacity(0.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(file.description, style: const TextStyle(fontSize: 16)),
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
