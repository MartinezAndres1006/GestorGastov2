/**
 * CONFIGURACIÓN DE VARIABLES DE ENTORNO (CLIENT-SIDE)
 * Para conectar con tu proyecto de Supabase.
 *
 * Puedes configurar tus credenciales aquí, o bien ingresarlas directamente
 * desde la pantalla de ajustes de la aplicación.
 *
 * IMPORTANTE: Utiliza únicamente la clave 'anon' (pública). Nunca uses la 'service_role'.
 */
window.ENV = window.ENV || {
  SUPABASE_URL: ' https://uvpngylvcoyvjhhahqfr.supabase.co/rest/v1/',      // Ejemplo: 'https://xyzcompany.supabase.co'
  SUPABASE_ANON_KEY: 'sb_publishable_baedrl-DKcZqkJPmIQc0ZA_Ru7_yH6E'  // Tu clave anon/public de Supabase
};
