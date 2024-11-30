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
