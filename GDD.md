# GDD — Cryptid Café

> **Documento vivo.** Este archivo es la fuente única de verdad del diseño. Cada cambio importante que hagamos en el juego debe actualizar la sección correspondiente y añadir una fila al [Registro de cambios](#17-registro-de-cambios).

| Campo | Valor |
|---|---|
| **Título de trabajo** | Cryptid Café |
| **Nombre interno** | Café de Críptidos |
| **Versión del documento** | 0.3 |
| **Fecha** | 22 de octubre de 2026 |
| **Estado** | MVP implementado (prototipo jugable) |
| **Plataforma** | Roblox (móvil primero, PC y consola) |
| **Motor** | Roblox Studio + Rojo 7.7.1 + Luau |
| **Repositorio** | <https://github.com/carlos00012/mi-juego> |
| **Responsable** | carlos00012 |
| **Idioma del juego** | Inglés para el lanzamiento; español como localización posterior |

---

## 0. Cómo se usa este documento

- **Una sola fuente de verdad.** Si una decisión no está aquí, no existe.
- **Estados:** `Idea` → `Diseño` → `Prototipo` → `Implementado` → `Live`.
- **Cambios:** cada sistema implementado se marca con su estado y se añade al registro de cambios.
- **Nombres:** los nombres de cara al jugador van en inglés (`Cryptid Café`, `Mothman`); las notas internas van en español.
- **Regla de oro:** si una función no puede explicarse en una frase y no alimenta uno de los pilares, se recorta.

---

## 1. Resumen ejecutivo

**Cryptid Café** es un tycoon de cafetería con colección de criaturas y un misterio narrativo. Heredas *The Lantern*, un café abandonado en el pueblo de Mistwood, donde cada noche llegan críptidos —Mothman, Bigfoot, el Monstruo de Flatwoods— a pedir algo de comer. Sirve, amplía el local, decora, descubre sus historias y averigua por qué alguien está borrando a los críptidos de la memoria del pueblo.

**Frase de venta:** *The last café before the veil.* / *El último café antes del velo.*

**Género:** tycoon de servicio + colección + narrativa cozy-spooky.

**Sesión objetivo:** 15–25 minutos, 3–5 veces por semana.

**Público:** 9–16 años como núcleo, con gancho para jugadores de 16+ que disfrutan juegos cozy y de colección.

**Monetización:** cosméticos, temas de café y calidad de vida. Sin loot boxes, sin ventajas de poder, sin pay-to-win.

### Propuesta única

| Juego existente | Lo que tomamos | Lo que hacemos distinto |
|---|---|---|
| Restaurant Tycoon 3 | Servicio, cocina, progresión de local | Los clientes son críptidos con historias y peticiones especiales |
| Pet Store Tycoon | Colección de criaturas | La colección se gana sirviéndolas, no comprándolas |
| Theme Park Tycoon 2 | Construcción y creatividad | Construcción con impacto directo en el servicio y la ambientación |
| Lumber Tycoon 2 | Exploración y maestría | Misterio por capítulos y biomas que se abren con prestigio |

**Diferencial:** no es “otro restaurante” ni “otro simulador de mascotas”. Es un café narrativo donde la colección, la construcción y el misterio comparten el mismo bucle.

---

## 2. Pilares de diseño

| Pilar | Qué significa | Prueba de diseño |
|---|---|---|
| **Un café lleno de historias** | Cada críptido es un personaje, no una skin | ¿El jugador puede contar algo de este críptido después de servirlo? |
| **Construye tu refugio** | El layout y la decoración importan | ¿Dos cafés con las mismas mejoras se juegan distinto? |
| **La noche cambia las reglas** | Preparar de día, servir de noche, eventos | ¿La noche se siente distinta de la preparación? |
| **Siempre hay algo que recordar** | Códice, variantes, capítulos, eventos | ¿Siempre hay un objetivo a 1 sesión y otro a 1 semana? |
| **Comparte la mesa** | Visitas, regalos, Night Rush cooperativo | ¿Jugar con un amigo mejora el bucle, no solo lo duplica? |

---

## 3. Investigación de mercado

### 3.1 Referencias principales (octubre 2026)

| Juego | Jugadores concurrentes | Visitas | Lección |
|---|---:|---:|---|
| Restaurant Tycoon 3 | ~8.500 | 382 M | Servicio + cocina + farming; el bucle activo importa |
| Pet Store Tycoon | ~8.500 | 15 M | La colección de criaturas engancha desde el minuto uno |
| Theme Park Tycoon 2 | ~3.200 | 1.600 M | La creatividad y la construcción dan años de vida |
| Lumber Tycoon 2 | ~2.700 | 1.300 M | Exploración, maestría y economía profunda |
| Car Dealership Tycoon | ~2.200 | 2.500 M | Coleccionar + competir + eventos |
| Restaurant Tycoon 2 | — | 1.600 M | Progresión clara y capas sociales |

*Datos de rblxdb y RobloxGo, octubre de 2026. Son instantáneas, no promedios.*

### 3.2 Qué funciona en el género

1. **El tema es el producto.** Un tycoon genérico compite por precio; uno temático compite por fantasía.
2. **La construcción debe desbloquear mecánicas, no solo multiplicadores.** Cada compra tiene que cambiar cómo se juega.
3. **El final del build no puede ser el final del juego.** Hace falta prestigio, colección o competencia.
4. **La colección es retención.** Coches, mascotas, animales o cartas dan un objetivo a largo plazo.
5. **Lo social multiplica.** Visitar cafés, regalar duplicados y jugar en cooperativo retiene más que un leaderboard solo.
6. **Actualizar seguido.** Contenido pequeño cada 2–4 semanas; contenido grande cada 2–3 meses.

### 3.3 El hueco que ocupamos

Los tycoons de servicio son profundos pero genéricos. Los juegos de colección tienen criaturas pero poca gestión. **Cryptid Café** une las dos cosas con una capa narrativa que no existe en el género:

- Colección con historia, no solo rareza.
- Construcción con consecuencias reales en el servicio.
- Misterio por capítulos que da un “por qué” a largo plazo.
- Estética cozy-spooky reconocible y muy compartible.

---

## 4. Público objetivo

| Segmento | Edad | Motivación | Qué le damos |
|---|---:|---|---|
| **Constructor cozy** | 9–14 | Crear y decorar | Build mode, temas, visitas |
| **Coleccionista** | 10–16 | Completar el códice | 30+ críptidos, variantes, logros |
| **Social** | 10–16 | Jugar con amigos | Night Rush, regalos, leaderboards |
| **Optimizador** | 13–18 | Mejorar números | Layout, economía, prestigio |
| **Narrativo** | 12–18 | Descubrir el misterio | Capítulos, pistas, personajes |

**Dispositivo principal:** móvil. La UI debe funcionar con una mano y con texto grande. PC y consola son secundarios pero compatibles.

**Seguridad:** sin chat libre fuera de Roblox, sin sangre ni terror explícito, sin mecánicas de presión temporal agresivas.

---

## 5. Fantasía y narrativa

### 5.1 Premisa

Mistwood es un pueblo al borde del **Velo**, la frontera entre nuestro mundo y el de las criaturas que la gente prefiere olvidar. Tu tía **Mabel** desapareció hace un año. Te dejó *The Lantern*, un café que solo abre de noche, y una nota: *“Si vuelven, dales de comer. Si preguntan por mí, no les mientas.”*

Cada noche, los críptidos llegan. Algunos buscan su plato favorito; otros, una memoria perdida. Cada 30 noches aparece el **Hollow Guest**, un cliente sin rostro que paga con recuerdos. Servirle revela un fragmento de lo que pasó con Mabel y con el **Hollow Moon**, un eclipse que está borrando a los críptidos del mundo.

### 5.2 Tono

- **Cozy-spooky:** misterio y niebla, pero cálido y divertido. Nada de gore.
- **Humor:** los críptidos son celebridades locales con problemas mundanos.
- **Emoción:** cada capítulo cierra con una revelación pequeña, no con un cliffhanger cruel.
- **Referencias:** Studio Ghibli, Gravity Falls, Over the Garden Wall, juegos cozy de gestión.

### 5.3 Capítulos

| Capítulo | Bioma | Tema | Criptído jefe | Estado |
|---|---|---|---|---|
| 1. The Lantern | Mistwood | Abrir el café y conocer a los habituales | Mothman | Diseño |
| 2. The Hollow Marsh | Hollow Marsh | La niebla borra recuerdos | Nessie | Idea |
| 3. Ember Mesa | Ember Mesa | El calor despierta al Hollow Moon | Jersey Devil | Idea |
| 4. Frostpeak | Frostpeak | El último refugio antes del eclipse | Yeti | Idea |
| 5. The Hollow Moon | The Hollow Moon | Enfrentar al Hollow Guest | Hollow Guest | Idea |

### 5.4 Cómo se cuenta

- **Códice:** cada críptido tiene ficha, lore, plato favorito y una nota de Mabel.
- **Diálogos cortos:** 1–3 líneas por cliente; nunca bloquean el servicio.
- **Objetos del café:** notas, fotos y recuerdos que se desbloquean al decorar.
- **Misiones de historia:** 20 en el lanzamiento; avanzan al cumplir objetivos normales.
- **Sin cinemáticas largas:** máximo 20 segundos; el resto es ambiental.

---

## 6. Bucles de juego

### 6.1 Bucle central

```
PREPARAR (día)
  ├─ Recoger ingredientes del jardín
  ├─ Cocinar y stockear
  ├─ Elegir menú y especial del día
  └─ Asignar personal
        ↓
SERVIR (noche)
  ├─ Recibir y sentar críptidos
  ├─ Tomar pedidos
  ├─ Cocinar y servir
  ├─ Limpiar y reponer
  └─ Gestionar eventos
        ↓
RECOMPENSAR
  ├─ Ecto (dinero)
  ├─ Sightings (colección)
  ├─ Reputación
  └─ Cebos raros
        ↓
MEJORAR / COLECCIONAR
  ├─ Estaciones y decoración
  ├─ Nuevas recetas
  ├─ Nuevos críptidos
  └─ Prestigio
        ↓
      repetir
```

### 6.2 Bucle de sesión (15–25 min)

1. **0:00–1:00** — Reclamar *Night Shift* (ingresos offline) y ver misiones diarias.
2. **1:00–3:00** — Preparar menú, stock y personal.
3. **3:00–10:00** — Servir una noche (o dos si hay Rush Night).
4. **10:00–15:00** — Gastar Ecto en 1–2 mejoras; revisar el códice.
5. **15:00–20:00** — Perseguir un objetivo concreto: un críptido raro, una variante o una misión.
6. **20:00+** — Salir; el café sigue produciendo hasta 8 horas.

### 6.3 Bucle a largo plazo

```
Capítulo → Bioma → Prestigio → Códice → Evento estacional → Social → repetir
```

- **Semana 1:** tutorial, primer críptido, primer prestigio.
- **Semana 2–4:** completar Mistwood, desbloquear variantes, primer evento.
- **Mes 2–3:** segundo bioma, prestigio 2–3, colección 50%.
- **Mes 4–6:** biomas 3–4, eventos, leaderboards, cooperativo.
- **Largo plazo:** códice completo, prestigio 10, cosméticos, récords.

### 6.4 Primeros 10 minutos (onboarding)

| Minuto | Evento | Objetivo |
|---|---|---|
| 0:00 | Llegas a *The Lantern* | Narrativa breve, sin menús |
| 0:30 | Conoces a Bigfoot | Primer cliente guiado |
| 1:00 | Sirves tu primer plato | Recompensa inmediata |
| 2:00 | Compras la primera mejora | Entiendes el gasto |
| 3:00 | Abres la primera noche | Ves el bucle completo |
| 5:00 | Descubres a Mothman | Primer “wow” de colección |
| 7:00 | Recibes una misión diaria | Razón para volver |
| 10:00 | Se guarda y se muestra el próximo objetivo | Gancho a la siguiente sesión |

**Regla:** el primer críptido se descubre antes del minuto 5. La primera mejora, antes del minuto 2.

---

## 7. Sistemas de juego

### 7.1 Cafetería y construcción

**Propósito:** que el café sea una expresión del jugador y que el layout afecte al servicio.

- **Parcela:** cada jugador tiene una parcela en un pueblo compartido de hasta 6 jugadores. La parcela se instancia al entrar y se libera al salir.
- **Rejilla:** 4 studs. Paredes, suelos, puertas y ventanas se colocan en la rejilla; los props se colocan libremente con rotación de 15°.
- **Zonas:** comedor, cocina, jardín, laboratorio, escaparate. Cada zona desbloquea mejoras.
- **Métricas del café:**
  - **Asientos:** capacidad simultánea.
  - **Flujo:** distancia media entre puerta, asientos y cocina.
  - **Ambiente:** decoración, luz y música.
  - **Menú:** variedad y calidad de platos.
- **Build mode:** activar/desactivar, seleccionar, mover, rotar, vender, deshacer. Guardado automático.
- **Layouts:** 3 presets guardados (`Cozy`, `Fast`, `Showcase`).
- **Límites:** 250 parts por parcela en el lanzamiento; se sube con mejoras.

### 7.2 Clientes críptidos

**Propósito:** el corazón del bucle activo.

- **Estados:** `Arrive → Queue → Seat → Order → Wait → Eat → Pay → Leave`.
- **Paciencia:** 45–90 segundos según rareza y tipo de cliente.
- **Satisfacción (1–5):** tiempo de espera, plato favorito, ambiente y limpieza.
- **Propina:** multiplicador por satisfacción y rapidez; el plato favorito da +50%.
- **Peticiones especiales:** Mothman pide luces bajas; Fresno Nightcrawler pide una mesa junto a la ventana; Chupacabra pide que no haya plantas cerca.
- **Rareza:** común, poco común, raro, legendario, mítico. A más rareza, más Ecto, Sightings y probabilidad de variante.
- **Salida:** si la paciencia llega a 0, se va; pierdes propina y reputación, pero no la partida.
- **Sin colisiones físicas entre clientes:** usan waypoints y evitan atascos.

### 7.3 Cocina y recetas

**Propósito:** dar habilidad y ritmo al servicio.

- **Estaciones:** preparación, estufa, horno, cafetera, nevera, fregadero.
- **Receta:** 1–3 pasos; cada paso tarda 2–6 segundos; el jugador puede ayudar o dejar al personal.
- **Calidad:** `Perfect` (ventana de 0.4 s), `Good`, `Burnt`. La calidad multiplica el pago.
- **Menú:** 4 platos al inicio, hasta 8 con mejoras; 1 especial diario que rota.
- **Ingredientes:** jardín (hierbas, bayas, setas, flores lunares) + proveedor. Stock limitado por noche.
- **Sin fallo permanente:** quemar un plato cuesta tiempo, no la noche.

### 7.4 Economía

**Monedas:**

| Moneda | Tipo | Fuente | Uso |
|---|---|---|---|
| **Ecto (Ɛ)** | Blanda | Pedidos, propinas, misiones, offline | Mejoras, ingredientes, decoración, personal |
| **Sightings** | XP de colección | Descubrir/servir críptidos | Nivel de códice, recompensas |
| **Moon Tokens** | Evento | Eventos estacionales | Cosméticos limitados |
| **Robux** | Premium | Compra | Cosméticos y QoL |

**Fuentes y sumideros:**

| Fuente | % aproximado | Sumidero | % aproximado |
|---|---:|---|---:|
| Pedidos | 60% | Mejoras | 55% |
| Propinas | 15% | Ingredientes/stock | 20% |
| Misiones | 10% | Decoración | 15% |
| Offline | 10% | Personal | 8% |
| Logros/eventos | 5% | Prestigio | 2% |

**Fórmulas base (tunables):**

```lua
orderPayout = dish.Value
    * qualityMultiplier      -- 0.8 a 1.3
    * ambienceMultiplier     -- 0.9 a 1.4
    * staffMultiplier        -- 1.0 a 1.25
    * prestigeMultiplier     -- 1 + 0.2 * (prestige - 1)
    * eventMultiplier        -- 1.0 a 2.0

tip = dish.Value * 0.15 * patienceFactor * favoriteBonus
patienceFactor = math.clamp(remainingPatience / totalPatience, 0, 1)
favoriteBonus = isFavorite and 1.5 or 1.0

upgradeCost = baseCost * 1.8 ^ tier
prestigeCost = 100_000 * 3 ^ prestige
offlineEarnings = floor(avgIncomePerMinute * hoursAway * 0.4)
```

**Reglas anti-inflación:**
- Los ingresos crecen más lento que los costes.
- Cada bioma añade un sumidero nuevo (tema, personal, ingrediente).
- El offline está limitado a 8 h y al 40% del ingreso activo.
- No hay “imprimir dinero” sin coste de tiempo o espacio.

### 7.5 Progresión

| Sistema | Escala | Qué desbloquea |
|---|---|---|
| **Nivel de café** | 1–30 | Estaciones, menú, zonas |
| **Reputación** | 1–5 estrellas | Clientes raros, eventos, descuentos |
| **Capítulo** | 1–5 | Biomas, historia, jefes |
| **Prestigio (Legend)** | 1–10 | Multiplicador permanente, temas, títulos |
| **Códice** | 30+ críptidos | Variantes, lore, cosméticos |
| **Logros** | 50 | Títulos, Ecto, decoración |

**Curva de nivel:** `xpNeeded(level) = floor(100 * level ^ 1.5)`. El nivel 30 se alcanza en 20–30 h de juego activo.

### 7.6 Códice

- **Ficha:** retrato, rareza, bioma, plato favorito, frase, lore, variantes.
- **Descubrimiento:** servir al críptido por primera vez; las variantes se descubren al verlas o fotografiarlas.
- **Variantes:** Normal, Shiny (5%), Shadow (evento), Golden (prestigio).
- **Recompensas:** cada 25% del códice da un cosmético; el 100% da un título y un tema de café.
- **Duplicados:** dan *Fragments* para subir el nivel de la ficha y mejorar su propina.
- **Foto:** modo cámara opcional; una foto de un críptido raro da Sightings extra.

### 7.7 Misterio

- **Pistas:** se obtienen al servir al Hollow Guest, decorar con objetos concretos y completar capítulos.
- **Tablero de recuerdos:** UI con hilos, fotos y notas; se completa por capítulos.
- **Sin castigo:** el misterio avanza con el juego normal; no hay “pérdida” de progreso.
- **Revelación final:** el Hollow Guest es una versión olvidada de Mabel; el jugador elige entre recordarla o dejar que descanse. Dos finales, mismo contenido, distinto epílogo.

### 7.8 Prestigio (Legend)

- **Cuándo:** al completar la historia de Mistwood (capítulo 1) y tener 100.000 Ɛ. Cada bioma posterior añade un nivel de prestigio.
- **Qué resetea:** Ecto, nivel de café, mejoras, stock y personal.
- **Qué conserva:** códice, cosméticos, logros, historia y títulos.
- **Qué da:** `+20%` de ingresos por nivel, un tema de café y una variante Golden.
- **Coste:** `100.000 * 3 ^ prestige`; máximo 10.
- **Leaderboard:** Ecto semanal y Legend total.
- **Filosofía:** cada prestigio debe ser más rápido y abrir una forma nueva de jugar, no solo un multiplicador.

### 7.9 Misiones

| Tipo | Frecuencia | Ejemplos | Recompensa |
|---|---|---|---|
| **Diarias** | 3/día | Servir 10 críptidos; 5 platos perfectos; comprar 1 mejora | Ecto, cebo, Sightings |
| **Semanales** | 5/semana | Descubrir 1 raro; completar 3 noches; visitar 1 café | Cosmético, Moon Tokens |
| **Historia** | 20 en 1.0 | “Sirve a Mothman”, “Encuentra la nota de Mabel” | Capítulo, receta, tema |
| **Logros** | 50 | “Sirve 100 platos perfectos” | Título, decoración |

**Racha:** 7 días con recompensa creciente; el día 7 da un cosmético. Un día perdido no rompe la racha si se usa un “streak freeze” ganado en misiones.

### 7.10 Social

- **Visitas:** portal en el pueblo para visitar la parcela de un amigo; puedes comprar una consumición y dejar una propina.
- **Regalos:** 1 duplicado de códice al día; fomenta la colección sin crear una economía de trading.
- **Night Rush:** 2–4 jugadores sirven una noche en el café del anfitrión; recompensas compartidas y un cosmético semanal.
- **Leaderboards:** amigos, servidor y global; categorías Ecto semanal, códice y Legend.
- **Café Showcase:** votación semanal de decoración; el ganador recibe un adorno exclusivo.
- **Chat seguro:** emotes y frases predefinidas; sin chat libre fuera del chat de Roblox.

### 7.11 Eventos

| Evento | Frecuencia | Regla | Recompensa |
|---|---|---|---|
| **Fog Night** | Semanal | +25% aparición de raros, menos visibilidad | Cebo raro |
| **Meteor Shower** | Semanal | Recetas cósmicas, +50% raros | Ingrediente lunar |
| **Power Outage** | Semanal | Usa faroles; propinas +30% | Cosmético de luz |
| **Rush Night** | Semanal | Doble de clientes, 1.5× Ecto | Ecto, Sightings |
| **Hollow Moon Festival** | Octubre | Críptidos de sombra, tablero de recuerdos | Tema, variante Shadow |
| **Frostbite Feast** | Diciembre | Clientes de hielo, bebidas calientes | Tema, cosmético |
| **Bloom Rush** | Abril | Cosechas dobles, críptidos florales | Tema, variante Shiny |
| **Solar Eclipse** | Junio | Evento cósmico, jefe especial | Título, tema |

**Regla:** los eventos no deben castigar al que se los pierde. El contenido limitado vuelve al año siguiente o se puede comprar con Moon Tokens.

### 7.12 Monetización

**Principios:**
- El juego completo se puede disfrutar gratis.
- Solo se vende **cosmético, tema o calidad de vida**.
- Sin loot boxes, sin monedas premium ocultas, sin presión de tiempo.
- Precios claros y visibles antes de comprar.

| Producto | Tipo | Precio | Qué da |
|---|---|---|---|
| 2× Ecto | Game Pass | 299 R$ | Multiplicador permanente de Ecto |
| Decor+ | Game Pass | 199 R$ | +50 espacios de decoración |
| Night Shift +4h | Game Pass | 149 R$ | Offline hasta 12 h |
| VIP Café Theme | Game Pass | 399 R$ | Tema visual y música |
| Supporter Pack | Game Pass | 499 R$ | Título, delantal y farol |
| Seasonal Journal | Premium track | 399 R$ | Cosméticos de temporada |
| Cosmetic bundles | Dev Product | 99–299 R$ | Temas, sombreros, adornos |

**Métricas de monetización:** conversión 2–4%, sin dependencia de “ballenas”. Si el jugador gratis no puede competir en el leaderboard, el diseño está mal.

---

## 8. Contenido

### 8.1 Alcance por versión

| Versión | Biomas | Críptidos | Recetas | Mejoras | Historia | Estado |
|---|---:|---:|---:|---:|---:|---|
| **MVP** | 1 | 3 | 6 | 6 | 0 (post-MVP) | Implementado (prototipo) |
| **1.0** | 1 | 8 | 16 | 18 | 20 misiones | Diseño |
| **1.1** | 2 | 14 | 24 | 24 | 30 misiones | Idea |
| **1.2** | 3 | 20 | 32 | 30 | 40 misiones | Idea |
| **2.0** | 5 | 30+ | 48+ | 40+ | Endgame | Idea |

### 8.2 Biomas

| Bioma | Estética | Mecánica | Estado |
|---|---|---|---|
| **Mistwood** | Bosque húmedo, faroles, musgo, lluvia suave | Base del juego; clientes habituales | Diseño |
| **Hollow Marsh** | Pantano, niebla, luciérnagas, café-barco | La niebla reduce la visibilidad; faroles guían | Idea |
| **Ember Mesa** | Desierto al atardecer, cristales, tren | El calor acelera el deterioro; sombra importa | Idea |
| **Frostpeak** | Nieve, aurora, hielo | Bebidas calientes; clientes se congelan si esperan | Idea |
| **The Hollow Moon** | Surrealista, recuerdos, eclipse | Endgame narrativo | Idea |

### 8.3 Críptidos del lanzamiento

| # | Criptído | Rareza | Plato favorito | Gancho |
|---:|---|---|---|---|
| 1 | **Bigfoot** | Común | Forest Floor Pancakes | El habitual tranquilo; tutorial |
| 2 | **Jackalope** | Poco común | Carrot Cloud Cake | Competitivo y presumido |
| 3 | **Chupacabra** | Poco común | Berry Beast Smoothie | Vegetariano incomprendido |
| 4 | **Mothman** | Raro | Luna Latte | Mensajero del Hollow Moon |
| 5 | **Fresno Nightcrawler** | Raro | Pajama Pasta | Solo aparece de noche; pide ventana |
| 6 | **Flatwoods Monster** | Raro | Cosmic Cocoa | Alienígena melancólico |
| 7 | **Hodag** | Poco común | Log Roll Cake | Leñador gruñón con corazón |
| 8 | **Loveland Frogman** | Poco común | Swamp Soda | Exestrella de cine B |

**Actualización 1.1:** Nessie, Jersey Devil, Kitsune, Yeti, Hollow Guest.

### 8.4 Recetas del lanzamiento

Luna Latte · Forest Floor Pancakes · Carrot Cloud Cake · Berry Beast Smoothie · Pajama Pasta · Cosmic Cocoa · Log Roll Cake · Swamp Soda · Moss Matcha · Mushroom Melt · Firefly Fizz · Acorn Affogato · Moon Pie · Bramble Tart · Lantern Lemonade · Midnight Mocha.

Cada receta tiene: nombre, ingredientes, estación, tiempo, valor base, calidad y un críptido que la adora.

### 8.5 Mejoras del lanzamiento (18)

| Categoría | Mejoras |
|---|---|
| **Cocina** | Estufa II, Horno, Cafetera, Mesa de preparación, Nevera, Fregadero |
| **Comedor** | Mesas, Reservados, Barra, Faroles, Música, Decoración |
| **Jardín** | Jardineras, Tronco de setas, Arbusto de bayas |
| **Laboratorio** | Mezclador de cebos, Analizador, Telescopio |

Cada una tiene 3 niveles en 1.0 y 5 a largo plazo. Los efectos son legibles: `+1 asiento`, `−15% tiempo`, `+10% propina`, `+1 receta`.

### 8.6 Alcance real del MVP implementado (v0.3)

| Sistema | Implementación actual |
|---|---|
| **Parcelas** | 6 parcelas fijas; 1 cafetería por jugador; el jugador es teletransportado a su parcela |
| **Cafetería** | Preconstruida por código; sin modo construcción en el MVP |
| **Estaciones** | 3: `Stove`, `Prep` y `Coffee`; cada una con `ProximityPrompt` |
| **Recetas** | 6: Luna Latte, Forest Floor Pancakes, Carrot Cloud Cake, Berry Beast Smoothie, Cosmic Cocoa y Mushroom Melt |
| **Críptidos** | 3: Bigfoot, Jackalope y Mothman |
| **Mesas** | 3 base + hasta 3 extra con la mejora `extra_table` |
| **Mejoras** | 6: `extra_table`, `better_stove`, `premium_beans`, `cozy_lanterns`, `menu_board`, `flyer_campaign` |
| **Bucle** | El jugador cocina, recoge el plato, lo lleva a la mesa y lo sirve; el cliente paga, deja propina y se va |
| **Clientes** | Modelo de partes sin `Humanoid`; `Root` anclado y resto de partes con `WeldConstraint` |
| **Guardado** | DataStore con fallback a memoria si API Services no está disponible; autosave y guardado al salir |
| **UI** | Construida por código: HUD, tienda, códice y avisos; sin assets externos todavía |
| **Autoridad** | Toda la lógica económica y de pedidos vive en el servidor; el cliente solo envía intención de compra |
| **Interacción** | `ProximityPrompt` para estaciones, platos y mesas |
| **Fuera del MVP** | Modo construcción, misiones, prestigio, social, eventos, analytics y monetización |

**Criterio de aceptación del MVP:** un jugador puede entrar, recibir su cafetería, cocinar una receta, servirla a un críptido, cobrar Ecto y comprar una mejora sin errores de runtime.

---

## 9. Dirección de arte

**Estilo:** low-poly estilizado, formas gruesas, siluetas legibles, colores planos y luz cálida. Nada de realismo.

**Paleta:**

| Uso | Color |
|---|---|
| Noche | Azul verdoso profundo `#14243A` |
| Bosque | Verde musgo `#3E5C4A` |
| Madera | Ámbar `#B97842` |
| Luz | Ámbar cálido `#FFB45C` |
| Magia | Violeta `#8C6BD8` |
| Acento | Rosa salmón `#E88C7D` |

**Luz:** faroles y neón suave; niebla volumétrica ligera; fireflies; sombras suaves. Evitar escenas oscuras ilegibles en móvil.

**UI:** papel y madera, tipografía redondeada, iconos grandes, una mano. Colores con contraste AA.

**Audio:** jazz lo-fi + instrumentos acústicos; ambiente de noche (grillos, lluvia, campanas); SFX satisfactorios para servir, monedas y descubrimientos. Música reactiva: más intensa en Rush Night.

**Modelos:** ver sección 10.

---

## 10. Pipeline de modelos con Studio

### 10.1 Herramientas

| Herramienta | Uso |
|---|---|
| **Studio Modeler / Part tools** | Blockout, formas, props, críptidos |
| **Solid Modeling** | Union, Negate, Intersect, Separate para detalles |
| **Procedural Models** | Variantes y módulos parametrizados (`/generate_procedural_model`) |
| **Toolbox / Creator Store** | Props genéricos ya creados (mesas, sillas, lámparas, plantas) |
| **Pivot / Scale / Material** | Pivotes, escala y acabado |
| **Rojo** | Sincronizar `.rbxm` desde el repo a Studio |

### 10.2 Política de modelos prehechos de Studio

**Sí, se pueden usar.** Ahorran tiempo y permiten llegar al vertical slice sin modelar cada silla. Reglas:

1. **Prioridad:** props genéricos → Toolbox; críptidos y piezas de identidad → Modeler.
2. **Auditar siempre:** insertar, revisar scripts, eliminar cualquier `Script`/`LocalScript` ajeno, revisar `MeshPart`, texturas y colisiones.
3. **Licencia:** usar assets gratuitos con permiso claro; no usar assets de pago sin comprarlos; evitar modelos de autores desconocidos.
4. **Atribuir:** guardar `AssetSource`, `AssetAuthor` y `AssetLicense` como atributos del modelo y en `CREDITS.md`.
5. **Adaptar:** recolorear, escalar y simplificar para que encajen con la paleta y el presupuesto.
6. **No confiar en el rendimiento:** revisar parts/triángulos; un prop de Toolbox puede traer 500 parts.
7. **Nunca** insertar modelos con scripts en `ServerScriptService` o con remotes ocultos.

**Tabla de decisión:**

| Necesidad | Fuente | Ejemplo |
|---|---|---|
| Mesa, silla, lámpara, planta | Toolbox + retoque | `Prop_Table_Round_01` |
| Estufa, horno, cafetera | Toolbox + retoque | `Prop_Stove_01` |
| Criptído | Modeler custom | `Cryptid_Mothman_01` |
| Letrero, reloj lunar, frasco de recuerdos | Modeler custom | `Prop_LanternSign_01` |
| Variantes de color | Material/Color o Procedural | `Cryptid_Bigfoot_Shiny` |

### 10.3 Kit modular y dimensiones

**Rejilla:** 4 studs. **Altura de pared:** 12. **Grosor:** 1.

| Pieza | Dimensiones (studs) | Notas |
|---|---|---|
| Mostrador | 4 × 2 × 3 | Pivote en la base |
| Mesa redonda | 4 × 4 × 2.5 | 2–4 asientos |
| Silla | 2 × 2 × 3 | Se puede agrupar |
| Puerta | 4 × 1 × 7 | Marco incluido |
| Ventana | 4 × 1 × 4 | Cristal `Glass` |
| Estufa | 4 × 3 × 3 | 2 puntos de cocina |
| Cafetera | 2 × 2 × 3 | Emisiva |
| Jardinera | 4 × 2 × 1.5 | 4 plantas |
| Criptído | 4 × 4 × 6–8 | Hitbox simple |

**Presupuesto:**

| Tipo | Parts máx. | Triángulos máx. | Texturas |
|---|---:|---:|---|
| Prop pequeño | 40 | 2.000 | 512×512 o color plano |
| Prop grande | 80 | 4.000 | 512×512 |
| Criptído | 80 | 8.000 | 512×512 |
| Héroe (letrero/reloj) | 120 | 10.000 | 1024×1024 |

### 10.4 Proceso de un modelo custom

1. **Blockout** con Parts en Studio; proporciones y silueta primero.
2. **Solid Modeling** para unir, restar o intersectar; evitar uniones innecesarias.
3. **Detalles:** ojos, dientes, faroles, cristales; usar `Neon` con moderación.
4. **Pivote:** `PrimaryPart` en la base; `Pivot` al centro de masa.
5. **Colisiones:** `CanCollide` solo en superficies transitables; decoración pequeña con `CanQuery = false`.
6. **Nombres:** `Prop_<Categoría>_<Nombre>_<Variante>` o `Cryptid_<Nombre>_<Variante>`.
7. **Atributos:** `AssetSource`, `AssetAuthor`, `AssetLicense`, `AssetVersion`.
8. **Guardar** como `.rbxm` en `src/shared/Assets/Models/`.
9. **Probar** en Studio con Rojo y medir parts/triángulos.
10. **Registrar** en el GDD y en `CREDITS.md`.

### 10.5 Estructura de carpetas de modelos

```
src/shared/Assets/
├── Models/
│   ├── Kit/          # paredes, suelos, puertas, ventanas
│   ├── Props/        # mesas, sillas, estufas, decoración
│   ├── Cryptids/     # críptidos y variantes
│   └── Hero/         # letrero, reloj lunar, frasco de recuerdos
├── Textures/
├── Audio/
└── UI/
```

**Git LFS:** los `.rbxm`, `.rbxmx`, imágenes, audio y FBX se versionan con LFS. El CI debe hacer `checkout` con `lfs: true` para que `rojo build` reciba los archivos reales, no punteros.

### 10.6 Checklist de un modelo antes de commitear

- [ ] Sin scripts ajenos.
- [ ] `PrimaryPart` y pivote correctos.
- [ ] Escala coherente con el kit.
- [ ] Colisiones probadas.
- [ ] Parts y triángulos dentro del presupuesto.
- [ ] Color/material dentro de la paleta.
- [ ] Nombre y atributos de origen.
- [ ] Captura en el GDD o en el PR.
- [ ] Registrado en `CREDITS.md` si es de terceros.

---

## 11. Arquitectura técnica

### 11.1 Estructura Rojo

```
src/
├── client/
│   ├── init.client.luau
│   ├── Controllers/
│   │   └── GameController.luau
│   └── UI/
│       ├── HUD.luau
│       ├── Shop.luau
│       ├── Codex.luau
│       ├── Components.luau
│       └── Theme.luau
├── server/
│   ├── init.server.luau
│   ├── Services/
│   │   ├── DataService.luau
│   │   ├── PlotService.luau
│   │   ├── CustomerService.luau
│   │   ├── UpgradeService.luau
│   │   ├── RemoteService.luau
│   │   └── SyncService.luau
│   └── World/
│       ├── WorldBuilder.luau
│       ├── CafeBuilder.luau
│       └── CustomerModelBuilder.luau
└── shared/
    ├── Config/
    │   ├── GameConfig.luau
    │   ├── Recipes.luau
    │   ├── Cryptids.luau
    │   └── Upgrades.luau
    ├── Types.luau
    └── Util/
        └── UpgradeUtil.luau
```

### 11.2 Responsabilidades

| Módulo | Responsabilidad |
|---|---|
| `DataService` | Perfil, DataStore con fallback, XP/Ecto y leaderstats |
| `PlotService` | Asignar/liberar parcelas, mesas extra y prompts |
| `CustomerService` | Spawn, pedidos, cocina, servicio, propinas y salida |
| `UpgradeService` | Compra, validación y aplicación de mejoras |
| `RemoteService` | Creación de remotes y contrato cliente-servidor |
| `SyncService` | Sincronización de perfil y avisos al cliente |
| `WorldBuilder` | Plaza, spawn, decoración y límites del mundo |
| `CafeBuilder` | Cafetería preconstruida, estaciones, mesas y carteles |
| `CustomerModelBuilder` | Modelo de críptido con `Root` y `WeldConstraint` |
| `GameController` | Conexión de remotes, perfil y UI en el cliente |
| `HUD` / `Shop` / `Codex` | Interfaz de juego, tienda y códice |

### 11.3 Esquema de datos

```lua
export type Profile = {
    version: number,
    userId: number,
    ecto: number,
    level: number,
    xp: number,
    reputation: number,
    biome: string,
    chapter: number,
    prestige: number,
    upgrades: { [string]: number },
    unlocked: { [string]: boolean },
    codex: { [string]: { seen: number, variant: string? } },
    quests: { daily: { [string]: number }, weekly: { [string]: number } },
    cosmetics: { [string]: boolean },
    layout: { [string]: any },
    stats: { [string]: number },
    lastLogin: number,
    lastOfflineClaim: number,
}
```

**Guardado:** `ProfileStore` (o DataStore con bloqueo de sesión), autosave cada 60 s, `BindToClose`, reintentos con backoff y backups. Nunca guardar en el cliente.

### 11.4 Remotes

| Remote | Tipo | Validación |
|---|---|---|
| `ProfileSync` | Event | Solo servidor → cliente; perfil saneado |
| `Notify` | Event | Solo servidor → cliente; mensajes cortos |
| `PurchaseUpgrade` | Function | Propietario, mejora existente, nivel máximo, Ecto suficiente |
| `RequestProfile` | Function | Devuelve el perfil actual del jugador autenticado |

**Regla:** el servidor recalcula todo. El cliente solo envía intenciones. En el MVP no hay remotes de construcción, pedidos ni prestigio porque esos sistemas aún no existen.

### 11.5 Analítica

Eventos mínimos: `session_start`, `tutorial_step`, `first_order`, `first_upgrade`, `night_complete`, `cryptid_discovered`, `prestige`, `purchase`, `visit`, `gift`.

**KPIs objetivo:**

| Métrica | Objetivo |
|---|---:|
| D1 | ≥ 25% |
| D7 | ≥ 10% |
| D30 | ≥ 4% |
| Sesión media | 15–25 min |
| Primera mejora | < 2 min |
| Primer críptido | < 5 min |
| Crash-free | ≥ 99.5% |

### 11.6 Rendimiento

- Máximo 6 parcelas por servidor; 1 jugador por parcela.
- Máximo 30 clientes simultáneos por parcela; pooling.
- Sin bucles `while true` por cliente; usar `task.spawn` con esperas y estados.
- `StreamingEnabled` en el pueblo; modelos fuera de vista no se renderizan.
- Presupuesto de parts por parcela: 250 en 1.0, 400 con mejoras.
- Medir en móvil de gama media antes de cada release.

### 11.7 Decisiones de implementación del MVP

| Decisión | Motivo |
|---|---|
| **Servidor autoritativo** | Evita duplicación de Ecto y trampas; el cliente solo pide comprar |
| **Una cafetería por jugador** | El MVP valida el bucle sin construir un sistema de visitas |
| **Cafetería preconstruida por código** | Elimina el modo construcción y permite probar el bucle antes de modelar props |
| **`ProximityPrompt`** | Interacción nativa, accesible en móvil y sin UI extra |
| **Clientes sin `Humanoid`** | Menos coste de simulación; `Root` anclado + `WeldConstraint` para el cuerpo |
| **DataStore con fallback a memoria** | Permite probar en Studio sin publicar; el fallback no persiste entre sesiones |
| **UI por código** | Cero dependencias de assets externos; fácil de iterar y localizar |
| **Sin misiones, prestigio, social ni monetización** | Se posponen a 1.0 para no inflar el MVP |

**Deuda técnica conocida:** el modelo de cliente es un placeholder de partes; la UI no tiene arte final; el fallback de memoria no sustituye a un DataStore real; falta telemetría.

---

## 12. UI/UX y onboarding

> **Estado MVP (v0.3):** existen HUD, tienda, códice y avisos. El modo construcción, las misiones, el temporizador de noche y el botón de build son objetivos de 1.0, no del MVP.

**HUD:** Ecto, nivel, reputación, temporizador de noche, misión activa, botón de build.

**Build mode:** catálogo por categorías, vista de rejilla, rotación, undo, confirmar. En móvil, controles grandes y sin menús anidados.

**Códice:** tarjetas con filtros por rareza/bioma; vista de detalle con lore y variantes.

**Misiones:** lista de 3 diarias + 5 semanales; barra de progreso; reclamar con un toque.

**Tienda:** cosméticos con vista previa; precios claros; sin temporizadores falsos.

**Onboarding:** 5 pasos guiados, sin texto largo; el jugador sirve antes de leer.

**Accesibilidad:** texto escalable, contraste alto, modo daltónico, reducción de movimiento, subtítulos y SFX separados.

---

## 13. Balance

### 13.1 Curva objetivo

| Hito | Tiempo | Sensación |
|---|---:|---|
| Primera mejora | 1 min | “Puedo mejorar ya” |
| Primer críptido | 3–5 min | “Esto es especial” |
| Primera noche completa | 8–10 min | “Entiendo el bucle” |
| Primer prestigio | 4–6 h | “Puedo empezar de nuevo mejor” |
| Contenido 1.0 | 20–30 h | “Hay mucho por hacer” |
| Códice completo | 40–60 h | “Quiero el 100%” |

### 13.2 Palancas de ajuste

- `dish.Value` y `upgradeCost` en `Config`.
- `customerSpawnRate` y `patience`.
- `offlineRate` y `offlineCap`.
- `rareChance` y `variantChance`.
- `prestigeMultiplier` y `prestigeCost`.

Todo debe estar en módulos de configuración, no hardcodeado.

### 13.3 Reglas de economía

- Un jugador nuevo debe poder comprar algo en la primera noche.
- Nunca dos mejoras obligatorias seguidas sin una decisión.
- El coste de la siguiente mejora no debe superar 3 noches de ingresos.
- El prestigio no debe sentirse obligatorio hasta después del primer bioma.
- Los cosméticos no deben dar poder.

---

## 14. Roadmap

> Estimación para **1 persona a tiempo completo**. Si es a tiempo parcial, duplicar.

| Fase | Duración | Entregable | Criterio de aceptación |
|---|---:|---|---|
| **0. Preproducción** | 1 semana | GDD, repo, blockout, auditoría de assets | El GDD está aprobado y el repo compila |
| **1. MVP** | 2 semanas | 6 parcelas, 3 estaciones, 3 críptidos, 6 recetas, 6 mejoras, guardado | Implementado como prototipo; falta playtest con jugador real |
| **2. Vertical slice** | 3 semanas | Tutorial, 6 críptidos, 12 mejoras, UI, SFX, códice | Un jugador nuevo completa el tutorial sin ayuda |
| **3. Contenido 1.0** | 4 semanas | Mistwood, 8 críptidos, 16 recetas, 18 mejoras, 20 misiones, prestigio | 30 min de juego con progresión clara |
| **4. Pulido y soft launch** | 3 semanas | Analytics, balance, eventos, optimización móvil | D1 ≥ 20% en soft launch |
| **5. Live ops** | Continuo | Biomas 2–5, eventos, cosméticos, fixes | Actualización cada 2–4 semanas |

**Hito de lanzamiento:** 12–13 semanas (~3 meses) a tiempo completo. **Primer bioma extra:** 4–6 semanas después.

---

## 15. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Scope creep (demasiados críptidos) | Alta | Alto | Lanzar con 8; el resto en updates |
| Tiempo de modelado | Alta | Alto | Props de Toolbox + Modeler solo para héroes |
| Economía desbalanceada | Media | Alto | Config tunable + telemetría + playtests |
| Rendimiento en móvil | Media | Alto | Presupuesto de parts, pooling, StreamingEnabled |
| Pérdida de datos | Baja | Muy alto | ProfileStore, backups, BindToClose |
| Nombre “Cryptid Café” ya usado | Media | Medio | Búsqueda de marca antes del lanzamiento; alternativas |
| Moderación/chat | Media | Alto | Chat seguro, sin UGC, filtros de Roblox |
| Monetización rechazada | Baja | Medio | Solo cosméticos, sin loot boxes |
| Burnout del desarrollador | Media | Alto | Sprints cortos, recortar contenido, no crunch |

---

## 16. Decisiones abiertas

| Decisión | Opciones | Fecha límite |
|---|---|---|
| Nombre final | Cryptid Café / Moth & Mocha / The Lantern | Antes del marketing |
| Estilo visual | Low-poly plano / clay / pixel 3D | Vertical slice |
| Tamaño de servidor | 6 jugadores (MVP); evaluar 8 en 1.0 | Resuelto para MVP |
| Guardado | DataStore custom con fallback (MVP); ProfileStore en 1.0 | Resuelto para MVP |
| Precio del 2× Ecto | 199 / 299 / 399 R$ | Soft launch |
| Idioma inicial | Inglés / inglés + español | Vertical slice |
| Música | Compositor / licencia | Vertical slice |

---

## 17. Registro de cambios

| Fecha | Versión | Cambio | Autor |
|---|---|---|---|
| 22/10/2026 | 0.1 | Borrador inicial: concepto, investigación, bucles, economía, contenido y roadmap | carlos00012 |
| 22/10/2026 | 0.2 | Se añade la política de reutilizar modelos prehechos de Studio/Toolbox, auditoría, licencias y créditos; se detalla el pipeline de modelos y LFS | carlos00012 |
| 22/10/2026 | 0.3 | Se registra el MVP implementado: 6 parcelas, 3 estaciones, 3 críptidos, 6 recetas, 6 mejoras, guardado con fallback, UI por código y decisiones técnicas; se actualiza la estructura Rojo y los remotes reales | carlos00012 |

**Plantilla para nuevas filas:**

```
| DD/MM/AAAA | 0.X | Qué cambió y por qué | carlos00012 |
```

**Regla:** ningún cambio de código o contenido se considera terminado si no está reflejado aquí.

---

## 18. Referencias

- rblxdb — *Best Roblox Tycoon Games (octubre 2026)*: <https://rblxdb.com/best-roblox-games/tycoon>
- Endsights — *Roblox Tycoon Games 2026: Builds, Loops, Economies*: <https://endsights.com/roblox-tycoon-games>
- Roblox Creator Hub — *Retention*: <https://create.roblox.com/docs/production/analytics/retention>
- Roblox Creator Hub — *Solid modeling*: <https://create.roblox.com/docs/parts/solid-modeling>
- Roblox DevForum — *Procedural Models*: <https://devforum.roblox.com/t/full-release-procedural-models-build-parametrized-3d-models-with-code-or-ai/4642542>
- Roblox DevForum — *How to make your game have replayability*: <https://devforum.roblox.com/t/how-to-make-your-game-have-replayability/1082534>
- Game-ace — *Roblox monetization best practices*: <https://game-ace.com/blog/how-to-ensure-your-roblox-monetization>
- IntelBricks — *Restaurant Tycoon 3 stats*: <https://www.intelbricks.com/games/restaurant-tycoon-3-7094518649>
- Roblox Creator Hub — *3D art and Studio*: <https://create.roblox.com/docs/art/overview-studio>

---

*Fin del documento. Si algo no está claro, es que falta una decisión: añádela a “Decisiones abiertas” en lugar de improvisarla en código.*
