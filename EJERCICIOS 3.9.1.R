#---------------------------------#
#       EJERCICIOS 3.9.1          #
#  Estrella Guerra, Danilo David  #
#---------------------------------#

rm(list = ls())
cat("\014")
graphics.off()
options(scipen = 999)



library(pacman)
p_load(ggplot2, dplyr, datos, maps, tictoc, mapproj, plotly)


 ### 1. Convierte un gráfico de barras apiladas en un gráfico circular usando `coord_polar()`.

# Vamos a almacenar los datos de las en un onjeto llamado `millas` para usarlo en los ejemplos
millas <- datos::millas
millas
 
 #   Para este gráfico de barras apiladas queremos observar cuantos autos fueron fabricados en dos mil ocho y  
 #   de tracción en las 4 ruedas, teniendo en cuenta el fabricante y la clase.

 # Gráfico-1
millas %>%  filter(traccion == "4" & anio == 2008 & combustible == "p") %>% ggplot() + 
  aes(x = fabricante, fill = clase) + geom_bar()

 #   Para convertir este grafico de barras apiladas en un grafico circular 
 #   tenemos que usar la funcion "coord_polar" que está en el paquete de ggplot2.


 #   Por defecto el argumento theta = "x" y nos da un gráfico que se conoce como `Ojo de Buey`.
 #   Cuando el argumento es theta = "x", los valores del eje `x` se mapean a los ángulos en la proyección polar, 
 #   lo que hace que las barras (o marcadores) se extiendan radialmente según los valores del eje `x`.

 # Grafico-2
millas %>%  filter(traccion == "4" & anio == 2008 & combustible == "p") %>% ggplot() + 
  aes(x = fabricante, fill = clase) + 
  geom_bar() +
  coord_polar()

 #  Cuando el argumento es theta = "y", los valores del eje `y` se mapean a los ángulos en la proyección polar,
 #  lo que significa que la longitud de las barras (la distancia radial) se determina por los valores del eje `y`.

 # Gráfico-3
millas %>%  filter(traccion == "4" & anio == 2008 & combustible == "p") %>% ggplot() + 
  aes(x = fabricante, fill = clase) + 
  geom_bar() +
  coord_polar(theta = "y")


 ### 2. ¿Qué hace `labs()`? Lee la documentación.

 #  La función labs() en el paquete ggplot2 se utiliza para establecer etiquetas y leyendas en un gráfico.
 #  Permite personalizar y añadir títulos a los ejes x e y, la leyenda de colores, el título del gráfico y 
 #  la leyenda general del gráfico. Es una forma conveniente de agregar metadatos descriptivos a un gráfico creado con ggplot2.

 #  En este ejemplo usaremos el codigo del Gráfico-1 

 # Gráfico-4
millas %>%  filter(traccion == "4" & anio == 2008 & combustible == "p") %>% ggplot() + 
  aes(x = fabricante, fill = clase) + geom_bar() +
  labs(title = "Distribución de clase de automóviles 
       por fabricante en 2008",                                   # Le agregamos un título adecuado
       x = "Fabricante del auto",                                 # Cambiamos el nombre del eje `x`
       y = "Número de autos",                                     # Cambiamos el nombre del eje `y`
       fill = "Tipo de auto",                                     # Cambiamos el nombre de la leyenda
       subtitle = "Estos autos solo tienen tracción en las 
       cuatro ruedas y combustible premium",                      # le agremos un subtítulo
       caption = "fuente: http://fueleconomy.gov")                # le agregamos la fuente de donde se han proporcionado los datos


 # `labs()` no es la única función para agregar títulos. `xlab()`, `ylab()` y `ggtitle()` realizan la misma función.


 ### 3. ¿Cuál es la diferencia entre `coord_quickmap()` y `coord_map()`?

 # `Coord_map` y `coord_quickmap` son dos funciones que permiten proyectar mapas en entornos de visualización en R, 
 # aunque difieren significativamente en términos de precisión y velocidad de cálculo.

 # La función coord_map ofrece una proyección precisa del mapa, aunque requiere un tiempo 
 # de computación considerable. Su objetivo es aproximar la proyección lo máximo posible 
 # para obtener representaciones cartográficas fieles a la realidad,
 # siendo útil para áreas extensas o cuando se necesita alta precisión espacial.

 # Coord_quickmap ofrece una aproximación rápida para preservar líneas rectas en la visualización 
 # del mapa, a diferencia de coord_map. Aunque menos precisa, coord_quickmap destaca por su velocidad 
 # y eficiencia computacional, siendo útil para representar áreas pequeñas cercanas al ecuador donde la 
 # preservación de líneas rectas es prioritaria sobre la precisión cartográfica.

 # Para este ejemplo vamos a usar el mapa del mundo
 # por defecto la proyección que usa es `Mercator`
mundo <- ggplot(map_data("world"),
       aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = 1)
mundo
  # Vamos a usar el paquete `tictoc`, lo cual nos permitirá saber el tiempo que demora en ejecutarse el código.

tic()
mundo + coord_map(xlim = c(-180, 180))  # Hemos modificado los límites del eje X debido a que la función produce
toc()                                   # unas líneas horizontales no deseadas

tic()
mundo + coord_quickmap()
toc()

 # Ejecutando los códigos podemos ver que cuando usamos la función `coord_quickmap` el tiempo de ejecución es menor
 # al tiempo de ejecución de la función `coord_map` pero las proporciones del mapa no son tan precisas.

 # A continuación usaremos direfentes tipos de proyección

 # Proyección Van der grinten
mundo + coord_map(projection = "vandergrinten",
                  xlim = c(-180, 180))

 # Proyección Ortográfica
mundo + coord_map(projection = "orthographic")

 # Proyección Ojo de pez
mundo + coord_map(projection = "fisheye", 
                  n = 4)   # Índice de refracción

 # Proyección Sinusoidal
mundo + coord_map(projection = "sinusoidal",
                  xlim = c(-180, 180))

 # Proyección Cilíndrica
mundo + coord_map(projection = "cylindrical",
                  xlim = c(-180, 180))
# Proyección Gall-Peters 
mundo + coord_map(projection = "gall",
                  parameters = 45,
                  xlim = c(-180, 180))

 # podemos ver los diferentes tipos de proyecciones que hay desde el siguiente código.
 ?mapproj::mapproject


 # Usaremos el mapa de Italia para dar un ejemplo con la funcion `coord_quickmap`
italia <- map_data("italy") %>% ggplot() + aes(x = long, y = lat, group = group) +
  geom_polygon(fill = "white", color = "black")
italia
  
 # Arreglaremos las proporciones usando la funcion `coord_quickmap`
 
 italia + coord_quickmap(expand = TRUE) # Si es FALSO, los límites se toman exactamente de los datos o de xlim/ylim.
  
 # En resumen, la elección entre coord_map y coord_quickmap dependerá de las necesidades 
 # específicas del usuario en cuanto a precisión, velocidad y escala de representación 
 # del mapa en el entorno de visualización de R.
  

 ### 4. ¿Qué te dice la gráfica siguiente sobre la relación entre la ciudad y la `autopista`? 
  
  ggplot(data = millas, mapping = aes(x = ciudad, y = autopista)) +
    geom_point()
  
  # Ya que la mayoría de los datos están por encima de esta línea, significa que la mayoría de los autos 
  # tienen un mejor rendimiento en autopista en comparación con su rendimiento en ciudad, gastan menos
  # combustible en la autopista por milla recorrida 
  
 ### ¿Por qué es `coord_fixed` importante? ¿Qué hace `geom_abline`?
  
  # `coord_fixed` se utiliza para garantizar que la relación entre las unidades
  # en ambos ejes sea igual en un gráfico, lo que significa que una unidad en el eje x es igual a
  # una unidad en el eje y en términos de la apariencia visual del gráfico. Es útil cuando se necesitan
  # gráficos con una escala igual en ambos ejes, como en gráficos de dispersión donde las unidades en
  # ambos ejes deben ser proporcionales entre sí.
  
  # `geom_abline` se utiliza para trazar líneas diagonales (líneas de regresión) en un gráfico. 
  # Es útil para visualizar relaciones lineales entre variables en un gráfico de dispersión o para agregar 
  # líneas de regresión a otros tipos de gráficos para resaltar tendencias o patrones en los datos.
  
  ggplot(data = millas, mapping = aes(x = ciudad, y = autopista)) +
    geom_point() +
    geom_abline()
  
  # Si solo usamos la función `geom_abline` en el gráfico traza una linea diagonal pero las proporciones 
  # estan mal ajustadas, podemos interpretar erróneamente el gráfico.
  
  ggplot(data = millas, mapping = aes(x = ciudad, y = autopista)) +
    geom_point() +
    geom_abline() +
    coord_fixed()
  
  # Ahora al agregar la función `coord_fixed` aseguramos que la línea que genera `geom_abline` 
  # tenga un ángulo de 45 grados.
  # Esto facilita la comparación cuando los rendimientos en autopista y ciudad son iguales.

  # Podemos usar el paquete `plotly` para tener un gráfico mas interactivo.
  ggplot(data = millas, mapping = aes(x = ciudad, 
                                      y = autopista,
                                      color = fabricante)) + # Para saber el fabricante del auto
    geom_point() +
    geom_abline() +
    coord_fixed()
  ggplotly()
 
  # Ahora podemos ver la información de cada punto como por ejemplo cual es la 
  # cantidad de millas recorridas en autopista, en ciudad y cual es su fabricante.
  
  







