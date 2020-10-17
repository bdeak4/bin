require 'open-uri'
require 'digest/sha2'
require 'net/smtp'
require "pony"

class MonitorWebpageJob < ApplicationJob
  queue_as :default

  def perform
    users = User.all
    users.each do |user|
      modified = []
      user.webpages.each do |webpage|
        next if !webpage.url
        html = URI.open(webpage.url).read
        if webpage.element
          doc = Nokogiri::HTML(html)
          elements = doc.css(webpage.element)
          html = elements.text
        end
        elements_hash = Digest::SHA2.hexdigest html

        if elements_hash != webpage.elements_hash
          modified.push(webpage.url)
          webpage.update_attribute(:elements_hash, elements_hash)
        end
      end

      if modified.any?
        Pony.mail(:to => user.email, :from => 'robot@bdeak.net', :subject => '[webmonitor] new changes', :body => modified.join('\n'))
      end
    end
  end
end
