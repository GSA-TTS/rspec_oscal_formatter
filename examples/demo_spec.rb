require 'rails_helper'
require 'rspec'

plan_filename = Pathname('/tmp/oscal/assessment-plan.json')
RSpecOscalFormatter.configure do |config|
  config.plan_filename = plan_filename
end
RSpec.configure do |config|
  config.add_formatter RSpecOscalFormatter::PlanFormatter, plan_filename
  config.add_formatter RSpecOscalFormatter::ResultsFormatter, '/tmp/oscal/assessment-results.json'
end

RSpec.describe 'PasswordAssessment' do
  it 'confirms passwords are set to the appropriate minimum length',
     control_id: 'ms-01', statement_id: 'ms-01_smt',
     assessment_plan_uuid: 'da1ce957-e50e-42a0-936e-1a44f9d8a96c' do |assessment|
    expect(Devise.password_length.first).to be > 8
  end
end

RSpec.describe 'ConfirmTLS' do
  it 'confirms that TLS is configured on the server',
     control_id: 'ms-13', statement_id: 'ms-13_smt',
     assessment_plan_uuid: '04465aa4-eebc-4527-894f-649e900081b8' do |assessment|
    expect(ENV['HTTPS']).to eq('on')
  end
end
