class InfluencerPayment < ActiveRecord::Base
  # ----------------------------------------------------------------------
  # == Include Modules == #
  # ----------------------------------------------------------------------


  # ----------------------------------------------------------------------
  # == Constants == #
  # ----------------------------------------------------------------------

  enum status: [:pending, :paid, :failed]

  # ----------------------------------------------------------------------
  # == Attributes == #
  # ----------------------------------------------------------------------


  # ----------------------------------------------------------------------
  # == File Uploader == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == Associations and Nested Attributes == #
  # ----------------------------------------------------------------------

  belongs_to :user

  # ----------------------------------------------------------------------
  # == Validations == #
  # ----------------------------------------------------------------------


  # ----------------------------------------------------------------------
  # == Callbacks == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == Scopes and Other macros == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == Instance methods == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == Class methods == #
  # ----------------------------------------------------------------------
end
