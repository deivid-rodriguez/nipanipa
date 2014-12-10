namespace :scrapers do
  TEL_PREFIX = "(?:Tel\s*(?:(?:&|\/)\s*[Ff]ax)?\s*(?:[:.])?)"
  FAX_PREFIX = "(?:Fax\s*(?:[:.])?)"
  CEL_PREFIX = "(?:[Cc]ell\s*(?:[:.])?)"
  WEB_REGEXP = "www\.\S+\.\S+"
  MAIL_PREFIX = "[Ee](?:[- ])?[Mm]ail\s*(?:[:.])?\s*"
  MAIL_REGEXP = '[^@\s]+@\S+'

  def farm_address(info)
    address = info[/^(.*?)(?:#{TEL_PREFIX}|#{FAX_PREFIX}|#{CEL_PREFIX})/, 1]
    address.strip! if address
    address
  end

  def farm_name(info)
    name = info[/^(.*?),/, 1]
    name
  end

  def farm_phone(info)
    phone = info[/^(?:.*?)#{TEL_PREFIX}([0-9 .-]+)/, 1]
    phone.delete!('.') if phone
    phone.delete!('-') if phone
    phone.delete!(' ') if phone
    phone = phone[0..9] if phone
    phone
  end

  def farm_cell(info)
    cell = info[/^(?:.*?)#{CEL_PREFIX}([0-9 .-]+)/, 1]
    cell.delete!('-') if cell
    cell.delete!(' ') if cell
    cell
  end

  def farm_mails_and_webs(info)
    data = info.match(/(?:#{MAIL_PREFIX})\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/)
    return nil unless data

    mails = data[1..4].select { |d| d =~ /@/ }
    webs = data[1..4].select { |d| d =~ /www/ }
    [mails.join(' '), webs.join(' ')]
  end

  def farm_desc(info)
    m = info[/(?:#{MAIL_PREFIX})\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/, 1]
    return info.partition(m[1..4].keep_if { |d| d =~ /@|www/ }.last)[2] if m

    cell = info[/^(?:.*?)#{CEL_PREFIX}([0-9 .-]+)/, 1]
    return info.partition(cell)[2] if cell

    phone = info[/^(?:.*?)#{TEL_PREFIX}([0-9 .-]+)/, 1]
    info.partition(phone)[2] if phone
  end

  desc 'Scrapes France Wwoofing list'
  task :france do
    fout = File.new('france-list.cvs')
    fout.write('Region,Name,Phone,Mails,Websites,Description')

    previous_line, in_farm_list, farm_info, region = nil, false, nil, nil

    IO.foreach(ARGV[0]) do |line|
      if line =~ /^Coordinator/
        region = previous_line.chomp.capitalize
        in_farm_list = false
      end

      previous_line = line

      in_farm_list = true if line =~ /^1. /
      next unless in_farm_list

      if line =~ /^\d+\. (.*)$/
        if farm_info
          farm_string = farm_info.join(' ')
          name = farm_name(farm_string)
          phone = farm_phone(farm_string)
          phone = farm_cell(farm_string) unless phone
          mails, webs = farm_mails_and_webs(farm_string)
          desc = farm_desc(farm_string).try(:strip)
          fout.write "#{region},#{name},#{phone},#{mails},#{webs},#{desc}"
        end
        farm_info = [Regexp.last_match[1].chomp]
      else
        farm_info << line.chomp
      end
    end
  end
end
