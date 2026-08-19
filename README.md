# 📱 Gestor Financiero Personal (V2 - Cloud Sync, Supabase Auth & SMTP)

Aplicación web de gestión financiera personal mobile-first, moderna y segura, con **autenticación de usuarios**, **base de datos en la nube (Supabase PostgreSQL)**, **Row Level Security (RLS)**, **sincronización multi-dispositivo**, **soporte para SMTP propio** y **persistencia offline con IndexedDB**.

---

## 🚀 Guía de Configuración y Despliegue Paso a Paso

### 1. ¿Qué archivos componen el proyecto?
* **[`index.html`](file:///C:/Users/alena/Desktop/gestor-financiero/index.html)**: Aplicación web completa con interfaz Mobile-First, autenticación Supabase, cálculo financiero y analítica gráfica.
* **[`supabase_schema.sql`](file:///C:/Users/alena/Desktop/gestor-financiero/supabase_schema.sql)**: Script SQL ejecutable en Supabase (11 tablas, claves foráneas, triggers de `updated_at`, perfiles automáticos y políticas RLS estrictas).
* **[`env.js`](file:///C:/Users/alena/Desktop/gestor-financiero/env.js)**: Configuración de credenciales de Supabase (`SUPABASE_URL` y `SUPABASE_ANON_KEY`).
* **[`manifest.json`](file:///C:/Users/alena/Desktop/gestor-financiero/manifest.json)** & **[`sw.js`](file:///C:/Users/alena/Desktop/gestor-financiero/sw.js)**: Soporte para instalación como PWA y funcionamiento offline.

---

### 2. Configurar Base de Datos en Supabase (3 Minutos)

1. Crea una cuenta gratuita en [supabase.com](https://supabase.com) y crea un **Nuevo Proyecto** (ej: `finanzas-personales`).
2. En el menú lateral izquierdo de tu proyecto, haz clic en **"SQL Editor"** (ícono `>_`).
3. Abre el archivo [`supabase_schema.sql`](file:///C:/Users/alena/Desktop/gestor-financiero/supabase_schema.sql), copia todo su contenido, pégalo en el editor y haz clic en **"RUN"**.
4. ¡Listo! Se habrán creado todas las tablas con sus índices, triggers y políticas RLS de seguridad que aseguran que cada usuario solo acceda a sus propios datos.
5. Ve a **Project Settings** (⚙️) → **API** y copia:
   * **Project URL** (ej: `https://xyzcompany.supabase.co`)
   * **anon public Key** (la clave pública que empieza con `eyJ...`).

---

### 3. Configurar SMTP Propio en Supabase (Para autenticación ilimitada sin límites de envío)

> [!IMPORTANT]
> **¿Por qué configurar un SMTP propio?**
> Supabase en su plan gratuito incluye un servidor de email por defecto limitado a **3 a 4 correos por hora**. Si intentas registrar varios usuarios seguidos, Supabase bloquea los envíos con el error *"Email rate limit exceeded"*.
> Al conectar tu propio servidor SMTP (como **Gmail**, **Resend** o **Brevo**), eliminas esta restricción y puedes enviar cientos o miles de correos de confirmación y recuperación de contraseña sin límites.

#### Opción A: Configurar con Gmail (Rápido y Gratis)
1. En tu cuenta de Google, ve a [Seguridad de Google](https://myaccount.google.com/security) y asegúrate de tener la **Verificación en 2 pasos activada**.
2. Ve a [Contraseñas de Aplicaciones](https://myaccount.google.com/apppasswords).
3. Genera una contraseña para `Supabase Finanzas` y copia la clave de 16 letras que te da Google.
4. En tu panel de Supabase, ve a **Project Settings** (⚙️) → **Authentication** → sección **SMTP Settings**.
5. Activa el interruptor **"Enable Custom SMTP"** y completa los campos:
   * **Sender email**: Tu correo de Gmail (ej: `tu_correo@gmail.com`)
   * **Sender name**: `Finanzas Personales`
   * **Host**: `smtp.gmail.com`
   * **Port number**: `587`
   * **Minimum interval between emails**: `60` (o `30`)
   * **Username**: Tu correo de Gmail (ej: `tu_correo@gmail.com`)
   * **Password**: La contraseña de aplicación de 16 letras generada en el paso 3.
6. Haz clic en **"Save"**. ¡Ahora tienes envíos ilimitados desde tu propio correo!

#### Opción B: Configurar con Resend (Profesional y Gratis - 3.000 emails/mes)
1. Crea una cuenta gratuita en [resend.com](https://resend.com).
2. Ve a **API Keys** y genera una nueva clave (ej: `re_123456...`).
3. En Supabase (**Project Settings** → **Authentication** → **SMTP Settings**):
   * **Sender email**: `onboarding@resend.dev` (o tu dominio verificado)
   * **Sender name**: `Finanzas App`
   * **Host**: `smtp.resend.com`
   * **Port number**: `587`
   * **Username**: `resend`
   * **Password**: Tu clave API de Resend (`re_...`)
4. Haz clic en **"Save"**.

---

### 4. Opción para Registro Instantáneo (Sin Esperar Confirmación de Email)

Si prefieres que los usuarios o tú puedan registrarse e ingresar **al instante sin tener que entrar al email a verificar la cuenta**:
1. En Supabase, ve a **Authentication** (menú lateral) → **Providers** → **Email**.
2. Desactiva la casilla **"Confirm email"**.
3. Haz clic en **"Save"**.
4. ¡Listo! A partir de ese momento, cualquier usuario que se registre iniciará sesión automáticamente en la app al segundo siguiente.

---

### 5. Conectar la Aplicación con Supabase

Tienes dos formas de configurar tus credenciales:

#### Método A: Desde el archivo `env.js`
Abre [`env.js`](file:///C:/Users/alena/Desktop/gestor-financiero/env.js) y pega tus credenciales:
```javascript
window.ENV = {
  SUPABASE_URL: 'https://tu-proyecto.supabase.co',
  SUPABASE_ANON_KEY: 'tu-clave-anon-publica'
};
```

#### Método B: Directamente desde la aplicación
1. Abre `index.html` en tu navegador.
2. Presiona el botón amarillo **"⚙️ Configurar Credenciales Ahora"** (o "Configurar conexión Supabase").
3. Pega tu Project URL y tu Anon Key y haz clic en **"Guardar y Conectar"**.

---

### 6. Subir los Cambios a GitHub y Desplegar en Vercel

Ejecuta estos comandos en tu terminal de PowerShell en `C:\Users\alena\Desktop\gestor-financiero`:

```powershell
git add .
git commit -m "feat: optimización de auth, sanitización de credenciales y soporte smtp"
git pull origin main --rebase
git push origin main
```

Una vez ejecutado, Vercel detectará el push y desplegará la versión actualizada automáticamente en pocos segundos.
