local script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)

local Engine = dofile(
  pandoc.path.normalize(
    pandoc.path.join({
      script_dir,
      "..",
      "..",
      "core",
      "engine.lua"
    })
  )
)

local Compiler = dofile(
  pandoc.path.join({
    script_dir,
    "compiler.lua"
  })
)

local Defaults = dofile(
  pandoc.path.join({
    script_dir,
    "defaults.lua"
  })
)

return Engine.create({
  name = "plantuml",
  block_class = "plantuml",
  version = "0.2.0",
  compiler = Compiler,
  defaults = Defaults
})
