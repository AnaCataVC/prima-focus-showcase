# Divulgación Progresiva en Configuraciones (Patrón UX)

## El Problema
Presentar demasiados controles u opciones complejas (ej. selectores de hora inicio/fin) en pantallas de Ajustes desde el principio puede abrumar al usuario y generar carga cognitiva innecesaria, especialmente si la mayoría de los usuarios se conformarán con el comportamiento por defecto.

## La Decisión
Para la configuración del Modo Nocturno / Desconexión, implementamos el patrón UX de **Divulgación Progresiva**:
- **Vista por defecto**: Solo se muestra un interruptor (Toggle/Switch) llamado "Silenciar durante la noche".
- **Interacción**: Si el usuario lo activa, la interfaz se expande sutilmente hacia abajo revelando controles adicionales para modificar la hora de inicio y fin.

Este enfoque mantiene la interfaz limpia y accesible para usuarios promedio, mientras sigue ofreciendo flexibilidad para usuarios avanzados o con necesidades específicas (como trabajadores por turnos).
