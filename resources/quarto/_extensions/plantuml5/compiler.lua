local Compiler = {}

local function trim_trailing_slash(value)
  return (value:gsub("/+$", ""))
end

local function hex_encode(value)
  return (value:gsub(".", function(character)
    return string.format("%02x", string.byte(character))
  end))
end

function Compiler.mime_type(config)
  if tostring(config.format) == "svg" then
    return "image/svg+xml"
  end

  error(
    "Formato PlantUML no soportado: "
      .. tostring(config.format)
  )
end

function Compiler.compile(source, config)
  local format = tostring(config.format)

  if format ~= "svg" then
    error(
      'Formato PlantUML no soportado: '
        .. format
        .. '. Use "svg".'
    )
  end

  local url = trim_trailing_slash(tostring(config.server))
    .. "/"
    .. format
    .. "/~h"
    .. hex_encode(source)

  local ok, mime_type, contents = pcall(
    pandoc.mediabag.fetch,
    url
  )

  if not ok then
    error(
      "No se pudo obtener el diagrama PlantUML.\n"
        .. "URL: "
        .. url
        .. "\nDetalle: "
        .. tostring(mime_type)
    )
  end

  if contents == nil or contents == "" then
    error("PlantUML devolvio una respuesta vacia: " .. url)
  end

  return mime_type or Compiler.mime_type(config), contents
end

return Compiler
