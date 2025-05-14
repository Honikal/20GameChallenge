```
Creador: Honikal Coding
Fecha: 23/04/2025
status: Development
```
# Tabla de contenido

- [Introducción](#Introducción)
	- [Metas](##Metas)
	- [Metas extra](##Metas/extra)
- [Desarrollo](#Desarrollo)
	- [2025-02-17](##2025-02-17)
	- [2025-02-18](##2025-02-18)
	- [2025-02-20](##2025-02-20)
	- [2025-02-22](##2025-02-22)
# Introducción

Atari Breakout fue el descendiente directo de Pong, como contestación por Atari al notar que su juego *Pong* estaba lentamente siendo copiado por distintas compañías, su idea era mantener la jugabilidad más innovativa y estar por delante del mercado. 

Éste juego en su origen fue creado usando transistores y puertas lógicas, un método más complicado que el de ahora para crear dicho juego. Como sabemos, en una máquina moderna, éste proyecto no debería ser muy complicado.

| ***Dificultad***         |                 |
| ------------------------ | :-------------: |
| **Complejidad**          | :luc_star_half: |
| **Alcance del Proyecto** |   :luc_star:    |
## Metas

* Crear un mapa de juego simple, con 2 paredes, un techo del cual rebotar, y un suelo en el cual al colisionar el balón, se pierda.
* Crear una paleta que pueda moverse izquierda y derecha usando inputs de jugador.
* Agregar un balón que rebote por las paredes, paleta y techo.
* Agregar objetos como ladrillos en la parte cercana del techo (El juego original tenía 16 ladrillos, depende del tamaño elegido para la pantalla cambian).
* Activar que el balón al chocar con un ladrillo rebote. Cuando el balón choca con el ladrillo, éste debería desaparecer.
	* Romper un ladrillo agrega puntos extra al puntaje del jugador.
	* La velocidad del balón aumenta al chocar con los ladrillos.
* El puntaje debería de ser mostrado, al mismo tiempo que un contador de vidas. El jugador inicia con 3 vidas. Si el jugador no llega hacia el balón a tiempo, se resta una vida. El juego termina cuando el jugador ha perdido todas sus vidas.
## Metas extra

* Guardar la puntuación más alta a través de sesiones y mostrarla junto al Player Score.
* Si hay más valentía, no guardar solo el Highscore, sino que una lista del 1 al 10 de mejores puntuaciones, mostrarlas como tal, y permitir que el jugador si entró en un nuevo record o en la lista con una puntuación alta, poder escribir sus iniciales. (3 digitos, como en los arcades).
* Agregar diferentes colores a los ladrillos por fila. (Originalmente el juego era blanco y negro, pero tenía un decorado en la pantalla, para simular distintos colores).
* La paleta debería hacerse más estrecha una vez el jugador llegue al techo.

# Desarrollo

Acá iré detallando paso a paso los avances desde día uno, distintas experiencias que se tuvieron durante el desarrollo del proyecto, y más detalles a considerar con respecto. Dicho ésto, descripciones más específicas serán detalladas en cada uno de los apartados por fecha.

## [[2025-04-23]]

Sip, me di un tiempo luego desde el Jetpack Joyride versión fantasma, pero a mi justificación, estaba ocupado con proyectos de la universidad, Dark Souls y cosas similares. Pero decidí empezar el proyecto

## [[2025-04-24]]

Empecé con la programación básica e inicial, programar al jugador (*movimiento, el poder disparar, y la base de lo que pasaría cuando fuera atacado*), y el movimiento de la bala.

## [[2025-04-28]]

Continué con el diseño, esta vez los enemigos.
## [[2025-05-12]]

Continuamos con la programación del proyecto, en esta ocasión, programando el enemigo y el movimiento.

## [[2025-05-13]]

Resolvimos el bug, programamos el que el enemigo pudiera disparar, y empezamos a programar los bunkers y checamos que eliminaran al jugador o a la bala.

