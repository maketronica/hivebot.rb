require 'rubyserial'

def arduino_serial_path
  Dir['/dev/serial/by-id/usb-Arduino*'].first
end

port = Serial.new(arduino_serial_path, 115200)

puts arduino_serial_path

while(true) do
  data = port.read(1000);
  puts data unless data.empty?
end
