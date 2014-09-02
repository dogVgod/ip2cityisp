require 'rubygems'
require 'bundler/setup'
require 'ip2cityisp'
ip =  ARGV[0]
@db = Ip2cityisp::Database.new('/tmp/ipinfo.data')
r = @db.query('8.8.8.8')
rip = r["area"]+r["isp"]  
p rip
p @db.version
