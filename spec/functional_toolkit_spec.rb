require './functional_toolkit'

describe Proc do

  it "Should not break tradional proc-calling" do
    ->(string) { string.upcase }.('bang!').should == 'BANG!'
  end

  it "Automatically curries if too few arguments are supplied" do
    two_argument_proc = ->(arg_one, arg_two){:result}
    two_argument_proc.(:one_argument).should be_an_instance_of(Proc)

    two_argument_proc.(:one_argument).(:another_argument).should == :result
  end

  it "Allows partial mapping via auto-currying" do
    two_argument_proc = ->(one, two){:result}
    (1..10)
      .map { |num| two_argument_proc.(:two) }
      .map { |f| f.(:two) }
      .should == ([:result] * 10)

    (1..10)
      .map(&two_argument_proc)
      .map { |f| f.(:two) }
      .should == ([:result] * 10)

    (1..10)
      .map { |num, other_param| num + other_param }
      .map { |f| f.(1) }
      .should == (2..11).to_a
  end

  it "Should not break traditional mapping" do
    (1..5).map { |num| ('x' + num.to_s).to_sym }.should == [:x1, :x2, :x3, :x4, :x5]
  end

end

describe Object do
  it "Should be possible to set instance methods of a class via prototype" do
    String::prototype(:shoutcase).set ->{ self.upcase + '!' }
    "hello".shoutcase.should == 'HELLO!'

    String::prototype(:lotsa_shouts).set ->(times){ ([self.shoutcase, ' '] * times).join[0..-2] }
    "hey".lotsa_shouts(3).should == "HEY! HEY! HEY!"
  end

  it "Should be possible to call instance methods from a class prototype" do
    String::prototype(:to_sym).('test').should == :test
  end

end
