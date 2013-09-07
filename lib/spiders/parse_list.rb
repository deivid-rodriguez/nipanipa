Tel_prefix  = "(?:Tel\s*(?:(?:&|\/)\s*[Ff]ax)?\s*(?:[:.])?)"
Fax_prefix  = "(?:Fax\s*(?:[:.])?)"
Cel_prefix  = "(?:[Cc]ell\s*(?:[:.])?)"
Web_regexp  = "www\.\S+\.\S+"
Mail_prefix = "[Ee](?:[- ])?[Mm]ail\s*(?:[:.])?\s*"
Mail_regexp = '[^@\s]+@\S+'

def farm_address(farm_info)
  address = farm_info[/^(.*?)(?:#{Tel_prefix}|#{Fax_prefix}|#{Cel_prefix})/,1]
  address.strip! if address
  return address
end

def farm_name(farm_info)
  name = farm_info[/^(.*?),/,1]
  return name
end

def farm_phone(farm_info)
  phone = farm_info[/^(?:.*?)#{Tel_prefix}([0-9 .-]+)/,1]
  phone.delete!('.') if phone
  phone.delete!('-') if phone
  phone.delete!(' ') if phone
  phone = phone[0..9] if phone
  return phone
end

def farm_cell(farm_info)
  cell = farm_info[/^(?:.*?)#{Cel_prefix}([0-9 .-]+)/,1]
  cell.delete!('-') if cell
  cell.delete!(' ') if cell
  return cell
end

def farm_mails_and_webs(farm_info)
  data = farm_info.match(/(?:#{Mail_prefix})\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/)
  return nil if !data

  mails = data[1..4].select { |d| d =~ /@/ }
  webs = data[1..4].select { |d| d =~ /www/ }
  return mails.join(' '), webs.join(' ')
end

def farm_desc(farm_info)
  data = farm_info.match(/(?:#{Mail_prefix})\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/)
  if data
    desc = farm_info.partition(data[1..4].keep_if{ |d| d =~ /@|www/ }.last)[2]
  else
    cell = farm_info[/^(?:.*?)#{Cel_prefix}([0-9 .-]+)/,1]
    if cell
      desc = farm_info.partition(cell)[2]
    else
      phone = farm_info[/^(?:.*?)#{Tel_prefix}([0-9 .-]+)/,1]
      if phone
        desc = farm_info.partition(phone)[2]
      end
    end
  end
  desc.strip! if desc
  return desc
end

puts "Region,Name,Phone,Mails,Websites,Description"

previous_line = nil
in_farm_list = false
farm_info = nil
current_region = nil

IO.foreach(ARGV[0]) do |line|
  if line =~ /^Coordinator/
    current_region = previous_line.chomp.capitalize
    in_farm_list = false
  end

  if line =~ /^1. /
    in_farm_list = true
  end

  if in_farm_list
    if line =~ /^\d+\. (.*)$/
      if farm_info
        farm_string = farm_info.join(' ')
        name = farm_name(farm_string)
        phone = farm_phone(farm_string)
        phone = farm_cell(farm_string) unless phone
        mails, webs = farm_mails_and_webs(farm_string)
        desc = farm_desc(farm_string)
        puts "#{current_region},#{name},#{phone},#{mails},#{webs},#{desc}"
      end
      farm_info = [$1.chomp]
    else
      farm_info << line.chomp
    end
  end

  previous_line = line
end
