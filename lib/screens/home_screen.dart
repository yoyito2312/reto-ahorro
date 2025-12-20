import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; 
import '../logic/game_logic.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  final GameLogic _gameLogic = GameLogic();
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 3));

  List<int> _pickedNumbers = [];
  bool _isLoading = true;
  int? _lastPickedNumber;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    List<int> savedNumbers = await _storageService.getPickedNumbers();
    setState(() {
      _pickedNumbers = savedNumbers;
      _isLoading = false;
    });
  }

  Future<void> _pickNumber() async {
    int? newNumber = _gameLogic.generateRandomNumber(_pickedNumbers);

    if (newNumber == null) {
      // Reto completado
      _showCompletionDialog();
      return;
    }

    setState(() {
      _pickedNumbers.add(newNumber);
      _lastPickedNumber = newNumber;
    });

    await _storageService.savePickedNumbers(_pickedNumbers);
    
    // Celebración visual pequeña al sacar número
    if (_gameLogic.calculateDaysLeft(_pickedNumbers) == 0) {
       _confettiController.play();
       _showCompletionDialog();
    } else {
      _showNewNumberDialog(newNumber);
    }
  }

  void _showNewNumberDialog(int number) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("¡Número del Día!", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$number",
                style: GoogleFonts.poppins(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                "Debes ahorrar:",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
              ),
              Text(
                "\$${NumberFormat('#,###').format(number * 100)}",
                 style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("¡Entendido!"),
            )
          ],
        );
      },
    );
  }

  void _showCompletionDialog() {
    _confettiController.play();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¡FELICITACIONES! 🎉"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("¡Has completado el Reto de Ahorro de 365 días!"),
              const SizedBox(height: 20),
              Text("Total Ahorrado:", style: GoogleFonts.poppins(fontSize: 16)),
              Text(
                "\$${NumberFormat('#,###').format(_gameLogic.calculateTargetTotal())}",
                style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final totalSaved = _gameLogic.calculateTotalSaved(_pickedNumbers);
    final daysLeft = _gameLogic.calculateDaysLeft(_pickedNumbers);
    final percent = _pickedNumbers.length / GameLogic.totalDays;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.green[700],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Reto Ahorro", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green.shade800, Colors.green.shade400],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Text("Total Ahorrado", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text(
                            "\$${NumberFormat('#,###').format(totalSaved)}",
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildProgressCard(daysLeft, percent),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: daysLeft > 0 ? _pickNumber : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          "SACAR NÚMERO",
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Historial de Números", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 50,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final number = index + 1;
                      final isPicked = _pickedNumbers.contains(number);
                      return Container(
                        decoration: BoxDecoration(
                          color: isPicked ? Colors.green[100] : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isPicked ? Colors.green : Colors.grey.shade300),
                          boxShadow: [
                             if (!isPicked) BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
                          ]
                        ),
                        child: Center(
                          child: isPicked 
                            ? Icon(Icons.check, size: 20, color: Colors.green[800])
                            : Text(
                                "$number",
                                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                              ),
                        ),
                      );
                    },
                    childCount: 365,
                  ),
                ),
              ),
               const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int daysLeft, double percent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Progreso", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              Text("${(percent * 100).toStringAsFixed(1)}%", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[200],
            color: Colors.green,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Faltan", "$daysLeft días"),
              _buildStatItem("Meta", "\$6.6M"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
