@echo off
REM ============================================================
REM  RESPALDO COMPLETO de venta_carros
REM  Incluye: tablas, datos, procedimientos, funciones, triggers,
REM  vistas y eventos.  (Tarea de administración: usa root.)
REM  Ajusta la ruta si tu XAMPP no está en C:\xampp
REM ============================================================
set MYSQLDUMP="C:\xampp\mysql\bin\mysqldump.exe"

%MYSQLDUMP% -h 127.0.0.1 -P 3307 -u root -p --routines --triggers --events --single-transaction --default-character-set=utf8mb4 --databases venta_carros > respaldo_venta_carros.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Respaldo creado: respaldo_venta_carros.sql
) else (
    echo.
    echo Hubo un error. Revisa la ruta de mysqldump, el puerto y la contraseña.
)
pause
