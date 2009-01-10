#!/usr/bin/env ruby

# This is a hack to facilitate my use of a bluetooth mouse as a remote input device to trigger the
# playing of an sound file.
# 
# Run it by typing:
# 
#   ./click_to_play path_to_sound_file
# 
# The window will become full screen and contain a button which fills the screen. When the button
# is pressed, the sound will play.
# 
# To quit, hit the Esc key.

require "rubygems"
require "gtk2"
require "gst"

class ClickToPlay
  def initialize(file)
    raise ArgumentError, "File to play not specified" if file.nil?
    @file = file
    
    new_playbin
    build_window
  end
  
  def quit
    @playbin.stop
    Gtk.main_quit
  end
  
  def build_window
    @window = Gtk::Window.new
    @window.add_events(Gdk::Event::BUTTON_PRESS_MASK)
    
    @window.signal_connect("destroy") { quit }
    @window.signal_connect("key_press_event") do |widget, event|
      quit if event.keyval == Gdk::Keyval::GDK_Escape
    end
    @window.signal_connect("button_press_event") { play }
    
    @window.fullscreen
    @window.show_all
  end
  
  def new_playbin
    @playbin.stop if @playbin
    
    @playbin = Gst::ElementFactory.make('playbin')
    @playbin.uri = "file://#{@file}"
    @playbin.bus.add_watch do |bus, message|
      new_playbin if message.type == Gst::Message::Type::EOS
      true
    end
  end
  
  def play
 	  @playbin.play
  end
end

ClickToPlay.new(ARGV.first)
Gst.init
Gtk.main
