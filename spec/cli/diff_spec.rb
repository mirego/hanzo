require 'spec_helper'

describe Hanzo::CLI do
  describe :diff do
    let(:env) { 'production' }
    let(:diff!) { Hanzo::CLI.new(['diff', env]) }
    let(:heroku_remotes) { { 'production' => 'heroku-app-production' } }

    let(:diff_cmd) { "git remote update #{env} && git diff #{env}/master...HEAD" }

    before do
      expect(Hanzo::Installers::Remotes).to receive(:environments).and_return(['production'])
      expect(Hanzo::Installers::Remotes).to receive(:installed_environments).and_return(['production'])
    end

    context 'successful diff' do
      let(:diff_result) { true }

      before do
        expect(Hanzo).to receive(:run).with(diff_cmd).once.and_return(diff_result)
      end

      it 'should update the right remote and run a diff' do
        diff!
      end
    end
  end
end
