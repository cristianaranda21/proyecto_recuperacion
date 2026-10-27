// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../data/catalogo_libros.dart';
import 'catalogoLibros.dart';
import 'detalleLibro.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _abrirCatalogo(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CatalogoLibrosPage()));
  }

  void _abrirDetalle(BuildContext context, Map<String, dynamic> libro) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DetalleLibroPage(libro: libro)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final libroDestacado = catalogoLibros.first;
    final disponibles = catalogoLibros
        .where((libro) => libro['estado'] == 'Disponible')
        .length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BIBLIOTECA ESCOLAR',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hola, lector',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Abrir catálogo',
                    onPressed: () => _abrirCatalogo(context),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _abrirDetalle(context, libroDestacado),
                      child: _LibroDestacado(libro: libroDestacado),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _DatoBiblioteca(
                            valor: '${catalogoLibros.length}',
                            etiqueta: 'Libros en catálogo',
                            icono: Icons.auto_stories_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DatoBiblioteca(
                            valor: '$disponibles',
                            etiqueta: 'Disponibles hoy',
                            icono: Icons.check_circle_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Para descubrir',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _abrirCatalogo(context),
                          child: const Text('Ver todos'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...catalogoLibros
                        .take(3)
                        .map(
                          (libro) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _LibroResumen(
                              libro: libro,
                              onTap: () => _abrirDetalle(context, libro),
                            ),
                          ),
                        ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _abrirCatalogo(context),
                        icon: const Icon(Icons.menu_book),
                        label: const Text('Explorar catálogo'),
                      ),
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
}

class _LibroDestacado extends StatelessWidget {
  const _LibroDestacado({required this.libro});

  final Map<String, dynamic> libro;

  @override
  Widget build(BuildContext context) {
    final color = libro['color'] as Color;

    return Container(
      height: 216,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF176B67),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -22,
            top: -28,
            child: Icon(
              Icons.auto_stories,
              size: 180,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            left: 18,
            top: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFFD58A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                child: Text(
                  'SELECCIÓN DE LA SEMANA',
                  style: TextStyle(
                    color: Color(0xFF47351B),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'UNA HISTORIA PARA VOLVER',
                        style: TextStyle(
                          color: Color(0xFFD4E8E1),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        libro['titulo'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          height: 1.08,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        libro['autor'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 118,
                    constraints: const BoxConstraints(minWidth: 76),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x44000000),
                          blurRadius: 14,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Icon(
                      libro['icono'] as IconData,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DatoBiblioteca extends StatelessWidget {
  const _DatoBiblioteca({
    required this.valor,
    required this.etiqueta,
    required this.icono,
  });

  final String valor;
  final String etiqueta;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 84),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E7E2)),
      ),
      child: Row(
        children: [
          Icon(icono, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  valor,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  etiqueta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LibroResumen extends StatelessWidget {
  const _LibroResumen({required this.libro, required this.onTap});

  final Map<String, dynamic> libro;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = libro['color'] as Color;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.13),
            child: Icon(libro['icono'] as IconData, color: color),
          ),
          title: Text(
            libro['titulo'] as String,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(libro['autor'] as String),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
