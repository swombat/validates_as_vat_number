require 'test/unit'
require 'rubygems'
require 'flexmock/test_unit'

begin
  require File.dirname(__FILE__) + '/../../../../config/boot'
  require 'active_record'
  require 'validates_as_vat_number'
rescue LoadError
  require 'rubygems'
  require 'active_record'
  require File.dirname(__FILE__) + '/../lib/validates_as_vat_number'
end


class TestRecord < ActiveRecord::Base
  def self.columns; []; end
  attr_accessor :vat_number, :country_code
  validates_as_vat_number :vat_number,
    :scope => :country_code
end

class TestValidatesAsVatNumber < Test::Unit::TestCase
  VIES_URL = "http://ec.europa.eu/taxation_customs/vies/api/checkVatPort?wsdl"
  def setup
    @test_record = TestRecord.new(:vat_number => "PL1234567890", :country_code => "PL")
  end


  def test_inproper_vat_number
    assert !@test_record.valid?
    assert @test_record.errors.invalid?(:vat_number)
    assert_equal("is not valid Vat EU number", @test_record.errors.on(:vat_number))
  end


  def test_proper_vat_number_when_communications_problem_at
    mock_vies_exception
    @test_record.country_code = "AT"
    @test_record.vat_number = "ATU12345678"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_be
    mock_vies_exception
    @test_record.country_code = "BE"
    @test_record.vat_number = "BE0123456789"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_bg
    mock_vies_exception
    @test_record.country_code = "BG"
    @test_record.vat_number = "BG123456789"

    assert @test_record.valid?
    assert @test_record.errors.empty?

    @test_record.vat_number = "BG1234567890"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_cy
    mock_vies_exception
    @test_record.country_code = "CY"
    @test_record.vat_number = "CY12345678L"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_numer_when_communications_problem_cz
    mock_vies_exception
    @test_record.country_code = "CZ"
    @test_record.vat_number = "CZ12345678"

    assert @test_record.valid?
    assert @test_record.errors.empty?

    @test_record.vat_number = "CZ1234567890"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_de
    mock_vies_exception
    @test_record.country_code = "DE"
    @test_record.vat_number = "DE123456789"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_dk
    mock_vies_exception
    @test_record.country_code = "DK"
    @test_record.vat_number = "DK12 12 12 12"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_ee
    mock_vies_exception
    @test_record.country_code = "EE"
    @test_record.vat_number ="EE123456789"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_el
    mock_vies_exception
    @test_record.country_code = "EL"
    @test_record.vat_number = "EL123456789"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_prblem_es
    mock_vies_exception
    @test_record.country_code = "ES"
    @test_record.vat_number = "ESX1234567X"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_fi
    mock_vies_exception
    @test_record.country_code = "FI"
    @test_record.vat_number = "FI12345678"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_fr
    mock_vies_exception
    @test_record.country_code = "FR"
    @test_record.vat_number = "FRab 123456789"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_gb
    mock_vies_exception
    @test_record.country_code = "GB"
    @test_record.vat_number = "GB123 1234 12"

    assert @test_record.valid?
    assert @test_record.errors.empty?

    @test_record.vat_number = "GB123 1234 12 123"

    assert @test_record.valid?
    assert @test_record.errors.empty?

    @test_record.vat_number = "GBGD123"

    assert @test_record.valid?
    assert @test_record.errors.empty?

    @test_record.vat_number = "GBHA123"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_hu
    mock_vies_exception
    @test_record.country_code = "HU"
    @test_record.vat_number = "HU12345678"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_ie
    mock_vies_exception
    @test_record.country_code = "IE"
    @test_record.vat_number = "IE1S12345L"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_it
    mock_vies_exception
    @test_record.country_code = "IT"
    @test_record.vat_number = "IT12345678901"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_lt
    mock_vies_exception
    @test_record.country_code = "LT"
    @test_record.vat_number = "LT123456789"

    assert @test_record.valid?
    assert @test_record.errors.empty?

    @test_record.vat_number = "LT123456789012"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_lu
    mock_vies_exception
    @test_record.country_code = "LU"
    @test_record.vat_number = "LU12345678"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_lv
    mock_vies_exception
    @test_record.country_code = "LV"
    @test_record.vat_number = "LV123456789012"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_mt
    mock_vies_exception
    @test_record.country_code = "MT"
    @test_record.vat_number = "MT12345678"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_nl
    mock_vies_exception
    @test_record.country_code = "NL"
    @test_record.vat_number = "NL123456789BAB"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_pl
    mock_vies_exception

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_pt
    mock_vies_exception
    @test_record.country_code = "PT"
    @test_record.vat_number = "PT123456789"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_ro
    mock_vies_exception
    @test_record.country_code = "RO"
    @test_record.vat_number = "RO12"

    assert @test_record.valid?
    assert @test_record.errors.empty?

    @test_record.vat_number = "RO1234567890"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_se
    mock_vies_exception
    @test_record.country_code = "SE"
    @test_record.vat_number = "SE123456789012"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_si
    mock_vies_exception
    @test_record.country_code = "SI"
    @test_record.vat_number = "SI12345678"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_proper_vat_number_when_communications_problem_sk
    mock_vies_exception
    @test_record.country_code = "SK"
    @test_record.vat_number = "SK1234567890"

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  def test_inproper_vat_number_when_communications_problem
    mock_vies_exception
    flexmock(@test_record, :validate_for_pl => false)

    assert @test_record.valid?
    assert @test_record.errors.empty?
  end


  protected


  def mock_vies_exception
    rpc_driver = flexmock("rpc_driver")
    rpc_driver.should_receive(:checkVat).and_raise("dupa")
    wsdl_factory = flexmock("wsdl_factory")
    wsdl_factory.should_receive(:create_rpc_driver).and_return(rpc_driver)
    flexmock(SOAP::WSDLDriverFactory).should_receive(:new).with(VIES_URL).and_return(wsdl_factory)
  end
end
