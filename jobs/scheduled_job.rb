require 'rubygems'
require 'action_mailer'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  :username => "getitdon",
  :password => "getitdon",
  :database => "gtd_production",
#  :username => "root",
#  :password => "",
#  :database => "gtd_development"
  :socket => "/var/run/mysqld/mysqld.sock"
  
)

class ListItem < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  has_many :list_items, :order => :position
end

class ActionItem < ActiveRecord::Base
end

ActiveRecord::Base.logger =  Logger.new(STDOUT)

ActionMailer::Base.smtp_settings = {
  :address => "custommode.com", # your email server here
  :port => 25,
  :domain => 'custommode' # This is the name which will be given to the email server during the HELO
#  :user_name => '',
#  :password => ''
}


# setting up the root of the template so that ActionMailer will know where to find the ERB template
class StandAloneEmailSender < ActionMailer::Base
  def notify_list_item(list_item)
    subject  "List Item Notification"
    recipients  [list_item.user.email]
    from  "notify@custommode.com" 
    body  'List Item ' + list_item.description + ' is due ' + list_item.remind_at.to_s 
  end
  def notify_action_item(action_item)
    subject  "Action Item Notification"
    recipients  [action_item.list_item.user.email]
    from  "notify@custommode.com" 
    body  'Action Item ' + action_item.description + ' is due ' + action_item.remind_at.to_s 
  end
end


#find all list_items that requre notification and notify
now = Time.now
ListItem.find(:all,
  :conditions => ["remind_at > :remind_hi and remind_at < :remind_low" , {:remind_hi => now, :remind_low => now + 15*60 }]
  ).each do |i|
  # creating a class by subclassing ActionMailer
  puts "sending list_item notify"
  StandAloneEmailSender.deliver_notify_list_item i
end
#find all action items that require notification and notify
ActionItem.find(:all,
  :conditions => ["remind_at > :remind_hi and remind_at < :remind_low" , {:remind_hi => now, :remind_low => now + 15*60 }]
  ).each do |i|
  # creating a class by subclassing ActionMailer
  puts "sending action_item notify"
  StandAloneEmailSender.deliver_notify_action_item i
end

#find all list items that are done and not in the completed list and move it to completed list
completed_list_item_type = 6
puts  now - 1*24*60*60
ListItem.find(:all,
  :conditions => ["list_type_id != :list_type_id and done_at <= :done_at" , 
    {:list_type_id => completed_list_item_type, :done_at => now - 1*24*60*60 }]
  ).each do |i|
  # creating a class by subclassing ActionMailer
  puts "moving to completed list"
  i.list_type_id = completed_list_item_type
  i.save
end