# Guía de Configuración de Firebase para Reto Ahorro App

Esta guía te ayudará a configurar Firebase para la aplicación de ahorro.

## Paso 1: Crear Proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en "Agregar proyecto" o "Add project"
3. Nombre del proyecto: `reto-ahorro` (o el que prefieras)
4. Acepta los términos y crea el proyecto

## Paso 2: Habilitar Autenticación

1. En el menú lateral, ve a **Build** → **Authentication**
2. Haz clic en "Get started"
3. En la pestaña "Sign-in method", habilita:
   - **Email/Password**: Activa el método
   - Guarda los cambios

## Paso 3: Crear Base de Datos Firestore

1. En el menú lateral, ve a **Build** → **Firestore Database**
2. Haz clic en "Create database"
3. Selecciona "Start in **test mode**" (para desarrollo)
   - Esto permite lecturas/escrituras sin restricciones
   - **IMPORTANTE**: Cambiar a producción más adelante
4. Selecciona la ubicación más cercana (ej: `us-central1`)
5. Crea la base de datos

## Paso 4: Configurar para Web

### 4.1. Registrar la App Web

1. En la página principal del proyecto, haz clic en el ícono **Web** (`</>`)
2. Nombre de la app: "Reto Ahorro Web"
3. **NO** marques "Also set up Firebase Hosting"
4. Haz clic en "Register app"

### 4.2. Copiar Configuración

Firebase te mostrará un script como este:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "reto-ahorro-xxxxx.firebaseapp.com",
  projectId: "reto-ahorro-xxxxx",
  storageBucket: "reto-ahorro-xxxxx.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:xxxxxxxxxxxxxxxxxx"
};
```

**Copia estos valores** - los necesitarás en el siguiente paso.

## Paso 5: Actualizar el Código de la App

### 5.1. Abrir `lib/main.dart`

Reemplaza estas líneas en el archivo `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    // Estos valores serán reemplazados con los de tu proyecto Firebase
    apiKey: 'TU_API_KEY',              // ← Reemplazar
    appId: 'TU_APP_ID',                // ← Reemplazar
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',  // ← Reemplazar
    projectId: 'TU_PROJECT_ID',        // ← Reemplazar
  ),
);
```

Con tus valores reales de Firebase:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    appId: '1:123456789012:web:xxxxxxxxxxxxxxxxxx',
    messagingSenderId: '123456789012',
    projectId: 'reto-ahorro-xxxxx',
  ),
);
```

### 5.2. Instalar Dependencias

Abre una terminal en la carpeta del proyecto y ejecuta:

```bash
flutter pub get
```

## Paso 6: Ejecutar la Aplicación

### Para Web (Desarrollo)

```bash
flutter run -d chrome
```

### Para Windows

```bash
flutter run -d windows
```

### Para Android (si tienes emulador)

```bash
flutter run -d android
```

## Paso 7: Probar la App

1. **Registrar un usuario**:
   - Abre la app en el navegador/dispositivo
   - Ve a la pestaña "Registrarse"
   - Ingresa nombre, email y contraseña
   - Haz clic en "Crear Cuenta"

2. **Verificar en Firebase Console**:
   - Ve a **Authentication** → **Users**
   - Deberías ver tu usuario creado

3. **Usar la app**:
   - Haz clic en "SACAR NÚMERO" para elegir un número del reto
   - Tu progreso se guarda automáticamente en Firestore

4. **Ver datos en Firestore**:
   - Ve a **Firestore Database** → **Data**
   - Verás una colección `user_progress` con tu documento

## Paso 8: Configuración de Seguridad (Producción)

### 8.1. Reglas de Firestore

Ve a **Firestore Database** → **Rules** y reemplaza con:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Solo usuarios autenticados pueden acceder
    match /user_progress/{userId} {
      // Solo el dueño puede leer/escribir sus datos
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Haz clic en "Publish" para aplicar las reglas.

### 8.2. Reglas de Authentication

Las reglas por defecto de Authentication son suficientes:

- Solo usuarios con email/password válidos pueden autenticarse
- Cambia a producción cuando estés listo

## Problemas Comunes

### Error: "No Firebase App"

**Solución**: Verifica que los valores en `main.dart` están correctamente configurados con los de tu proyecto.

### Error: "PERMISSION_DENIED"

**Solución**: Revisa las reglas de Firestore. En desarrollo, usa test mode. En producción, usa las reglas del Paso 8.1.

### No se instalan las dependencias

**Solución**:

1. Verifica que tienes Flutter instalado: `flutter --version`
2. Ejecuta: `flutter pub get`
3. Si hay conflictos, ejecuta: `flutter pub upgrade`

### La app no carga en web

**Solución**:

1. Asegúrate de tener Chrome instalado
2. Ejecuta: `flutter run -d web-server` para usar otro navegador
3. Verifica la consola del navegador para errores

## Siguientes Pasos

- ✅ Configurar Firebase
- ✅ Registrar usuarios
- ✅ Probar funcionalidad de ahorro
- 🔄 Implementar reglas de seguridad
- 🔄 Configurar para otras plataformas (Android, iOS)
- 🔄 Personalizar UI/UX según preferencias

---

**¿Necesitas ayuda?** Revisa la [documentación de FlutterFire](https://firebase.flutter.dev/)
