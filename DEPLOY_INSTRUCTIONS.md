# Guía de Publicación en GitHub Pages 🚀

¡Tu app está lista! Sigue estos pasos exactos para subirla a internet gratis.

## Paso 1: Crear el repositorio en GitHub

1. Inicia sesión en [GitHub.com](https://github.com).
2. Haz clic en el botón **+** (arriba a la derecha) y selecciona **"New repository"**.
3. **Repository name**: Escribe `reto-ahorro-app` (o el nombre que quieras).
4. **Public/Private**: Elige **Public** (necesario para GitHub Pages gratis).
5. **NO** marques ninguna casilla de "Initialize this repository with..." (ni README, ni .gitignore).
6. Haz clic en **"Create repository"**.

## Paso 2: Subir tu código

Verás una pantalla con instrucciones. Copia las líneas que aparecen bajo **"…or push an existing repository from the command line"**. Serán parecidas a estas (¡pero usa las tuyas!):

```bash
git remote add origin https://github.com/TU_USUARIO/reto-ahorro-app.git
git branch -M main
git push -u origin main
```

Abre tu terminal en la carpeta del proyecto y pega esos comandos uno por uno.

## Paso 3: Activar GitHub Pages

1. En la página de tu repositorio en GitHub, ve a **Settings** (pestaña arriba).
2. En el menú de la izquierda, busca y haz clic en **Pages**.
3. En la sección **Build and deployment > Source**, asegúrate que diga "Deploy from a branch".
4. En **Branch**, selecciona `main` y la carpeta `/(root)`.
5. Haz clic en **Save**.

## ¡Listo! 🎉

Espera unos segundos (o minutos). GitHub te mostrará un enlace en esa misma página (ej: `https://tu-usuario.github.io/reto-ahorro-app/`).

¡Ese es el enlace de tu App! Ábrelo en tu celular para instalarla.
