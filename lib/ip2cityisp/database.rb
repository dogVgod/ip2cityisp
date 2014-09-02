require 'rubygems'
require 'bundler/setup'
require 'bindata'
module Ip2cityisp
  class Header < BinData::Record
    SIZE = 8
    endian :little
    string :index_version , :read_length => 4
    uint32 :total_nums
  end

  class Index < BinData::Record
    SIZE = 12
    endian :little
    uint32 :ip_start
    uint32 :country_offset
    uint32 :isp_offset
    uint32 :ip_end
  end

  class Database
    attr_reader  :area, :isp
    def initialize(file = 'ipinfo.data')
      if file.respond_to?(:to_str)
        @file = File.new(file.to_str)
      else
        @file = file
        @file.seek(0)
      end
      @header = Ip2cityisp::Header.read(@file)
      $start = Ip2cityisp::Header::SIZE
      $high = @header.total_nums
      $off1 = @header.total_nums*12 + 20
      $version  = @header.index_version
      #get end off2
      @file.seek($high*12+8)
      index = Ip2cityisp::Index.read(@file)
      $off2 = $off1 + index.country_offset
      $create_time=  index.isp_offset
      @file.seek(0)
    end

    def version
        $version + ":CREATE TIME:" + Time.at($create_time).to_date.to_s
    end

    def query(ip)
      if ip.respond_to?(:to_str)
          #way 1
          ips = ip.to_str.split('.')  
          ip = ips[0].to_i * 16777216 + ips[1].to_i * 65536 + ips[2].to_i * 256 + ips[3].to_i
          #p ip
          #way 2
          #ip = ip.to_str.split('.').collect{|i| i.to_i}.pack('C4').unpack('N')[0]
      end
      raise ArgumentError, "invalid ip" unless (0...(1 << 32)).include?(ip)
      low = 0
      high = $high - 1 
      start = $start
      info = {"area"=>"","isp"=>""}
      while(low <= high)
          middle = (low + high) >> 1 
          #p middle
          @file.seek(start + middle * Ip2cityisp::Index::SIZE)
          index = Ip2cityisp::Index.read(@file)
          ip_start = index.ip_start
          country_offset = index.country_offset
          isp_offset = index.isp_offset
          ip_end = index.ip_end
          if ip < index.ip_start
             high = middle - 1
          elsif ip >= index.ip_end
              low = middle + 1
          else
              if country_offset >= 0
                  country_off = $off1 +  country_offset
                  if country_off < @file.size
                      @file.seek(country_off)
                      vlen = @file.read(1).unpack('C')[0]
                      info["area"] = @file.read(vlen).force_encoding("UTF-8")
                  end
              end
              isp_off = $off2 +  isp_offset
              if isp_offset >= 0
                  isp_off = $off2 +  isp_offset
                  if isp_off < @file.size
                      @file.seek(isp_off)
                      vlen = @file.read(1).unpack('C')[0]
                      info["isp"] = @file.read(vlen).force_encoding("UTF-8")
                  end
              end 
              return info
          end
        end
    end
  end
end
