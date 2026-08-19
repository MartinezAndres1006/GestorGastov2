# 📱 Gestor Financiero Personal (V2 - Cloud Sync & Auth)

Aplicación web de gestión financiera personal mobile-first, moderna y segura, con **autenticación de usuarios**, **base de datos en la nube (Supabase PostgreSQL)**, **Row Level Security (RLS)**, **sincronización multi-dispositivo** y **soporte offline con IndexedDB**.

---

## 🚀 Guía de Configuración y Despliegue Paso a Paso

### 1. ¿Qué archivos componen el proyecto?
* **[`index.html`](file:///C:/Users/alena/.gemini/antigravity/scratch/gestor-financiero/index.html)**: Aplicación web completa con interfaz Mobile-First, autenticación Supabase, cálculo financiero y analítica gráfica.
* **[`supabase_schema.sql`](file:///C:/Users/alena/.gemini/antigravity/scratch/gestor-financiero/supabase_schema.sql)**: Script SQL ejecutable en Supabase (11 tablas, claves foráneas, triggers de `updated_at`, perfil automático de usuario y políticas RLS estrictas).
* **[`env.js`](file:///C:/Users/alena/.gemini/antigravity/scratch/gestor-financiero/env.js)**: Configuración de credenciales públicas de Supabase (`SUPABASE_URL` y `SUPABASE_ANON_KEY`).
* **[`manifest.json`](file:///C:/Users/alena/.gemini/antigravity/scratch/gestor-financiero/manifest.json)** & **[`sw.js`](file:///C:/Users/alena/.gemini/antigravity/scratch/gestor-financiero/sw.js)**: Soporte para instalación como PWA y funcionamiento offline.

---

### 2. Configurar Backend en Supabase (3 Minutos)

1. Crea una cuenta gratuita en [supabase.com](https://supabase.com) y crea un **Nuevo Proyecto** (ej: `finanzas-personales`).
2. En el menú lateral izquierdo de tu proyecto, haz clic en **"SQL Editor"**.
3. Abre el archivo [`supabase_schema.sql`](file:///C:/Users/alena/.gemini/antigravity/scratch/gestor-financiero/supabase_schema.sql), copia todo su contenido, pégalo en el editor de Supabase y haz clic en **"RUN"**.
4. ¡Listo! Se habrán creado todas las tablas con sus índices, triggers y políticas RLS de seguridad que aseguran que cada usuario solo acceda a sus propios datos.
5. Ve a **Project Settings** (icono de engranaje) → **API** y copia:
   * **Project URL** (ej: `https://xyzcompany.supabase.co`)
   * **Project API Keys** → `anon` `public` (la clave pública).

---

### 3. Conectar la Aplicación con Supabase

Tienes dos formas de configurar tus credenciales:

#### Método A: Desde el archivo `env.js`
Abre [`env.js`](file:///C:/Users/alena/.gemini/antigravity/scratch/gestor-financiero/env.js) y pega tus credenciales:
```javascript
window.ENV = {
  SUPABASE_URL: 'https://tu-proyecto.supabase.co',
  SUPABASE_ANON_KEY: 'tu-clave-anon-publica'
};
```

#### Método B: Directamente desde la aplicación (Sin editar archivos)
1. Abre `index.html` en tu navegador.
2. En la pantalla de Login, toca el botón **"⚙️ Configurar conexión Supabase"**.
3. Pega tu URL y tu Anon Key y haz clic en **"Guardar y Conectar"**.
4. Tus credenciales se guardarán de forma segura en tu navegador.

---

### 4. Cómo ejecutar la aplicación localmente
* Haz doble clic sobre [`index.html`](file:///C:/Users/alena/.gemini/antigravity/scratch/gestor-financiero/index.html) para abrirla en cualquier navegador.
* Para probar la vista móvil desde tu PC, presiona `F12` y activa la vista de teléfono móvil (`Ctrl + Shift + M`).

---

### 5. Cómo subirla a GitHub y desplegarla en Vercel

#### Paso A: Subir a GitHub
```bash
git init
git add .
git commit -m "feat: versión 2 con Supabase Auth, Cloud Sync y RLS"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/gestor-financiero.git
git push -u origin main
```

#### Paso B: Desplegar en Vercel
1. Entra a [vercel.com](https://vercel.com) e inicia sesión.
2. Haz clic en **"Add New..."** → **"Project"** e importa tu repositorio de GitHub.
3. En **Framework Preset**, déjalo como **Other** (sitio estático).
4. Haz clic en **"Deploy"**.
5. ¡Listo! Tendrás tu enlace HTTPS público para abrir desde tu celular 1, celular 2 o computadora.

---

## 🔒 Características de Seguridad y Sincronización

* 👤 **Supabase Auth**: Inicio de sesión persistente, registro de nuevas cuentas y recuperación de contraseña por email.
* 🛡️ **Row Level Security (RLS)**: Cada consulta a la base de datos se filtra automáticamente por `auth.uid() = user_id`. Ningún usuario puede ver ni modificar datos de otros.
* 🔄 **Sincronización Multi-dispositivo**: Cualquier movimiento registrado en un teléfono se sincroniza instantáneamente con tus otros dispositivos al iniciar sesión.
* ⚡ **Indicador de Sincronización en Vivo**: En la cabecera puedes ver el estado en todo momento:
  * `● Sincronizado` (Verde)
  * `● Sincronizando...` (Azul animado)
  * `● Sin conexión` (Ámbar)
  * `● Error de sincronización` (Rojo)
* 📥 **Asistente de Migración 1-Click**: Si tenías datos guardados en la versión anterior (V1) en este dispositivo, la app te ofrecerá subirlos automáticamente a tu nueva cuenta en la nube sin duplicados.
* 📴 **100% Funcional Offline**: Si te quedas sin conexión, la app guarda tus cambios localmente en IndexedDB y los sincroniza al volver a tener internet.
