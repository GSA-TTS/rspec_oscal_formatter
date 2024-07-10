require 'rails_helper'
require 'rspec'

plan_filename = Pathname('/tmp/oscal/assessment-plan.json')
RSpecOscalFormatter.configure do |config|
  config.plan_filename = plan_filename
  config.ssp_filename = 'doc/compliance/system-security-plan.json'
end
RSpec.configure do |config|
  config.add_formatter RSpecOscalFormatter::PlanFormatter, plan_filename
  config.add_formatter RSpecOscalFormatter::ResultsFormatter, '/tmp/oscal/assessment-results.json'
end

RSpec.describe 'PasswordAssessment' do
  it 'confirms passwords are set to the appropriate minimum length',
     control_id: 'ms-01', statement_id: 'ms-01_smt' do
    expect(Devise.password_length.first).to be > 8
  end
end

RSpec.describe 'ConfirmTLS' do
  it 'confirms that TLS is configured on the server',
     control_id: 'ms-13', statement_id: 'ms-13_smt',
     implementation_statement_uuid: '1a2bdef8-2ddd-420a-85e9-31b2e6b7ec0c' do
    expect(ENV['HTTPS']).to eq('on')
  end
end

# Each test will inherit the control_id from the parent ExampleGroup
RSpec.describe 'Grouping tests', control_id: 'ms-02' do
  it 'validates the first statement', statement_id: 'ms-02_a' do
    expect(object).to be_valid
  end

  it 'validates the second statement', statement_id: 'ms-02_b' do
    expect(object).to be_compliant
  end
end
