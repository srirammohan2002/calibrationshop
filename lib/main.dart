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
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
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
                  'CALIBRATION PRO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 1.5,
                    fontFamily: 'Poppins',
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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ipController = TextEditingController(
    text: '192.168.1.100',
  );

  List<CalibrationFile> files = [
    CalibrationFile(
      id: '1',
      name: 'RAIN MASTER',
      description: 'Enhanced wet traction & stability control',
      price: 7.99,
      hexUrl: 'https://your-supabase-url.com/rain_mode.hex',
      image: 'assets/rain_mode.png',
      color: const Color(0xFF64B5F6),
      rating: 4.8,
      downloads: 1243,
    ),
    CalibrationFile(
      id: '2',
      name: 'SPORT PLUS',
      description: 'Max performance with aggressive throttle mapping',
      price: 9.99,
      hexUrl: 'https://your-supabase-url.com/sports_mode.hex',
      image: 'assets/sports_mode.png',
      color: const Color(0xFFE57373),
      rating: 4.9,
      downloads: 1876,
    ),
    CalibrationFile(
      id: '3',
      name: 'ECO PRO',
      description: 'Fuel efficiency optimized up to 15% savings',
      price: 5.99,
      hexUrl: 'https://your-supabase-url.com/eco_mode.hex',
      image: 'assets/eco_mode.png',
      color: const Color(0xFF81C784),
      rating: 4.5,
      downloads: 932,
    ),
    CalibrationFile(
      id: '4',
      name: 'OFF-ROAD EXPERT',
      description: 'Rock crawl mode with torque vectoring enhancement',
      price: 12.99,
      hexUrl: 'https://cchmdnjgncvhwfgwddtd.supabase.co/storage/v1/object/sign/calibration.file/off_road_cal%20%20Modified.hex?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InN0b3JhZ2UtdXJsLXNpZ25pbmcta2V5X2I0NTQ3NjkzLTI3NjAtNDFkZi04ZjI3LWM3NWI2NzIzZTI2MSJ9.eyJ1cmwiOiJjYWxpYnJhdGlvbi5maWxlL29mZl9yb2FkX2NhbCAgTW9kaWZpZWQuaGV4IiwiaWF0IjoxNzQ1MjI0MDE3LCJleHAiOjE3NzY3NjAwMTd9.xJKto6dM7Na7HXr3qrDnWShErMEz47GoCW-2DM8hExo',
      image: 'assets/off_road_mode.png',
      color: const Color(0xFFA1887F),
      rating: 4.7,
      downloads: 1567,
    ),
    CalibrationFile(
      id: '5',
      name: 'TRACK EDITION',
      description: 'Race-spec calibration with launch control',
      price: 14.99,
      hexUrl: 'https://your-supabase-url.com/track_mode.hex',
      image: 'assets/track_mode.png',
      color: const Color(0xFFBA68C8),
      rating: 5.0,
      downloads: 2105,
    ),
    CalibrationFile(
      id: '6',
      name: 'WINTER PRO',
      description: 'Cold weather optimization with soft launch',
      price: 6.99,
      hexUrl: 'https://your-supabase-url.com/winter_mode.hex',
      image: 'assets/winter_mode.png',
      color: const Color(0xFF4FC3F7),
      rating: 4.6,
      downloads: 876,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'FIND YOUR PERFECT CALIBRATION',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              background: Container(color: Colors.white),
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
                    'PREMIUM CALIBRATIONS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                  file: files[index],
                  onPurchase: () => _showPurchaseDialog(files[index]),
                  onFlash: () => _flashToEsp32(files[index]),
                ).animate().fadeIn(delay: (100 * index).ms);
              }, childCount: files.length),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showIpDialog,
        child: const Icon(Icons.settings_input_component),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showIpDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'DEVICE CONNECTION',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _ipController,
                  decoration: InputDecoration(
                    labelText: 'ESP32 IP Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.developer_board),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () {
                        // QR Scanner functionality would go here
                      },
                    ),
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
                              content: const Text('Connection settings saved'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                          'CONNECT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            action: SnackBarAction(
                              label: 'CHECKOUT',
                              textColor: Colors.white,
                              onPressed: () {
                                // Checkout functionality would go here
                              },
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
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${response.body}'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Connection failed: $e'),
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
            onPressed: () {
              // Share functionality would go here
            },
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
                      onPressed: () {
                        // Flash functionality would go here
                      },
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
