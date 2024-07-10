require 'rails_helper'
require 'rspec'

plan_filename = Pathname('/tmp/oscal/assessment-plan.json')
RSpecOscalFormatter.configure do |config|
  config.plan_filename = plan_filename
  config.assessment_plan_uuid = '80356305-ecad-4ece-a015-3d7164ed210b'
end
RSpec.configure do |config|
  config.add_formatter RSpecOscalFormatter::PlanFormatter, plan_filename
  config.add_formatter RSpecOscalFormatter::ResultsFormatter, '/tmp/oscal/assessment-results.json'
end

RSpec.describe 'PasswordAssessment' do
  it 'confirms passwords are set to the appropriate minimum length',
     control_id: 'ms-01', statement_id: 'ms-01_smt' do |assessment|
    expect(Devise.password_length.first).to be > 8
  end
end

RSpec.describe 'ConfirmTLS' do
  it 'confirms that TLS is configured on the server',
     control_id: 'ms-13', statement_id: 'ms-13_smt' do |assessment|
    expect(ENV['HTTPS']).to eq('on')
  end
end
