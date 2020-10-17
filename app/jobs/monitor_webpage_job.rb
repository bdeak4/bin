require 'open-uri'
require 'digest/sha2'
require 'net/smtp'
require "pony"

class MonitorWebpageJob < ApplicationJob
  queue_as :default

  def perform(user)
    modified = []
    user.webpages.each do |webpage|
      doc = Nokogiri::HTML(URI.open(webpage.url).read)
      elements = doc.css(webpage.element)
      elements_hash = Digest::SHA2.hexdigest elements.text

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
