# frozen_string_literal: true

require File.expand_path('../../config/environment', __dir__)

require 'ynab_transaction'
require 'ynab'

module YNAB
  class Interface
    def get_bill_pay_transactions
      categories_resp = api.categories.get_categories(budget_id)
      category_groups = categories_resp.data.category_groups

      categories = category_groups.flat_map(&:categories)
                                  .select { |cat| cat.goal_type == 'MF' }

      categories.flat_map do |cat|
        api.transactions
           .get_transactions_by_category(budget_id, cat.id, since_date: Time.now - 4.weeks)
           .data
           .transactions
           .map do |t|
             YnabTransaction.new(
               date: t.date,
               category: cat.name,
               payee: t.payee_name,
               amount: t.amount
             )
           end
      end
    end

    protected

    def api
      YNAB::API.new(access_token)
    end

    def access_token
      ENV['YNAB_TOKEN']
    end

    def budget_id
      ENV['YNAB_BUDGET_ID']
    end
  end
end
