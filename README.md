# Proyecto de Gestión de Ubicaciones y Órdenes

Este proyecto permite gestionar ubicaciones y asignar órdenes a amigos, con varias validaciones para asegurar la correcta asignación y evitar duplicados. La aplicación se encarga de almacenar las ubicaciones en las preferencias locales del dispositivo y restringe la cantidad de órdenes que se pueden asignar a un amigo.

## Funcionalidades

- **Guardar Ubicación**: Permite al usuario guardar una ubicación junto con un título, descripción, fotos y la asignación de un amigo.
- **Verificación de Campos Vacíos**: Antes de guardar una ubicación, se verifica que todos los campos obligatorios (título, descripción, latitud, longitud y amigo asignado) estén completos.
- **Evitar Ubicaciones Duplicadas**: Si la ubicación ya ha sido guardada anteriormente, no se permite agregarla nuevamente.
- **Validación de Distancia**: Si una nueva ubicación está demasiado cerca (menos de 500 metros) de una ubicación ya guardada, no se permite su almacenamiento.
- **Restricción de Órdenes por Amigo**: Cada amigo puede tener un máximo de 5 órdenes asignadas. Si un amigo ya tiene 5 órdenes, no se le pueden asignar más.
- **Interfaz de Usuario**: Se utilizan mensajes emergentes (`SnackBar`) para informar al usuario sobre errores, como campos vacíos, ubicaciones duplicadas, cercanas o la restricción de órdenes.

## Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo para aplicaciones móviles.
- **SharedPreferences**: Almacenamiento local para guardar las ubicaciones y el estado de la aplicación.
- **JSON**: Formato de almacenamiento y lectura de las ubicaciones.

## Instrucciones de Uso

1. **Instalación**: Clona el repositorio en tu máquina local.
2. **Dependencias**: Asegúrate de tener las dependencias necesarias instaladas ejecutando `flutter pub get`.
3. **Ejecuta la aplicación**: Puedes ejecutar la aplicación utilizando el comando `flutter run`.

<div style="display: flex; align-items: center;">
    <img src="https://github.com/user-attachments/assets/ffb8907a-2351-41d2-99a7-f7ca11e21efa" alt="simulator screenshot" width="300"/>
</div>
<div style="display: flex; align-items: center;">
    <img src="https://github.com/user-attachments/assets/59e905cb-d302-4014-87a1-ce186de56edf" alt="simulator screenshot" width="300"/>
</div>
<div style="display: flex; align-items: center;">
    <img src="https://github.com/user-attachments/assets/ce6e4896-f6b3-416f-9cde-81045c875e9a" alt="simulator screenshot" width="300"/>
</div>
<div style="display: flex; align-items: center;">
    <img src="https://github.com/user-attachments/assets/f3461bb5-f4e4-4e45-84cb-d52a9f2fab62" alt="simulator screenshot" width="300"/>
</div>
<div style="display: flex; align-items: center;">
    <img src="https://github.com/user-attachments/assets/05ad7b88-d031-40c5-b23f-e660c5196218" alt="simulator screenshot" width="300"/>
</div>


