require 'spec_helper.rb'
require 'dotfile_group.rb'

describe Dotfile::Group do
  let(:config_file) { 'spec/examples/groups.conf' }
  let(:group) { Dotfile::Group.new(config_file, %w{ vim zsh xorg }) }

  it 'reads a given groups.conf file' do
    File.exist?(config_file).should be_true
  end

  describe '#file' do
    it 'returns a file' do
      group.file.should be_an_instance_of(File)
    end
  end

  describe 'parsing a line' do
    
    let(:valid_line) { "  test_file , ~/.test_file # This is a comment." }

    it "ignores any line starting with a '#'" do
      line = "# This entire line is a comment!"
      group.ignore_line?(line).should be_true
    end

    it 'ignores empty lines' do
      line = ""
      group.ignore_line?(line).should be_true
    end

    it 'does not ignore an important line' do
      group.ignore_line?(valid_line).should be_nil
    end

    it 'removes encompassing whitespace' do
      line = "  some text  "
      expected = "some text"
      group.strip_excess(line).should eq(expected)
    end

    it 'removes trailing comments' do
      line = "  some text # This is a comment!"
      expected = "some text"
      group.strip_excess(line).should eq(expected)
    end

    it 'returns current_group nil until assigned' do
      group.current_group.should be_nil
    end

    it 'changes the current group name given [group]' do
      group.parse_line('[vim]')
      group.current_group.should == "vim"
    end

    it 'returns a two element hash given the current group is included' do
      group.parse_line('[vim]')
      group.included_groups.should include(group.current_group)

      parsed = group.parse_line(valid_line)
      parsed.should be_an_instance_of(Hash)
      parsed.length.should == 2

      expected = [ "test_file", File.expand_path("~/.test_file") ]
      parsed[:source_file].should eq(expected[0])
      parsed[:destination_file].should eq(expected[1])
    end

    it 'does not return a hash if the current group is not included' do
      group.parse_line('[no_group]')
      group.included_groups.should_not include(group.current_group)

      group.parse_line(valid_line).should be_nil
    end

  end

end
