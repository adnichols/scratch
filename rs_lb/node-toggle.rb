#!/usr/bin/env ruby

require 'fog'
require 'pp'
require 'trollop'

p = Trollop::Parser.new do
  opt :lb, "Load balancer ID", :type => String
  opt :node, "Node ID to touch", :type => String
  opt :state, "Node State - ENABLED | DISABLED | DRAINING", :type => String
  opt :toggle, "Wanna toggle the node"
end

@opts = Trollop::with_standard_exception_handling p do 
  raise Trollop::HelpNeeded if ARGV.empty?
  p.parse ARGV
end

@lb = Fog::Rackspace::LoadBalancers.new

node_state = @lb.get_node(@opts[:lb], @opts[:node])[:body]["node"]["condition"]
puts "Current State: #{node_state}"

def update_state(new_state)
  @lb.update_node(@opts[:lb], @opts[:node], options = { :condition => "#{new_state}" })
end

if @opts[:state]
  update_state(@opts[:state])

elsif @opts[:toggle]
  if node_state == "ENABLED"
    update_state("DISABLED")
  elsif node_state == "DISABLED"
    update_state("ENABLED")
  end  
end

node_state = @lb.get_node(@opts[:lb], @opts[:node])[:body]["node"]["condition"]
puts "End State: #{node_state}"
