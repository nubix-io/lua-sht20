local M = {
  -- memory map
  TEMP_REG        = 0x0000, -- 0x001
  HUM_REG         = 0x0001, -- 0x002
  TEMP_CORRECTION = 0x0102, -- 0x103
  HUM_CORRECTION  = 0x0103  -- 0x104
}

function M.readHumidityRH(modbusClient)
  local uncompensatedHumRH = M.readUncompensatedHumidityRH(modbusClient)
  local data = modbusClient:readInputRegisters(M.HUM_CORRECTION, 1)
  local humCorrection = M.readShort(data[2], data[1])
  local humRH = uncompensatedHumRH + humCorrection
  return humRH
end

function M.readRawHumidityRH(modbusClient)
  local data = modbusClient:readInputRegisters(M.HUM_REG, 1)
  local rawHumRH = M.readShort(data[2], data[1])
  return rawHumRH
end

function M.readRawTemperatureC(modbusClient)
  local data = modbusClient:readInputRegisters(M.TEMP_REG, 1)
  local rawTempC = M.readShort(data[2], data[1])
  return rawTempC
end

function M.readShort(lsb, msb)
  local val = lsb + msb * 256
  if val >= 32768 then val = val - 65536 end
  return val
end

function M.readTemperatureC(modbusClient)
  local uncompensatedTempC = M.readUncompensatedTemperatureC(modbusClient)
  local data = modbusClient:readInputRegisters(M.TEMP_CORRECTION, 1)
  local tempCorrection = M.readShort(data[2], data[1])
  local tempC = uncompensatedTempC + tempCorrection
  return tempC
end

function M.readUncompensatedHumidityRH(modbusClient)
  local rawHumRH = M.readRawHumidityRH(modbusClient)
  local humRH = rawHumRH / 10
  return humRH
end

function M.readUncompensatedTemperatureC(modbusClient)
  local rawTempC = M.readRawTemperatureC(modbusClient)
  local tempC = rawTempC / 10
  return tempC
end

return M
