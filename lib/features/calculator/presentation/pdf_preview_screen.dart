import 'package:calculadora_laboral_mx/features/calculator/data/pdf_report_service.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_input.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_result.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfReportPreviewScreen extends StatelessWidget {
  const PdfReportPreviewScreen({
    required this.input,
    required this.result,
    super.key,
  });

  final LaborCalculationInput input;
  final LaborCalculationResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista previa PDF')),
      body: PdfPreview(
        build: (_) =>
            const PdfReportService().buildReport(input: input, result: result),
        canChangeOrientation: false,
        canChangePageFormat: false,
        pdfFileName: 'reporte_laboral.pdf',
      ),
    );
  }
}
