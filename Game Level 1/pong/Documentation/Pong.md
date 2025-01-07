---

---

```
Creador: Honikal Coding
Fecha: 16/12/2024
status: Development
```
# Tabla de contenidos
- [Introducción](#Introducción)
	- [Metas](##Metas)
	- [Metas extra](##Metas/extra)
- [Desarrollo](#Desarrollo)
	- [2025-01-06](##2025-01-06)
# Introducción

Pong fue un juego arcade ampliamente exitoso. Salió en el año 1972, e inició la primera explosión de arcades. El juego parece simple a día de hoy, pero fue diseñado alrededor del hardware. Escencialmente, Pong fue una computadora especializada diseñada para rebotar un balón en medio de 2 raquetas, y mantener una puntuación.

No ocuparemos hacer éste juego mediante partes de computadora, por supuesto! Con una máquina moderna, éste proyecto debería ser sencillo iniciar.

| ***Dificultad***         |                 |
| ------------------------ | :-------------: |
| **Complejidad**          | :luc_star_half: |
| **Alcance del Proyecto** | :luc_star_half: |
## Metas

* Crear una arena con 2 paredes y un divisor
* Agregar una paleta en ambos finales del campo de la arena. Usar inputs del usuario para mover las raquetas arriba y abajo.
* Agregar un balón que se mueve alrededor del campo y rebota en las raquetas y las paredes.
* Detectar cuando el balón sale de la arena. Asignar un punto al jugador que anotó.
* Seguir y mostrar la puntuación de cada jugador.
## Metas extra

* Crear una IA que pueda seguir al balón para poder jugar con un solo jugador.
* Crear un menú y permitir al jugador resetear el juego.
* Agregar sonidos básicos. Reproduce un sonido cada vez que el balón haga colisión con algo, y cada que un jugador gana un punto.
# Desarrollo

Acá entonces, iré detallando una a una, las distintas experiencias que considere importantes a denotar, destacar y considerar, para así en un futuro, de ser necesario volver a checarlas, considerar a releer éste documento, ya que gracias al orden
## [[2025-01-06]]

Fecha de inicio del proyecto, acá empecé con el desarrollo y la creación del proyecto, primero empecé creando los repositorios, preparar documentación principal, y más detalles a tomar en consideración.

Finalmente, iniciamos con la creación del proyecto como tal, y creamos los primeros 3 objetos, el objeto madre de paleta, y el balón base como tal.

Aún sin embargo, requeriremos aplicar el movimiento y los inputs como tal.