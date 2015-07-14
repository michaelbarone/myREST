gpio.mode(1,gpio.OUTPUT)
gpio.write(1,gpio.HIGH)
gpio.write(1,gpio.LOW)
sv=net.createServer(net.TCP) 
print("Server started")
sv:listen(80,function(conn)
  conn:on("receive",function(conn,request)
    local e = string.find(request, "/")
    local request_handle = string.sub(request, e + 1)
    e = string.find(request_handle, "HTTP")
    request_handle = string.sub(request_handle, 0, (e-2))
    if request_handle == "ota_update" then
      conn:send("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n" .. "ota mode" .. "\r\n")
      conn:close()
      sv:close()
      dofile("ota.lc")
    else
      uart.write(0, request_handle.."\n")
      uart.on("data", '}',
        function(data)
          uart.on("data") 
          conn:send("HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nConnection: close\r\n\r\n" .. data .. "\r\n")
          conn:close()
        end, 0)
    end
  end)
end)