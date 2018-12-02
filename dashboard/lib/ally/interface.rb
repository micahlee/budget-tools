# frozen_string_literal: true

require File.expand_path('../../config/environment', __dir__)

require 'bank_transaction'
require 'watir'
require 'webdrivers'
require 'date'

module Ally
  class Interface
    def transactions(event_handler=nil)
      Enumerator.new do |enum|
        event_handler.call("Creating browser") if event_handler
        browser = Watir::Browser.new :chrome,
                                     switches: %w[ --headless
                                                   --disable-gpu --no-sandbox
                                                   --disable-prompt-on-repost
                                                   --windows-size=3200x1800]

        event_handler.call("Navigating to Ally") if event_handler
        browser.goto 'https://secure.ally.com/'
        
        event_handler.call("Logging in") if event_handler
        browser.text_field(id: 'login-username').set ENV['ALLY_USER']
        browser.text_field(id: 'login-password').set ENV['ALLY_PASSWORD']
        browser.button(type: 'submit').click

        Watir::Wait.until { browser.title.include? 'Dashboard' }

        # Navigate to transfers page
        event_handler.call("Navigating to transfers page") if event_handler
        browser.link(text: 'Transfers').click
        Watir::Wait.until { browser.title.include? 'Make Transfer' }

        # Open activity tab
        event_handler.call("Opening activity tab") if event_handler
        browser.link(text: 'Activity').click
        Watir::Wait.until { browser.title.include? 'Activity' }

        history_table = browser.p(text: 'History').next_sibling

        rows = history_table.tbody.trs(id: /activity-row-.*/)

        rows.each do |row|
          event_handler.call(row.html) if event_handler
          date = row.td(name: 'activityDeliveryDate').text
          date = Date.strptime(date, '%b %d, %Y')
          accounts = row.spans(class: 'activity-account-link')
          to = accounts[0].text[/To ([^\*]*) [\*\d]+/, 1]
          from = accounts[1].text[/From ([^\*]*) [\*\d]+/, 1]
          amount = row.tds[2].text.gsub(/[^\d]/, '').to_i * 10

          # Expand panel to get details
          expand_link = row.tds[1].a
          expand_link.click

          Watir::Wait.until { row.next_sibling.text.include? 'Transfer Status' }

          note = ''
          if row.next_sibling.span(class: 'memo-multiline-block').exist?
            note = row.next_sibling.span(class: 'memo-multiline-block').text
          end

          transaction = BankTransaction.new(date: date, to_acct: to, from_acct: from, amount: amount, memo: note)
          event_handler.call("DBG: transaction=#{transaction}") if event_handler
          enum << transaction
        end
      rescue StandardError => ex
        browser&.screenshot&.save 'error.png'
        raise ex
      ensure
        browser&.quit
      end
    end
  end
end
