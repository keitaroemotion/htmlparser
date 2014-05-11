# this script aims at parsing HTML of Jenkins Jemeter output.

job=ARGV[0]
num=ARGV[1]

class Setting
    def ip             # instance method, getter  
     @ip  
    end  
    def ip=(i)         # instance method, setter  
     @ip = i  
    end 
    def odir
      @odir
    end
    def odir=(x)
      @odir=x
    end
end


def loadsetting()
  fname = "info.conf"
  st=Setting.new
  File.open(fname, "r").each_line do |line|
    data = line.split(/\t/)
    case data[0] 
    when "ip"
     st.ip = data[1].chomp.strip
    when "outdir"
     st.odir = data[1].chomp.strip
    else
     
    end   
  end
  return st
end


sett = loadsetting()
puts "ip: "+sett.ip

# get websource from the url:
require 'net/http'
blocks= Net::HTTP.get(sett.ip, "/#{job}/#{num}/jenkins.html").split('td class="left')

fname = sett.odir+"/sample.txt"
puts "==> "+fname
puts blocks
ofile = File.open(fname, "w")

$i = 1
while $i  < blocks.length do
  blocks[$i].split('><').each{
    |x|
      puts x
      if x.include? "Help us localize this page"
         break
      end
      tokens = x.split(/[<>]/) 
      if (x.strip.length > 2) && (tokens.length == 3) 
        ofile.print tokens[1]+"\t" 
      end
  }  
  $i+=1
  ofile.puts
end	

ofile.close


