require 'artoo'

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

connection :navigation, :adaptor => :ardrone_navigation, :port => '192.168.1.1:5554'
device :nav, :driver => :ardrone_navigation, :connection => :navigation

work do
  on drone, :ready => :fly
  on nav, :navdata => :print_nav_info

  drone.start(nav)
end

def fly(*data)
  after(1.seconds) { drone.take_off }
  after(2.seconds) { drone.led(:blink_orange,1,2) }
  after(3.seconds) { drone.hover }
  after(5.seconds) { drone.up(0.5) }

  after(7.seconds) do
    drone.turn_right(0.5)
    drone.forward(0.4)
  end

  after(9.seconds) do
    drone.turn_left(0.5)
    drone.backward(0.4)
  end

  after(11.seconds) { drone.hover }
  after(15.seconds) { drone.land }
end

def print_nav_info(*data)
  puts "#{data[1].inspect}"
end
