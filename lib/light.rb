require 'pi_piper'
include PiPiper

class Light
  PINS = {
    "green" => 4,
    "red" => 17,
    "yellow" => 27
  }

  def initialize(color)
    @color = color
    @pin = PiPiper::Pin.new(:pin => PINS[color], :direction => :out)
  end

  def on
    @pin.on
  end

  def off
    @pin.off
  end

  def flash(times)
    Process.detach(fork{
    times.times do |i|
      puts "DEBUG: #{i}"
      on
      sleep 0.05
      off
      sleep 0.05
    end
    })
  end

  def on_for(time)
    Process.detach(fork{
      puts "LIGHT ON"
      on
      sleep time
      off
    })
  end
end
