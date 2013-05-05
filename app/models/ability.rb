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

    if phase.selection_allowed? || phase.selection_completed?
      can [:see_nominations, :see_stats], Proposal
      can [:selections], User do |user|
        user.publish_selections?
      end
    end

    if !phase.anonymous?
      can [:see_proposer], Proposal
    end

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

      if phase.new_suggestions_allowed?
        can [:create], Suggestion, :author_id => user.id
      end

      if phase.selection_allowed?
        can [:create], Selection
      end

      if user.moderator?
        can :update, Suggestion
        can :see, :moderator_dashboard
        can :selections, User
      end

      if phase.voting_allowed?
        can [:vote], Proposal
        cannot [:vote], Proposal, :proposer_id => user.id
      end
    end
  end
end
