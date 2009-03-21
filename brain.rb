require 'iconv'
require 'ldap'
require 'pp'
require 'yaml'
require 'builder'
#config parsing
$config = YAML::load_file 'config.yaml'
$config[:port]=LDAP::LDAP_PORT if $config[:port]==nil
#define search params
$scope = LDAP::LDAP_SCOPE_SUBTREE
$filter = '(&(objectCategory=Person)(company=*))'#company name must be not nil
$attrs = ['objectClass',#class
  'userAccountControl','description',#blocked? (66048 if not blocked)
  'sn','givenName',#фамилия,имя отчество
  'company','department','title',#...
  'telephoneNumber','mobile','pager','mail',]#внутр, сот, быстр, мыло

#small mixin
class String
  def win2utf
    return (Iconv::iconv 'utf8','cp1251',self)[0] if defined? self
    return self
  end
  def utf2win
    return (Iconv::iconv 'cp1251','utf8')[0] if defined? self
    return self
  end
end

class Array
  def swap! a, b
    a = (self.size-1) if a>=self.size
    b = (self.size-1) if b>=self.size
    self[a], self[b] = self[b], self[a]
    self
  end
end

class Hash
  def ordered_arrays order
    keys=self.keys
    values=self.values
    order.each{|key,pos|
      i=keys.index key
      unless i == nil
        keys.swap! i, pos
        values.swap! i,pos
      end
    } if order!=nil
    return keys,values
  end
end

#fetching ldap search results to noraml hash
def fetch_entry entry
  res = Hash.new
  res[:desc]        = entry['description']!=nil ? entry['description'][0] : '-'
  res[:firstname]   = entry['givenName']!=nil ? entry['givenName'][0].win2utf : '-'
  res[:lastname]    = entry['sn']!=nil ? entry['sn'][0].win2utf : '-'
  res[:company]     = entry['company'][0].win2utf
  res[:department]  = entry['department']!=nil ? entry['department'][0].win2utf : '-'
  res[:title]       = entry['title']!=nil ? entry['title'][0].win2utf : '-'
  res[:intphone]    = entry['telephoneNumber']!=nil ? entry['telephoneNumber'][0] : '-'
  res[:mobile]      = entry['mobile']!=nil ? entry['mobile'][0] : '-'
  res[:speed]       = entry['pager']!=nil ? entry['pager'][0] : '-'
  res[:email]       = entry['mail']!=nil ? entry['mail'][0] : '-'
  res[:semail]      = entry['mail']!=nil ? entry['mail'][0].slice(0..19) : '-'
  return res
end

#parsing contact to phonebook hash
def parse_entry! contact,hash
  company = contact[:company]
  dep     = contact[:department]
  title   = contact[:title]
  type    = contact[:desc]=='fax' ? :fax : :human
  hash[company]=Hash.new if hash[company]==nil
  hash[company][dep]=Hash.new if hash[company][dep]==nil
  if type == :fax
    hash[company][dep][:fax]=contact
  else
    hash[company][dep][title]=Array.new if hash[company][dep][title]==nil
    hash[company][dep][title].push contact
  end
end

def make_search
  hash = Hash.new
  begin#connecting to ldap and binding with it
    LDAP::Conn.new($config[:host],$config[:port]).bind($config[:admin_dn],$config[:admin_pswd]) { |conn|
      begin
        begin#searching for people
          conn.search2($config[:base], $scope, $filter, $attrs) { |entry|
            #processing search results
            parse_entry!(fetch_entry(entry), hash)
          }
        rescue LDAP::ResultError
          conn.perror("Parsing error: search")
          exit
        end
      rescue => err#fail
        conn.perror("Parsing error: bind. #{err}")
        exit
      end
    }
  rescue#connect or bind failed
    puts 'Connection and binding failed'
    exit
  end
  return hash
end

def save_xml hash, output, stylesheet
  pp output
  out=File.new output,'w'
  xml=Builder::XmlMarkup.new(:target=>out,:indent => 2)
  xml.instruct!
  xml.instruct! 'xml-stylesheet', 'type'=>"text/xsl",'href'=>stylesheet
  xml.blackbook do
    companys,deps = hash.ordered_arrays $config[:companys]
    companys.each do |c|
      puts "Adding hell: #{c}"
      departments,tits = deps[companys.index(c)].ordered_arrays $config[:departments]
      xml.tag!("company","name"=>c) do
        departments.each do |d|
          puts "\tAdding department: #{d}"
          titles,conts = tits[departments.index(d)].ordered_arrays $config[:titles]
          xml.tag!("dep","name"=>d) do
            titles.each do |t|
              contacts=conts[titles.index(t)]
              puts "\t\tAdding job title #{t}"
              if t == :fax
                xml.fax {
                  xml.name  contacts[:firstname]
                  xml.value contacts[:intphone]
                }
              else
                xml.title('name'=>t) {
                  contacts.each{|contact|
                    xml.human {
                      xml.firstname contact[:firstname]
                      xml.lastname  contact[:lastname]
                      xml.intphone  contact[:intphone]
                      xml.mobile    contact[:mobile]
                      xml.speed     contact[:speed]
                      xml.email     contact[:email]
                      xml.semail    contact[:semail]
                    }
                  }
                }
              end
            end
          end
        end
      end
    end
  end
  out.close
end