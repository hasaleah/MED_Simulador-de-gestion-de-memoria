# Simulador de Gestión de Memoria (MMU)

### Proyecto Integrador: Unidad 1  
Materia: Manejo y estructura de base de datos  
Alumna: Catherine Andrea Argumedo Barahona

## Descripción General
Simulador de una Unidad de Administración de Memoria (MMU) implementado en pseudocódigo PSeInt, el sistema modela una RAM física de 16 KB dividida en
4 marcos de 4 KB, con soporte para traducción de direcciones lógicas a físicas y dos algoritmos de reemplazo de páginas: FIFO y Óptimo (OPT).


## Especificaciones del Sistema

| Componente         | Valor                  |
|--------------------|------------------------|
| RAM física         | 16 KB                  |
| Tamaño de marco    | 4 KB                   |
| Marcos físicos     | 4 (M1..M4)             |
| Memoria Swap       | 32 KB                  |
| Marcos de usuario  | 3 (para la simulación) |
| Páginas lógicas    | 5 (P1..P5)             |

---


## ✿ Fase 1: Estructuras y mapa de bits

Se definen dos arreglos paralelos `MarcoOcupado[]` y `MarcoPagina[]` para representar la RAM física, el mapa de bits imprime `0` (libre) o `1` (ocupado)
por cada marco tras cada operación.

**Salida esperada:**
```
Estado inicial:
Mapa de bits (M1..M4): 0 0 0 0
Página 1 asignada al marco 1
Página 2 asignada al marco 2
Página 3 asignada al marco 3
Mapa de bits (M1..M4): 1 1 1 0
Marco 2 liberado
Mapa de bits (M1..M4): 1 0 1 0
```


## ✿ Fase 2: MMU y traducción de direcciones

La función `TraducirDireccion(paginaLogica, offset, ...)` consulta la tabla de páginas y calcula:

```
dirFisica = (marco × 4096) + offset
```

Si la página no está en RAM (`Presente[p] = 0`), retorna `-1` indicando
**fallo de página**.

**Salida esperada:**
```
Prueba 1 (Página en memoria):
Dirección física: 8292       ← (marco 2 × 4096) + 100

Prueba 2 (Fallo de página):
Resultado: -1
```


## ✿ Fase 3: Algoritmos de reemplazo

**Cadena de referencias:** `[1, 2, 3, 4, 1, 2, 5, 1, 2, 3, 4, 5]`  
**Marcos disponibles:** 3

### FIFO (First In, First Out)
✿ Expulsa la página que entró primero a la RAM usando un puntero circular  
✿ No considera si la página será usada pronto; solo el orden de llegada  

### OPT (Óptimo)
✿ Expulsa la página cuyo **próximo uso está más lejos** en la cadena futura  
✿ Garantiza el mínimo teórico de fallos posible

**Salida esperada:**
```
Fallos de página FIFO: 9
Fallos de página OPT:  7
```
---

## Análisis de resultados

| t  | Ref | Marco 1 | Marco 2 | Marco 3 | FIFO ¿Fallo? | OPT ¿Fallo? | Nota OPT                       |
|----|-----|---------|---------|---------|--------------|-------------|-------------------------------------------|
| 1  | P1  | P1      | —       | —       | Fallo        | Fallo       | Marco libre                               |
| 2  | P2  | P1      | P2      | —       | Fallo        | Fallo       | Marco libre                               |
| 3  | P3  | P1      | P2      | P3      | Fallo        | Fallo       | Marco libre                               |
| 4  | P4  | P4      | P2      | P3      | Fallo        | Fallo       | FIFO expulsa P1 (ptr=1) / OPT expulsa P3 (próximo uso más lejano) |
| 5  | P1  | P4      | P1      | P3      | Fallo        | Hit         | FIFO expulsa P2 (ptr=2) / OPT: P1 ya está |
| 6  | P2  | P4      | P1      | P2      | Fallo        | Hit         | FIFO expulsa P3 (ptr=3) / OPT: P2 ya está |
| 7  | P5  | P5      | P1      | P2      | Fallo        | Fallo       | FIFO expulsa P4 (ptr=1) / OPT expulsa P4 (no se usa hasta t=11) |
| 8  | P1  | P5      | P1      | P2      | Hit          | Hit         | P1 en marco 2                             |
| 9  | P2  | P5      | P1      | P2      | Hit          | Hit         | P2 en marco 3                             |
| 10 | P3  | P5      | P3      | P2      | Fallo        | Fallo       | FIFO expulsa P1 (ptr=2) / OPT expulsa P1 (ya no aparece más) |
| 11 | P4  | P5      | P3      | P4      | Fallo        | Fallo       | FIFO expulsa P2 (ptr=3) / OPT expulsa P2 (ya no aparece más) |
| 12 | P5  | P5      | P3      | P4      | Hit          | Hit         | P5 en marco 1                             |

| Algoritmo  | Fallos de Página |
|------------|-----------------|
| FIFO       | 9               |
| OPT        | 7               |
| Diferencia | 2 menos con OPT |

---
### ¿Por qué OPT tiene mejor rendimiento?

OPT logra 2 fallos menos porque en cada reemplazo elige expulsar la página
que **no se necesitará en el futuro inmediato**, evitando traer de vuelta
al poco tiempo una página recién expulsada. FIFO, en cambio, puede expulsar
una página que se usará en el siguiente acceso simplemente porque fue la
primera en entrar.

Matemáticamente, OPT es el **límite inferior teórico**: ningún otro algoritmo
puede producir menos fallos de página para una cadena dada con un número fijo
de marcos.

### ¿Por qué OPT no se usa en sistemas reales?

OPT requiere **conocer de antemano** toda la secuencia futura de referencias
a páginas. En un sistema operativo real esto es imposible, ya que los accesos
a memoria dependen de la ejecución dinámica del programa y de la interacción
del usuario. OPT solo es viable en simulaciones donde la cadena de referencias
se conoce completamente desde el inicio, como en este proyecto.

En la práctica, los sistemas operativos usan aproximaciones como **LRU**
(Least Recently Used), que asume que lo usado recientemente volverá a usarse
pronto, obteniendo resultados cercanos a OPT sin necesitar información futura.
