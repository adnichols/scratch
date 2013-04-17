#!/usr/bin/env ruby

require 'fog'
require 'pp'
require 'trollop'

p = Trollop::Parser.new do
  opt :list, "List all nodes"
  opt :lb, "Load balancer ID", :type => String
  opt :name, "Name of load balancer", :type => String
  opt :state, "Node State - ENABLED | DISABLED | DRAINING", :type => String
end

@opts = Trollop::with_standard_exception_handling p do 
  raise Trollop::HelpNeeded if ARGV.empty?
  p.parse ARGV
end

lb = Fog::Rackspace::LoadBalancers.new
nodes = Fog::Compute::RackspaceV2.new

lb_list = lb.list_load_balancers
node_list = nodes.list_servers

if @opts[:name]
  my_lb = lb_list.data[:body]["loadBalancers"].select {|mylb| mylb["name"] == @opts[:name] }
  puts "Matched LB #{@opts[:name]}"
  pp my_lb
end

if @opts[:list]
  lb_list.data[:body]["loadBalancers"].each do |l|
    puts "Name: #{l["name"]} ID: #{l["id"]}"
    node_list = lb.list_nodes(l["id"])
    pp l
    node_list.data[:body]["nodes"].each do |ln|
      pp ln
      node = nodes.list_servers[:body]["servers"].select {|n| n["addresses"]["private"][0]["addr"] == ln["address"]}
      puts " => IP: #{ln["address"]} Name: #{node[0]["name"]} (#{ln["id"]}) Status: #{ln["status"]} Condition: #{ln["condition"]}"
    end
  end
end