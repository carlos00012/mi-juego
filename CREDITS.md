# Créditos de assets

Este archivo registra todos los modelos, texturas, animaciones, música y efectos de sonido de terceros que se usen en **Cryptid Café**. También sirve como comprobante de licencia para el equipo y para la comunidad.

## Política de uso

1. **Licencia clara o no se usa.** Todo asset debe indicar autor, fuente y licencia. Si no se puede verificar, se descarta.
2. **Auditar antes de importar.** Insertar en Studio, revisar scripts, `MeshPart`, texturas, colisiones y número de parts. Eliminar cualquier script ajeno.
3. **Nada de assets de pago sin compra.** No se usan modelos de pago sin licencia adquirida.
4. **Adaptar a la dirección de arte.** Recolorear, escalar y simplificar para que encajen con la paleta y el presupuesto.
5. **Registrar aquí y en el GDD.** El modelo debe llevar atributos `AssetSource`, `AssetAuthor` y `AssetLicense`.
6. **Los modelos propios también se documentan** en el GDD, pero no necesitan crédito externo.

## Modelos y props de Studio / Toolbox

| Asset | Autor | Fuente (URL) | Licencia | Uso en el juego | Fecha | Estado |
|---|---|---|---|---|---|---|
| _Pendiente_ | — | — | — | — | — | — |

## Criptídos y piezas de identidad

Estos se modelan en Studio con el Modeler y Solid Modeling. No son de terceros.

| Asset | Autor | Herramienta | Uso | Fecha |
|---|---|---|---|---|
| _Pendiente_ | carlos00012 | Studio Modeler | — | — |

## Texturas e imágenes

| Asset | Autor | Fuente (URL) | Licencia | Uso | Fecha |
|---|---|---|---|---|---|
| _Pendiente_ | — | — | — | — | — |

## Audio y música

| Asset | Autor | Fuente (URL) | Licencia | Uso | Fecha |
|---|---|---|---|---|---|
| _Pendiente_ | — | — | — | — | — |

## Animaciones

| Asset | Autor | Fuente (URL) | Licencia | Uso | Fecha |
|---|---|---|---|---|---|
| _Pendiente_ | — | — | — | — | — |

## Cómo añadir una entrada

1. Copia la fila de la tabla correspondiente.
2. Rellena autor, URL, licencia y uso.
3. Añade los atributos al modelo en Studio:

```lua
model:SetAttribute("AssetSource", "Toolbox / Creator Store")
model:SetAttribute("AssetAuthor", "Nombre del autor")
model:SetAttribute("AssetLicense", "Licencia o permiso")
```

4. Guarda el `.rbxm` en `src/shared/Assets/Models/`.
5. Haz commit de este archivo junto con el modelo.

## Licencias aceptadas

- Assets oficiales de Roblox con permiso de uso en experiencias.
- Modelos gratuitos del Creator Store con licencia que permita uso comercial.
- Assets propios o encargados con contrato.
- Música y SFX con licencia CC0, CC-BY (con atribución) o comprados.

## Licencias no aceptadas

- Modelos sin autor o sin licencia verificable.
- Assets de pago sin compra.
- Modelos con scripts ocultos o remotes.
- Contenido con marcas registradas de terceros sin permiso.
- Modelos extraídos de otros juegos.

---

_Última actualización: 22/10/2026._
