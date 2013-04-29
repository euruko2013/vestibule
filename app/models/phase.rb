class Phase
  def self.current
    now = DateTime.now
    all.detect { |phase| now >= phase.starting_at && now < phase.ending_at }
  end

  def self.all
    [ZERO, ONE, INTERLUDE, TWO, CONFIRMATION, LINEUP]
  end

  def self.last_submission_date
    ONE.ending_at
  end

  def self.last_voting_date
    INTERLUDE.ending_at
  end

  attr_accessor :name

  attr_accessor :main_text
  attr_accessor :countdown_text

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

  attr_accessor :selection_allowed
  alias_method :selection_allowed?, :selection_allowed

  attr_accessor :anonymous
  alias_method :anonymous?, :anonymous

  attr_accessor :submission_withdrawal_allowed
  alias_method :submission_withdrawal_allowed?, :submission_withdrawal_allowed

  ZERO = Phase.new.tap do |p|
    p.name = "Before the beginning"
    p.main_text = "Be part of #{Settings.event_name}: we highly encourage you to submit as many proposals as you want, help the authors make theirs better and finally select the most interesting ones for the final agenda! What are you waiting for?"
    p.countdown_text = "before the submissions open!"
    p.starting_at = DateTime.new(1970, 1, 1)
    p.ending_at = DateTime.parse('2013-03-28T00:00:00+2')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = false
    p.new_suggestions_allowed = false
    p.selection_allowed = false
    p.anonymous = true
    p.submission_withdrawal_allowed = false
  end.freeze

  ONE = Phase.new.tap do |p|
    p.name = "Phase 1: Submissions"
    p.main_text = "Be part of #{Settings.event_name}: we highly encourage you to submit as many proposals as you want, help the authors make theirs better and finally select the most interesting ones for the final agenda! What are you waiting for?"
    p.countdown_text = "to submit, refine and discuss proposals!"
    p.starting_at = DateTime.parse('2013-03-28T00:00:00+2')
    p.ending_at = DateTime.parse('2013-04-24T00:00:00+3')

    p.new_submissions_allowed = true
    p.submission_editing_allowed = true
    p.voting_allowed = true
    p.new_suggestions_allowed = true
    p.selection_allowed = false
    p.anonymous = true
    p.submission_withdrawal_allowed = true
  end.freeze

  INTERLUDE = Phase.new.tap do |p|
    p.name = "Interlude"
    p.main_text = "Make it <em>your</em> #{Settings.event_name}: select the finalists before the grand voting! We highly encourage you to go through every single proposal select the most interesting ones. After all, this is what the conference is all about! What are you waiting for?"
    p.countdown_text = "to cast your votes that will define the finalists!"
    p.starting_at = DateTime.parse('2013-04-24T00:00:00+3')
    p.ending_at = DateTime.parse('2013-04-29T00:00:00+3')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = true
    p.new_suggestions_allowed = false
    p.selection_allowed = false
    p.anonymous = true
    p.submission_withdrawal_allowed = true
  end.freeze

  TWO = Phase.new.tap do |p|
    p.name = "Phase 2: Final voting"
    p.main_text = "This is it! This is the time you define #{Settings.event_name}! Make <strong>your</strong> ideal lineup."
    p.countdown_text = "to define the conference schedule!"
    p.starting_at = DateTime.parse('2013-04-29T00:00:00+3')
    p.ending_at = DateTime.parse('2013-05-06T00:00:00+3')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = false
    p.new_suggestions_allowed = false
    p.selection_allowed = true
    p.anonymous = false
    p.submission_withdrawal_allowed = true
  end.freeze

  CONFIRMATION = Phase.new.tap do |p|
    p.name = "Speakers confirmation"
    p.main_text = ""
    p.starting_at = DateTime.parse('2013-05-06T00:00:00+3')
    p.ending_at = DateTime.parse('2013-05-09T00:00:00+3')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = false
    p.new_suggestions_allowed = false
    p.selection_allowed = false
    p.anonymous = false
    p.submission_withdrawal_allowed = true
  end.freeze

  LINEUP = Phase.new.tap do |p|
    p.name = "Lineup announcement"
    p.main_text = ""
    p.starting_at = DateTime.parse('2013-05-09T00:00:00+3')
    p.ending_at = DateTime.parse('2100-01-01T00:00:00+2')

    p.new_submissions_allowed = false
    p.submission_editing_allowed = false
    p.voting_allowed = false
    p.new_suggestions_allowed = false
    p.selection_allowed = false
    p.anonymous = false
    p.submission_withdrawal_allowed = false
  end.freeze
end