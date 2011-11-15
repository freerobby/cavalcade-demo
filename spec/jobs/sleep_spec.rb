require "#{File.dirname(__FILE__)}/../spec_helper"

describe Sleep do
  it "pauses for num_seconds seconds" do
    Sleep.stub(:sleep)
    Sleep.should_receive(:sleep).with(7)
    Sleep.perform(7)
  end
end
