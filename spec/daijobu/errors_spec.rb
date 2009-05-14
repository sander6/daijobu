require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daijobu::Error do
  
  it "should be a standard error" do
    Daijobu::Error.ancestors.should include(StandardError)
  end
  
end

describe Daijobu::UnknownScheme do

  it "should be a Daijobu error" do
    Daijobu::UnknownScheme.ancestors.should include(Daijobu::Error)
  end
  
end

describe Daijobu::InvalidAdapter do

  it "should be a Daijobu error" do
    Daijobu::InvalidAdapter.ancestors.should include(Daijobu::Error)
  end
  
end
 
describe Daijobu::NoFallbackScheme do

  it "should be a Daijobu error" do
    Daijobu::NoFallbackScheme.ancestors.should include(Daijobu::Error)
  end
  
end