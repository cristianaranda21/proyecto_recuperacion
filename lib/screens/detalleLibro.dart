// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DetalleLibroPage extends StatefulWidget {
  const DetalleLibroPage({super.key, required this.libro});

  final Map<String, dynamic> libro;

  @override
  State<DetalleLibroPage> createState() => _DetalleLibroPageState();
}

class _DetalleLibroPageState extends State<DetalleLibroPage> {
  bool _guardado = false;

  void _alternarGuardado() {
    setState(() => _guardado = !_guardado);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _guardado
              ? 'Libro guardado en tus favoritos.'
              : 'Libro quitado de favoritos.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final libro = widget.libro;
    final color = libro['color'] as Color;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del libro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onDoubleTap: _alternarGuardado,
                  child: Container(
                    width: 190,
                    height: 252,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 18,
                          offset: Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            libro['icono'] as IconData,
                            color: Colors.white,
                            size: 76,
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Icon(
                            _guardado ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                libro['categoria'] as String,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                libro['titulo'] as String,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'por ${libro['autor']}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF65716C),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE1E7E2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      libro['estado'] == 'Disponible'
                          ? Icons.check_circle_outline
                          : Icons.schedule,
                      color: libro['estado'] == 'Disponible'
                          ? const Color(0xFF27714F)
                          : const Color(0xFFB76A20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Estado: ${libro['estado']}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Explora esta lectura en la Biblioteca Escolar. Consulta su categoría y disponibilidad antes de solicitar el préstamo.',
                style: TextStyle(height: 1.5, color: Color(0xFF48534E)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _alternarGuardado,
                  icon: Icon(
                    _guardado ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(
                    _guardado
                        ? 'Guardado en favoritos'
                        : 'Guardar en favoritos',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
