// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../AppBackend/api_map.dart';
import '../Utils/plus_button.dart';
import '../AppBackend/listar_datas_entregas.dart';
import '../../core/app_cores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate;

  void _navigateToCadastroPacote(BuildContext context) async {
    setState(() {
      selectedDate = null;
    });
    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Iniciar Rota'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: const ListarDatasEntregas(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LevExpress'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    Center(
                      child: api_map(date: selectedDate),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _navigateToCadastroPacote(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 236, 237, 238),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            elevation: 6,
                          ),
                          child: const Text(
                            'Iniciar Rota',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: PlusButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = null;
                          });
                          Navigator.pushNamed(context, '/cadastrar-pacote');
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppCores.drawerBackground,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                color: AppCores.appBarBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: AppCores.drawerBackground, size: 40),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'LevExpress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerMenuItem(
                    icon: Icons.home,
                    label: 'Início',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.add_box,
                    label: 'Cadastrar Pacote',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cadastrar-pacote');
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.list_alt,
                    label: 'Listar Pacotes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/listar-pacotes');
                    },
                  ),
                  const Divider(
                    color: AppCores.inputBorder,
                    height: 32,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _DrawerMenuItem(
                icon: Icons.exit_to_app,
                label: 'Sair',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                color: AppCores.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppCores.drawerIcon),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? AppCores.drawerItemText,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: (color ?? AppCores.buttonBackground).withAlpha((0.08 * 255).toInt()),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      minLeadingWidth: 0,
    );
  }
}