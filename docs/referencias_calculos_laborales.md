# Referencias para calculos laborales

Documento de apoyo para futuras pantallas de referencia dentro de Calculadora
Laboral MX.

Ultima revision interna: 18/06/2026.

## Fuente legal principal

- Ley Federal del Trabajo, Camara de Diputados del H. Congreso de la Union.
  - URL: https://www.diputados.gob.mx/LeyesBiblio/pdf/LFT.pdf
  - Documento consultado: texto vigente con ultima reforma publicada en DOF
    14-05-2026.

## Mapeo de conceptos

| Concepto en la app | Formula usada | Fundamento citado | Nota para mostrar al usuario |
| --- | --- | --- | --- |
| Dias trabajados no pagados | salario diario * dias pendientes | LFT art. 89 | Corresponde a salario devengado pendiente de pago capturado por el usuario. |
| Aguinaldo proporcional | salario diario * dias de aguinaldo * proporcion anual | LFT art. 87 | La LFT establece aguinaldo minimo de 15 dias y pago proporcional cuando no se labora el año completo. |
| Vacaciones proporcionales | salario diario * dias de vacaciones * proporcion periodo | LFT arts. 76 y 79 | Los dias anuales se toman de la tabla legal por antiguedad; si la relacion termina antes del periodo completo, se estima la parte proporcional. |
| Vacaciones pendientes | salario diario * dias de vacaciones pendientes | LFT arts. 76 y 79 | Se calculan con los dias pendientes capturados por el usuario. |
| Prima vacacional | vacaciones * porcentaje prima vacacional | LFT art. 80 | La prima vacacional no debe ser menor al 25% sobre los salarios correspondientes a vacaciones. |
| Indemnizacion constitucional | salario diario integrado * 90 dias | LFT arts. 48 y 50 | Estimacion general de tres meses de salario para despido injustificado; la procedencia depende del caso concreto. |
| Prima de antiguedad | min(sdi, salario minimo diario * 2) * 12 dias * años trabajados | LFT art. 162, relacionado con arts. 485 y 486 | Doce dias por año trabajado, con salario base topado a dos salarios minimos diarios. |
| 20 dias por año | salario diario integrado * 20 dias * años trabajados | LFT art. 50 | Concepto sujeto a supuestos legales y a la accion laboral ejercida. Conviene mostrarlo como estimacion condicionada. |
| ISR estimado | ISR estimado = 0 por ahora | Pendiente de integracion fiscal | Campo preparado para calculo futuro. No sustituye una determinacion fiscal. |
| Comparacion contra oferta | oferta de empresa - total neto estimado | Comparacion aritmetica informativa | No es un concepto laboral legal; solo contrasta la oferta contra el calculo estimado. |

## Tabla de vacaciones usada

Base: LFT art. 76.

| Antiguedad | Dias de vacaciones |
| --- | ---: |
| 1 año | 12 |
| 2 años | 14 |
| 3 años | 16 |
| 4 años | 18 |
| 5 años | 20 |
| 6 a 10 años | 22 |
| 11 a 15 años | 24 |
| 16 a 20 años | 26 |
| 21 a 25 años | 28 |
| 26 a 30 años | 30 |

## Salario minimo diario configurable

La app usa `minimumDailyWage` como constante configurable del motor de calculo
para aplicar el tope de prima de antiguedad:

```dart
LaborCalculatorService({this.minimumDailyWage = 315.04})
```

Notas de mantenimiento:

- Validar este monto cada año contra la resolucion vigente de la CONASAMI y/o
  el Diario Oficial de la Federacion.
- Si se agrega seleccion por zona geografica, separar al menos:
  - Salario minimo general.
  - Zona Libre de la Frontera Norte.
- El fundamento del tope esta en LFT arts. 485 y 486; el monto operativo debe
  actualizarse con la resolucion anual aplicable.

## Aviso sugerido para la app

Esta herramienta ofrece una estimacion informativa basada en los datos
ingresados por el usuario y en referencias generales de la Ley Federal del
Trabajo. No sustituye asesoria legal, fiscal ni laboral profesional. Para casos
especificos, consulta a PROFEDET, un abogado laboral o el Centro de
Conciliacion correspondiente.

## Pendientes recomendados

- Agregar liga a la fuente oficial dentro de la app cuando exista una pantalla
  de referencias.
- Agregar fecha de revision de fundamentos en el PDF.
- Revisar anualmente salario minimo, tabla de vacaciones y reformas a la LFT.
- Integrar calculo fiscal de ISR con fuente fiscal vigente antes de mostrar un
  impuesto estimado distinto de cero.
