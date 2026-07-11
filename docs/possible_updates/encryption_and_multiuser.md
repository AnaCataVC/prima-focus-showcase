# Posibles Actualizaciones Futuras

## Encriptación y Soporte Multiusuario

Para mantener el MVP simple y ágil, la base de datos local de SQLite (Room) almacenará los datos en texto plano. Sin embargo, estas funcionalidades estaban previstas y podrían agregarse en el futuro:

### 1. `userId` (Soporte Multiusuario / Sincronización)
En el diseño original, las tablas `tasks` y `sessions` contemplaban la posibilidad de relacionar cada registro con un `userId`. Esto es útil si en el futuro queremos:
- Soportar múltiples cuentas en el mismo dispositivo.
- Volver a habilitar la sincronización en la nube (Firestore), donde el `userId` es clave para mantener la separación de datos y reglas de seguridad.

### 2. `encrypted` (Privacidad y Seguridad)
Se planteaba tener una bandera `encrypted` (0/1) en las tareas, de modo que el contenido sensible (como el `title` o la `description`) pudiera ser cifrado.
- **Implementación futura**: Se podría usar la librería `androidx.security.crypto.EncryptedSharedPreferences` para guardar una llave maestra, y usar `SQLCipher` para encriptar toda la base de datos de Room, o bien aplicar criptografía a nivel de columna (AES) antes de insertar el registro.

*Nota: Por ahora, ambos conceptos quedan fuera del MVP para enfocarnos en velocidad de desarrollo.*
