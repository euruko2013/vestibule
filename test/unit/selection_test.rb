require 'test_helper'

class SelectionTest < ActiveSupport::TestCase
	context "validations" do
		setup do
			@selection = FactoryGirl.build(:selection)
		end

    should "be valid" do
      assert @selection.valid?
    end

    should "validate position in 1..10" do
      [1,4,10].each do |i|
        @selection.position = i
        assert @selection.valid?
      end
      [0,-1,11,20].each do |i|
        @selection.position = i
        assert @selection.invalid?
      end
    end

    should "validate presence of user" do
      @selection.user = nil
      assert @selection.invalid?
    end

    should "validate presence of proposal" do
      @selection.proposal = nil
      assert @selection.invalid?
    end

    should "validate uniqueness of user and proposal" do
      @selection.save!
      another_selection = FactoryGirl.build(:selection, user_id: @selection.user_id, proposal_id: @selection.proposal_id, position: 2)
      assert another_selection.invalid?
      another_selection.proposal = FactoryGirl.create(:proposal)
      assert another_selection.valid?
    end

    should "validate uniq position per user" do
      @selection.save!
      another_selection = FactoryGirl.build(:selection, user_id: @selection.user_id, position: @selection.position)
      assert another_selection.invalid?
      another_selection.position += 1
      assert another_selection.valid?
    end
	end
end
