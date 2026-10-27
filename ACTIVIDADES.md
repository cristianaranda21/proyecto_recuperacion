# Actividades 1 y 2: Biblioteca Escolar

## Actividad 1: estructura visual y layout

La aplicación usa `List<Map<String, dynamic>>` en `lib/data/catalogo_libros.dart` para guardar id, título, autor, categoría, estado, icono y color de cada libro.

- `Expanded` ocupa el espacio libre de su eje en `Row`, `Column` o `Flex`. Sus propiedades principales son `child` y `flex`; obliga a su hijo a llenar la porción asignada.
- `Flexible` permite que su hijo use hasta el espacio asignado sin obligarlo a llenarlo. Sus propiedades principales son `child`, `flex` y `fit` (`FlexFit.loose` por defecto).
- `Stack` superpone sus hijos. Sus propiedades principales incluyen `children`, `alignment`, `fit` y `clipBehavior`.
- `Positioned` ubica un hijo de `Stack` mediante `top`, `right`, `bottom`, `left`, `width` y `height`.
- Diferencia: `Expanded` equivale a `Flexible(fit: FlexFit.tight)`. Ambos participan en el reparto del espacio libre, pero `Expanded` obliga al hijo a llenarlo y `Flexible` puede dejar espacio sobrante.
- Si se quita `Expanded` del ejercicio de `Row`, el hijo deja de reclamar una fracción del espacio libre; puede quedar espacio sin usar y, si el contenido excede el ancho, producirse overflow.
- Si ambos hijos son `Expanded` con `flex: 1`, se reparten el espacio libre por igual. Con factores `flex` distintos, el reparto es proporcional.

En `homePage.dart`, `Expanded` organiza la cabecera y el área desplazable; `Flexible` y `Expanded` reparten el contenido de la tarjeta destacada. `Stack` y `Positioned` colocan la decoración y la etiqueta encima de ella.

## Actividad 2: interacción y scroll

- `GestureDetector` reconoce gestos sin proporcionar por sí mismo una respuesta visual Material. `InkWell` reconoce toques y muestra la reacción de tinta Material; se utiliza dentro de un `Material`.
- `SliverAppBar` se integra con el desplazamiento y puede expandirse, contraerse, fijarse o flotar.
- `CustomScrollView` combina slivers en un único desplazamiento eficiente, por ejemplo una barra flexible y una lista perezosa.
- `Dismissible` permite descartar una fila con un gesto. Cada fila tiene una clave estable; al descartarla se actualiza la lista y se ofrece «Deshacer».

`catalogoLibros.dart` combina `CustomScrollView`, `SliverAppBar` y `SliverList`. Al tocar un libro se abre `detalleLibro.dart`; al deslizarlo se elimina de la lista de la sesión. La búsqueda y el filtro por categoría refinan los resultados.

## Ejecutar y validar

Desde la raíz del proyecto:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```