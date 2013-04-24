class Ability
  include CanCan::Ability

  # See the wiki for how to define abilities:
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user, phase = Phase.current)
    user ||= User.new

    # Everyone
    can :see, :index
    can :see, :motivation
    can :see, :about
    can :create, :session
    can :read, User
    can :read, Proposal

    # Registered users
    if user.persisted?
      can :destroy, :session

      can :see, :dashboard
      can :see, :my_motivation
      can [:update], User, :id => user.id

      if phase.new_submissions_allowed?
        can [:create], Proposal, :proposer_id => user.id
      end

      if phase.submission_editing_allowed?
        can [:update], Proposal, :proposer_id => user.id
      end

      if phase.submission_withdrawal_allowed?
        can [:withdraw, :republish], Proposal, :proposer_id => user.id
      end

      can [:see_votes], Proposal, :proposer_id => user.id

      if phase.new_suggestions_allowed?
        can [:create], Suggestion, :author_id => user.id
      end

      if user.moderator?
        can :update, Suggestion
        can :update, Proposal
        can :see, :moderator_dashboard
      end

      if phase.voting_allowed?
        can [:vote], Proposal
        cannot [:vote], Proposal, :proposer_id => user.id
      end
    end
  end
end
