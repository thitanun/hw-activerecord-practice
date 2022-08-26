require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where(first: 'Candice')
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where('email LIKE ?', '%@%')
  end

  def self.with_dot_org_email
    Customer.where('email LIKE ?', '%.org%')
  end
  
  def self.with_invalid_email
    Customer.where('email not LIKE ?', '%@%')
  end

  def self.with_blank_email
    Customer.where(email: nil)
  end

  def self.born_before_1980
    #Customer.where('birthdate < ?', Date.strptime('1980-01-01', '%Y-%m-%d'))
    Customer.where("birthdate < '1980-01-01'")
  end

  def self.with_valid_email_and_born_before_1980
    #Customer.where("email LIKE '%@%' and birthdate < ?", Date.strptime('1980-01-01', '%Y-%m-%d'))
    #Customer.where("email LIKE ? and birthdate < ?", '%@%', Date.strptime('1980-01-01', '%Y-%m-%d'))
    Customer.where("email LIKE '%@%' and birthdate < '1980-01-01'")
  end

  def self.last_names_starting_with_b
    Customer.where('last LIKE ?','B%').order(birthdate: :asc)
    #Customer.where('last LIKE ?','b%').order(birthdate: :asc)
  end
  
  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    #Customer.find_by("first ='Gussie'AND last ='Murray'").update(birthdate: Time.parse('2004-02-09'))
    #Time.zone = "UTC"
    #Customer.find_by(first: 'Gussie', last: 'Murray').update(birthdate: Time.zone.parse('2004-02-08'))
    #Customer.find_by(first: 'Gussie', last: 'Murray').update(birthdate: Time.parse('2004-02-08').change(offset: "UTC"))
    #Customer.find_by(first: 'Gussie', last: 'Murray').update(birthdate: Date.strptime('2004-02-08', '%Y-%m-%d'))
    #Customer.find_by(first: 'Gussie', last: 'Murray').update(birthdate: '2004-02-08')
    Customer.find_by(first: 'Gussie', last: 'Murray').update(birthdate: Time.find_zone("UTC").parse('2004-02-08'))
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where('email not LIKE ?', '%@%').update(email: nil)
  end

  def self.delete_meggie_herman
    Customer.find_by(first: 'Meggie', last: 'Herman').update(first: nil, last: nil)
    #Customer.find_by(first: 'Meggie', last: 'Herman').delete()
  end
  
  def self.delete_everyone_born_before_1978
    #Customer.where("birthdate < ?", Date.strptime('1980-01-01', '%Y-%m-%d')).delete_all()
    Customer.where("birthdate < '1978-01-01'").delete_all()
  end
  # etc. - see README.md for more details
end
