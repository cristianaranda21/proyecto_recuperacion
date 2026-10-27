// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../data/catalogo_libros.dart';
import 'detalleLibro.dart';

class CatalogoLibrosPage extends StatefulWidget {
  const CatalogoLibrosPage({super.key});

  @override
  State<CatalogoLibrosPage> createState() => _CatalogoLibrosPageState();
}

class _CatalogoLibrosPageState extends State<CatalogoLibrosPage> {
  late final List<Map<String, dynamic>> _libros;
  String _busqueda = '';
  String _categoriaSeleccionada = 'Todos';

  @override
  void initState() {
    super.initState();
    _libros = List<Map<String, dynamic>>.of(catalogoLibros);
  }

  List<String> get _categorias => [
    'Todos',
    ...{for (final libro in _libros) libro['categoria'] as String},
  ];

  List<Map<String, dynamic>> get _librosFiltrados {
    final consulta = _busqueda.trim().toLowerCase();
    return _libros.where((libro) {
      final coincideCategoria =
          _categoriaSeleccionada == 'Todos' ||
          libro['categoria'] == _categoriaSeleccionada;
      final coincideTexto =
          consulta.isEmpty ||
          (libro['titulo'] as String).toLowerCase().contains(consulta) ||
          (libro['autor'] as String).toLowerCase().contains(consulta);
      return coincideCategoria && coincideTexto;
    }).toList();
  }

  void _eliminarLibro(Map<String, dynamic> libro) {
    setState(() {
      _libros.removeWhere((elemento) => elemento['id'] == libro['id']);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('“${libro['titulo']}” se quitó del catálogo.'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              setState(() {
                _libros.add(libro);
                _libros.sort(
                  (a, b) => (a['id'] as int).compareTo(b['id'] as int),
                );
              });
            },
          ),
        ),
      );
  }

  void _abrirDetalle(Map<String, dynamic> libro) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DetalleLibroPage(libro: libro)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final librosVisibles = _librosFiltrados;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 188,
            pinned: true,
            floating: true,
            stretch: true,
            title: const Text('Catálogo'),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(
                start: 72,
                bottom: 16,
              ),
              background: Container(
                color: const Color(0xFF176B67),
                child: Stack(
                  children: [
                    Positioned(
                      right: -14,
                      top: 18,
                      child: Icon(
                        Icons.menu_book,
                        size: 166,
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    const Positioned(
                      left: 24,
                      bottom: 66,
                      child: Text(
                        'Historias para cada curiosidad',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: TextField(
                onChanged: (valor) => setState(() => _busqueda = valor),
                decoration: InputDecoration(
                  hintText: 'Buscar por título o autor',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE1E7E2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE1E7E2)),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _categorias.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final categoria = _categorias[index];
                  return ChoiceChip(
                    label: Text(categoria),
                    selected: _categoriaSeleccionada == categoria,
                    onSelected: (_) =>
                        setState(() => _categoriaSeleccionada = categoria),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 8),
              child: Text(
                '${librosVisibles.length} ${librosVisibles.length == 1 ? 'libro' : 'libros'}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF596761),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (librosVisibles.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: Text('No hay libros que coincidan con la búsqueda.'),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final libro = librosVisibles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Dismissible(
                      key: ValueKey('book-${libro['id']}'),
                      direction: DismissDirection.horizontal,
                      background: _fondoEliminar(
                        alignment: Alignment.centerLeft,
                      ),
                      secondaryBackground: _fondoEliminar(
                        alignment: Alignment.centerRight,
                      ),
                      onDismissed: (_) => _eliminarLibro(libro),
                      child: _TarjetaLibro(
                        libro: libro,
                        onTap: () => _abrirDetalle(libro),
                      ),
                    ),
                  );
                }, childCount: librosVisibles.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _fondoEliminar({required Alignment alignment}) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFB84436),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white),
    );
  }
}

class _TarjetaLibro extends StatelessWidget {
  const _TarjetaLibro({required this.libro, required this.onTap});

  final Map<String, dynamic> libro;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = libro['color'] as Color;
    final disponible = libro['estado'] == 'Disponible';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 58,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(libro['icono'] as IconData, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      libro['titulo'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      libro['autor'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF65716C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      libro['categoria'] as String,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    disponible ? Icons.check_circle : Icons.schedule,
                    color: disponible
                        ? const Color(0xFF27714F)
                        : const Color(0xFFB76A20),
                    size: 19,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    disponible ? 'Disponible' : 'Prestado',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
