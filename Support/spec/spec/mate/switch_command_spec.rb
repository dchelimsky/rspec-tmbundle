require File.dirname(__FILE__) + '/../../../lib/spec/mate/switch_command'

module Spec
  module Mate
    describe SwitchCommand do
      def twin(expected, opts={:webapp => false})
        File.stub!(:exist?).and_return(opts[:webapp])

        simple_matcher do |actual, matcher|
          matcher.failure_message = "expected #{actual.inspect} to twin #{expected.inspect}, but it didn't"
          matcher.negative_failure_message = "expected #{actual.inspect} not to twin #{expected.inspect}, but it did"
          matcher.description = "treat #{expected.inspect} and #{actual.inspect} as twins"

          command = SwitchCommand.new
          command.twin(actual) == expected &&
          command.twin(expected) == actual
        end
      end

      class << self
        def expect_twins(pair)
          specify do
            pair[0].should twin(pair[1])
          end
        end
      end

      def be_a(expected)
        simple_matcher do |actual, matcher|
          matcher.failure_message = "expected #{actual.inspect} to be_a #{expected.inspect}, but it didn't"
          matcher.negative_failure_message = "expected #{actual.inspect} not to be_a #{expected.inspect}, but it did"
          SwitchCommand.new.file_type(actual) == expected
        end
      end
    
      describe "in a regular app" do
        expect_twins [
          "/Users/aslakhellesoy/scm/rspec/trunk/RSpec.tmbundle/Support/spec/spec/mate/switch_command_spec.rb",
          "/Users/aslakhellesoy/scm/rspec/trunk/RSpec.tmbundle/Support/lib/spec/mate/switch_command.rb"
        ]
      
        it "should suggest plain spec" do
          "/a/full/path/spec/snoopy/mooky_spec.rb".should be_a("spec")
        end

        it "should suggest plain file" do
          "/a/full/path/lib/snoopy/mooky.rb".should be_a("file")
        end
      
        it "should create spec for spec files" do
          regular_spec = <<-SPEC
require File.dirname(__FILE__) + '/../spec_helper'

describe ${1:Type} do
  it "should ${2:description}" do
    $0
  end
end
SPEC
          SwitchCommand.new.content_for('spec', "spec/foo/zap_spec.rb").should == regular_spec
          SwitchCommand.new.content_for('spec', "spec/controller/zap_spec.rb").should == regular_spec
        end

        it "should create class for regular file" do
          file = <<-EOF
module Foo
  class Zap
  end
end
EOF
          SwitchCommand.new.content_for('file', "lib/foo/zap.rb").should == file
          SwitchCommand.new.content_for('file', "some/other/path/lib/foo/zap.rb").should == file
        end
      end
    
      describe "in a Rails or Merb app" do
        def twin(expected)
          super(expected, :webapp => true)
        end
      
        expect_twins [
          "/a/full/path/app/controllers/mooky_controller.rb",
          "/a/full/path/spec/controllers/mooky_controller_spec.rb"
        ]
      
        expect_twins [
          "/a/full/path/app/controllers/application.rb",
          "/a/full/path/spec/controllers/application_controller_spec.rb"
        ]
      
        expect_twins [
          "/a/full/path/spec/controllers/application_controller_spec.rb",
          "/a/full/path/app/controllers/application.rb"
        ]
      
        expect_twins [
          "/a/full/path/app/controllers/job_applications_controller.rb",
          "/a/full/path/spec/controllers/job_applications_controller_spec.rb"
        ]
      
        expect_twins [
          "/a/full/path/spec/controllers/job_applications_controller_spec.rb",
          "/a/full/path/app/controllers/job_applications_controller.rb"
        ]
      
        expect_twins [
          "/a/full/path/app/helpers/application_helper.rb",
          "/a/full/path/spec/helpers/application_helper_spec.rb"
        ]
      
        expect_twins [
          "/a/full/path/spec/helpers/application_helper_spec.rb",
          "/a/full/path/app/helpers/application_helper.rb"
        ]

        expect_twins [
          "/a/full/path/app/models/mooky.rb",
          "/a/full/path/spec/models/mooky_spec.rb"
        ]

        expect_twins [
          "/a/full/path/app/helpers/mooky_helper.rb",
          "/a/full/path/spec/helpers/mooky_helper_spec.rb"
        ]

        expect_twins [
          "/a/full/path/app/views/mooky/show.html.erb",
          "/a/full/path/spec/views/mooky/show.html.erb_spec.rb"
        ]
      
        expect_twins [
          "/a/full/path/app/views/mooky/show.rhtml",
          "/a/full/path/spec/views/mooky/show.rhtml_spec.rb"
        ]
      
        expect_twins [
          "/a/full/path/lib/foo/mooky.rb",
          "/a/full/path/spec/lib/foo/mooky_spec.rb"
        ]
      
        it "should suggest controller spec" do
          "/a/full/path/spec/controllers/mooky_controller_spec.rb".should be_a("controller spec")
        end

        it "should suggest model spec" do
          "/a/full/path/spec/models/mooky_spec.rb".should be_a("model spec")
        end

        it "should suggest helper spec" do
          "/a/full/path/spec/helpers/mooky_helper_spec.rb".should be_a("helper spec")
        end

        it "should suggest view spec" do
          "/a/full/path/spec/views/mooky/show.html.erb_spec.rb".should be_a("view spec")
        end

        it "should suggest controller" do
          "/a/full/path/app/controllers/mooky_controller.rb".should be_a("controller")
        end

        it "should suggest model" do
          "/a/full/path/app/models/mooky.rb".should be_a("model")
        end

        it "should suggest helper" do
          "/a/full/path/app/helpers/mooky_helper.rb".should be_a("helper")
        end

        it "should suggest view" do
          "/a/full/path/app/views/mooky/show.html.erb".should be_a("view")
        end

        it "should create spec that requires a helper" do
          SwitchCommand.new.content_for('controller spec', "spec/controllers/mooky_controller_spec.rb").split("\n")[0].should == 
            "require File.dirname(__FILE__) + '/../spec_helper'"
        end
      end
    end
  end
end
