function CodeBlock(block)

  if not block.classes:includes("plantuml") then
    return nil
  end

  io.stderr:write("----------------------------------------\n")
  io.stderr:write("PlantUML block detected\n")
  io.stderr:write("----------------------------------------\n")
  io.stderr:write(block.text .. "\n")
  io.stderr:write("----------------------------------------\n")

  return pandoc.Para({
    pandoc.Str("PlantUML OK")
  })

end