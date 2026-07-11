# WorkManager vs Doze Mode (Decisión Arquitectónica)

## El Problema
Configurar frecuencias altas (ej. 15 o 30 minutos) en `PeriodicWorkRequest` de WorkManager para notificaciones locales resulta contraproducente. Android, a través de sus sistemas de gestión energética (Doze Mode y App Standby Buckets), tiende a ignorar frecuencias muy cortas para apps en segundo plano, agrupándolas en ventanas de mantenimiento.
Además, si la app intenta implementar un "Modo Nocturno" simplemente despertándose para verificar la hora y luego abortar la notificación, se consumen recursos de CPU (wakelocks) y batería de forma ineficiente durante la madrugada.

## La Solución / Decisión
1. **Reducción de frecuencia**: Se ajustó la frecuencia mínima a 90 minutos, respetando no solo la eficiencia energética, sino también los ritmos ultradianos del usuario para el trabajo profundo (Deep Work).
2. **Postergación inteligente**: En lugar de abortar tareas dentro del Worker de noche, se utiliza `setInitialDelay()` al momento de encolar el trabajo. Si el usuario configura la app en horas de silencio, se calcula matemáticamente el tiempo restante hasta el final de la ventana de silencio y se le instruye al sistema operativo que difiera completamente la ejecución, evitando que el dispositivo salga del sueño profundo durante la madrugada.
