# Guía de Instalación de Flutter en Windows

Esta guía te ayudará a instalar Flutter paso a paso en Windows.

---

## Requisitos Previos

- Windows 10 o superior (64-bit)
- Al menos 2 GB de espacio en disco
- Git para Windows (se instalará si no lo tienes)

---

## Paso 1: Descargar Flutter

1. Ve a la página oficial de Flutter: <https://docs.flutter.dev/get-started/install/windows>

2. Haz clic en el botón **"Download Flutter SDK"** o descarga directamente desde:
   - **Enlace directo**: <https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip>
   - (O la versión más reciente disponible)

3. El archivo descargado será un ZIP de aproximadamente **1.5 GB**

---

## Paso 2: Extraer Flutter

1. **Crea una carpeta** para Flutter (recomendado):
   - Ubicación recomendada: `C:\src\flutter`
   - O puedes usar: `C:\flutter`

   > ⚠️ **IMPORTANTE**: NO instales Flutter en carpetas como:
   > - `C:\Program Files\` (requiere permisos elevados)
   > - Carpetas con espacios en el nombre
   > - Carpetas dentro de `Windows\System32`

2. **Extrae el archivo ZIP** descargado:
   - Clic derecho en el archivo → "Extraer todo..."
   - Selecciona la carpeta que creaste (ej: `C:\src\`)
   - Asegúrate de que la ruta final sea: `C:\src\flutter\`

3. **Verifica** que la estructura sea correcta:

   ```
   C:\src\flutter\
   ├── bin\
   ├── packages\
   ├── README.md
   └── ...
   ```

---

## Paso 3: Agregar Flutter al PATH

### Opción A: Usando PowerShell (Recomendado - Automático)

1. Abre **PowerShell como Administrador**:
   - Presiona `Win + X`
   - Selecciona "Windows PowerShell (Admin)" o "Terminal (Admin)"

2. Ejecuta este comando (cambia la ruta si instalaste en otro lugar):

```powershell
[System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\src\flutter\bin', [System.EnvironmentVariableTarget]::User)
```

3. Cierra y vuelve a abrir la terminal para que los cambios surtan efecto.

### Opción B: Manual (Interfaz Gráfica)

1. **Abre Variables de Entorno**:
   - Presiona `Win + R`
   - Escribe: `sysdm.cpl`
   - Presiona Enter
   - Ve a la pestaña "Opciones avanzadas"
   - Haz clic en "Variables de entorno"

2. **Edita la variable Path**:
   - En "Variables de usuario", busca `Path`
   - Haz clic en "Editar..."
   - Haz clic en "Nuevo"
   - Agrega: `C:\src\flutter\bin` (o la ruta donde instalaste)
   - Haz clic en "Aceptar" en todas las ventanas

3. **Reinicia la terminal** para aplicar cambios

---

## Paso 4: Verificar la Instalación

1. **Abre una nueva terminal** (PowerShell o CMD):
   - Presiona `Win + R`
   - Escribe: `powershell`
   - Presiona Enter

2. **Verifica que Flutter esté instalado**:

```bash
flutter --version
```

Deberías ver algo como:

```
Flutter 3.16.0 • channel stable
Framework • revision...
Engine • revision...
Tools • Dart 3.2.0 • DevTools 2.28.0
```

3. **Ejecuta Flutter Doctor** para verificar dependencias:

```bash
flutter doctor
```

Esto te mostrará qué componentes necesitas instalar.

---

## Paso 5: Instalar Dependencias Adicionales

### A. Git (Requerido)

Si `flutter doctor` indica que Git no está instalado:

1. Descarga Git desde: <https://git-scm.com/download/win>
2. Instala con las opciones por defecto
3. Reinicia la terminal

### B. Visual Studio Code (Recomendado)

1. Descarga desde: <https://code.visualstudio.com/>
2. Instala normalmente
3. Abre VS Code
4. Ve a Extensions (Ctrl+Shift+X)
5. Busca e instala:
   - **Flutter** (incluye Dart automáticamente)

### C. Chrome (Para desarrollo Web)

Si quieres ejecutar la app en el navegador:

- Chrome ya debería estar instalado
- Si no, descarga desde: <https://www.google.com/chrome/>

---

## Paso 6: Configurar Flutter para Web

```bash
flutter config --enable-web
```

---

## Paso 7: Probar la Instalación

1. **Navega a tu proyecto**:

```bash
cd C:\Users\fortox\Desktop\App_Reto_Ahorro
```

2. **Obtén las dependencias**:

```bash
flutter pub get
```

3. **Ejecuta la app en Chrome**:

```bash
flutter run -d chrome
```

---

## Problemas Comunes y Soluciones

### ❌ Error: "flutter: The term 'flutter' is not recognized"

**Solución**:

- Verifica que agregaste Flutter al PATH correctamente
- Reinicia la terminal completamente
- Verifica la ruta: `C:\src\flutter\bin` existe

### ❌ Error: "Unable to find git in your PATH"

**Solución**:

- Instala Git desde: <https://git-scm.com/download/win>
- Reinicia la terminal después de instalar

### ❌ Flutter Doctor muestra errores

**Solución**:

- Lee cuidadosamente cada error
- La mayoría son opcionales (Android SDK, Visual Studio, etc.)
- Para desarrollo web solo necesitas: Flutter, Git y Chrome

### ❌ Error: "cmdline-tools component is missing"

**Solución**:

- Este error es solo si quieres desarrollar para Android
- Para web no es necesario, puedes ignorarlo

---

## Verificación Rápida - Checklist ✅

Marca cada paso cuando lo completes:

- [ ] Flutter descargado y extraído
- [ ] Flutter agregado al PATH
- [ ] `flutter --version` funciona
- [ ] `flutter doctor` ejecutado (sin errores críticos)
- [ ] Git instalado
- [ ] Chrome instalado
- [ ] `flutter pub get` ejecutado en tu proyecto
- [ ] App ejecutándose con `flutter run -d chrome`

---

## Comandos Útiles

```bash
# Ver versión de Flutter
flutter --version

# Ver estado del sistema
flutter doctor

# Ver dispositivos disponibles
flutter devices

# Limpiar proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Ejecutar en Chrome
flutter run -d chrome

# Ejecutar en Windows (si está disponible)
flutter run -d windows

# Crear build de producción para web
flutter build web
```

---

## Próximos Pasos

Una vez que Flutter esté instalado correctamente:

1. Ejecuta en tu proyecto:

   ```bash
   cd C:\Users\fortox\Desktop\App_Reto_Ahorro
   flutter pub get
   flutter run -d chrome
   ```

2. Deberías ver la pantalla de login/registro de la app

3. Registra un usuario y prueba la funcionalidad

---

## Ayuda Adicional

- **Documentación oficial**: <https://docs.flutter.dev/get-started/install/windows>
- **Discord de Flutter**: <https://discord.gg/flutter>
- **Stack Overflow**: <https://stackoverflow.com/questions/tagged/flutter>

---

**¿Necesitas ayuda con algún paso?** Solo avísame en qué parte te quedaste y te ayudo a resolverlo. 🚀
