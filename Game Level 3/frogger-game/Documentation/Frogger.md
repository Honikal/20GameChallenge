```
Creador: Honikal Coding (Conocido ahora como Ducksician)
Fecha: 20/02/2026
status: Development
```

# Tabla de contenido

- [Introducción](#Introducción)
	- [Metas](##Metas)
	- [Metas extra](##Metas/extra)
- [Desarrollo](#Desarrollo)
	- [[2026-02-20]]
	- []()
	- []()
	- []()
	- []()

# Introducción

Frogger es uno de los juegos antiguos con mayor maneras distintas de morir y con distintas animaciones. Siendo publicado en Japón en 1981, su diseñador principal tuvo la idea al observar una rana intentando cruzar la carretera mientras éste estaba detenido en el semáforo. Éste juego llamó la atención por su premisa y su jugabilidad "no violenta".

| Dificultad               |                            |
| ------------------------ | -------------------------- |
| **Complejidad**          | :luc_star: :luc_star_half: |
| **Alcance del Proyecto** | :luc_star: :luc_star:      |
## Metas

* Crear y animar una rana. Ésta rana debe ser capaz de moverse arriba, abajo, izquierda o derecha. El movimiento no es suave, la rana debe de saltar hacia el punto cada que un botón es presionado. Cada vez que se presione el botón la rana se moverá un campo.
* Crea el área de juego. El área está dividido en líneas (filas). Existe una línea segura, 5 líneas de vehículos, otra línea segura, y 5 líneas de agua. Finalmente, existen 5 lilypads en la parte arriba del juego.
* Crear y animar los obstáculos. Todos los obstáculos se mueven de forma horizontal. Los obstáculos pueden alternar dirección por cada línea.
	* La carretera tiene distintos vehículos, cada línea con patrones distintos vehículos y velocidades distintas.
	* El río es alternado entre líneas de troncos y tortugas. Algunas tortugas se sumergen periódicamente. Algunos troncos son en realidad cocodrilos, que pueden comer al jugador si éste cae en su boca abierta.
* El jugador debería morir si:
	* Salen de la pantalla.
	* Son aplastados por un vehículo.
	* Si caen en el agua (las ranas se pueden ahogar)
	* Son mordidos o devorados por un animal salvaje. 
* Si el jugador llega a un lilypad en la parte arriba de la pantalla, dicho lugar estará ocupado. Cuando todos los lilypads estén llenos, el nivel ha terminado.
* Agregar UI que contenga un contador de vidas y un contador de puntuación.
* Crear una animación o usar un efecto de partículas para hacer la muerte de la rana más peculiar.
## Metas extra

* Has un sistema de puntuación estilo arcade que pueda guardar las 10 mejores puntuaciones, y que sea funcional a la hora de exportar dicha puntuación a itch.io.
* Has distintas animaciones para cada una de las situaciones de muerte de la rana (ahogándose, siendo aplastada, etc).
* También, poner un temporizador entre cada rana que llega al punto, y en algunos lilypads aveces aparecen moscas, las cuales dan puntos extra, o puede salir un cocodrilo.
* Crea múltiples niveles. Las dificultades más altas tienen vehículos más rápidos y menos plataformas. Además, también mayor chance que salgan troncocodrilos (crocodilos como troncos). Y la segunda zona segura ahora tiene una serpiente que puede comer al jugador.

