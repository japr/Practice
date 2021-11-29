# Readme

## Configuración del proyecto
- Descargar el repo
- Utilizando terminal ir a la carpeta del proyecto y ejecutar el comando `pod install`, en caso de no tener instalado [Cocoapods](https://cocoapods.org) descargar e instalar, luego nuevamente ejecutar el comando.
- Una vez finalizado, abrir el archivo `Practice.xcworkspace`.

## Capas de la app
La pequeña app de muestra fue escrita utilizando una implementación de `clean architecture`, varios patrones de diseño como lo son el patrón `repositorio`, `singleton` y un poco de programación reactiva con `RxSwift`, cada parte lógica del código separada por capas.

- Capa de Datos: Para el almacenamiento local de la informacion la capa de datos consta de una clase `Database`y otra clase `DatabaseEntity`. La primera encargada de crear u obtener si ya existe la base de datos local, igualmente es la encargada de cargar objetos desde la base de datos a memoria o guardar nuevos objetos. Por su parte la segunda, es simplemente un protocolo que declara ciertos tipos de variables y funciones que los objetos a almacenar en la base de datos deben implementar, ésto con el fin de hacer un poco más génerica la función de la capa de datos.

- Capa de Networking: Para este caso dos archivos están involucrados, uno contiene la `API` y `Environments` de la app, con todas las rutas y url base que utilizará nuestra app. El segundo archivo contiene la clase `NetworkConnection` encargada de crear y lanzar las peticiones a la red, pasando unos valores predeterminados para las peticiones y devolviendo los valores esperados a manera de `Observables`.

- Capa de Modelos: Para los objetos a modelar, dos tipos de clases fueron utilizadas unas de tipo Cache, que se refieren a todos los objetos a almacenar localmente en la base de datos. El otro tipo y que es más utilizado en la app como tal son de tipo `Value Type` esto con el fin de no tener objetos cargados en memoria desde la base de datos todo el tiempo, lo que se hace es un mapeo desde el tipo de objeto local a la estructura correspondiente.

- Capa de Vista: Para la vista, tres tipos de archivos son empleados. El `Controller`, el cual contiene finalmente los elementos a renderizar. El `wireframe`, quien será el encargado de las transiciones entre una controlador y otro, encargandose además de setear o inyectar correctamente todas las dependencias necesarias para que la nueva vista a presentar trabaje bien. Y finalmente el `Presenter`, éste es el encargado de recibir las interacciones de los elementos de la UI con el usuario, y pasar la información a la dependencia necesaria, una vez completado el flujo de información el presenter retorna al controller el resultado para que éste actualice la UI.

## Principio de Responsabilidad Unica
El principio de responsabilidad única es uno de los 5 conceptos usualmente tenidos en cuenta para el desarrollo de la programación orientada a objetos. Como su nombre lo indica, hace referencia a que una clase debería encargarse de hacer solo 1 cosa a la vez, es decir, si tenemos una clase que debe realizar ciertas acciones, lo mejor es dividirla en otras subclases, las cuales cada una haga una sola acción y finalmente encapsularlas en una clase, que lo único que hace es delegar el trabajo a las demás. Así en caso de tener que cambiar alguna acción, lo unico para actualizar sería la clase que realiza la acción finalmente.

## Codigo Limpio
Según mi opinión un código limpio debe tener las siguientes carácterísticas:
- Syntaxis, una buena syntaxis a lo largo del código, permite a quien lo lea familiarizarse mucho más rápido con la estructura y adaptarse mejor a la hora de hacer cambios.
- Pruebas unitarias, en lo posible implementar pruebas unitarias para que al añadir cambios, posibles errores sean detectados antes de ir a QA.
- Comentarios, que expliquen la estructura de la clase que se está viendo, o si es para un framework, explicar para que corresponde cada método disponible
- Commits, mensajes de cambios claros y en lo posible cortos