#
# Copyright (c) 2013 figo GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require "flt"
require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require_relative "../lib/figo"

class FigoTest < MiniTest::Unit::TestCase
  def setup
    @sut = Figo::Session.new(CONFIG["ACCESS_TOKEN"])
  end

  ##   Accounts
  # Retrieve Bank Account
  def test_retrieve_bank_account
    account = @sut.get_account "A1.2"
    assert_equal account.account_id, "A1.2"
  end

  # Retrieve all Bank Accounts
  def test_retreive_all_bank_accounts
    accounts = @sut.accounts
    assert accounts.length > 0
  end

  # Retrieve Bank Account Balance and Limits
  def test_retreive_bank_account_balance_and_limits
    assert @sut.get_account_balance("A1.2")
  end

  # Modify Bank Account
  def test_modify_bank_account
    account = @sut.get_account "A1.2"
    account.name = "new name"

    execption = assert_raises(Figo::Error) { @sut.modify_account account }
    assert "Missing, invalid or expired access token.", execption.message
    # @sut.modify_account account

    # modified_account = @sut.get_account "A1.2"
    # assert_equal modified_account.name "new name"
  end

  # Set Bank Account Sort Order
  def test_set_account_sort_order
    accounts = @sut.accounts
    execption = assert_raises(Figo::Error) { @sut.account_sort_order(accounts) }
    assert "Missing, invalid or expired access token.", execption.message

    # assert @sut.account_sort_order(accounts)
  end

  # Delete bank account
  def test_delete_bank_account
    execption = assert_raises(Figo::Error) { @sut.remove_account("A1.2") }
    assert "Missing, invalid or expired access token.", execption.message

    # assert_nil @sut.remove_account("A1.2")
  end

  # Modify Bank Account Credit Line and Limits
  def test_modify_bank_account_credit_line_and_limits
    old_balance = @sut.get_account_balance("A1.2")
    balance = old_balance.clone

    balance.balance = 1

    execption = assert_raises(Figo::Error) { @sut.modify_account_balance("A1.2", balance) }
    assert "Missing, invalid or expired access token.", execption.message
    # new_balance = @sut.modify_account_balance("A1.2", balance)

    # assert old_balance.balance != new_balance.balance
  end

  # Remove Stored Pin from Bank Account
  def test_remove_pin_from_bank_account

    new_bank_info = Figo::Bank.new(@sut, {bank_id: "B1.1", sepa_creditor_id: "DE02ZZZ0123456789", save_pin: true})

    execption = assert_raises(Figo::Error) { @sut.remove_bank_pin(new_bank_info) }
    assert "Missing, invalid or expired access token.", execption.message

    # assert_nil @sut.remove_bank_pin(new_bank_info)
  end
end
