# VehiPlaza

Aplicación web de compra y venta de vehículos con **PHP + MySQL**.
La lógica de datos en la base de datos: procedimientos almacenados, funciones,
triggers y vistas.

## Roles

| Rol | Qué puede hacer |
|---|---|
| **usuario** | Registrarse, iniciar sesión, publicar vehículos (con foto y equipamiento), guardar y quitar favoritos, editar su cuenta (teléfono, correo, contraseña), ver y eliminar sus publicaciones |
| **administrador** | Todo lo anterior + panel `admin.html`: CRUD de usuarios (con rol y estado), cambiar el estado o eliminar cualquier publicación, ver la auditoría y los reportes (`reportes.html`) |

Al iniciar sesión se crea una sesión en el servidor (PHP). El menú muestra *Admin* y *Reportes*
solo al administrador, y las operaciones de administración se validan en el servidor y en la
base de datos (`fn_es_admin`).

## Usuarios de prueba

| Rol | Correo | Contraseña |
|---|---|---|
| Administrador | `admin@ventacarros.com` | `Admin123*` |
| Usuario | `usuario@ventacarros.com` | `Usuario123*` |

## Requisitos

- XAMPP (Apache + PHP 8 + MariaDB 10.2+ o MySQL 8.0.16+). Los `CHECK` solo se aplican desde esas versiones.
- Navegador moderno.

## Instalación

1. **Copia el proyecto** a `C:\xampp\htdocs\ProyectoBase\` y enciende Apache y MySQL desde XAMPP.
2. **Crea la base de datos:** en phpMyAdmin (`http://localhost/phpmyadmin`) ve a **Importar** y selecciona `bd/venta_carros.sql`.
   Crea las 13 tablas, los catálogos, las rutinas, los triggers, las vistas y los usuarios de prueba.
3. **Crea el usuario de la aplicación:** en la pestaña **SQL** ejecuta `bd/usuario_app.sql`.
   Tiene solo `SELECT` y `EXECUTE`. Cambia la contraseña de ese archivo por una propia
   y usa **la misma** en el paso siguiente (si no coinciden, la aplicación no conecta).
4. **Configura las credenciales:** copia `.env.example` como `.env` y completa los datos
   (`DB_PORT` es `3307` si tu MySQL de XAMPP usa ese puerto; el normal es `3306`):
   ```
   DB_HOST=localhost
   DB_PORT=3307
   DB_NAME=venta_carros
   DB_USER=venta_app
   DB_PASS="usa la clave que asignaste en el paso 3"
   ```
5. **Abre** `http://localhost/ProyectoBase/` e inicia sesión con un usuario de prueba.

Si la aplicación dice *"Falta el archivo .env"* o *"no debe usar el usuario root"*, revisa el paso 4.
Si dice *"Access denied for user 'venta_app'"*, la contraseña del `.env` no coincide con la de la base de datos.

## Estructura

```
ProyectoBase/
├── index.html, detalle.html, publicar.html, cuenta.html, contacto.html
├── inisesi.html, registro.html
├── admin.html, reportes.html          (menú solo para administrador)
├── css/  img/  js/  bootstrap-4.0.0-dist/
├── js/                                (nav.js: menú y cierre de sesión en todas las páginas)
├── php/                               (conexion, sesion, auth, admin, cuenta, favoritos, ...)
├── bd/
│   ├── venta_carros.sql               esquema + rutinas + triggers + vistas + datos
│   ├── usuario_app.sql                usuario de la aplicación (permisos mínimos)
│   ├── respaldo.bat / restaurar.bat   respaldo y prueba de restauración
│   ├── verificar_restauracion.sql     comparación antes/después
├── .env.example   .gitignore   .htaccess
└── README.md
```

## Base de datos

- **13 tablas en 3FN:** `roles, usuarios, marcas, modelos, ciudades, transmisiones, combustibles,
  publicaciones, favoritos, equipamientos, publicacion_equipamiento, historial_precios, log_auditoria`,
  con PK, FK, `UNIQUE`, `NOT NULL`, `DEFAULT` y `CHECK`.
- **8 funciones:** `fn_formatear_precio, fn_antiguedad_vehiculo, fn_categoria_precio (IF/ELSEIF/ELSE),
  fn_comision_venta (CASE), fn_total_publicaciones_usuario, fn_total_favoritos_publicacion,
  fn_precio_promedio_marca, fn_es_admin`.
- **11 procedimientos:** `sp_usuario_registrar (OUT), sp_usuario_actualizar, sp_publicacion_crear (OUT, transacción),
  sp_publicacion_asignar_equipamiento (WHILE), sp_publicacion_eliminar (transacción), sp_favorito_agregar,
  sp_favorito_quitar, sp_admin_usuario_crear (OUT), sp_admin_usuario_actualizar, sp_admin_usuario_eliminar (transacción),
  sp_admin_publicacion_estado`.
- **9 triggers:** BEFORE (validación de usuarios y publicaciones) y AFTER (auditoría en `log_auditoria`,
  historial de precios).
- **7 vistas:** `v_publicaciones_detalle, v_favoritos_usuario, v_ranking_marcas, v_top_vendedores,
  v_publicaciones_populares, v_usuarios_admin, v_auditoria_reciente`.
- La aplicación **solo escribe mediante procedimientos almacenados**; el usuario `venta_app` no tiene
  `INSERT/UPDATE/DELETE` directos.


## CRUD desde la web

| Operación | Dónde | Cómo |
|---|---|---|
| **Create** | Registro, Publicar, Favoritos, Admin → crear usuario | `sp_usuario_registrar`, `sp_publicacion_crear`, `sp_favorito_agregar`, `sp_admin_usuario_crear` |
| **Read** | Inicio, Detalle, Cuenta, Reportes, Admin | Vistas `v_*` |
| **Update** | Cuenta (teléfono/correo/contraseña), Admin (usuarios y estado de publicaciones) | `sp_usuario_actualizar`, `sp_admin_usuario_actualizar`, `sp_admin_publicacion_estado` |
| **Delete** | Cuenta (mis publicaciones), Favoritos, Admin | `sp_publicacion_eliminar`, `sp_favorito_quitar`, `sp_admin_usuario_eliminar` |


## Respaldo y restauración

1. Abre una terminal en la carpeta `bd/` y ejecuta `respaldo.bat` (pide la contraseña de root de MySQL;
   si no le pusiste una, presiona Enter). Los `.bat` usan el puerto `3307`: si tu MySQL usa el `3306`,
   cambia `-P 3307` por `-P 3306` en `respaldo.bat` y `restaurar.bat`.
   Genera `respaldo_venta_carros.sql` con tablas, datos, **procedimientos, funciones, triggers y vistas**.
2. Ejecuta `verificar_restauracion.sql` en phpMyAdmin y anota los números.
3. Ejecuta `restaurar.bat` (borra la base y la reconstruye desde el respaldo).
4. Vuelve a ejecutar `verificar_restauracion.sql`: los números deben ser iguales.

> Si restauras, el usuario `venta_app` sigue funcionando (sus permisos no se borran con la base).

## Seguridad

- Las credenciales están en `.env`.
- La aplicación se conecta con `venta_app`.
- Contraseñas con `password_hash` (bcrypt); consultas con sentencias preparadas.
- El respaldo `respaldo_venta_carros.sql` contiene datos de los usuarios registrados.

