# ✉️ Plantillas de Correo Electrónico (Email Templates) para Supabase

Estas plantillas HTML cuentan con un diseño **Fintech Moderno, Responsive y llamativo** (tema oscuro elegante `#0f172a`, acentos de color, tipografía limpia y botones de llamada a la acción estilizados).

---

## 📍 ¿Dónde se configuran en Supabase?
1. Entra a tu proyecto en [supabase.com](https://supabase.com).
2. En el menú lateral izquierdo, ve a **Authentication** → **Email Templates**.
3. Selecciona la pestaña de cada plantilla, pega el código HTML correspondiente y haz clic en **"Save"**.

---

## 1. Confirm signup (Confirmación de Registro / Bienvenida)

* **Asunto (Subject)**: `🔐 Confirma tu cuenta en Finanzas Personales`
* **Contenido HTML**:

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirma tu cuenta</title>
  <style>
    body { margin: 0; padding: 0; background-color: #0b0f19; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #f8fafc; }
    .container { max-width: 540px; margin: 30px auto; background: #0f172a; border-radius: 20px; overflow: hidden; border: 1px solid #1e293b; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
    .hero { background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); padding: 36px 30px; text-align: center; border-bottom: 1px solid #1e293b; }
    .logo-badge { display: inline-block; background: #2563eb; width: 54px; height: 54px; line-height: 54px; font-size: 26px; border-radius: 16px; margin-bottom: 14px; box-shadow: 0 4px 14px rgba(37,99,235,0.4); }
    .title { font-size: 22px; font-weight: 800; color: #ffffff; margin: 0 0 6px 0; }
    .subtitle { font-size: 14px; color: #94a3b8; margin: 0; }
    .body-content { padding: 32px 30px; }
    .card-info { background: #1e293b; border-radius: 14px; padding: 18px; margin-bottom: 24px; border: 1px solid #334155; }
    .btn-cta { display: block; width: 100%; box-sizing: border-box; background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: #ffffff !important; text-decoration: none; padding: 16px; border-radius: 12px; font-weight: 700; font-size: 15px; text-align: center; box-shadow: 0 4px 15px rgba(37,99,235,0.35); margin: 24px 0; }
    .code-box { background: #0b0f19; border: 1px dashed #3b82f6; border-radius: 10px; padding: 12px; text-align: center; margin-top: 16px; }
    .code-text { font-family: monospace; font-size: 24px; font-weight: 800; letter-spacing: 4px; color: #60a5fa; margin: 4px 0 0 0; }
    .footer { padding: 20px 30px; text-align: center; font-size: 12px; color: #64748b; border-top: 1px solid #1e293b; }
  </style>
</head>
<body>
  <div class="container">
    <div class="hero">
      <div class="logo-badge">💳</div>
      <h1 class="title">¡Te damos la bienvenida!</h1>
      <p class="subtitle">Gestor Financiero Personal Multi-dispositivo</p>
    </div>
    <div class="body-content">
      <p style="font-size: 15px; line-height: 1.6; color: #cbd5e1; margin-top: 0;">
        Gracias por registrarte. Para proteger tu información financiera y comenzar a sincronizar tus cuentas y gastos en la nube, confirma tu dirección de correo electrónico:
      </p>

      <a href="{{ .ConfirmationURL }}" class="btn-cta" target="_blank">✓ Confirmar mi Cuenta</a>

      <div class="code-box">
        <div style="font-size: 11px; color: #94a3b8; text-transform: uppercase; font-weight: 700;">O utiliza tu código de 6 dígitos:</div>
        <div class="code-text">{{ .Token }}</div>
      </div>

      <div style="margin-top: 24px; font-size: 12px; color: #64748b; line-height: 1.5;">
        Si el botón no funciona, copia y pega el siguiente enlace en tu navegador:<br>
        <a href="{{ .ConfirmationURL }}" style="color: #3b82f6; word-break: break-all;">{{ .ConfirmationURL }}</a>
      </div>
    </div>
    <div class="footer">
      Si no creaste esta cuenta, puedes ignorar este mensaje de forma segura.<br>
      © 2026 Gestor Financiero Personal.
    </div>
  </div>
</body>
</html>
```

---

## 2. Reset password (Restablecer Contraseña)

* **Asunto (Subject)**: `🔑 Restablece tu contraseña - Finanzas Personales`
* **Contenido HTML**:

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Restablecer Contraseña</title>
  <style>
    body { margin: 0; padding: 0; background-color: #0b0f19; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #f8fafc; }
    .container { max-width: 540px; margin: 30px auto; background: #0f172a; border-radius: 20px; overflow: hidden; border: 1px solid #1e293b; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
    .hero { background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); padding: 36px 30px; text-align: center; border-bottom: 1px solid #1e293b; }
    .logo-badge { display: inline-block; background: #f59e0b; width: 54px; height: 54px; line-height: 54px; font-size: 26px; border-radius: 16px; margin-bottom: 14px; box-shadow: 0 4px 14px rgba(245,158,11,0.35); }
    .title { font-size: 22px; font-weight: 800; color: #ffffff; margin: 0 0 6px 0; }
    .subtitle { font-size: 14px; color: #94a3b8; margin: 0; }
    .body-content { padding: 32px 30px; }
    .warning-box { background: rgba(245,158,11,0.1); border: 1px solid #f59e0b; border-radius: 12px; padding: 14px 16px; font-size: 13px; color: #fde68a; margin-bottom: 20px; line-height: 1.4; }
    .btn-cta { display: block; width: 100%; box-sizing: border-box; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); color: #0f172a !important; text-decoration: none; padding: 16px; border-radius: 12px; font-weight: 800; font-size: 15px; text-align: center; box-shadow: 0 4px 15px rgba(245,158,11,0.3); margin: 20px 0; }
    .footer { padding: 20px 30px; text-align: center; font-size: 12px; color: #64748b; border-top: 1px solid #1e293b; }
  </style>
</head>
<body>
  <div class="container">
    <div class="hero">
      <div class="logo-badge">🔑</div>
      <h1 class="title">Recuperación de Acceso</h1>
      <p class="subtitle">Gestor Financiero Personal</p>
    </div>
    <div class="body-content">
      <p style="font-size: 15px; line-height: 1.6; color: #cbd5e1; margin-top: 0;">
        Recibimos una solicitud para restablecer la contraseña de tu cuenta. Haz clic en el siguiente botón para definir una nueva clave de acceso:
      </p>

      <a href="{{ .ConfirmationURL }}" class="btn-cta" target="_blank">Restablecer mi Contraseña</a>

      <div class="warning-box">
        🛡️ <b>Aviso de seguridad:</b> Este enlace expirará pronto. Si tú no realizaste esta solicitud, puedes desestimar este email y tu contraseña actual seguirá segura.
      </div>

      <div style="font-size: 12px; color: #64748b; line-height: 1.5;">
        Si tienes problemas con el botón, copia y pega este enlace:<br>
        <a href="{{ .ConfirmationURL }}" style="color: #f59e0b; word-break: break-all;">{{ .ConfirmationURL }}</a>
      </div>
    </div>
    <div class="footer">
      © 2026 Gestor Financiero Personal. Todos los derechos reservados.
    </div>
  </div>
</body>
</html>
```

---

## 3. Magic Link (Inicio de Sesión Rápido sin Contraseña)

* **Asunto (Subject)**: `⚡ Tu enlace de acceso directo - Finanzas Personales`
* **Contenido HTML**:

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Acceso Rápido</title>
  <style>
    body { margin: 0; padding: 0; background-color: #0b0f19; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #f8fafc; }
    .container { max-width: 540px; margin: 30px auto; background: #0f172a; border-radius: 20px; overflow: hidden; border: 1px solid #1e293b; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
    .hero { background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); padding: 36px 30px; text-align: center; border-bottom: 1px solid #1e293b; }
    .logo-badge { display: inline-block; background: #10b981; width: 54px; height: 54px; line-height: 54px; font-size: 26px; border-radius: 16px; margin-bottom: 14px; box-shadow: 0 4px 14px rgba(16,185,129,0.35); }
    .title { font-size: 22px; font-weight: 800; color: #ffffff; margin: 0 0 6px 0; }
    .subtitle { font-size: 14px; color: #94a3b8; margin: 0; }
    .body-content { padding: 32px 30px; }
    .btn-cta { display: block; width: 100%; box-sizing: border-box; background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: #ffffff !important; text-decoration: none; padding: 16px; border-radius: 12px; font-weight: 700; font-size: 15px; text-align: center; box-shadow: 0 4px 15px rgba(16,185,129,0.3); margin: 24px 0; }
    .footer { padding: 20px 30px; text-align: center; font-size: 12px; color: #64748b; border-top: 1px solid #1e293b; }
  </style>
</head>
<body>
  <div class="container">
    <div class="hero">
      <div class="logo-badge">⚡</div>
      <h1 class="title">Acceso Instantáneo</h1>
      <p class="subtitle">Gestor Financiero Personal</p>
    </div>
    <div class="body-content">
      <p style="font-size: 15px; line-height: 1.6; color: #cbd5e1; margin-top: 0;">
        Haz clic en el siguiente botón para iniciar sesión en tu cuenta de Finanzas sin necesidad de escribir tu contraseña:
      </p>

      <a href="{{ .ConfirmationURL }}" class="btn-cta" target="_blank">🚀 Entrar a mi Cuenta</a>

      <div style="font-size: 12px; color: #64748b; line-height: 1.5; margin-top: 20px;">
        Este enlace es de uso único y caducará automáticamente.<br>
        <a href="{{ .ConfirmationURL }}" style="color: #10b981; word-break: break-all;">{{ .ConfirmationURL }}</a>
      </div>
    </div>
    <div class="footer">
      © 2026 Gestor Financiero Personal.
    </div>
  </div>
</body>
</html>
```

---

## 4. Change email address (Cambio de Correo)

* **Asunto (Subject)**: `✉️ Confirma tu nuevo correo - Finanzas Personales`
* **Contenido HTML**:

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirmar Cambio de Correo</title>
  <style>
    body { margin: 0; padding: 0; background-color: #0b0f19; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #f8fafc; }
    .container { max-width: 540px; margin: 30px auto; background: #0f172a; border-radius: 20px; overflow: hidden; border: 1px solid #1e293b; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
    .hero { background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); padding: 36px 30px; text-align: center; border-bottom: 1px solid #1e293b; }
    .logo-badge { display: inline-block; background: #6366f1; width: 54px; height: 54px; line-height: 54px; font-size: 26px; border-radius: 16px; margin-bottom: 14px; box-shadow: 0 4px 14px rgba(99,102,241,0.35); }
    .title { font-size: 22px; font-weight: 800; color: #ffffff; margin: 0 0 6px 0; }
    .subtitle { font-size: 14px; color: #94a3b8; margin: 0; }
    .body-content { padding: 32px 30px; }
    .btn-cta { display: block; width: 100%; box-sizing: border-box; background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%); color: #ffffff !important; text-decoration: none; padding: 16px; border-radius: 12px; font-weight: 700; font-size: 15px; text-align: center; box-shadow: 0 4px 15px rgba(99,102,241,0.3); margin: 24px 0; }
    .footer { padding: 20px 30px; text-align: center; font-size: 12px; color: #64748b; border-top: 1px solid #1e293b; }
  </style>
</head>
<body>
  <div class="container">
    <div class="hero">
      <div class="logo-badge">✉️</div>
      <h1 class="title">Cambio de Correo Electrónico</h1>
      <p class="subtitle">Gestor Financiero Personal</p>
    </div>
    <div class="body-content">
      <p style="font-size: 15px; line-height: 1.6; color: #cbd5e1; margin-top: 0;">
        Recibimos una solicitud para asociar este correo a tu cuenta de Finanzas Personales. Para confirmarlo, haz clic en el siguiente botón:
      </p>

      <a href="{{ .ConfirmationURL }}" class="btn-cta" target="_blank">✓ Confirmar Nuevo Correo</a>

      <div style="font-size: 12px; color: #64748b; line-height: 1.5; margin-top: 20px;">
        Si no realizaste este cambio, ponte en contacto con nosotros o revisa la seguridad de tu cuenta.<br>
        <a href="{{ .ConfirmationURL }}" style="color: #6366f1; word-break: break-all;">{{ .ConfirmationURL }}</a>
      </div>
    </div>
    <div class="footer">
      © 2026 Gestor Financiero Personal.
    </div>
  </div>
</body>
</html>
```
