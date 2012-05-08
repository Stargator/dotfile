require 'spec_helper.rb'
require 'dotfile/dotfile_groupconfig.rb'

describe Dotfile::GroupConfig do

  let(:config_file) { 'spec/examples/groups.conf' }
  let(:dotfile_path) { 'spec/examples/dotfiles' }
  let(:included) { %w{ vim zsh xorg } }
  let(:group) { Dotfile::GroupConfig.new(config_file, dotfile_path, included, :test) }

  it 'reads examples/groups.conf' do
    File.exist?(config_file).should be_true
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

    describe '#parse_line' do
      before(:all) { @group = group }

      context 'when not initially given a group name' do
        before(:all) { @group.parse_line('') }

        specify { @group.current_group.should eq('') }

        context 'then given paths' do
          describe 'the parsed line' do
            specify { @group.parse_line(valid_line).should be_nil }
          end
        end   
      end

      context 'when given an included group name' do
        before(:all) { @group.parse_line('[vim]') }

        specify { @group.current_group.should eq('vim') }

        context 'then given paths' do
          describe 'the parsed line' do
            let(:source) { "spec/examples/dotfiles/vim/test_file" }
            let(:destination) { File.expand_path("~/.test_file") }
            subject { @group.parse_line(valid_line) }

            it { should be_a(Hash) }
            it { should have_exactly(3).items }
            specify { subject[:source].should eq(source) }
            specify { subject[:destination].should eq(destination) }
            specify { subject[:group].should eq(@group.current_group) }
          end
        end
      end

      context 'when given a non-included group name' do
        before(:all) { @group.parse_line('[not_included]') }

        specify { @group.included_groups.should_not include(@group.current_group) }
        specify { @group.current_group.should eq('not_included') }

        context 'then given paths' do
          describe 'the parsed line' do
            specify { @group.parse_line(valid_line).should be_nil }
          end
        end
      end
    end
  end

  describe 'parsing a file' do
    context 'when examples/groups.conf' do
      before(:all) { @group = group; @group.parse_file }
      subject { @group.dotfiles }

      describe '#dotfiles' do
        it { should have_exactly(4).items }

        describe 'each element' do
          specify { subject[0].should be_a(Hash) }
          specify { subject[0].should have_exactly(3).items }

          it 'should return a valid source' do
            File.exists?(subject[0][:source]).should be_true
          end

          it 'should return a valid destination' do
            path = File.dirname(subject[0][:destination])
            File.exists?(path).should be_true
          end
        end
      end
    end

    context 'when examples/groups.conf.2' do
      let(:config_file) { 'spec/examples/groups.conf.2' }
      before(:all) { @no_dirs = group; @no_dirs.parse }
      specify { @no_dirs.dotfiles.should have_exactly(1).items }
    end
  end

  describe 'handling directories' do
    before(:all) do
      @group = group
      @group.parse_file
    end

    subject { @group.get_directories }
    specify { subject.should have_exactly(2).items }

    it 'returns directories' do
      subject.each { |d| File.directory?(d[:source]).should be_true }
    end

    it 'does not return files' do
      subject.each { |d| File.file?(d[:source]).should be_false }
    end

    describe '#find_dotfiles' do
      before(:all) do
        @dotfiles = @group.find_dotfiles(@group.get_directories[1])
      end

      subject { @dotfiles }
      it { should be_an(Array) }
      it { should have_exactly(5).items }
      specify { subject[0].should be_a(Hash) }
      specify { subject.to_s.should match(/file_five/) }
    end

    describe 'adding found files' do
      before(:all) { @group.add_directory_contents }
      specify { @group.dotfiles.should have_exactly(12).items }
    end

    describe 'removing directories' do
      before(:all) { @group.remove_directories }
      specify { @group.dotfiles.should have_exactly(10).items }
    end
  end

  describe '#parse' do
    before(:all) { @group = group }

    it 'parses a given configuration file' do
      parse = proc { @group.parse }
      parse.should_not raise_error
    end

    describe 'dotfile array' do
      subject { @group.dotfiles }
      it { should have_exactly(10).items }

      describe 'each element' do
        specify { subject[0].should have_exactly(3).items }
      end
    end
  end

end
