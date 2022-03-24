class Trade::Run
  include Interactor::Organizer

  # This organizer will run the following interactors:
  # - Trade::ValidatesOperation
  # - Trade::Process
  # If no errors are raised, the trade will be processed.
  # If errors are raised, the trade will be canceled.
  organize(Trade::ValidatesOperation,
           Trade::Process)
end
