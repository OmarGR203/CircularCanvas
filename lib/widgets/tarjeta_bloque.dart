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
    final colorAcento = esCircular ? AppTema.circular : AppTema.verde;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(bloque),
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 112),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: esCircular
                ? AppTema.circularClaro
                : lleno
                    ? AppTema.mentaClaro
                    : Colors.white,
            border: Border.all(
              color: esCircular
                  ? AppTema.circular.withOpacity(0.35)
                  : lleno
                      ? AppTema.menta
                      : AppTema.borde,
              width: lleno || esCircular ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorAcento.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      'B${bloque.numero}',
                      style: TextStyle(
                        fontSize: 10,
                        color: colorAcento,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (lleno)
                    const Icon(Icons.check_circle, size: 16, color: AppTema.menta)
                  else if (esCircular)
                    const Icon(Icons.recycling, size: 16, color: AppTema.circular)
                  else
                    const Icon(Icons.add_circle_outline, size: 16, color: AppTema.textoClaro),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                bloque.titulo,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: esCircular ? AppTema.circular : AppTema.textoOscuro,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                lleno ? bloque.contenido : bloque.preguntaGuia.split('?').first + '?',
                style: TextStyle(
                  fontSize: 10,
                  color: lleno ? AppTema.textoMedio : AppTema.textoClaro,
                  fontStyle: lleno ? FontStyle.normal : FontStyle.italic,
                  height: 1.35,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
