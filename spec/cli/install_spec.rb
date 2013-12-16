require 'spec_helper'

describe Hanzo::CLI do
  describe :install do
    let(:install!) { Hanzo::CLI.new(['install', 'labs']) }
    let(:heroku_remotes) { { 'production' => 'heroku-app-production', 'qa' => 'heroku-app-qa' } }
    let(:labs_title) { 'Activating Heroku Labs' }

    before do
      Hanzo::Installers::Remotes.stub(:environments).and_return(heroku_remotes)
    end

    describe :labs do
      let(:available_labs) { { 'user-env-compile' => 'Description' } }

      let(:enable_labs_cmd) { "heroku labs:enable" }
      let(:enable_labs_info) { '- Enabled for' }

      before do
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
  end
end

