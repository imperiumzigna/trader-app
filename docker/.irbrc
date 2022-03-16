IRB.conf[:USE_READLINE] = true
IRB.conf[:AUTO_INDENT]  = false

# Save History between irb sessions
require "irb/ext/save-history"
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['IRB_HISTFILE']}"

def application_name
  Rails.application.class.module_parent.name
end

def rails_environment
  Rails.env
end

# Checking if we are in rails console
if defined?(Rails)
  prompt = "#{application_name}[#{rails_environment}]"

  # defining custom prompt
  IRB.conf[:PROMPT][:RAILS] = {
    PROMPT_I: "#{prompt}>> ",
    PROMPT_N: "#{prompt}> ",
    PROMPT_S: "#{prompt}* ",
    PROMPT_C: "#{prompt}? ",
    RETURN: " => %s\n"
  }

  # Setting our custom prompt as prompt mode
  IRB.conf[:PROMPT_MODE] = :RAILS
end
