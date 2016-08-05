require 'spec_helper'

describe HeaderableEtag do
  it 'has a version number' do
    expect(HeaderableEtag::VERSION).not_to be nil
  end


  describe ".headers_string" do
    let(:current_headers) { { a: 'one', b: 'two', c: 'three' } }
    let(:header_keys_for_etag) { [:b, :c] }
    subject { described_class.headers_string(current_headers, header_keys_for_etag) }
    it { is_expected.to eq 'threetwo' }
  end

  describe ".etag_with_headers" do
    let(:current_headers) { { 'ETag' => 'etag', 'Extra' => 'extra' } }
    let(:header_keys_for_etag) { ['Extra'] }
    subject { described_class.etag_with_headers(current_headers, header_keys_for_etag) }
    before { allow(described_class).to receive(:digest) }
    it { subject; expect(described_class).to have_received(:digest).with('extraetag') }
  end

  describe ".digest" do
    let(:string) { SecureRandom.hex }
    subject { described_class.digest(string) }
    it { expect(subject.length).to eq 32 }
  end

  describe described_class::Middleware do
    let(:app_call_return) { [200, { 'ETag' => 'etag'}, ''] }
    let(:app) { double(call: app_call_return) }
    let(:env) { double }
    let(:header_keys_for_etag) { ['Extra'] }
    let(:middleware) { described_class.new(app, header_keys_for_etag) }
    subject { middleware }
    it { is_expected.to be_a described_class }

    context "#call" do
      subject { middleware.call(env) }
      before { allow(HeaderableEtag).to receive(:etag_with_headers) }
      it { subject; expect(app).to have_received(:call).with(env) }
      it { subject; expect(HeaderableEtag).to have_received(:etag_with_headers) }
    end
  end
end
