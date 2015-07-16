require "./contact"
require "yaml"

class AddressBook
  attr_reader :contacts

  def initialize
    @contacts = []
  end

  def print_contact_list
    puts "Contact List"
    contacts.each do |contact|
      puts contact.to_s('last_first')
    end
  end

  def find_by_name(name)
    results = []
    search = name.downcase
    contacts.each do |contact|
    if contact.full_name.downcase.include?(search)
        results.push(contact)
      end
    end
    puts "Name search results (#{search})"
    results.each do |contact|
      puts contact.to_s('full_name')
      contact.print_phone_numbers
      contact.print_addresses
      puts "\n"
    end
  end 
  
  def find_by_phone_number(number)
    results = []
    search = number.gsub("-", "")
    contacts.each do |contact|
      contact.phone_numbers.each do |phone_number|
        if phone_number.number.gsub("-", "").include?(search)
          results.push(contact) unless results.include?(contact)
        end
      end
    end
    print_results("Phone search results (#{search})", results)
  end


  def print_results(search, results)
    puts search
    results.each do |contact|
      puts contact.to_s('full_name')
      contact.print_phone_numbers
      contact.print_addresses
      puts "\n"
    end
  end

  def find_by_address(query)
    results = []
    search = query.downcase
    contacts.each do |contact|
      contact.addresses.each do |address|
        if address.to_s('long').downcase.include?(search)
          results.push(contact) unless results.include?(contact)
        end
      end
    end
    print_results("Address search results (#{search})", results)
  end

  def open
    if File.exist?("contacts.yml")
      @contacts = YAML.load_file("contacts.yml")
    end
  end

  def save
    File.open("contacts.yml", "w") do |file|
      file.write(contacts.to_yaml)
    end
  end


  def run
    loop do
      puts "Address Book"
      puts "a: Add Contact"
      puts "p: Print Address Book"
      puts "s: Search"
      puts "e: Exit"
      print "Enter your choice: "
      input = gets.chomp.downcase
      case input
      when 'a'
        add_contact
      when 'p'
        print_contact_list
      when 's'
        print "Search term: "
        search = gets.chomp
        find_by_name(search)
        find_by_phone_number(search)
        find_by_address(search)
      when 'e'
         save()
         break  
      end
      puts "\n"
    end
  end

  def add_contact
    contact = Contact.new
    print "First name: "
    contact.first_name = gets.chomp
    print "Middle name: "
    contact.middle_name = gets.chomp
    print "Last name: "
    contact.last_name = gets.chomp

    loop do
      puts "Add phone number or address? "
      puts "p: Add phone number"
      puts "a: Add address"
      puts "(Any other key to go back)"
      response = gets.chomp.downcase
      case response
      when 'p'
        phone = PhoneNumber.new
        print "Phone number kind (Home, Work, etc): "
        phone.kind = gets.chomp
        print "Number: "
        phone.number = gets.chomp
        contact.phone_numbers.push(phone)
      when 'a'
        address = Address.new
        print "Address Kind (Home, Work, etc): "
        address.kind = gets.chomp
        print "Address line 1: "
        address.street_1 = gets.chomp
        print "Address line 2: "
        address.street_2 = gets.chomp
        print "City: "
        address.city = gets.chomp
        print "State: "
        address.state = gets.chomp
        print "Postal Code: "
        address.postal_code = gets.chomp
        contact.addresses.push(address)
      else
        print "\n"
        break
      end
    end

    contacts.push(contact)
  end

end




address_book = AddressBook.new

# jason = Contact.new
# jason.first_name = "Jason"
# jason.last_name = "Seifer"
# jason.add_phone_number("Home", "123-456-7890")
# jason.add_phone_number("Work", "456-789-0123")
# jason.add_address("Home", "123 Main St.", "", "Portland", "OR", "12345")

# nick = Contact.new
# nick.first_name = "Nick"
# nick.last_name = "Pettit"
# nick.add_phone_number("Home", "222-222-2222")
# nick.add_address("Home", "222 Two Lane", "", "Portland", "OR", "12345")

# address_book.contacts.push(jason)
# address_book.contacts.push(nick)

# address_book.print_contact_list

# address_book.find_by_name("e")

# address_book.find_by_phone_number("2")
address_book.run