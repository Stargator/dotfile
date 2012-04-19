require 'spec_helper.rb'
require 'dotfile/dotfile_groupconfig.rb'

describe Dotfile::GroupConfig do

  let(:config_file) { 'spec/examples/groups.conf' }
  let(:group) { Dotfile::GroupConfig.new(config_file, %w{ vim zsh xorg }, :test) }

  it 'reads a given groups.conf file' do
    File.exist?(config_file).should be_true
  end

  describe '#file' do
    it 'returns a file' do
      group.config_file.should be_a(File)
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

    it 'returns empty current_group until assigned' do
      group.current_group.should eq('')
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
          parsed.should be_a(Hash)
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
      @group.dotfiles[0].should be_a(Hash)
    end

    describe '#dotfiles' do
      it 'returns an array of hashes' do
        @group.dotfiles.each do |dotfile|
          dotfile.should be_a(Hash)
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

  describe 'handling directories' do

    before(:all) do
      @group = group
      @group.parse_file
    end

    it 'reads each element of dotfile and returns any directories' do
      @group.get_directories.should have_exactly(2).items
    end

    it 'returns directories' do
      @group.get_directories.each do |dir|
        is_a_directory = File.directory?(dir[:source])
        is_a_directory.should be_true
      end
    end

    it 'does not return regular files' do
      @group.get_directories.each do |dir|
        is_a_file = File.file?(dir[:source])
        is_a_file.should be_false
      end
    end

    describe '#add_contents' do
      before(:all) do
        @dotfiles = @group.find_dotfiles(@group.get_directories[1])
      end

      it 'returns all dotfiles in a directory recursively' do
        @dotfiles.should be_an(Array)
        @dotfiles.should have_exactly(5).items
      end

      it 'returns an array of hashes' do
        @dotfiles[0].should be_a(Hash)
      end

      it 'descends right down the directory tree' do
        @dotfiles.to_s.should match(/file_five/)
      end
    end

    describe 'removing hashes pointing to directories' do
      it 'adds all found files to the rest' do
        @group.add_directory_contents
        @group.dotfiles.should have_exactly(12).items
      end

      it 'removes the directories from the dotfiles array' do
        @group.remove_directories
        @group.dotfiles.should have_exactly(10).items
      end
    end

  end

  describe 'parsing a file with no directories and one file' do
    let(:config_file) { 'spec/examples/groups.conf.2' }

    before(:all) do
      @no_dirs = group
    end

    it 'returns a single dotfile' do
      @no_dirs.parse
      @no_dirs.dotfiles.should have_exactly(1).items
    end
  end

  describe '#parse' do
    before(:all) do
      @group = group
    end

    it 'parses a given configuration file' do
      @group.parse
    end

    it 'will return dotfile information' do
      @group.dotfiles.each do |dotfile|
        dotfile[:group].should_not be_nil
        dotfile[:source].should_not be_nil
        dotfile[:destination].should_not be_nil
      end
    end

    it 'returns the correct amount of dotfiles' do
      @group.dotfiles.should have_exactly(10).items
    end
  end

end
