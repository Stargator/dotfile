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
      line = "\n"
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

    describe '#parse_line' do
      context 'given a group name' do
        it 'changes the current group name' do
          group.parse_line('[group_name]')
          group.current_group.should == "group_name"
        end
      end

      context 'given a source and destination' do
        it 'returns a hash when the current group is included' do
          group.parse_line('[vim]')
          group.included_groups.should include(group.current_group)

          parsed = group.parse_line(valid_line)
          parsed.should be_an_instance_of(Hash)
          parsed.should have_exactly(3).items

          expected_source = "spec/examples/resources/dotfiles/vim/test_file"
          expected_destination = File.expand_path("~/.test_file")
          parsed[:group].should eq(group.current_group)
          parsed[:source].should eq(expected_source)
          parsed[:destination].should eq(expected_destination)
        end

        it 'returns nil when the current group is not included' do
          group.parse_line('[no_group]')
          group.included_groups.should_not include(group.current_group)

          group.parse_line(valid_line).should be_nil
        end
      end
    end

  end

  describe 'parsing a file' do

    before(:all) do
      @group = group
    end
    
    it 'returns a hash for every line in an included group' do
      @group.parse_file
      @group.dotfiles.should have_exactly(4).items
      @group.dotfiles[0].should be_an_instance_of(Hash)
    end

    describe '#dotfiles' do
      it 'returns an array of hashes' do
        @group.dotfiles.each do |dotfile|
          dotfile.should be_an_instance_of(Hash)
          dotfile.should have_exactly(3).items
        end
      end
        
      it 'returns a path to the source file' do
        file = @group.dotfiles[0][:source]
        File.exists?(file).should be_true
      end

      it 'returns a valid destination path' do
        file = @group.dotfiles[0][:destination]
        path = File.dirname(file)
        File.exists?(path).should be_true
      end
    end

  end

end
