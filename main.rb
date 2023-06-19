require 'json'

class Person
    attr_accessor :name
  
    def initialize(name)
      @name = name
    end
  
    def valid_name?
      @name.match?(/\A[a-zA-Z ]+\z/)
    end
  end
  
  module Contactable
    def self.contact_details(email, mobile)
      "#{email} | #{mobile}"
    end
  end
  
  class User < Person
    attr_accessor :email, :mobile
  
    def initialize(name, email, mobile)
      super(name)
      @email = email
      @mobile = mobile
    end
  
    def self.valid_mobile?(mobile)
      mobile.match?(/\A0\d{10}\z/)
    end
    def create
        if !valid_name?
        puts "Invalid Name"
        return false
        elsif !self.class.valid_mobile?(mobile)
        puts "Invalid Phone Number"
        return false
        else
        user_data = {name: name, email: email, mobile: mobile}
        users = User.read_users_from_file
        users << user_data
        User.write_users_to_file(users)
        puts "Login Scsessfuly mr / miss, #{name}."
        return self
        end
    end
    def self.list(n = nil)
      users = read_users_from_file
      if n.nil?
        users.each {|user| puts "#{user["name"]} | #{Contactable.contact_details(user["email"], user["mobile"])}"}
      else
        users.first(n).each {|user| puts "#{user["name"]} | #{Contactable.contact_details(user["email"], user["mobile"])}"}
      end
    end
  
    private
  
    def self.read_users_from_file
      if File.exist?('user.json')
        JSON.parse(File.read('user.json'))
      else
        []
      end
    end
  
    def self.write_users_to_file(users)
      File.write('user.json', JSON.pretty_generate(users))
    end
  end
 puts "Please Enter Your Name:"
 name = gets.chomp

 puts " Enter Your Email Address:"
 email = gets.chomp

 puts " Enter Your Mobile Phone:"
 mobile = gets.chomp

 user = User.new(name, email, mobile)
 user.create
puts " Enter * To List Our User Or Number :"
input = gets.chomp

if input == "*"
  User.list
elsif input.match?(/\A\d+\z/)
  User.list(input.to_i)
else 
  puts "Invalid Data ! Please enter '*' or number"
end