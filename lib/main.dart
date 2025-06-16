import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';

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
        cardTheme: const CardTheme(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 180, height: 180)
                .animate()
                .scale(duration: 800.ms)
                .then(delay: 200.ms)
                .fadeIn(duration: 500.ms),
            const SizedBox(height: 20),
            const Text(
              'AUTOTUNE PRO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.5,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ipController =
      TextEditingController(text: '172.20.10.2');
  int _currentIndex = 0;
  String _currentSuspensionMode = 'Normal';
  Color _currentModeColor = Colors.green;

  final List<CalibrationFile> calibrationFiles = [
    CalibrationFile(
      id: '1',
      name: 'RAIN MODE',
      description: 'Enhanced wet traction & stability control',
      price: 7.99,
      hexUrl:
          'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Rain_cal.hex',
      image: 'assets/rain_mode.png',
      color: const Color(0xFF64B5F6),
      rating: 4.8,
      downloads: 1243,
    ),
    CalibrationFile(
      id: '2',
      name: 'ROAD MODE',
      description: 'Max performance with aggressive throttle mapping',
      price: 9.99,
      hexUrl:
          'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Road_cal.hex',
      image: 'assets/sports_mode.png',
      color: const Color(0xFFE57373),
      rating: 4.9,
      downloads: 1876,
    ),
    CalibrationFile(
      id: '3',
      name: 'OFF-ROAD MODE',
      description: 'Fuel efficiency optimized up to 15% savings',
      price: 5.99,
      hexUrl:
          'https://raw.githubusercontent.com/srirammohan2002/ESP32_HEX_Files/refs/heads/main/47c_Cycle_AT048_D1R0_1CH_2WS_DB229_JW01a_K125_12.7_deb027_Off_Road_cal.hex',
      image: 'assets/eco_mode.png',
      color: const Color(0xFF81C784),
      rating: 4.5,
      downloads: 932,
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
      'description': 'aggressive driving',
      'icon': Icons.speed,
      'color': Colors.red,
      'mode': 'MODE 2'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Shop Tab
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('PREMIUM CALIBRATIONS'),
                  centerTitle: true,
                  background: ColoredBox(color: Colors.white),
                ),
                pinned: true,
                backgroundColor: Colors.white,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FEATURED TUNES',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search calibrations...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      onPurchase: () =>
                          _showPurchaseDialog(calibrationFiles[index]),
                      onFlash: () => _flashToEsp32(calibrationFiles[index]),
                    ).animate().fadeIn(delay: (100 * index).ms);
                  }, childCount: calibrationFiles.length),
                ),
              ),
            ],
          ),

          // Suspension Tab
          Column(
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
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
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
          ),

          // Settings Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'DEVICE SETTINGS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ESP32 CONNECTION',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      const Text(
                        'Ensure your device is connected to the same network',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('SCAN NETWORK'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Connection settings saved'),
                                    behavior: SnackBarBehavior.floating,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'SAVE',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'APP SETTINGS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: const Text('Dark Mode'),
                        value: false,
                        onChanged: (value) {},
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Notifications'),
                        value: true,
                        onChanged: (value) {},
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Auto-Connect'),
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_repair),
            label: 'Suspension',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(CalibrationFile file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Hero(
                tag: 'image_${file.id}',
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: file.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(file.image, width: 80, height: 80),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                file.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${file.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  file.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${file.rating}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.download, color: Colors.green, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${file.downloads}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${file.name} added to cart'),
                            behavior: SnackBarBehavior.floating,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            action: SnackBarAction(
                              label: 'CHECKOUT',
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'BUY NOW',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
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
    required this.rating,
    required this.downloads,
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
                    child: Image.asset(file.image, width: 80, height: 80),
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
                  child: Image.asset(file.image, width: 150, height: 150),
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
