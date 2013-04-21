class Phase
  def self.current
    now = DateTime.now
    all.detect { |phase| now >= phase.starting_at && now < phase.ending_at }
  end

  def self.all
    [ZERO, ONE, INTERLUDE, TWO, CONFIRMATION, LINEUP]
  end

  attr_accessor :starting_at
  attr_accessor :ending_at

  attr_accessor :new_submissions_allowed
  alias_method :new_submissions_allowed?, :new_submissions_allowed

  attr_accessor :submission_editing_allowed
  alias_method :submission_editing_allowed?, :submission_editing_allowed

  attr_accessor :new_suggestions_allowed
  alias_method :new_suggestions_allowed?, :new_suggestions_allowed

  attr_accessor :voting_allowed
  alias_method :voting_allowed?, :voting_allowed

  attr_accessor :submission_withdrawal_allowed
  alias_method :submission_withdrawal_allowed?, :submission_withdrawal_allowed

  ZERO = Phase.new.tap do |p|
    p.starting_at = DateTime.new(1970, 1, 1)
    p.ending_at = DateTime.parse('2013-03-28T00:00:00+2')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = false
    p.new_suggestions_allowed = false
    p.submission_withdrawal_allowed = false
  end.freeze

  ONE = Phase.new.tap do |p|
    p.starting_at = DateTime.parse('2013-03-28T00:00:00+2')
    p.ending_at = DateTime.parse('2013-04-24T00:00:00+3')

    p.new_submissions_allowed = true
    p.submission_editing_allowed = true
    p.voting_allowed = true
    p.new_suggestions_allowed = true
    p.submission_withdrawal_allowed = true
  end.freeze

  INTERLUDE = Phase.new.tap do |p|
    p.starting_at = DateTime.parse('2013-04-24T00:00:00+3')
    p.ending_at = DateTime.parse('2013-04-29T00:00:00+3')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = true
    p.new_suggestions_allowed = false
    p.submission_withdrawal_allowed = true
  end.freeze

  TWO = Phase.new.tap do |p|
    p.starting_at = DateTime.parse('2013-04-29T00:00:00+3')
    p.ending_at = DateTime.parse('2013-05-06T00:00:00+3')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = false
    p.new_suggestions_allowed = false
    p.submission_withdrawal_allowed = true
  end.freeze

  CONFIRMATION = Phase.new.tap do |p|
    p.starting_at = DateTime.parse('2013-05-06T00:00:00+3')
    p.ending_at = DateTime.parse('2013-05-09T00:00:00+3')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = false
    p.new_suggestions_allowed = false
    p.submission_withdrawal_allowed = true
  end.freeze

  LINEUP = Phase.new.tap do |p|
    p.starting_at = DateTime.parse('2013-05-09T00:00:00+3')
    p.ending_at = DateTime.parse('2100-01-01T00:00:00+2')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = false
    p.new_suggestions_allowed = false
    p.submission_withdrawal_allowed = false
  end.freeze
end