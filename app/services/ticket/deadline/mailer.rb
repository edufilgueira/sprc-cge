class Ticket::Deadline::Mailer
    def self.call
      new.call
    end
    
    def call
      DeadlineMailer.result.deliver
    end
end