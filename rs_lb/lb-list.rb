#!/usr/bin/env ruby

require 'fog'
require 'pp'

lb = Fog::Rackspace::LoadBalancers.new

lb_list = lb.list_load_balancers

lb_list.data[:body]["loadBalancers"].each do |l|
  puts "Name: #{l["name"]} ID: #{l["id"]}"
  node_list = lb.list_nodes(l["id"])
  node_list.data[:body]["nodes"].each do |n|
    puts " => IP: #{n["address"]} ID: #{n["id"]} Status: #{n["status"]} Condition: #{n["condition"]}"
  end
end
