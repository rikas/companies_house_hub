# frozen_string_literal: true

require 'yaml'
# 02200605
module CompaniesHouseHub
  class FilingHistoryFormatter
    def initialize(filing_history)
      @filing_history = filing_history
    end

    def formatted(format = 'pdf')
      name = descriptions[@filing_history.description]
      name = name.downcase

      # If "made_up_date" exists then replace it with the filing date and don't include filing.date
      # in the file name (made_up_date will be used).
      if name =~ /{.*}/
        name = replace_placeholders(name)
        date = nil
      end

      cleanup(name)

      [name, date].compact.join('-') << ".#{format}"
    end

    private

    def descriptions
      CompaniesHouseHub.load_yml('filing_history_descriptions')['description']
    end

    def cleanup(name)
      name.tr!('*', '')
      name.tr!("\s", '-')
    end

    # Replaces the placeholders in yaml descriptions with what we get from Companies House (and is
    # stored in FilingHistory#description_values).
    def replace_placeholders(text)
      matches = text.scan(/\{([a-z_]+)\}/).flatten

      return text unless matches.any?

      replaced = text.dup

      matches.each do |match|
        value = @filing_history.description_values.dig(match.to_sym)
        replaced.sub!(/{#{match}}/, value)
      end

      replaced
    end
  end
end
