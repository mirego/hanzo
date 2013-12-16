require 'spec_helper'

describe Hanzo::CLI do
  describe :deploy do
    let(:env) { 'production' }
    let(:branch) { '1.0.0' }
    let(:deploy!) { Hanzo::CLI.new(['deploy', env]) }
    let(:migrations_exist) { false }
    let(:heroku_remotes) { { 'production' => 'heroku-app-production' } }
    let(:migration_dir) { 'db/migrate' }

    let(:migration_question) { 'Run migrations?' }
    let(:deploy_question) { "Branch to deploy in #{env}:" }

    let(:migration_cmd) { "heroku run rake db:migrate --remote #{env}" }
    let(:restart_cmd) { "heroku ps:restart --remote #{env}" }
    let(:deploy_cmd) { "git push -f #{env} #{branch}:master" }

    before do
      Dir.should_receive(:exists?).with(migration_dir).and_return(migrations_exist)
      Hanzo::Installers::Remotes.stub(:environments).and_return(heroku_remotes)
      Hanzo.should_receive(:ask).with(deploy_question).and_return(branch)
      Hanzo.should_receive(:run).with(deploy_cmd).once
    end

    context 'without migration' do
      it 'should git push to heroku upstream' do
        deploy!
      end
    end

    context 'with migrations' do
      let(:migrations_exist) { true }

      context 'that should be ran' do
        before do
          Hanzo.should_receive(:agree).with(migration_question).and_return(true)
          Hanzo.should_receive(:run).with(migration_cmd)
          Hanzo.should_receive(:run).with(restart_cmd)
        end

        it 'should run migrations' do
          deploy!
        end
      end

      context 'that should not be ran' do
        before do
          Hanzo.should_receive(:agree).with(migration_question).and_return(false)
          Hanzo.should_not_receive(:run).with(migration_cmd)
          Hanzo.should_not_receive(:run).with(restart_cmd)
        end

        it 'should not run migrations' do
          deploy!
        end
      end
    end
  end
end
