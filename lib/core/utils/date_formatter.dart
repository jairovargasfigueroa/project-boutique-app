// lib/core/utils/date_formatter.dart

class DateFormatter {
  /// Formatea fecha completa con hora
  /// Ejemplo: 03/11/2025 06:10
  static String formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year;
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$anio $hora:$minuto';
  }

  /// Formatea solo la fecha sin hora
  /// Ejemplo: 03/11/2025
  static String formatearSoloFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year;

    return '$dia/$mes/$anio';
  }

  /// Formatea solo la hora
  /// Ejemplo: 06:10
  static String formatearSoloHora(DateTime fecha) {
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }
}
