require 'spec_helper'

describe Hanzo::CLI do
  describe :config do
    let(:config!) { Hanzo::CLI.new(['config', action]) }
    let(:heroku_remotes) { { 'production' => 'heroku-app-production', 'qa' => 'heroku-app-qa' } }

    before { expect(Hanzo::Installers::Remotes).to receive(:environments).and_return(heroku_remotes) }

    describe :compare do
      let(:action) { 'compare' }
      let(:config_cmd) { 'heroku config' }

      let(:fetch_environment_title) { 'Fetching environment variables' }
      let(:compare_environment_title) { 'Comparing environment variables' }

      let(:environment_one_name) { 'production' }
      let(:environment_two_name) { 'qa' }
      let(:environment_one) do
        <<-RUBY.unindent
        SMTP_PORT:     25
        SMTP_PASSWORD: hanzo
        SMTP_HOST:     localhost
        RUBY
      end
      let(:environment_two) do
        <<-RUBY.unindent
        SMTP_PORT:     25
        SMTP_USERNAME: hanzo
        RUBY
      end

      before do
        expect(Hanzo).to receive(:title).with(fetch_environment_title)
        expect(Hanzo).to receive(:title).with(compare_environment_title)

        expect(Hanzo).to receive(:run).with("#{config_cmd} -r #{environment_one_name}", true).and_return(environment_one)
        expect(Hanzo).to receive(:run).with("#{config_cmd} -r #{environment_two_name}", true).and_return(environment_two)

        expect(Hanzo).to receive(:print).with("Missing variables in #{environment_one_name}", :yellow)
        expect(Hanzo).to receive(:print).with(['- SMTP_USERNAME'])
        expect(Hanzo).to receive(:print).with("Missing variables in #{environment_two_name}", :yellow)
        expect(Hanzo).to receive(:print).with(['- SMTP_PASSWORD', '- SMTP_HOST'])
      end

      it 'should list missing variables for all environments' do
        config!
      end
    end
  end
end
