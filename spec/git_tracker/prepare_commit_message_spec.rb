require 'spec_helper'
require 'git_tracker/prepare_commit_message'

describe GitTracker::PrepareCommitMessage do
  subject(:prepare_commit_message) { GitTracker::PrepareCommitMessage }

  describe '.run' do
    let(:hook) { double('PrepareCommitMessage') }
    before do
      prepare_commit_message.stub(:new) { hook }
    end

    it 'runs the hook' do
      hook.should_receive(:run)
      prepare_commit_message.run('FILE1', 'hook_source', 'sha1234')
    end
  end

  describe '.new' do

    it 'requires the name of the commit message file' do
      expect { prepare_commit_message.new }.to raise_error(ArgumentError)
    end

    it 'remembers the name of the commit message file' do
      expect(prepare_commit_message.new('FILE1').file).to eq('FILE1')
    end

    it 'optionally accepts a message source' do
      expect(hook = prepare_commit_message.new('FILE1', 'merge').source).to eq('merge')
    end

    it 'optionally accepts the SHA-1 of a commit' do
      expect(hook = prepare_commit_message.new('FILE1', 'commit', 'abc1234').commit_sha).to eq('abc1234')
    end
  end

  describe '#run' do
    let(:hook) { GitTracker::PrepareCommitMessage.new('FILE1') }
    before do
      GitTracker::Branch.stub(:story_number) { story }
    end

    context 'with an existing commit (via `-c`, `-C`, or `--amend` options)' do
      let(:hook) { described_class.new('FILE2', 'commit', '60a086f3') }

      it 'exits with status code 0' do
        expect { hook.run }.to succeed
      end
    end

    context 'branch name without a Pivotal Tracker story number' do
      let(:story) { nil }

      it 'exits without updating the commit message' do
        expect { hook.run }.to succeed
        GitTracker::CommitMessage.should_not have_received(:append)
      end
    end

    context 'branch name with a Pivotal Tracker story number' do
      let(:story) { '8675309' }
      let(:commit_message) { double('CommitMessage', :mentions_story? => false) }

      before do
        commit_message.stub(:keyword) { nil }
        GitTracker::CommitMessage.stub(:new) { commit_message }
      end

      it 'appends the number to the commit message' do
        commit_message.should_receive(:append).with('[#8675309]')
        hook.run
      end

      context 'keyword mentioned in the commit message' do
        before do
          commit_message.stub(:mentions_story?).with('8675309') { false }
          commit_message.stub(:keyword) { 'Delivers' }
        end

        it 'appends the keyword and the story number' do
          commit_message.should_receive(:append).with('[Delivers #8675309]')
          hook.run
        end
      end

      context 'number already mentioned in the commit message' do
        before do
          commit_message.stub(:mentions_story?).with('8675309') { true }
        end

        it 'exits without updating the commit message' do
          expect { hook.run }.to succeed
          GitTracker::CommitMessage.should_not have_received(:append)
        end
      end
    end

  end
end
