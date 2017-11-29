require 'spec_helper'

describe Hanzo::CLI do
  describe :deploy do
    let(:deploy!) { Hanzo::CLI.new(['deploy', 'production']) }
    let(:deploy_question) { 'Branch to deploy in production:' }
    let(:deploy_command) { "git push -f production 1.0.0:master" }

    before do
      expect(Hanzo::Installers::Remotes).to receive(:environments).and_return(['production'])
      expect(Hanzo::Installers::Remotes).to receive(:installed_environments).and_return(['production'])
    end

    context 'deploy with specific branch' do
      let(:deploy!) { Hanzo::CLI.new(['deploy', 'production', '2.0.0']) }
      let(:deploy_command) { "git push -f production 2.0.0:master" }
      let(:deploy_result) { true }
      let(:config) { {} }

      before do
        allow(Hanzo).to receive(:config).and_return(config)
        expect(Hanzo).not_to receive(:ask)
        expect(Hanzo).to receive(:run).with(deploy_command).once.and_return(deploy_result)
      end

      it 'should git push to heroku upstream' do
        deploy!
      end
    end

    context 'successful deploy and without after_deploy commands' do
      let(:deploy_result) { true }
      let(:config) { {} }

      before do
        allow(Hanzo).to receive(:config).and_return(config)
        expect(Hanzo).to receive(:ask).with(deploy_question).and_return('1.0.0')
        expect(Hanzo).to receive(:run).with(deploy_command).once.and_return(deploy_result)
      end

      it 'should git push to heroku upstream' do
        deploy!
      end
    end

    context 'with existing after_deploy commands' do
      let(:config) { { 'after_deploy' => %w(foo bar) } }

      before do
        allow(Hanzo).to receive(:config).and_return(config)
        expect(Hanzo).to receive(:ask).with(deploy_question).and_return('1.0.0')
        expect(Hanzo).to receive(:run).with(deploy_command).once.and_return(deploy_result)
      end

      context 'with successful deploy' do
        let(:deploy_result) { true }

        before do
          expect(Hanzo).to receive(:agree).with('Run `foo` on production?').and_return(agree_after_deploy_result)
          expect(Hanzo).to receive(:agree).with('Run `bar` on production?').and_return(agree_after_deploy_result)
        end

        context 'with after_deploy commands skipped' do
          let(:agree_after_deploy_result) { false }

          before do
            expect(Hanzo).not_to receive(:run).with('heroku run foo --remote production')
            expect(Hanzo).not_to receive(:run).with('heroku run bar --remote production')
            expect(Hanzo).not_to receive(:run).with('heroku ps:restart --remote production')
          end

          specify { deploy! }
        end

        context 'without after_deploy commands skipped' do
          let(:agree_after_deploy_result) { true }

          before do
            expect(Hanzo).to receive(:run).with('heroku run foo --remote production')
            expect(Hanzo).to receive(:run).with('heroku run bar --remote production')
            expect(Hanzo).to receive(:run).with('heroku ps:restart --remote production')
          end

          specify { deploy! }
        end
      end

      context 'without successful deploy' do
        let(:deploy_result) { false }

        before do
          expect(Hanzo).not_to receive(:agree)
          expect(Hanzo).not_to receive(:run).with('heroku run foo --remote production')
          expect(Hanzo).not_to receive(:run).with('heroku run bar --remote production')
          expect(Hanzo).not_to receive(:run).with('heroku ps:restart --remote production')
        end

        specify { deploy! }
      end
    end
  end
end
