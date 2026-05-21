import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();
  String _result = '—';
  String _selectedOp = '';
  String _errorMsg = '';
  bool _hasResult = false;
  late AnimationController _resultController;
  late Animation<double> _resultScale;

  @override
  void initState() {
    super.initState();
    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _resultScale = CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _num1Controller.dispose();
    _num2Controller.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _calculate(String op) {
    setState(() {
      _errorMsg = '';
      _selectedOp = op;

      final raw1 = _num1Controller.text.trim();
      final raw2 = _num2Controller.text.trim();

      if (raw1.isEmpty || raw2.isEmpty) {
        _errorMsg = '⚠ Kedua input tidak boleh kosong!';
        _result = '—';
        _hasResult = false;
        return;
      }

      final n1 = double.tryParse(raw1);
      final n2 = double.tryParse(raw2);

      if (n1 == null || n2 == null) {
        _errorMsg = '⚠ Masukkan angka yang valid!';
        _result = '—';
        _hasResult = false;
        return;
      }

      if (op == '÷' && n2 == 0) {
        _errorMsg = '⚠ Tidak bisa membagi dengan nol!';
        _result = '∞';
        _hasResult = false;
        return;
      }

      double res;
      switch (op) {
        case '+':
          res = n1 + n2;
          break;
        case '−':
          res = n1 - n2;
          break;
        case '×':
          res = n1 * n2;
          break;
        case '÷':
          res = n1 / n2;
          break;
        default:
          return;
      }

      _result = res % 1 == 0 ? res.toInt().toString() : res.toStringAsFixed(4);
      _hasResult = true;
      _resultController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1565C0),
                  Color(0xFFE3F2FD),
                ],
                stops: [0.0, 0.35, 1.0],
              ),
            ),
          ),
          // Bubbles dekoratif
          _buildDecorBubble(60, -20, null, 100, 0.1),
          _buildDecorBubble(null, 40, 20, 70, 0.08),
          _buildDecorBubble(200, 20, null, 50, 0.12),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 24),
                  // Input card
                  _buildInputCard(),
                  const SizedBox(height: 20),
                  // Operator buttons
                  _buildOperatorGrid(),
                  const SizedBox(height: 20),
                  // Result
                  _buildResultCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorBubble(
      double? top, double? left, double? right, double size, double opacity) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(opacity * 2),
            width: 2,
          ),
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white30),
          ),
          child: const Icon(
            Icons.calculate_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kalkulator',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'Operasi matematika dasar',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildInputField(
            controller: _num1Controller,
            label: 'Angka Pertama',
            icon: Icons.looks_one_rounded,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _num2Controller,
            label: 'Angka Kedua',
            icon: Icons.looks_two_rounded,
          ),
          if (_errorMsg.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEF9A9A)),
              ),
              child: Text(
                _errorMsg,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFC62828),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF0D47A1),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: const Color(0xFF1976D2),
          fontSize: 14,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFBBDEFB), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F9FF),
      ),
    );
  }

  Widget _buildOperatorGrid() {
    final ops = [
      _OpData('+', 'Tambah', const Color(0xFF1565C0), const Color(0xFFE3F2FD)),
      _OpData('−', 'Kurang', const Color(0xFF1976D2), const Color(0xFFE3F2FD)),
      _OpData('×', 'Kali', const Color(0xFF0288D1), const Color(0xFFE1F5FE)),
      _OpData('÷', 'Bagi', const Color(0xFF0277BD), const Color(0xFFE1F5FE)),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 2,
      children: ops.map((op) => _buildOpButton(op)).toList(),
    );
  }

  Widget _buildOpButton(_OpData op) {
    final isSelected = _selectedOp == op.symbol;
    return GestureDetector(
      onTap: () => _calculate(op.symbol),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [op.color, op.color.withBlue(255)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : op.color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: op.color.withOpacity(isSelected ? 0.4 : 0.15),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 6),
              spreadRadius: isSelected ? 1 : 0,
            ),
            if (isSelected)
              BoxShadow(
                color: op.color.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              op.symbol,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : op.color,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              op.label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : op.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Text(
            'Hasil Perhitungan',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ScaleTransition(
            scale: _hasResult ? _resultScale : const AlwaysStoppedAnimation(1),
            child: Text(
              _result,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 52,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          if (_selectedOp.isNotEmpty && _hasResult) ...[
            const SizedBox(height: 8),
            Text(
              '${_num1Controller.text} $_selectedOp ${_num2Controller.text} = $_result',
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OpData {
  final String symbol;
  final String label;
  final Color color;
  final Color bg;
  const _OpData(this.symbol, this.label, this.color, this.bg);
}
