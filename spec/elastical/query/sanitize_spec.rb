require 'spec_helper'

describe Elastical::Query::Sanitize do
  let(:query_string) { "am i crazy AND handsome NOT (rich OR [wealthy OR hungry]) ? !" }

  context 'full sanitization' do
    it 'should be sanitized' do
      Elastical::Query::Sanitize.escape_string(query_string).tap do |escaped|
        escaped.should == "am i crazy \\A\\N\\D handsome \\N\\O\\T \\(rich \\O\\R \\[wealthy \\O\\R hungry\\]\\) \\? \\!"
      end
    end
  end

  context 'operators' do
    it 'should escape AND OR NOT operators' do
      Elastical::Query::Sanitize.send(:escape_operators, query_string).tap do |escaped|
        escaped.should == "am i crazy \\A\\N\\D handsome \\N\\O\\T (rich \\O\\R [wealthy \\O\\R hungry]) ? !"
      end
    end
  end
end
