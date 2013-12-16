require 'spec_helper'

describe Hanzo::CLI do
  describe :install do
    let(:install!) { Hanzo::CLI.new(['install', type]) }
    let(:heroku_remotes) { { 'production' => 'heroku-app-production', 'qa' => 'heroku-app-qa' } }

    describe :labs do
      let(:type) { 'labs' }
      let(:labs_title) { 'Activating Heroku Labs' }
      let(:available_labs) { { 'user-env-compile' => 'Description' } }

      let(:enable_labs_cmd) { "heroku labs:enable" }
      let(:enable_labs_info) { '- Enabled for' }

      before do
        Hanzo::Installers::Remotes.stub(:environments).and_return(heroku_remotes)
        Hanzo::Heroku.stub(:available_labs).and_return(available_labs)
        Hanzo.should_receive(:title).with(labs_title)

        available_labs.each do |name, description|
          Hanzo.should_receive(:agree).with("Add #{name}?").and_return(true)

          heroku_remotes.each do |env, app|
            Hanzo.should_receive(:run).with("#{enable_labs_cmd} #{name} --remote #{env}")
            Hanzo.should_receive(:print).with("#{enable_labs_info} #{env}")
          end
        end
      end

      it 'should install specified labs for each environment' do
        install!
      end
    end

    describe :remotes do
      let(:type) { 'remotes' }
      let(:create_remotes_title) { 'Creating git remotes' }

      before { Hanzo.should_receive(:title).with(create_remotes_title) }

      context '.heroku-remotes exists' do
        before do
          Hanzo::Installers::Remotes.stub(:environments).and_return(heroku_remotes)
          heroku_remotes.each do |env, app|
            Hanzo.should_receive(:print).with("Adding #{env}")
            Hanzo.should_receive(:run).with("git remote rm #{env} 2>&1 > /dev/null")
            Hanzo.should_receive(:run).with("git remote add #{env} git@heroku.com:#{app}.git")
          end
        end

        it 'should install git remotes' do
          install!
        end
      end

      context '.heroku-remotes file is missing' do
        before { Hanzo.should_receive(:print).twice }

        it 'should display error message' do
          lambda { install! }.should raise_error SystemExit
        end
      end
    end
  end
end
