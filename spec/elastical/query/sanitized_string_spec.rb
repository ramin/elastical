require 'spec_helper'

describe Elastical::Query::SanitizedString do
  let(:query_string) { "am i crazy AND handsome NOT (rich OR [wealthy OR hungry]) ? !" }

  context 'sanitized string' do
    it 'should be an instance of SanitizedString' do
      Elastical::Query::SanitizedString.new(query_string).class.should == Elastical::Query::SanitizedString
    end

    it 'returns the string when calling to_s or to_str' do
      string = "am i crazy \\A\\N\\D handsome \\N\\O\\T \\(rich \\O\\R \\[wealthy \\O\\R hungry\\]\\) \\? \\!"
      Elastical::Query::SanitizedString.new(query_string).to_s.should   == string
      Elastical::Query::SanitizedString.new(query_string).to_str.should == string
    end
  end
end
