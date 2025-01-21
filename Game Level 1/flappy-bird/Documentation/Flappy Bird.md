
```
Creador: Honikal Coding
Fecha: 13/01/2025
status: Development
```
# Tabla de contenidos
- [Introducción](#Introducción)
	- [Metas](##Metas)
	- [Metas extra](##Metas/extra)
- [Desarrollo](#Desarrollo)
	- [2025-01-13](##2025-01-13)
	- [2025-01-16](##2025-01-16)
	- [2025-01-17](##2025-01-17)
	- [2025-01-18](##2025-01-18)
	- [2025-01-19](##2025-01-19)
	- [Detalles finales](##Fecha/de/terminación/y/resumen)
# Introducción

Flappy bird fue un juego móbil del año 2013. Un juego que ganó popularidad masiva en 2014, bastante adictivo en su tiempo. Sin embargo, fue removido del Appstore por su popularidad y su atracción negativa en la media.

El juego es simple, manejamos un player (un pájaro), el cual manejamos como una pelota de tenis, con gravedad que sube y baja, y con base a ésto debemos intentar hacer que pase en medio de las tuberías.

| ***Dificultad***         |            |
| ------------------------ | :--------: |
| **Complejidad**          | :luc_star: |
| **Alcance del Proyecto** | :luc_star: |
## Metas

* Crear un mapa de mundo con un piso
* Crear un objeto jugador, aplicando una fuerza constante que lo envíe hacia abajo.
* Agregar obstáculos que se generen y aparezcan a la derecha del área de juego. Los obstáculos deben deslizarse a través de la pantalla hacia la izquierda. Éstos aparecen en pares. (Deben de tener colisión de manera que si el jugador choca con éstos, pierde)
* Detectar cuando el jugador colisiona con los obstáculos o el suelo, y resetear el juego cuando esto ocurra.
* Acumular un punto por cada vez que el jugador pasa por en medio de los obstáculos.
## Metas extra

* Agregar efectos de sonido cada vez que el jugador gana un punto o cuando pierda.
* Crear un sistema que controle la puntuación del jugador y la muestre.
* Guardar también la puntuación máxima del jugador, para tener control del Highscore a través de distintas partidas.
* Tener un sistema de medallas como el Flappy Bird original.
* Agregar un background de fondo, y quizás también implementar un ParallaxBackground para que el fondo lentamente vaya cambiando.
# Desarrollo

Acá entonces, iré detallando una a una, las distintas experiencias que considere importantes a denotar, destacar y considerar, para así en un futuro, de ser necesario volver a checarlas, considerar a releer éste documento, ya que gracias al orden
## [[2025-01-13]]

Fecha de inicio del proyecto, acá empecé con el desarrollo y la creación del proyecto, acá lo que hice básicamente fue preparar el player como tal, el código básico del movimiento, y la gravedad que lo empuja hacia abajo.

También dedicamos tiempo a redibujar el Flappy Bird en aseprite y cambiar los obstáculos por edificios.
## [[2025-01-16]]

En éste día nos encargamos de crear las tuberías como tal, y el área de puntaje, acá en resumen lo que haremos es habilitar el código base de colisión como tal, también el del área como tal para que sea buscado por el jugador.

Luego de ésto lo que sucederá es simple, tenemos que aplicar un movimiento constante hacia la izquierda
## [[2025-01-17]]

En éste momento nos encargamos de finalizar todo lo relacionado al código normal, control de puntuación, implementamos el main junto a su código, generamos un sistema por medio de Timer para generar las tuberías, también buscamos liberarlas del sistema para que no sobrecarguen la memoria, lo básico para que sea considerado un juego.
## [[2025-01-18]]

Acá nos encargamos de crear un menú de main menu y un menú o mensaje de GameOver, además, también buscamos lógica para guardar los datos de las partidas, también implementamos los efectos de sonido al saltar, chocar y caer.

Cabe destacar, que Godot tiene sus ventajas a la hora de generar UI simple y decente como tal.

## [[2025-01-19]]

Acá, decidí tomarme el tiempo de pulir aquellos **Bugs** visuales o posibles problemas que tenía la partida, mejorar o hacer tweeks ligeros al movimiento, spawn de tuberías, posición de layer z de generación de los elementos, y así.
## Fecha de terminación y resumen

Como tal, concluimos con los detalles de lo aprendido, aprendimos a guardar los datos en un archivo .cfg, aprendimos a usar un SoundPlayer y la utilidad del AnimationPlayer, además mejorarmos entendimiento de señales, emisiones y más tipos de escenas, como las de colisiones y entendimos la importancia de dividir en instancias distintas.

Terminamos el proyecto el día *19 de Enero del 2024, siendo las 7:00 p.m*, hemos aprendido bastante durante el trayecto, al mismo tiempo que usamos de un método para acelerar la curva del balón y creamos una especie de IA algo tonta, pero poco a poco se irá mejorando. 

Después de todo, éste se trata de un miniproyecto para aprender a familiarizarnos con el sistema.