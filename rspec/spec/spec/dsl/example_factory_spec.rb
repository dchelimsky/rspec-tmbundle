require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe BehaviourFactory do
      it "should create an anonymous Spec::DSL::Example subclass by default" do
        behaviour = Spec::DSL::BehaviourFactory.create("behaviour")
        behaviour.name.should be_empty
        behaviour.superclass.should == Spec::DSL::Example
      end

      it "should create a Spec::DSL::Example when :type => :default" do
        behaviour = Spec::DSL::BehaviourFactory.create("behaviour", :type => :default)
        behaviour.name.should be_empty
        behaviour.superclass.should == Spec::DSL::Example
      end

      it "should create a Spec::DSL::Example when :behaviour_type => :default" do
        behaviour = Spec::DSL::BehaviourFactory.create("behaviour", :behaviour_type => :default)
        behaviour.name.should be_empty
        behaviour.superclass.should == Spec::DSL::Example
      end

      it "should create specified type when :type => :something_other_than_default" do
        behaviour_class = Class.new(Example) do
          def initialize(*args, &block); end
        end
        Spec::DSL::BehaviourFactory.register_behaviour(:something_other_than_default, behaviour_class)
        behaviour = Spec::DSL::BehaviourFactory.create("behaviour", :type => :something_other_than_default)
        behaviour.name.should be_empty
        behaviour.superclass.should == behaviour_class
      end

      it "should create specified type when :behaviour_type => :something_other_than_default" do
        behaviour_class = Class.new(Example) do
          def initialize(*args, &block); end
        end
        Spec::DSL::BehaviourFactory.register_behaviour(:something_other_than_default, behaviour_class)
        behaviour = Spec::DSL::BehaviourFactory.create("behaviour", :behaviour_type => :something_other_than_default)
        behaviour.name.should be_empty
        behaviour.superclass.should == behaviour_class
      end
      
      it "should type indicated by spec_path" do
        behaviour_class = Class.new(Example) do
          def initialize(*args, &block); end
        end
        Spec::DSL::BehaviourFactory.register_behaviour(:something_other_than_default, behaviour_class)
        behaviour = Spec::DSL::BehaviourFactory.create("behaviour", :spec_path => "./spec/something_other_than_default/some_spec.rb")
        behaviour.name.should be_empty
        behaviour.superclass.should == behaviour_class
      end
      
      it "should type indicated by spec_path (with spec_path generated by caller on windows)" do
        behaviour_class = Class.new(Example) do
          def initialize(*args, &block); end
        end
        Spec::DSL::BehaviourFactory.register_behaviour(:something_other_than_default, behaviour_class)
        behaviour = Spec::DSL::BehaviourFactory.create("behaviour", :spec_path => "./spec\\something_other_than_default\\some_spec.rb")
        behaviour.name.should be_empty
        behaviour.superclass.should == behaviour_class
      end
      
      after(:each) do
        Spec::DSL::BehaviourFactory.unregister_behaviour(:something_other_than_default)
      end
    end
  end
end
