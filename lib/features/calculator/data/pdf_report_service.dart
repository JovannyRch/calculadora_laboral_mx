import 'dart:io';
import 'dart:typed_data';

import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_input.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_result.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfReportService {
  const PdfReportService();

  Future<Uint8List> buildReport({
    required LaborCalculationInput input,
    required LaborCalculationResult result,
    DateTime? generatedAt,
  }) async {
    final generated = generatedAt ?? DateTime.now();
    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
            italic: pw.Font.helveticaOblique(),
          ),
        ),
        build: (context) => [
          _header(generated),
          _sectionTitle('Datos ingresados'),
          _keyValueTable(_inputRows(input)),
          _sectionTitle('Resultado general'),
          _keyValueTable(_resultRows(result)),
          _sectionTitle('Desglose'),
          _breakdownTable(result),
          if (input.companyOfferAmount != null) ...[
            _sectionTitle('Comparacion con oferta'),
            _keyValueTable(_offerRows(input, result)),
          ],
          _notice(),
        ],
      ),
    );

    return document.save();
  }

  Future<File> saveTemporary({
    required LaborCalculationInput input,
    required LaborCalculationResult result,
  }) async {
    final bytes = await buildReport(input: input, result: result);
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/reporte_laboral_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    return file.writeAsBytes(bytes, flush: true);
  }

  Future<void> shareReport({
    required LaborCalculationInput input,
    required LaborCalculationResult result,
  }) async {
    final file = await saveTemporary(input: input, result: result);
    await Share.shareXFiles([
      XFile(file.path, mimeType: 'application/pdf'),
    ], text: 'Reporte de estimacion laboral');
  }

  pw.Widget _header(DateTime generatedAt) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 18),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blueGrey300)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Calculadora Laboral MX',
            style: pw.TextStyle(
              fontSize: 13,
              color: PdfColors.blueGrey700,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Reporte de estimacion laboral',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Fecha de generacion: ${_formatDate(generatedAt)}',
            style: const pw.TextStyle(color: PdfColors.blueGrey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 22, bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 15,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blueGrey900,
        ),
      ),
    );
  }

  pw.Widget _keyValueTable(List<(String, String)> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blueGrey100),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.2),
        1: pw.FlexColumnWidth(1.8),
      },
      children: [
        for (final row in rows)
          pw.TableRow(
            children: [
              _cell(row.$1, bold: true, background: PdfColors.blueGrey50),
              _cell(row.$2),
            ],
          ),
      ],
    );
  }

  pw.Widget _breakdownTable(LaborCalculationResult result) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blueGrey100),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.15),
        1: pw.FlexColumnWidth(1.35),
        2: pw.FlexColumnWidth(1.45),
        3: pw.FlexColumnWidth(0.8),
        4: pw.FlexColumnWidth(0.8),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blueGrey50),
          children: [
            _cell('Concepto', bold: true),
            _cell('Formula', bold: true),
            _cell('Fundamento', bold: true),
            _cell('Categoria', bold: true),
            _cell('Importe', bold: true),
          ],
        ),
        for (final item in result.breakdownItems)
          pw.TableRow(
            children: [
              _cell(item.title),
              _cell(item.formula),
              _cell(_legalText(item)),
              _cell(_categoryLabel(item.category)),
              _cell(_money(item.amount)),
            ],
          ),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false, PdfColor? background}) {
    return pw.Container(
      color: background,
      padding: const pw.EdgeInsets.all(7),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _notice() {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey50,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Text(
        'Este reporte es una estimacion informativa generada con base en los '
        'datos proporcionados por el usuario. No sustituye asesoria legal, '
        'fiscal ni laboral profesional. Los fundamentos citados corresponden '
        'a referencias generales de la Ley Federal del Trabajo vigente al '
        'momento de preparar esta version de la app.',
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.blueGrey800),
      ),
    );
  }
}

String _legalText(BreakdownItem item) {
  if (item.legalBasis.isEmpty) return 'No especificado';
  if (item.legalNote.isEmpty) return item.legalBasis;
  return '${item.legalBasis}\n${item.legalNote}';
}

List<(String, String)> _inputRows(LaborCalculationInput input) {
  final dailySalary = input.dailySalary ?? input.monthlySalary / 30;
  final integratedDailySalary = input.integratedDailySalary ?? dailySalary;
  return [
    ('Tipo de calculo', input.calculationType.label),
    ('Fecha de ingreso', _formatDate(input.startDate)),
    ('Fecha de salida', _formatDate(input.endDate)),
    ('Antiguedad', '${_yearsWorked(input).toStringAsFixed(2)} años'),
    ('Salario mensual bruto', _money(input.monthlySalary)),
    ('Salario diario', _money(dailySalary)),
    ('Salario diario integrado', _money(integratedDailySalary)),
    ('Dias trabajados no pagados', input.unpaidWorkedDays.toString()),
    ('Dias de aguinaldo anual', input.annualBonusDays.toString()),
    ('Prima vacacional', '${input.vacationPremiumPercentage}%'),
    ('Vacaciones pendientes', input.pendingVacationDays.toString()),
    ('Aguinaldo recibido', input.receivedCurrentYearBonus ? 'Si' : 'No'),
    (
      'Vacaciones recibidas',
      input.receivedCurrentPeriodVacations ? 'Si' : 'No',
    ),
  ];
}

List<(String, String)> _resultRows(LaborCalculationResult result) {
  return [
    ('Total bruto', _money(result.grossTotal)),
    ('ISR estimado', _money(result.estimatedTax)),
    ('Total neto estimado', _money(result.netTotal)),
    ('Finiquito', _money(result.settlementTotal)),
    ('Liquidacion / indemnizacion', _money(result.severanceTotal)),
  ];
}

List<(String, String)> _offerRows(
  LaborCalculationInput input,
  LaborCalculationResult result,
) {
  return [
    ('Oferta de empresa', _money(input.companyOfferAmount ?? 0)),
    ('Diferencia', _money(result.companyOfferDifference ?? 0)),
    (
      'Porcentaje de diferencia',
      '${(result.companyOfferDifferencePercentage ?? 0).toStringAsFixed(2)}%',
    ),
  ];
}

String _categoryLabel(BreakdownCategory category) {
  return switch (category) {
    BreakdownCategory.settlement => 'Finiquito',
    BreakdownCategory.severance => 'Liquidacion',
    BreakdownCategory.tax => 'Impuestos',
    BreakdownCategory.comparison => 'Comparacion',
  };
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

double _yearsWorked(LaborCalculationInput input) {
  if (input.endDate.isBefore(input.startDate)) return 0;
  return input.endDate.difference(input.startDate).inDays / 365;
}

String _money(num value) {
  final sign = value < 0 ? '-' : '';
  final fixed = value.abs().toStringAsFixed(2);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '$sign\$${buffer.toString()}.${parts.last} MXN';
}
