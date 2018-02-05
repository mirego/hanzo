require 'spec_helper'

describe Hanzo::CLI do
  describe :install do
    let(:install!) { Hanzo::CLI.new(['install', type]) }
    let(:heroku_remotes) { { 'production' => 'heroku-app-production', 'qa' => 'heroku-app-qa' } }

    describe :labs do
      let(:type) { 'labs' }
      let(:labs_title) { 'Activating Heroku Labs' }
      let(:available_labs) { { 'user-env-compile' => 'Description' } }

      let(:enable_labs_cmd) { 'heroku labs:enable' }
      let(:enable_labs_info) { '- Enabled for' }

      before do
        expect(Hanzo::Installers::Remotes).to receive(:environments).and_return(heroku_remotes)
        expect(Hanzo::Heroku).to receive(:available_labs).and_return(available_labs)
        expect(Hanzo).to receive(:title).with(labs_title)

        available_labs.each_key do |name|
          expect(Hanzo).to receive(:agree).with("Add #{name}?").and_return(true)

          heroku_remotes.each_key do |env|
            expect(Hanzo).to receive(:run).with("#{enable_labs_cmd} #{name} --remote #{env}")
            expect(Hanzo).to receive(:print).with("#{enable_labs_info} #{env}")
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

      before { expect(Hanzo).to receive(:title).with(create_remotes_title) }

      context '.hanzo.yml exists' do
        before do
          expect(Hanzo::Installers::Remotes).to receive(:environments).and_return(heroku_remotes)

          heroku_remotes.each do |env, app|
            expect(Hanzo).to receive(:print).with("Adding #{env}")
            expect(Hanzo).to receive(:run).with("git remote rm #{env} 2>&1 > /dev/null")
            expect(Hanzo).to receive(:run).with("git remote add #{env} git@heroku.com:#{app}.git")
          end
        end

        it 'should install git remotes' do
          install!
        end
      end

      context '.hanzo.yml file is missing' do
        before { expect(Hanzo).to receive(:print).twice }

        it 'should display error message' do
          expect { install! }.to raise_error SystemExit
        end
      end
    end
  end
end
