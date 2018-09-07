# frozen_string_literal: true

require File.expand_path('../../config/environment', __dir__)

require 'bank_transaction'
require 'watir'
require 'webdrivers'
require 'date'

module Ally
  class Interface
    def transactions
      Enumerator.new do |enum|
        browser = Watir::Browser.new :chrome,
                                     switches: %w[ --headless
                                                   --disable-gpu --no-sandbox
                                                   --disable-prompt-on-repost
                                                   --windows-size=3200x1800]

        browser.goto 'https://secure.ally.com/'
        browser.text_field(id: 'login-username').set ENV['ALLY_USER']
        browser.text_field(id: 'login-password').set ENV['ALLY_PASSWORD']
        browser.button(type: 'submit').click

        Watir::Wait.until { browser.title.include? 'Dashboard' }

        # Navigate to transfers page
        browser.link(text: 'Transfers').click
        Watir::Wait.until { browser.title.include? 'Make Transfer' }

        # Open activity tab
        browser.link(text: 'Activity').click
        Watir::Wait.until { browser.title.include? 'Activity' }

        history_table = browser.p(text: 'History').next_sibling

        rows = history_table.tbody.trs(id: /.*_ActivityTr/)

        rows.each do |row|
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
          enum << transaction
        end
      rescue StandardError => ex
        p ex
        browser.screenshot.save 'error.png'
      ensure
        browser&.quit
      end
    end
  end
end
