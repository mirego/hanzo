require 'spec_helper'

describe Hanzo::Fetchers::Environment do
  let(:fetcher) { Hanzo::Fetchers::Environment.new(current_environment) }
  let(:current_environment) { 'production' }

  describe :exist? do
    let(:environments) { ['production'] }

    before { expect(fetcher).to receive(:environments).and_return(environments) }

    context 'with an existing environment' do
      it { expect(fetcher.exist?).to be_truthy }
    end

    context 'with an unexisting environment' do
      let(:current_environment) { 'staging' }
      it { expect(fetcher.exist?).to be_falsey }
    end
  end

  describe :installed? do
    let(:environments) { ['production'] }

    before { expect(fetcher).to receive(:installed_environments).and_return(environments) }

    context 'with an installed environment' do
      it { expect(fetcher.installed?).to be_truthy }
    end

    context 'with an uninstalled environment' do
      let(:current_environment) { 'staging' }
      it { expect(fetcher.installed?).to be_falsey }
    end
  end

  describe :installed_environments do
    before { expect(Hanzo::Installers::Remotes).to receive(:installed_environments) }

    specify { fetcher.send(:installed_environments) }
  end

  describe :environments do
    before { expect(Hanzo::Installers::Remotes).to receive(:environments) }

    specify { fetcher.send(:environments) }
  end
end
