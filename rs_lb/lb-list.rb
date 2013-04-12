#!/usr/bin/env ruby

require 'fog'
require 'pp'

lb = Fog::Rackspace::LoadBalancers.new

lb_list = lb.list_load_balancers

lb_list.data[:body]["loadBalancers"].each do |l|
  puts "Name: #{l["name"]} ID: #{l["id"]}"
end
