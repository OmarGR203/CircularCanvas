import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/tema.dart';

class TarjetaBloque extends StatelessWidget {
  final BloqueCanvas bloque;
  final void Function(BloqueCanvas) onTap;

  const TarjetaBloque({super.key, required this.bloque, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final esCircular = bloque.esCircular;
    final lleno = bloque.estaLleno;

    return GestureDetector(
      onTap: () => onTap(bloque),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: const BoxConstraints(minHeight: 90),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: esCircular
              ? AppTema.circularClaro
              : lleno
                  ? AppTema.mentaClaro
                  : Colors.white,
          border: Border.all(
            color: esCircular
                ? AppTema.circular.withOpacity(0.4)
                : lleno
                    ? AppTema.menta
                    : AppTema.borde,
            width: esCircular ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'B${bloque.numero}',
                  style: TextStyle(
                    fontSize: 10,
                    color: esCircular ? AppTema.circular : AppTema.textoClaro,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (lleno) Icon(Icons.check_circle, size: 14, color: AppTema.menta),
                if (esCircular && !lleno) Icon(Icons.recycling, size: 14, color: AppTema.circular),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              bloque.titulo,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: esCircular ? AppTema.circular : AppTema.textoOscuro,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              lleno ? bloque.contenido : bloque.preguntaGuia.split('?').first + '?',
              style: TextStyle(
                fontSize: 10,
                color: lleno ? AppTema.textoMedio : AppTema.textoClaro,
                fontStyle: lleno ? FontStyle.normal : FontStyle.italic,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
