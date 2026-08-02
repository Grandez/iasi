local Metadata = {}

function Metadata.scalar(value, default)
  if value == nil then
    return default
  end

  local value_type = pandoc.utils.type(value)

  if value_type == "Inlines" or value_type == "Blocks" then
    return pandoc.utils.stringify(value)
  end

  return value
end

function Metadata.boolean(value, default)
  value = Metadata.scalar(value, default)

  if type(value) == "boolean" then
    return value
  end

  local text = tostring(value):lower()

  if text == "true" then
    return true
  end

  if text == "false" then
    return false
  end

  return default
end

return Metadata
