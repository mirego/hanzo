require 'spec_helper'

describe Hanzo::CLI do
  describe :deploy do
    let(:env) { 'production' }
    let(:branch) { '1.0.0' }
    let(:deploy!) { Hanzo::CLI.new(['deploy', env]) }
    let(:heroku_remotes) { { 'production' => 'heroku-app-production' } }
    let(:migration_dir) { 'db/migrate' }

    let(:migration_question) { 'Run database migrations?' }
    let(:deploy_question) { "Branch to deploy in #{env}:" }

    let(:migration_cmd) { "heroku run rake db:migrate --remote #{env}" }
    let(:restart_cmd) { "heroku ps:restart --remote #{env}" }
    let(:deploy_cmd) { "git push -f #{env} #{branch}:master" }

    before do
      expect(Hanzo::Installers::Remotes).to receive(:environments).and_return(['production'])
      expect(Hanzo::Installers::Remotes).to receive(:installed_environments).and_return(['production'])
    end

    context 'successful deploy and without migrations' do
      let(:migrations_exist) { false }
      let(:deploy_result) { true }

      before do
        expect(Dir).to receive(:exist?).with(instance_of(String)).at_least(:once).and_return(migrations_exist)
        expect(Hanzo).to receive(:ask).with(deploy_question).and_return(branch)
        expect(Hanzo).to receive(:run).with(deploy_cmd).once.and_return(deploy_result)
      end

      it 'should git push to heroku upstream' do
        deploy!
      end
    end

    context 'with existing migrations' do
      let(:migrations_exist) { true }

      before do
        expect(Hanzo).to receive(:ask).with(deploy_question).and_return(branch)
        expect(Hanzo).to receive(:run).with(deploy_cmd).once.and_return(deploy_result)
      end

      context 'with successful deploy' do
        let(:deploy_result) { true }

        before do
          expect(Dir).to receive(:exist?).with(instance_of(String)).at_least(:once).and_return(migrations_exist)
        end

        context 'and migrations that should be ran' do
          before do
            expect(Hanzo).to receive(:agree).with(migration_question).and_return(true)
            expect(Hanzo).to receive(:run).with(migration_cmd)
            expect(Hanzo).to receive(:run).with(restart_cmd)
          end

          specify { deploy! }
        end

        context 'and migrations that should not be ran' do
          before do
            expect(Hanzo).to receive(:agree).with(migration_question).and_return(false)
            expect(Hanzo).not_to receive(:run).with(migration_cmd)
            expect(Hanzo).not_to receive(:run).with(restart_cmd)
          end

          specify { deploy! }
        end
      end

      context 'without successful deploy' do
        let(:deploy_result) { false }

        before do
          expect(Hanzo).not_to receive(:agree).with(migration_question)
          expect(Hanzo).not_to receive(:run).with(migration_cmd)
          expect(Hanzo).not_to receive(:run).with(restart_cmd)
        end

        specify { deploy! }
      end
    end
  end
end
