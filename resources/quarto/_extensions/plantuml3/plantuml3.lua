function CodeBlock(block)

  if not block.classes:includes("plantuml") then
    return nil
  end

  local filename = "diagram.puml"

  local file = io.open(filename, "w")

  if not file then
    error("Cannot create " .. filename)
  end

  file:write(block.text)
  file:close()

  return pandoc.Para({
    pandoc.Str("Generated: " .. filename)
  })

end