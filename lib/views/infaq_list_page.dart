import 'package:flutter/material.dart';
import '../controllers/infaq_controller.dart';
import '../models/infaq_models.dart';
import 'infaq_form_page.dart';
import 'package:infaq2/views/login_page.dart';

class InfaqListPage extends StatefulWidget {
  const InfaqListPage({super.key});

  @override
  State<InfaqListPage> createState() => _InfaqListPageState();
}

class _InfaqListPageState extends State<InfaqListPage> {
  final InfaqController _infaqController = InfaqController();
  late Future<List<Infaq>> _infaqList;

  @override
  void initState() {
    super.initState();
    _loadInfaqData();
  }

  void _loadInfaqData() {
    _infaqList = _infaqController.getAllInfaq();
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Konfirmasi Hapus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
          textAlign: TextAlign.left,
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data infaq ini?',
          style: TextStyle(color: Colors.grey[800]),
          textAlign: TextAlign.left,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: TextStyle(color: Colors.teal[300])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus', style: TextStyle(color: Colors.red[600])),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteInfaq(id);
    }
  }

  void _deleteInfaq(int id) async {
    await _infaqController.deleteInfaq(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Data infaq berhasil dihapus!'),
        backgroundColor: Colors.teal[600],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    setState(() {
      _loadInfaqData();
    });
  }

  void _logout() {
  // Implement your logout logic here, e.g., clear session or navigate to login page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2B3C),
      appBar: AppBar(
        title: Text(
          'قائمة الإنفاق',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.teal[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout, // Logout action
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal[900]!,
              Colors.teal[600]!,
              Colors.teal[400]!,
            ],
          ),
        ),
        child: FutureBuilder<List<Infaq>>(
          future: _infaqList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[300], size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_alt, color: Colors.white54, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada data tersedia',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }

            final infaqList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 16),
              itemCount: infaqList.length,
              itemBuilder: (context, index) {
                final infaq = infaqList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      infaq.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.teal[800],
                      ),
                    ),
                    subtitle: Text(
                      '${infaq.jenispenerimaan} - ${infaq.jumlah}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue[600]),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfaqFormPage(infaq: infaq),
                              ),
                            ).then((_) {
                              setState(() {
                                _loadInfaqData();
                              });
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[600]),
                          onPressed: () {
                            _showDeleteConfirmationDialog(infaq.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InfaqFormPage(),
            ),
          ).then((_) {
            setState(() {
              _loadInfaqData();
            });
          });
        },
        backgroundColor: Colors.teal[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
