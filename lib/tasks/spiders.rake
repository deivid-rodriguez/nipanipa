class FarmScrapper
  def initialize(line)
    @line = line
  end

  def address
    addr = @line[/^(.*?)(?:#{tel_prefix}|#{fax_prefix}|#{cel_prefix})/, 1]
    addr.strip! if addr
    addr
  end

  def name
    @line[/^(.*?),/, 1]
  end

  def phone
    tel = @line[/^(?:.*?)#{tel_prefix}([0-9 .-]+)/, 1]
    tel.delete!('.') if tel
    tel.delete!('-') if tel
    tel.delete!(' ') if tel
    tel = tel[0..9] if tel
    tel
  end

  def cel
    tmp_cel = @line[/^(?:.*?)#{cel_prefix}([0-9 .-]+)/, 1]
    tmp_cel.delete!('-') if tmp_cel
    tmp_cel.delete!(' ') if tmp_cel
    tmp_cel
  end

  def mails_and_webs
    data = @line.match(/(?:#{mail_prefix})\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/)
    return nil unless data

    mails = data[1..4].select { |d| d =~ /@/ }
    webs = data[1..4].select { |d| d =~ /www/ }
    [mails.join(' '), webs.join(' ')]
  end

  def desc
    m = @line[/(?:#{mail_prefix})\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/, 1]
    return @line.partition(m[1..4].keep_if { |d| d =~ /@|www/ }.last)[2] if m

    cell = @line[/^(?:.*?)#{cel_prefix}([0-9 .-]+)/, 1]
    return @line.partition(cell)[2] if cell

    phone = @line[/^(?:.*?)#{tel_prefix}([0-9 .-]+)/, 1]
    @line.partition(phone)[2] if phone
  end

  private

  def fax_prefix
    "(?:Fax\s*(?:[:.])?)"
  end

  def tel_prefix
    "(?:Tel\s*(?:(?:&|\/)\s*[Ff]ax)?\s*(?:[:.])?)"
  end

  def cel_prefix
    "(?:[Cc]ell\s*(?:[:.])?)"
  end

  def web_regexp
    "www\.\S+\.\S+"
  end

  def mail_prefix
    "[Ee](?:[- ])?[Mm]ail\s*(?:[:.])?\s*"
  end

  def mail_regexp
    '[^@\s]+@\S+'
  end
end

class CountryScraper
  def initialize(fin, fout)
    @fin = fin
    @fout = File.new(fout)
    @previous_line, @in_farm_list, @farm_info, @region = nil, false, nil, nil
  end

  def scrap!
    @fout.write('Region,Name,Phone,Mails,Websites,Description')

    IO.foreach(@fout) do |line|
      if line =~ /^Coordinator/
        @region = previous_line.chomp.capitalize
        @in_farm_list = false
      end

      @previous_line = line

      @in_farm_list = true if line =~ /^1. /
      next unless @in_farm_list

      if line =~ /^\d+\. (.*)$/
        if @farm_info
          farm_scraper = FarmScraper.new(@farm_info.join(' '))
          name = farm_scraper.name
          phone = farm_scraper.phone || farm_scraper.cel
          mails, webs = farm_scraper.mails_and_webs
          desc = farm_scraper.desc.try(:strip)

          fout.write "#{region},#{name},#{phone},#{mails},#{webs},#{desc}"
        end

        @farm_info = [Regexp.last_match[1].chomp]
      else
        @farm_info << line.chomp
      end
    end
  end
end

namespace :scrapers do
  desc 'Scrapes France Wwoofing list'
  task :france do
    CountryScraper.new(ARGV[0], 'france-list.cvs').scrap!
  end
end
