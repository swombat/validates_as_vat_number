# Link to rules:
# http://ec.europa.eu/taxation_customs/vies/lang.do?fromWhichPage=faqvies&selectedLanguage=EN
module ActiveRecord
  module Validations
    module ClassMethods
      require 'soap/wsdlDriver'

      # Structures of EU vat numbers. This structures are used when VIES service raise exception and
      # +vat_number+ is matched with RegExp.
      STRUCTURES = {
        :AT => /^ATU\w{8}$/,
        :BE => /^BE0\d{9}$/,
        :BG => /^BG\d{9,10}$/,
        :CY => /^CY\w{8}L$/,
        :CZ => /^CZ\d{8,10}$/,
        :DE => /^DE\d{9}$/,
        :DK => /^DK\d{2}\s\d{2}\s\d{2}\s\d{2}$/,
        :EE => /^EE\d{9}$/,
        :EL => /^EL\d{9}$/,
        :ES => /^ESX\d{7}X$/,
        :FI => /^FI\d{8}$/,
        :FR => /^FR\w{2}\s\d{9}$/,
        :GB => /^GB(\d{3}\s\d{4}\s\d{2}|\d{3}\s\d{4}\s\d{2}\s\d{3}|GD\d{3}|HA\d{3})$/,
        :HU => /^HU\d{8}$/,
        :IE => /^IE\wS\w{5}L$/,
        :IT => /^IT\d{11}$/,
        :LT => /^LT(\d{9}|\d{12})$/,
        :LU => /^LU\d{8}$/,
        :LV => /^LV\d{12}$/,
        :MT => /^MT\d{8}$/,
        :NL => /^NL\w{9}B\w{2}$/,
        :PL => /^PL\d{10}$/,
        :PT => /^PT\d{9}/,
        :RO => /^RO\d{2,10}$/,
        :SE => /^SE\d{12}$/,
        :SI => /^SI\d{8}$/,
        :SK =>/^SK\d{10}$/
      }

      # Validates attributes as VAT EU numbers.
      def validates_as_vat_number(*attr_names)
        RAILS_DEFAULT_LOGGER.debug "Checking VAT number"
        configuration = {
          :message => "is not valid Vat EU number",
          :scope => "country_code"
        }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          begin
            result = vat_check_driver.checkVat(
              :countryCode => record.send(configuration[:scope]),
              :vatNumber => value.sub(record.send(configuration[:scope]), "")
            )
            RAILS_DEFAULT_LOGGER.debug "Result from VAT check: #{result.inspect}"
            record.errors.add(attr_name, configuration[:message]) unless result && result.valid == "true"
          rescue  => e
            unless record.send(configuration[:scope]).blank?
              if STRUCTURES[record.send(configuration[:scope]).upcase.to_sym].match(value).nil?
                record.errors.add(attr_name, configuration[:message])
              end
            else
              raise e
            end
          end
        end
      end


      protected


      # Connect to webservice
      def vat_check_driver
        wsdl = "http://ec.europa.eu/taxation_customs/vies/api/checkVatPort?wsdl"
        SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
      end
    end
  end
end