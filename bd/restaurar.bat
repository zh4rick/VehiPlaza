@echo off
REM ============================================================
REM  PRUEBA DE RESTAURACIÓN
REM  Borra la base venta_carros y la reconstruye desde
REM  respaldo_venta_carros.sql. Úsalo para demostrar que el
REM  respaldo funciona (tablas + rutinas + triggers + vistas).
REM
REM  Antes: ejecuta verificar_restauracion.sql y anota los números.
REM  Después: vuelve a ejecutarlo y compara.
REM ============================================================
set MYSQL="C:\xampp\mysql\bin\mysql.exe"

if not exist respaldo_venta_carros.sql (
    echo No existe respaldo_venta_carros.sql. Ejecuta primero respaldo.bat
    pause
    exit /b 1
)

echo ATENCION: se va a BORRAR la base venta_carros y se restaurara desde el respaldo.
set /p CONFIRMA=Escribe SI para continuar: 
if /I not "%CONFIRMA%"=="SI" (
    echo Cancelado.
    pause
    exit /b 0
)

%MYSQL% -h 127.0.0.1 -P 3307 -u root -p -e "DROP DATABASE IF EXISTS venta_carros;"
%MYSQL% -h 127.0.0.1 -P 3307 -u root -p < respaldo_venta_carros.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Restauracion terminada. Ejecuta verificar_restauracion.sql y compara.
) else (
    echo.
    echo Hubo un error al restaurar.
)
pause
