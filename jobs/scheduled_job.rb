require 'rubygems'
require 'action_mailer'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
#  :username => "getitdon",
#  :password => "getitdon",
#  :database => "gtd_production"
  :username => "root",
  :password => "",
  :database => "gtd_development"
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
ActionMailer::Base.template_root = "."
class StandAloneEmailSender < ActionMailer::Base
  def notify_list_item(list_item)
    subject  "List Item Notification"
    recipients  [list_item.user.email]
    from  "notify@custommode.com" 
    body  'List Item ' + list_item.description + ' is due ' + list_item.remind_at.to_s 
  end
end


#find all list_items that requre notification and notify
ListItem.find(:all).each do |i|
  puts "Processing item " + i.id.to_s
  # creating a class by subclassing ActionMailer

  StandAloneEmailSender.deliver_notify_list_item i
  
  
end
#find all action items that require notification and notify

#find all list items that are done and not in the completed list and move it to completed list