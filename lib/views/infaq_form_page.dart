import 'package:flutter/material.dart';
import '../controllers/infaq_controller.dart';
import '../models/infaq_models.dart';

class InfaqFormPage extends StatefulWidget {
  final Infaq? infaq;
  const InfaqFormPage({super.key, this.infaq});

  @override
  State<InfaqFormPage> createState() => _InfaqFormPageState();
}

class _InfaqFormPageState extends State<InfaqFormPage> {
  final _formKey = GlobalKey<FormState>();
  final InfaqController _infaqController = InfaqController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  String? _selectedJenisPenerimaan;

  final List<String> _jenisPenerimaanOptions = ['QRIS', 'Transfer'];

  @override
  void initState() {
    super.initState();
    if (widget.infaq != null) {
      _namaController.text = widget.infaq!.nama;
      _jumlahController.text = widget.infaq!.jumlah;
      _selectedJenisPenerimaan = widget.infaq!.jenispenerimaan;
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notifikasi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Close the form page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _saveInfaq() async {
    if (_formKey.currentState!.validate()) {
      final infaq = Infaq(
        id: widget.infaq?.id ?? 0,
        nama: _namaController.text,
        jenispenerimaan: _selectedJenisPenerimaan!,
        jumlah: _jumlahController.text,
        createdAt: widget.infaq?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.infaq == null) {
        await _infaqController.createInfaq(infaq);
        _showSuccessDialog('Infaq berhasil dibuat!');
      } else {
        await _infaqController.updateInfaq(infaq);
        _showSuccessDialog('Infaq berhasil diperbarui!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          widget.infaq == null ? 'Tambah Infaq' : 'Edit Infaq',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[800],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal[100]!,
              Colors.teal[50]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextFormField(
                  controller: _namaController,
                  labelText: 'Nama',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan masukkan nama';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownButtonFormField(),
                const SizedBox(height: 16),
                _buildPaymentMethodContent(),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _jumlahController,
                  labelText: 'Jumlah',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan masukkan jumlah';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[600]!, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdownButtonFormField() {
    return DropdownButtonFormField<String>(
      value: _selectedJenisPenerimaan,
      decoration: InputDecoration(
        labelText: 'Jenis Penerimaan',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[600]!, width: 2),
        ),
      ),
      items: _jenisPenerimaanOptions
          .map((jenis) => DropdownMenuItem(
                value: jenis,
                child: Text(jenis == 'QRIS' ? 'QRIS' : 'Transfer'),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedJenisPenerimaan = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silakan pilih jenis penerimaan';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentMethodContent() {
    return Visibility(
      visible: _selectedJenisPenerimaan != null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _selectedJenisPenerimaan == 'QRIS'
            ? Column(
                children: [
                  Text(
                    'Pindai Kode QRIS di bawah ini:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/qris.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ],
              )
            : Column(
                children: [
                  Text(
                    'Detail Transfer Bank:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1234567890 - Bank XYZ a.n. Yayasan ABC',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _saveInfaq,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[800],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        widget.infaq == null ? 'Buat' : 'Perbarui',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
