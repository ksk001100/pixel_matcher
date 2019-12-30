RSpec.describe PixelMatcher do
  it "has a version number" do
    expect(PixelMatcher::VERSION).not_to be nil
  end

  describe PixelMatcher::DiffImage do
    let(:file1_path) { 'spec/fixtures/images/lena1.png' }
    let(:file2_path) { 'spec/fixtures/images/lena2.png' }
    let(:output_path) { './output.png' }

    subject { PixelMatcher::DiffImage.new(file1_path, file2_path) }

    it '#new' do
      expect(subject).to eq subject
    end

    it '#export' do
      expect(subject.export(output_path)).to eq subject
      FileUtils.rm_rf(output_path)
    end
  end
end
