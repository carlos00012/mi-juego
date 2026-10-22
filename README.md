# mi-juego

[![CI](https://github.com/carlos00012/mi-juego/actions/workflows/ci.yml/badge.svg)](https://github.com/carlos00012/mi-juego/actions/workflows/ci.yml)

Juego de Roblox con un flujo de trabajo basado en código:

- **Rojo** sincroniza los archivos `.luau` de VS Code con Roblox Studio.
- **Git + GitHub** guardan el historial y respaldan el proyecto.
- **Rokit** fija las versiones de Rojo, Selene, StyLua y Wally.
- **GitHub Actions** revisa el formato, el lint y compila el lugar en cada push.

Repositorio: <https://github.com/carlos00012/mi-juego>

## Requisitos

| Herramienta | Para qué |
|---|---|
| [Roblox Studio](https://create.roblox.com/) | Probar y publicar el juego |
| [Rokit](https://github.com/rojo-rbx/rokit) | Instalar Rojo y las herramientas |
| [Git](https://git-scm.com/) | Control de versiones |
| [VS Code](https://code.visualstudio.com/) | Editar el código |

## Puesta en marcha

```powershell
# 1. Instalar las herramientas fijadas en rokit.toml
rokit install

# 2. Instalar o actualizar el plugin de Rojo en Studio
rojo plugin install

# 3. Arrancar el servidor de Rojo
rojo serve
```

En Roblox Studio:

1. Abre un lugar nuevo (**Baseplate**) o el lugar generado con `rojo build`.
2. Ve a la pestaña **Plugins** y abre **Rojo**.
3. Pulsa **Connect**. Deberías ver `Server` y `Client` en el Explorer y los mensajes en la Output.

> El servidor se queda corriendo en esa terminal. Usa `Ctrl+C` para detenerlo.

## Estructura

```
mi-juego/
├── src/
│   ├── client/          → StarterPlayerScripts (LocalScripts)
│   ├── server/          → ServerScriptService (Scripts)
│   └── shared/          → ReplicatedStorage.Shared (ModuleScripts)
├── default.project.json → mapa de src/ a los servicios de Roblox
├── rokit.toml           → versiones de las herramientas
├── selene.toml          → reglas del linter
├── stylua.toml          → reglas del formateador
└── .github/workflows/   → CI (formato, lint y build)
```

### Reglas de nombres

| Archivo | Se convierte en |
|---|---|
| `algo.server.luau` | `Script` (solo servidor) |
| `algo.client.luau` | `LocalScript` (solo cliente) |
| `algo.luau` | `ModuleScript` (se requiere con `require`) |
| `init.server.luau` | Convierte la carpeta en un `Script` |
| `init.client.luau` | Convierte la carpeta en un `LocalScript` |

## Comandos útiles

```powershell
rojo serve                          # sincronizar con Studio
rojo build -o build/mi-juego.rbxlx  # generar un lugar jugable
selene src                          # buscar errores y malas prácticas
stylua src                          # formatear el código
rokit install                       # reinstalar las herramientas
```

## Flujo diario

```powershell
git pull
git checkout -b feature/nueva-idea

# ... editar en VS Code con rojo serve activo ...

git add .
git commit -m "feat: descripción del cambio"
git push -u origin feature/nueva-idea
```

Abre un Pull Request en GitHub. El CI revisa formato, lint y que el lugar compile.

## Qué se guarda y qué no

Rojo solo controla lo que está dentro de `src/`. Los objetos que crees a mano en Studio (mapas, modelos, UI) viven en el archivo `.rbxlx` y **no** se sincronizan a Git.

Para trabajo en equipo:

- Guarda modelos como `.rbxm` dentro de `src/` y Rojo los insertará en el lugar.
- O publica el lugar en Roblox y comparte el acceso.
- No subas `build/` a Git: el CI lo regenera.

## Publicar

1. Prueba en Studio con **Play**.
2. `File → Publish to Roblox`.
3. Configura nombre, descripción, ícono y privacidad en la página del juego.

Rojo no publica: sincroniza código y compila el lugar. La publicación se hace desde Studio.

## Problemas comunes

| Síntoma | Solución |
|---|---|
| `Failed to find tool 'rojo' in any project manifest` | Estás fuera de la carpeta del proyecto o falta `rokit.toml`. Ejecuta `rokit install`. |
| El plugin no conecta | Comprueba que `rojo serve` sigue corriendo y actualiza el plugin con `rojo plugin install`. |
| Los cambios no aparecen | Revisa la extensión del archivo y que esté dentro de `src/`. Mira la Output de Studio. |
| Puerto ocupado | `rojo serve --port 34873` y conecta el plugin a ese puerto. |
